#!/usr/bin/env python3
"""
AriannesNetworks GUI - Personality Network Analysis
Run R scripts or view existing results.
"""

import tkinter as tk
from tkinter import ttk, messagebox, scrolledtext
import sys
from pathlib import Path
import pandas as pd
import subprocess
import threading
import os
import shutil
import glob
import tempfile

# Try to import pyreadr for RData file reading
try:
    import pyreadr
    PYREADR_AVAILABLE = True
except ImportError:
    PYREADR_AVAILABLE = False

# matplotlib / networkx for embedded charts
try:
    import matplotlib
    matplotlib.use("TkAgg")
    import matplotlib.pyplot as plt
    from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg, NavigationToolbar2Tk
    import numpy as np
    MATPLOTLIB_AVAILABLE = True
except Exception:
    MATPLOTLIB_AVAILABLE = False

try:
    import networkx as nx
    NETWORKX_AVAILABLE = True
except ImportError:
    NETWORKX_AVAILABLE = False

sys.path.append(str(Path(__file__).parent / "src"))

PROJECT_ROOT = Path(__file__).parent
RESULTS_DIR = PROJECT_ROOT / "results"
DATA_DIR = PROJECT_ROOT / "data"


class SimpleGUI:
    def __init__(self, root):
        self.root = root
        self.root.title("AriannesNetworks - Personality Network Analysis")
        self.root.geometry("1200x820")

        self.r_process = None
        self.r_output_thread = None

        # R script mappings
        self.r_scripts = {
            "Neuroticism - Full Analysis (P0-P3)": "run_all_analysis_N.R",
            "Agreeableness - Full Analysis (P0-P3)": "run_all_analysis_A.R",
            "P1 - Data Pre-processing (Neuroticism)": "r_scripts/NEO & IPIP - P1 - data pre-processing & whole-sample_N.R",
            "P1 - Data Pre-processing (Agreeableness)": "r_scripts/NEO & IPIP - P1 - data pre-processing & whole-sample_NEOCA.R",
            "P2 - Resampling (Neuroticism)": "r_scripts/NEO & IPIP - P2 - resampling_N.R",
            "P2 - Resampling (Agreeableness)": "r_scripts/NEO & IPIP - P2 - resampling_A.R",
            "P3 - Network Analysis (Neuroticism)": "r_scripts/NEO & IPIP - P3 - netcompare & analysis_N.R",
            "P3 - Network Analysis (Agreeableness)": "r_scripts/NEO & IPIP - P3 - netcompare & analysis_A.R",
        }

        # RData file mappings
        self.rdata_files = {
            "P1 Data - Neuroticism": "data/NEO & IPIP - P1_nSim50_data_N.RData",
            "P1 Data - Agreeableness": "data/NEO & IPIP - P1_nSim50_data_A.RData",
            "P2 Data - Neuroticism": "data/NEO & IPIP - P2_nSim50_data_N.RData",
            "P2 Data - Agreeableness": "data/NEO & IPIP - P2_nSim50_data_A.RData",
            "P3 Results - Neuroticism": "data/NEO & IPIP - P3_nSim50_results_all_N.RData",
            "P3 Results - Agreeableness": "data/NEO & IPIP - P3_nSim50_results_all_A.RData",
        }

        # CSV results files (auto-discover)
        self.csv_results = self._discover_csv_results()

        self.create_widgets()
        self.setup_layout()

    def _discover_csv_results(self):
        results = {}
        if RESULTS_DIR.exists():
            for f in sorted(RESULTS_DIR.glob("*.csv")):
                results[f.name] = str(f)
        return results

    # -------------------------------------------------------------------------
    # Widget creation
    # -------------------------------------------------------------------------

    def create_widgets(self):
        self.main_frame = ttk.Frame(self.root, padding="10")

        # Title
        self.title_label = ttk.Label(
            self.main_frame,
            text="AriannesNetworks - Personality Network Analysis",
            font=("Arial", 14, "bold"),
        )

        # Top panel: two side-by-side control boxes
        self.top_panel = ttk.Frame(self.main_frame)

        # Left box: Run R Analysis
        self.r_frame = ttk.LabelFrame(self.top_panel, text="Run R Analysis", padding="10")
        self.script_var = tk.StringVar(value="Neuroticism - Full Analysis (P0-P3)")
        self.script_combo = ttk.Combobox(
            self.r_frame, textvariable=self.script_var,
            values=list(self.r_scripts.keys()), state="readonly", width=42,
        )
        self.run_r_btn = ttk.Button(self.r_frame, text="Run R Script", command=self.on_run_r)
        self.stop_r_btn = ttk.Button(self.r_frame, text="Stop", command=self.stop_r, state="disabled")

        # Right box: View Results
        self.view_frame = ttk.LabelFrame(self.top_panel, text="View Results", padding="10")

        self.rdata_var = tk.StringVar(value=list(self.rdata_files.keys())[4])
        self.rdata_combo = ttk.Combobox(
            self.view_frame, textvariable=self.rdata_var,
            values=list(self.rdata_files.keys()), state="readonly", width=32,
        )
        self.view_rdata_btn = ttk.Button(self.view_frame, text="View RData", command=self.on_view_rdata)

        csv_names = list(self.csv_results.keys()) if self.csv_results else ["(none found)"]
        self.csv_var = tk.StringVar(value=csv_names[0])
        self.csv_combo = ttk.Combobox(
            self.view_frame, textvariable=self.csv_var,
            values=csv_names, state="readonly", width=32,
        )
        self.view_csv_btn = ttk.Button(self.view_frame, text="View CSV", command=self.on_view_csv)

        # Status bar
        self.status_var = tk.StringVar(value="Ready")
        self.status_label = ttk.Label(
            self.main_frame, textvariable=self.status_var, relief="sunken", anchor="w"
        )

        # Notebook
        self.notebook = ttk.Notebook(self.main_frame)

        self.r_output_tab = ttk.Frame(self.notebook)
        self.r_output_text = scrolledtext.ScrolledText(self.r_output_tab, font=("Courier", 9))

        self.results_tab = ttk.Frame(self.notebook)
        self.results_text = scrolledtext.ScrolledText(self.results_tab, font=("Courier", 9))

        self.viz_tab = ttk.Frame(self.notebook)
        self._build_viz_tab()

        self.notebook.add(self.r_output_tab, text="R Output")
        self.notebook.add(self.results_tab, text="Results Viewer")
        self.notebook.add(self.viz_tab, text="Visualizations")

    def setup_layout(self):
        self.main_frame.grid(row=0, column=0, sticky="nsew")
        self.root.columnconfigure(0, weight=1)
        self.root.rowconfigure(0, weight=1)
        self.main_frame.columnconfigure(0, weight=1)
        self.main_frame.rowconfigure(2, weight=1)

        self.title_label.grid(row=0, column=0, pady=(0, 8), sticky="w")

        # Top panel
        self.top_panel.grid(row=1, column=0, sticky="ew", pady=(0, 6))
        self.top_panel.columnconfigure(0, weight=1)
        self.top_panel.columnconfigure(1, weight=1)

        # Left: Run R Analysis
        self.r_frame.grid(row=0, column=0, sticky="nsew", padx=(0, 4))
        ttk.Label(self.r_frame, text="Script:").grid(row=0, column=0, sticky="w", pady=2)
        self.script_combo.grid(row=0, column=1, columnspan=2, sticky="ew", padx=(4, 0), pady=2)
        self.run_r_btn.grid(row=1, column=1, sticky="ew", padx=(4, 2), pady=(6, 0))
        self.stop_r_btn.grid(row=1, column=2, sticky="ew", padx=(2, 0), pady=(6, 0))
        self.r_frame.columnconfigure(1, weight=1)

        # Right: View Results
        self.view_frame.grid(row=0, column=1, sticky="nsew", padx=(4, 0))
        ttk.Label(self.view_frame, text="RData file:").grid(row=0, column=0, sticky="w", pady=2)
        self.rdata_combo.grid(row=0, column=1, sticky="ew", padx=(4, 4), pady=2)
        self.view_rdata_btn.grid(row=0, column=2, pady=2)
        ttk.Label(self.view_frame, text="Results CSV:").grid(row=1, column=0, sticky="w", pady=2)
        self.csv_combo.grid(row=1, column=1, sticky="ew", padx=(4, 4), pady=2)
        self.view_csv_btn.grid(row=1, column=2, pady=2)
        self.view_frame.columnconfigure(1, weight=1)

        # Notebook
        self.notebook.grid(row=2, column=0, sticky="nsew")

        for tab, text_widget in [
            (self.r_output_tab, self.r_output_text),
            (self.results_tab, self.results_text),
        ]:
            tab.columnconfigure(0, weight=1)
            tab.rowconfigure(0, weight=1)
            text_widget.grid(row=0, column=0, sticky="nsew")

        # Status bar
        self.status_label.grid(row=3, column=0, sticky="ew", pady=(4, 0))

    # -------------------------------------------------------------------------
    # Visualizations tab
    # -------------------------------------------------------------------------

    def _build_viz_tab(self):
        self.viz_tab.columnconfigure(0, weight=1)
        self.viz_tab.rowconfigure(1, weight=1)

        # Control bar
        ctrl = ttk.Frame(self.viz_tab, padding="6")
        ctrl.grid(row=0, column=0, sticky="ew")
        ttk.Label(ctrl, text="Chart:").pack(side="left")
        self.chart_var = tk.StringVar()
        self.chart_combo = ttk.Combobox(
            ctrl, textvariable=self.chart_var, state="readonly", width=50
        )
        self.chart_combo["values"] = [
            "Network Centrality (Strength) by Facet",
            "Edge Weights: Raw vs IRT vs Disattenuated",
            "Network Graph - Raw Weights",
            "Network Graph - IRT Weights",
            "Scoring Method Correlation with NEO",
            "Item-Level Reliability (Alpha if Dropped)",
            "RF Feature Importance by Item",
            "2.5x Equivalence Comparison (OSF)",
            "Redundancy Proof: Anxiety Item + Facet Overlap",
        ]
        self.chart_combo.current(0)
        self.chart_combo.pack(side="left", padx=(6, 6))
        ttk.Button(ctrl, text="Show Chart", command=self.on_show_chart).pack(side="left")

        if not MATPLOTLIB_AVAILABLE:
            ttk.Label(
                self.viz_tab,
                text="matplotlib not available. Install it to see charts.",
                foreground="red",
            ).grid(row=1, column=0)
            return

        # Canvas
        canvas_frame = ttk.Frame(self.viz_tab)
        canvas_frame.grid(row=1, column=0, sticky="nsew")
        canvas_frame.columnconfigure(0, weight=1)
        canvas_frame.rowconfigure(0, weight=1)
        self.viz_fig = plt.Figure(figsize=(10, 6), dpi=100)
        self.viz_canvas = FigureCanvasTkAgg(self.viz_fig, master=canvas_frame)
        self.viz_canvas.get_tk_widget().grid(row=0, column=0, sticky="nsew")

        toolbar_frame = ttk.Frame(self.viz_tab)
        toolbar_frame.grid(row=2, column=0, sticky="ew")
        NavigationToolbar2Tk(self.viz_canvas, toolbar_frame)

        # Draw default chart after window renders
        self.root.after(300, self.on_show_chart)

    def on_show_chart(self):
        if not MATPLOTLIB_AVAILABLE:
            return
        chart = self.chart_var.get()
        self.viz_fig.clear()
        try:
            if chart == "Network Centrality (Strength) by Facet":
                self._chart_centrality()
            elif chart == "Edge Weights: Raw vs IRT vs Disattenuated":
                self._chart_edges()
            elif chart == "Network Graph - Raw Weights":
                self._chart_network("raw")
            elif chart == "Network Graph - IRT Weights":
                self._chart_network("irt")
            elif chart == "Scoring Method Correlation with NEO":
                self._chart_scoring_methods()
            elif chart == "Item-Level Reliability (Alpha if Dropped)":
                self._chart_item_reliability()
            elif chart == "RF Feature Importance by Item":
                self._chart_rf_importance()
            elif chart == "2.5x Equivalence Comparison (OSF)":
                self._chart_25x_equivalence()
            elif chart == "Redundancy Proof: Anxiety Item + Facet Overlap":
                self._chart_redundancy_proof()
        except Exception as e:
            ax = self.viz_fig.add_subplot(111)
            ax.text(0.5, 0.5, f"Error rendering chart:\n{e}",
                    ha="center", va="center", transform=ax.transAxes,
                    color="red", fontsize=10)
        self.viz_canvas.draw()
        self.notebook.select(self.viz_tab)

    def _load_csv(self, filename):
        path = RESULTS_DIR / filename
        if not path.exists():
            raise FileNotFoundError(f"Results file not found:\n{path}")
        return pd.read_csv(path)

    def _chart_centrality(self):
        df = self._load_csv("network_centrality_comparison.csv")
        ax = self.viz_fig.add_subplot(111)
        x = np.arange(len(df))
        w = 0.2
        strength_cols = [c for c in df.columns if "strength" in c]
        colors = ["#2196F3", "#4CAF50", "#FF9800", "#9C27B0"]
        for i, col in enumerate(strength_cols):
            ax.bar(x + i * w, df[col], w,
                   label=col.replace("_strength", ""),
                   color=colors[i % len(colors)])
        ax.set_xticks(x + w * (len(strength_cols) - 1) / 2)
        ax.set_xticklabels(df["facet"], rotation=30, ha="right")
        ax.set_ylabel("Strength Centrality")
        ax.set_title("Network Centrality (Strength) by Facet")
        ax.legend()
        self.viz_fig.tight_layout()

    def _chart_edges(self):
        df = self._load_csv("network_edge_comparison.csv")
        ax = self.viz_fig.add_subplot(111)
        x = np.arange(len(df))
        w = 0.22
        for i, col in enumerate(["raw", "irt", "disattenuated"]):
            if col in df.columns:
                bars = ax.bar(x + i * w, df[col], w, label=col)
                ax.bar_label(bars, fmt="%.2f", fontsize=6, padding=2, rotation=90)
        ax.set_xticks(x + w)
        ax.set_xticklabels(df["edge"], rotation=45, ha="right", fontsize=7)
        ax.set_ylabel("Edge Weight")
        ax.set_title("Edge Weights: Raw vs IRT vs Disattenuated")
        ax.legend()
        self.viz_fig.tight_layout()

    def _chart_network(self, kind="raw"):
        if not NETWORKX_AVAILABLE:
            ax = self.viz_fig.add_subplot(111)
            ax.text(0.5, 0.5, "networkx not installed.\nRun: pip install networkx",
                    ha="center", va="center", transform=ax.transAxes)
            return
        fname = "network_raw.csv" if kind == "raw" else "network_irt.csv"
        df = self._load_csv(fname)
        df = df.set_index(df.columns[0])
        G = nx.Graph()
        nodes = list(df.columns)
        G.add_nodes_from(nodes)
        for i, n1 in enumerate(nodes):
            for j, n2 in enumerate(nodes):
                if j > i:
                    val = float(df.loc[n1, n2])
                    if abs(val) > 0.001:
                        G.add_edge(n1, n2, weight=val)
        ax = self.viz_fig.add_subplot(111)
        pos = nx.spring_layout(G, seed=42)
        widths = [abs(G[u][v]["weight"]) * 6 for u, v in G.edges()]
        edge_colors = [
            "#F44336" if G[u][v]["weight"] < 0 else "#2196F3"
            for u, v in G.edges()
        ]
        nx.draw_networkx(G, pos=pos, ax=ax,
                         node_color="#FFC107", node_size=900,
                         width=widths, edge_color=edge_colors,
                         font_size=8, font_weight="bold")
        edge_labels = {(u, v): f"{G[u][v]['weight']:.2f}" for u, v in G.edges()}
        nx.draw_networkx_edge_labels(
            G,
            pos,
            edge_labels=edge_labels,
            font_size=7,
            ax=ax,
            bbox={"alpha": 0.6, "color": "white", "edgecolor": "none"},
        )
        ax.set_title(
            f"Network Graph - {kind.upper()} Weights  "
            "(blue=positive, red=negative)"
        )
        ax.axis("off")
        self.viz_fig.tight_layout()

    def _chart_scoring_methods(self):
        df = self._load_csv("scoring_method_comparison.csv")
        ax = self.viz_fig.add_subplot(111)
        pivot = df.pivot(index="facet", columns="method", values="r_neo")
        x = np.arange(len(pivot))
        w = 0.8 / max(len(pivot.columns), 1)
        colors = ["#2196F3", "#4CAF50", "#FF9800", "#9C27B0", "#00BCD4"]
        for i, col in enumerate(pivot.columns):
            ax.bar(x + i * w, pivot[col], w, label=col, color=colors[i % len(colors)])
        ax.set_xticks(x + w * (len(pivot.columns) - 1) / 2)
        ax.set_xticklabels(pivot.index, rotation=30, ha="right")
        ax.set_ylabel("Correlation with NEO")
        ax.set_title("Scoring Method Correlation with NEO")
        ax.legend()
        self.viz_fig.tight_layout()

    def _chart_item_reliability(self):
        df = self._load_csv("item_level_metrics.csv")
        facets = df["facet"].unique()[:6]
        n = len(facets)
        cols_n = 3
        rows_n = (n + cols_n - 1) // cols_n
        for idx, facet in enumerate(facets):
            ax = self.viz_fig.add_subplot(rows_n, cols_n, idx + 1)
            sub = df[df["facet"] == facet].sort_values("item")
            ax.barh(sub["item"], sub["alpha_if_dropped"], color="#2196F3")
            ax.set_title(facet, fontsize=8)
            ax.tick_params(labelsize=7)
        self.viz_fig.suptitle("Alpha if Item Dropped", fontsize=11)
        self.viz_fig.tight_layout(rect=[0, 0, 1, 0.96])

    def _chart_rf_importance(self):
        df = self._load_csv("rf_item_importance.csv")
        df = df.sort_values("rf_importance", ascending=True).tail(30)
        ax = self.viz_fig.add_subplot(111)
        ax.barh(df["item"], df["rf_importance"], color="#4CAF50")
        ax.set_xlabel("RF Importance")
        ax.set_title("Top 30 Items by Random Forest Importance")
        ax.tick_params(axis="y", labelsize=7)
        self.viz_fig.tight_layout()

    def _chart_25x_equivalence(self):
        """Show the core 1-item@84 vs 2-item@84 vs 1-item@212 comparison from docs."""
        conditions = ["1-item@84", "2-item@84", "1-item@212"]
        edgecorr = [0.0904, 0.2425, 0.2490]
        rankcorr = [0.1704, 0.4552, 0.4679]

        ax1 = self.viz_fig.add_subplot(121)
        ax2 = self.viz_fig.add_subplot(122)
        colors = ["#90A4AE", "#42A5F5", "#66BB6A"]

        bars1 = ax1.bar(conditions, edgecorr, color=colors)
        ax1.bar_label(bars1, fmt="%.4f", fontsize=8, padding=3)
        ax1.set_title("Edge Correlation")
        ax1.set_ylabel("Correlation")
        ax1.set_ylim(0, 0.55)
        ax1.tick_params(axis="x", rotation=20)
        ax1.text(
            0.02,
            0.96,
            "2-item@84 ~= 1-item@212\n(diff ~ 0.0066)",
            transform=ax1.transAxes,
            va="top",
            fontsize=9,
        )

        bars2 = ax2.bar(conditions, rankcorr, color=colors)
        ax2.bar_label(bars2, fmt="%.4f", fontsize=8, padding=3)
        ax2.set_title("Centrality Rank Correlation")
        ax2.set_ylim(0, 0.75)
        ax2.tick_params(axis="x", rotation=20)
        ax2.text(
            0.02,
            0.96,
            "2-item@84 ~= 1-item@212\n(diff ~ 0.0126)",
            transform=ax2.transAxes,
            va="top",
            fontsize=9,
        )

        self.viz_fig.suptitle(
            "2.5x Claim Check: Adding 1 indicator ~= 2.5x sample size",
            fontsize=11,
        )
        self.viz_fig.tight_layout(rect=[0, 0, 1, 0.95])

    def _chart_redundancy_proof(self):
        """Two-panel chart: weak Anxiety item + Anxiety/Depression overlap."""
        # Left panel from results CSV: item-level RF importance within Anxiety.
        item_df = self._load_csv("rf_item_importance.csv")
        anx = item_df[item_df["facet"] == "N1_Anxiety"].copy()
        if anx.empty:
            raise ValueError("No N1_Anxiety rows found in rf_item_importance.csv")

        # Keep the strongest and weakest items to make contrast obvious.
        anx = anx.sort_values("rf_importance_pct", ascending=False)
        top_n = anx.head(4)
        bot_n = anx.tail(3)
        plot_df = pd.concat([top_n, bot_n]).drop_duplicates(subset=["item"]).copy()
        plot_df = plot_df.sort_values("rf_importance_pct", ascending=True)

        ax1 = self.viz_fig.add_subplot(121)
        colors = ["#EF5350" if v < 1.0 else "#42A5F5" for v in plot_df["rf_importance_pct"]]
        bars = ax1.barh(plot_df["item"], plot_df["rf_importance_pct"], color=colors)
        ax1.bar_label(bars, fmt="%.2f%%", fontsize=8, padding=3)
        ax1.set_xlabel("RF Importance (%)")
        ax1.set_title("N1 Anxiety Items: strongest vs weakest")
        ax1.axvline(1.0, color="#9E9E9E", linestyle="--", linewidth=1)
        ax1.text(
            0.02,
            0.03,
            "Items under ~1% are effectively negligible",
            transform=ax1.transAxes,
            fontsize=8,
            va="bottom",
        )

        # Right panel from docs numbers: own-vs-best-other facet prediction R^2.
        facets = ["N1 Anxiety", "N3 Depression"]
        own_r2 = [0.568, 0.648]
        best_other_r2 = [0.401, 0.457]
        ratios = [1.42, 1.42]

        ax2 = self.viz_fig.add_subplot(122)
        x = np.arange(len(facets))
        w = 0.34
        b1 = ax2.bar(x - w / 2, own_r2, w, label="Own R^2", color="#66BB6A")
        b2 = ax2.bar(x + w / 2, best_other_r2, w, label="Best Other R^2", color="#FFA726")
        ax2.bar_label(b1, fmt="%.3f", fontsize=8, padding=2)
        ax2.bar_label(b2, fmt="%.3f", fontsize=8, padding=2)
        ax2.set_xticks(x)
        ax2.set_xticklabels(facets, rotation=12, ha="right")
        ax2.set_ylabel("R^2")
        ax2.set_title("Weak Discriminant Validity (docs)")
        ax2.legend(fontsize=8)
        for i, r in enumerate(ratios):
            ax2.text(i, max(own_r2[i], best_other_r2[i]) + 0.02, f"ratio={r:.2f}",
                     ha="center", va="bottom", fontsize=8)

        self.viz_fig.suptitle(
            "Redundancy Proof: one weak Anxiety item + Anxiety/Depression overlap",
            fontsize=11,
        )
        self.viz_fig.tight_layout(rect=[0, 0, 1, 0.95])

    # -------------------------------------------------------------------------
    # Action handlers
    # -------------------------------------------------------------------------

    def on_run_r(self):
        selected = self.script_var.get()
        if selected not in self.r_scripts:
            messagebox.showerror("Error", "Please select a valid R script")
            return
        script_path = str(PROJECT_ROOT / self.r_scripts[selected])
        if not os.path.exists(script_path):
            messagebox.showerror("Error", f"R script not found:\n{script_path}")
            return
        self._run_r_script(script_path)

    def stop_r(self):
        if self.r_process and self.r_process.poll() is None:
            self.r_process.terminate()
            self.status_var.set("R process stopped")
        self.run_r_btn.config(state="normal")
        self.stop_r_btn.config(state="disabled")

    def on_view_rdata(self):
        selected = self.rdata_var.get()
        rel_path = self.rdata_files.get(selected)
        if not rel_path:
            messagebox.showerror("Error", "No file selected.")
            return
        rdata_path = str(PROJECT_ROOT / rel_path)
        if not os.path.exists(rdata_path):
            messagebox.showerror("Error", f"File not found:\n{rdata_path}")
            return
        pyreadr_error = None

        # First try pyreadr for simple objects.
        if PYREADR_AVAILABLE:
            try:
                self.status_var.set(f"Loading {os.path.basename(rdata_path)} ...")
                self.root.update()
                result = pyreadr.read_r(rdata_path)
                txt = self.results_text
                txt.delete(1.0, tk.END)
                txt.insert(tk.END, f"FILE: {rdata_path}\n")
                txt.insert(tk.END, f"Objects: {list(result.keys())}\n")
                txt.insert(tk.END, "=" * 70 + "\n\n")
                for key, data in result.items():
                    txt.insert(tk.END, f"-- {key} --\n")
                    if isinstance(data, pd.DataFrame):
                        txt.insert(tk.END,
                                   f"DataFrame  shape={data.shape}  "
                                   f"columns={list(data.columns)}\n\n")
                        txt.insert(tk.END, data.to_string(max_rows=40) + "\n\n")
                    elif isinstance(data, pd.Series):
                        txt.insert(tk.END, f"Series  len={len(data)}\n{data.to_string()}\n\n")
                    else:
                        txt.insert(tk.END, f"{type(data).__name__}: {str(data)[:1000]}\n\n")
                self.notebook.select(self.results_tab)
                self.status_var.set(f"Loaded {os.path.basename(rdata_path)} (pyreadr)")
                return
            except Exception as e:
                pyreadr_error = str(e)
        else:
            pyreadr_error = "pyreadr is not installed"

        # Fallback: inspect via Rscript so complex objects can still be viewed.
        ok, output = self._inspect_rdata_with_r(rdata_path)
        if ok:
            txt = self.results_text
            txt.delete(1.0, tk.END)
            txt.insert(tk.END, output)
            self.notebook.select(self.results_tab)
            self.status_var.set(f"Loaded {os.path.basename(rdata_path)} (Rscript fallback)")
            return

        msg = (
            "Failed to load RData with both readers.\n\n"
            f"pyreadr: {pyreadr_error}\n\n"
            f"Rscript fallback: {output}"
        )
        messagebox.showerror("RData File", msg)
        self.status_var.set("RData load failed")

    def _inspect_rdata_with_r(self, rdata_path):
        """Inspect RData using Rscript and return a text summary for complex objects."""
        rscript_exe = self._find_rscript()
        if not rscript_exe:
            return False, "Rscript not found on PATH."

        r_code = """
args <- commandArgs(trailingOnly = TRUE)
f <- args[[1]]
e <- new.env(parent = .GlobalEnv)
loaded <- load(f, envir = e)
cat('FILE:', f, '\n')
cat('Objects:', paste(loaded, collapse=', '), '\n')
cat(strrep('=', 70), '\n\n')

for (nm in loaded) {{
    cat('--', nm, '--\n')
    tryCatch({{
        obj <- e[[nm]]
        cls <- paste(class(obj), collapse=' / ')
        cat('Class:', cls, '\n')
        if (is.data.frame(obj)) {{
            cat('Dimensions:', nrow(obj), 'x', ncol(obj), '\n')
            print(utils::head(obj, 10))
        }} else if (is.matrix(obj)) {{
            cat('Dimensions:', nrow(obj), 'x', ncol(obj), '\n')
            print(obj[1:min(10, nrow(obj)), 1:min(8, ncol(obj)), drop=FALSE])
        }} else if (is.list(obj)) {{
            cat('List length:', length(obj), '\n')
            nm2 <- names(obj)
            if (!is.null(nm2)) {{
                cat('First names:', paste(head(nm2, 20), collapse=', '), '\n')
            }}
        }} else if (is.vector(obj) || is.factor(obj)) {{
            cat('Length:', length(obj), '\n')
            print(utils::head(obj, 20))
        }} else {{
            cat('Type:', typeof(obj), '\n')
            d <- dim(obj)
            if (!is.null(d)) {{
                cat('Dimensions:', paste(d, collapse=' x '), '\n')
            }}
        }}
    }}, error = function(err) {{
        cat('Object summary error:', conditionMessage(err), '\n')
    }})
    cat('\n')
}}
"""

        script_path = None
        try:
            with tempfile.NamedTemporaryFile(mode="w", suffix=".R", delete=False, encoding="utf-8") as tmp:
                tmp.write(r_code)
                script_path = tmp.name

            proc = subprocess.run(
                [rscript_exe, script_path, rdata_path],
                cwd=str(PROJECT_ROOT),
                capture_output=True,
                text=True,
                timeout=120,
            )
            if proc.returncode != 0:
                err = (
                    proc.stderr.strip()
                    or proc.stdout.strip()
                    or f"Rscript exited with code {proc.returncode}"
                )
                return False, err
            text_out = proc.stdout.strip()
            if not text_out:
                text_out = proc.stderr.strip() or "Rscript returned no output."
            return True, text_out
        except Exception as e:
            return False, str(e)
        finally:
            if script_path and os.path.exists(script_path):
                try:
                    os.remove(script_path)
                except OSError:
                    pass

    def on_view_csv(self):
        selected = self.csv_var.get()
        csv_path = self.csv_results.get(selected)
        if not csv_path or not os.path.exists(csv_path):
            messagebox.showerror("Error", f"File not found:\n{csv_path}")
            return
        try:
            self.status_var.set(f"Loading {selected} ...")
            self.root.update()
            df = pd.read_csv(csv_path)
            txt = self.results_text
            txt.delete(1.0, tk.END)
            txt.insert(tk.END, f"FILE: {csv_path}\n")
            txt.insert(tk.END, f"Shape: {df.shape[0]} rows x {df.shape[1]} columns\n")
            txt.insert(tk.END, f"Columns: {list(df.columns)}\n")
            txt.insert(tk.END, "=" * 70 + "\n\n")
            txt.insert(tk.END, df.to_string() + "\n")
            self.notebook.select(self.results_tab)
            self.status_var.set(
                f"Loaded {selected}  ({df.shape[0]} rows x {df.shape[1]} cols)"
            )
        except Exception as e:
            messagebox.showerror("Error", f"Failed to load CSV:\n{e}")
            self.status_var.set("Error loading CSV")

    # -------------------------------------------------------------------------
    # R execution
    # -------------------------------------------------------------------------

    def _find_rscript(self):
        rscript = shutil.which("Rscript") or shutil.which("Rscript.exe")
        if rscript:
            return rscript
        for pattern in [
            r"C:\Program Files\R\R-*\bin\Rscript.exe",
            r"C:\Program Files (x86)\R\R-*\bin\Rscript.exe",
        ]:
            matches = sorted(glob.glob(pattern), reverse=True)
            if matches:
                return matches[0]
        return None

    def _run_r_script(self, script_path):
        rscript_exe = self._find_rscript()
        if not rscript_exe:
            messagebox.showerror(
                "Error",
                "Rscript not found.\nInstall R and ensure Rscript is on your PATH.",
            )
            return

        self.r_output_text.delete(1.0, tk.END)
        self.r_output_text.insert(tk.END, f"Rscript: {rscript_exe}\n")
        self.r_output_text.insert(tk.END, f"Script:  {script_path}\n")
        self.r_output_text.insert(tk.END, "=" * 70 + "\n\n")
        self.notebook.select(self.r_output_tab)
        self.status_var.set(f"Running {os.path.basename(script_path)} ...")
        self.run_r_btn.config(state="disabled")
        self.stop_r_btn.config(state="normal")

        def worker():
            try:
                self.r_process = subprocess.Popen(
                    [rscript_exe, script_path],
                    stdout=subprocess.PIPE,
                    stderr=subprocess.STDOUT,
                    universal_newlines=True,
                    bufsize=1,
                    cwd=str(PROJECT_ROOT),
                )
                for line in iter(self.r_process.stdout.readline, ""):
                    if line:
                        self.root.after(0, self._append_r_output, line)
                self.r_process.wait()
                rc = self.r_process.returncode
                msg = (
                    "Completed successfully."
                    if rc == 0
                    else f"Exited with code {rc}."
                )
                self.root.after(
                    0,
                    self._append_r_output,
                    "\n" + "=" * 70 + "\n" + msg + "\n",
                )
                self.root.after(0, lambda: self.status_var.set(f"R script {msg}"))
            except Exception as e:
                self.root.after(
                    0,
                    lambda: messagebox.showerror("Error", f"R execution failed:\n{e}"),
                )
                self.root.after(0, lambda: self.status_var.set("R execution failed"))
            finally:
                self.root.after(0, lambda: self.run_r_btn.config(state="normal"))
                self.root.after(0, lambda: self.stop_r_btn.config(state="disabled"))

        self.r_output_thread = threading.Thread(target=worker, daemon=True)
        self.r_output_thread.start()

    def _append_r_output(self, text):
        self.r_output_text.insert(tk.END, text)
        self.r_output_text.see(tk.END)
        self.root.update_idletasks()


def main():
    root = tk.Tk()
    app = SimpleGUI(root)  # noqa: F841

    # Center window
    root.update_idletasks()
    x = (root.winfo_screenwidth() // 2) - (root.winfo_width() // 2)
    y = (root.winfo_screenheight() // 2) - (root.winfo_height() // 2)
    root.geometry(f"+{x}+{y}")

    root.mainloop()


if __name__ == "__main__":
    main()
