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


class ToolTip:
    """Small hover tooltip for Tk widgets."""

    def __init__(self, widget, text):
        self.widget = widget
        self.text = text
        self.tip_window = None
        widget.bind("<Enter>", self._show)
        widget.bind("<Leave>", self._hide)

    def _show(self, _event=None):
        if self.tip_window or not self.text:
            return
        x = self.widget.winfo_rootx() + 18
        y = self.widget.winfo_rooty() + self.widget.winfo_height() + 6
        self.tip_window = tw = tk.Toplevel(self.widget)
        tw.wm_overrideredirect(True)
        tw.wm_geometry(f"+{x}+{y}")
        label = tk.Label(
            tw,
            text=self.text,
            justify="left",
            background="#FFFFE0",
            relief="solid",
            borderwidth=1,
            padx=6,
            pady=4,
            wraplength=380,
        )
        label.pack()

    def _hide(self, _event=None):
        if self.tip_window:
            self.tip_window.destroy()
            self.tip_window = None


class SimpleGUI:
    def __init__(self, root):
        self.root = root
        self.root.title("AriannesNetworks - Personality Network Analysis")
        self.root.geometry("1280x860")

        self.r_process = None
        self.r_output_thread = None

        self._apply_modern_theme()
        self._configure_plot_style()

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

    def _apply_modern_theme(self):
        self.palette = {
            "bg": "#F4F6F8",
            "surface": "#FFFFFF",
            "surface_alt": "#EEF3F8",
            "text": "#1A2530",
            "muted": "#4C6478",
            "accent": "#0E7490",
            "accent_hover": "#0B6077",
            "danger": "#B91C1C",
            "danger_hover": "#991B1B",
            "border": "#D7E1EA",
        }
        self.root.configure(bg=self.palette["bg"])

        style = ttk.Style()
        # Use clam for predictable cross-platform ttk styling.
        if "clam" in style.theme_names():
            style.theme_use("clam")

        style.configure("Main.TFrame", background=self.palette["bg"])
        style.configure("Card.TFrame", background=self.palette["surface"])
        style.configure(
            "Title.TLabel",
            background=self.palette["bg"],
            foreground=self.palette["text"],
            font=("Segoe UI", 20, "bold"),
        )
        style.configure(
            "SubTitle.TLabel",
            background=self.palette["bg"],
            foreground=self.palette["muted"],
            font=("Segoe UI", 10),
        )
        style.configure(
            "TLabel",
            background=self.palette["surface"],
            foreground=self.palette["text"],
            font=("Segoe UI", 10),
        )
        style.configure(
            "TLabelframe",
            background=self.palette["surface"],
            bordercolor=self.palette["border"],
            relief="solid",
        )
        style.configure(
            "TLabelframe.Label",
            background=self.palette["surface"],
            foreground=self.palette["text"],
            font=("Segoe UI", 10, "bold"),
        )
        style.configure("TCombobox", padding=6)
        style.configure("TButton", padding=7, font=("Segoe UI", 10, "bold"))
        style.configure(
            "Accent.TButton",
            background=self.palette["accent"],
            foreground="white",
            padding=7,
            font=("Segoe UI", 10, "bold"),
        )
        style.map(
            "Accent.TButton",
            background=[("active", self.palette["accent_hover"]), ("pressed", self.palette["accent_hover"])],
            foreground=[("disabled", "#D1D5DB")],
        )
        style.configure(
            "Danger.TButton",
            background=self.palette["danger"],
            foreground="white",
            padding=7,
            font=("Segoe UI", 10, "bold"),
        )
        style.map(
            "Danger.TButton",
            background=[("active", self.palette["danger_hover"]), ("pressed", self.palette["danger_hover"])],
            foreground=[("disabled", "#D1D5DB")],
        )
        style.configure("TNotebook", background=self.palette["bg"], borderwidth=0)
        style.configure(
            "TNotebook.Tab",
            padding=(14, 8),
            font=("Segoe UI", 10, "bold"),
            background=self.palette["surface_alt"],
        )
        style.map(
            "TNotebook.Tab",
            background=[("selected", self.palette["surface"])],
            foreground=[("selected", self.palette["accent"])],
        )
        style.configure(
            "Status.TLabel",
            background=self.palette["surface_alt"],
            foreground=self.palette["muted"],
            padding=(10, 6),
            font=("Segoe UI", 9),
        )

    def _configure_plot_style(self):
        if not MATPLOTLIB_AVAILABLE:
            return
        plt.rcParams.update(
            {
                "font.size": 10,
                "axes.titlesize": 13,
                "axes.labelsize": 11,
                "xtick.labelsize": 9,
                "ytick.labelsize": 9,
                "legend.fontsize": 9,
                "axes.titleweight": "bold",
                "axes.edgecolor": "#CBD5E1",
                "axes.linewidth": 0.8,
                "grid.color": "#DDE5ED",
                "grid.linestyle": "-",
                "grid.alpha": 0.7,
                "figure.facecolor": "#FDFEFE",
                "axes.facecolor": "#FFFFFF",
            }
        )

    def create_widgets(self):
        self.main_frame = ttk.Frame(self.root, padding="14", style="Main.TFrame")

        # Title
        self.title_block = ttk.Frame(self.main_frame, style="Main.TFrame")
        self.title_label = ttk.Label(
            self.title_block,
            text="AriannesNetworks",
            style="Title.TLabel",
        )
        self.subtitle_label = ttk.Label(
            self.title_block,
            text="Personality Network Analysis Workspace",
            style="SubTitle.TLabel",
        )

        # Top panel: two side-by-side control boxes
        self.top_panel = ttk.Frame(self.main_frame)

        # Left box: Run R Analysis
        self.r_frame = ttk.LabelFrame(self.top_panel, text="Run R Analysis", padding="12")
        self.script_var = tk.StringVar(value="Neuroticism - Full Analysis (P0-P3)")
        self.script_combo = ttk.Combobox(
            self.r_frame, textvariable=self.script_var,
            values=list(self.r_scripts.keys()), state="readonly", width=42,
        )
        self.run_r_btn = ttk.Button(self.r_frame, text="Run R Script", command=self.on_run_r, style="Accent.TButton")
        self.stop_r_btn = ttk.Button(self.r_frame, text="Stop", command=self.stop_r, state="disabled", style="Danger.TButton")

        # Right box: View Results
        self.view_frame = ttk.LabelFrame(self.top_panel, text="View Results", padding="12")

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
        self.status_label = ttk.Label(self.main_frame, textvariable=self.status_var, anchor="w", style="Status.TLabel")

        # Notebook
        self.notebook = ttk.Notebook(self.main_frame)

        self.r_output_tab = ttk.Frame(self.notebook)
        self.r_output_text = scrolledtext.ScrolledText(
            self.r_output_tab,
            font=("Consolas", 9),
            bg="#FAFCFE",
            fg="#1F2933",
            insertbackground="#1F2933",
            relief="flat",
            borderwidth=0,
        )

        self.results_tab = ttk.Frame(self.notebook)
        self.results_text = scrolledtext.ScrolledText(
            self.results_tab,
            font=("Consolas", 9),
            bg="#FAFCFE",
            fg="#1F2933",
            insertbackground="#1F2933",
            relief="flat",
            borderwidth=0,
        )

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

        self.title_block.grid(row=0, column=0, pady=(0, 10), sticky="ew")
        self.title_block.columnconfigure(0, weight=1)
        self.title_label.grid(row=0, column=0, sticky="w")
        self.subtitle_label.grid(row=1, column=0, sticky="w", pady=(2, 0))

        # Top panel
        self.top_panel.grid(row=1, column=0, sticky="ew", pady=(0, 8))
        self.top_panel.columnconfigure(0, weight=1)
        self.top_panel.columnconfigure(1, weight=1)

        # Left: Run R Analysis
        self.r_frame.grid(row=0, column=0, sticky="nsew", padx=(0, 6))
        ttk.Label(self.r_frame, text="Script:").grid(row=0, column=0, sticky="w", pady=2)
        self.script_combo.grid(row=0, column=1, columnspan=2, sticky="ew", padx=(4, 0), pady=2)
        self.run_r_btn.grid(row=1, column=1, sticky="ew", padx=(4, 2), pady=(6, 0))
        self.stop_r_btn.grid(row=1, column=2, sticky="ew", padx=(2, 0), pady=(6, 0))
        self.r_frame.columnconfigure(1, weight=1)

        # Right: View Results
        self.view_frame.grid(row=0, column=1, sticky="nsew", padx=(6, 0))
        ttk.Label(self.view_frame, text="RData file:").grid(row=0, column=0, sticky="w", pady=2)
        self.rdata_combo.grid(row=0, column=1, sticky="ew", padx=(4, 4), pady=2)
        self.view_rdata_btn.grid(row=0, column=2, pady=2)
        ttk.Label(self.view_frame, text="Results CSV:").grid(row=1, column=0, sticky="w", pady=2)
        self.csv_combo.grid(row=1, column=1, sticky="ew", padx=(4, 4), pady=2)
        self.view_csv_btn.grid(row=1, column=2, pady=2)
        self.view_frame.columnconfigure(1, weight=1)

        # Notebook
        self.notebook.grid(row=2, column=0, sticky="nsew", pady=(2, 0))

        for tab, text_widget in [
            (self.r_output_tab, self.r_output_text),
            (self.results_tab, self.results_text),
        ]:
            tab.columnconfigure(0, weight=1)
            tab.rowconfigure(0, weight=1)
            text_widget.grid(row=0, column=0, sticky="nsew")

        # Status bar
        self.status_label.grid(row=3, column=0, sticky="ew", pady=(8, 0))

    # -------------------------------------------------------------------------
    # Visualizations tab
    # -------------------------------------------------------------------------

    def _build_viz_tab(self):
        self.viz_tab.columnconfigure(0, weight=4)
        self.viz_tab.columnconfigure(1, weight=2)
        self.viz_tab.rowconfigure(1, weight=1)

        # Control bar
        ctrl = ttk.Frame(self.viz_tab, padding="8")
        ctrl.grid(row=0, column=0, columnspan=2, sticky="ew")
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
        show_btn = ttk.Button(ctrl, text="Show Chart", command=self.on_show_chart, style="Accent.TButton")
        show_btn.pack(side="left")

        ToolTip(
            self.chart_combo,
            "Pick a chart, then click Show Chart.\n"
            "The explanation panel below translates each chart into plain language.",
        )
        ToolTip(
            show_btn,
            "Render the selected chart and refresh the explanation text below.",
        )

        if not MATPLOTLIB_AVAILABLE:
            ttk.Label(
                self.viz_tab,
                text="matplotlib not available. Install it to see charts.",
                foreground="red",
            ).grid(row=1, column=0, columnspan=2)
            return

        # Left side: chart canvas and toolbar.
        canvas_frame = ttk.Frame(self.viz_tab, style="Card.TFrame", padding="6")
        canvas_frame.grid(row=1, column=0, sticky="nsew", padx=(0, 6))
        canvas_frame.columnconfigure(0, weight=1)
        canvas_frame.rowconfigure(0, weight=1)
        self.viz_fig = plt.Figure(figsize=(11.4, 7.2), dpi=110, facecolor="#FDFEFE")
        self.viz_canvas = FigureCanvasTkAgg(self.viz_fig, master=canvas_frame)
        self.viz_canvas.get_tk_widget().grid(row=0, column=0, sticky="nsew")

        toolbar_frame = ttk.Frame(canvas_frame)
        toolbar_frame.grid(row=1, column=0, sticky="ew", pady=(6, 0))
        NavigationToolbar2Tk(self.viz_canvas, toolbar_frame)

        # Right side: facet key + reading guide.
        info_panel = ttk.Frame(self.viz_tab, style="Card.TFrame", padding="6")
        info_panel.grid(row=1, column=1, sticky="nsew", padx=(6, 0))
        info_panel.columnconfigure(0, weight=1)
        info_panel.rowconfigure(1, weight=1)

        facet_key = ttk.LabelFrame(info_panel, text="Facet Key", padding="8")
        facet_key.grid(row=0, column=0, sticky="ew")
        ttk.Label(
            facet_key,
            text=(
                "N1=Anxiety  |  N2=Anger  |  N3=Depression  |  "
                "N4=Self-Consciousness  |  N5=Immoderation  |  N6=Vulnerability"
            ),
            justify="left",
        ).pack(anchor="w")
        ttk.Label(
            facet_key,
            text=(
                "Plot colors identify data series/signs (methods, positive/negative edges). "
                "Status labels below are interpretation levels."
            ),
            justify="left",
        ).pack(anchor="w")

        # Chart explanation panel
        help_frame = ttk.LabelFrame(info_panel, text="How To Read This Chart", padding="8")
        help_frame.grid(row=1, column=0, sticky="nsew", pady=(8, 0))
        help_frame.columnconfigure(0, weight=1)
        help_frame.rowconfigure(0, weight=1)
        self.viz_help_text = scrolledtext.ScrolledText(
            help_frame,
            height=16,
            wrap="word",
            font=("Segoe UI", 10),
            bg="#FBFDFE",
            fg="#1F2933",
            insertbackground="#1F2933",
            relief="flat",
            borderwidth=0,
        )
        self.viz_help_text.grid(row=0, column=0, sticky="nsew")
        self.viz_help_text.tag_configure("heading", font=("Segoe UI", 10, "bold"), foreground="#0F3A4A")
        self.viz_help_text.tag_configure("good", foreground="#2E7D32", font=("Segoe UI", 10, "bold"))
        self.viz_help_text.tag_configure("watch", foreground="#EF6C00", font=("Segoe UI", 10, "bold"))
        self.viz_help_text.tag_configure("problem", foreground="#C62828", font=("Segoe UI", 10, "bold"))
        self.viz_help_text.tag_configure("mono", font=("Consolas", 9))
        self.viz_help_text.config(state="disabled")

        # Draw default chart after window renders
        self.root.after(300, self.on_show_chart)

    def on_show_chart(self):
        if not MATPLOTLIB_AVAILABLE:
            return
        chart = self.chart_var.get()
        self._update_chart_explanation(chart)
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

    def _update_chart_explanation(self, chart):
        """Chart-specific explanation with concrete, data-grounded notes."""
        try:
            if chart == "Network Centrality (Strength) by Facet":
                df = self._load_csv("network_centrality_comparison.csv")
                top = df.sort_values("disatt_strength", ascending=False).iloc[0]
                low = df.sort_values("disatt_strength", ascending=True).iloc[0]
                full_text = (
                    f"Bottom line: {top['facet']} is the strongest hub and {low['facet']} is the weakest under disattenuated scoring.\n"
                    "Chart purpose: Compare which facets are most connected in the network under different scoring methods.\n"
                    "Axes: X = facet; Y = strength centrality (higher means more connected).\n"
                    "Legend: Raw (blue), IRT (green), Discrimination-weighted (orange), Disattenuated (purple).\n"
                    f"Current data takeaway: Highest disattenuated facet is {top['facet']} ({top['disatt_strength']:.3f}); lowest is {low['facet']} ({low['disatt_strength']:.3f}).\n"
                    "Common pitfall: Do not compare colors as good/bad; compare heights within each facet across methods.\n"
                    "Quick metric definitions: Strength centrality = sum of absolute edge weights connected to a facet."
                )
            elif chart == "Edge Weights: Raw vs IRT vs Disattenuated":
                df = self._load_csv("network_edge_comparison.csv")
                peak = df.iloc[df["pct_change"].abs().idxmax()]
                full_text = (
                    f"Bottom line: The edge {peak['edge']} changes the most after disattenuation, so it is the key sensitivity check.\n"
                    "Chart purpose: Compare each facet-to-facet edge under three scoring pipelines.\n"
                    "Axes: X = edge pair; Y = edge weight value.\n"
                    "Legend: Raw (blue), IRT (orange), Disattenuated (green).\n"
                    f"Current data takeaway: Largest raw->disattenuated change is {peak['edge']} ({peak['pct_change']:.1f}%).\n"
                    "Common pitfall: A bigger value is not automatically better; it means a stronger modeled connection.\n"
                    "Quick metric definitions: Edge weight = conditional relationship between two facets after controlling others."
                )
            elif chart == "Network Graph - Raw Weights":
                full_text = (
                    "Bottom line: Use this view to identify the strongest raw-score links and candidate hubs.\n"
                    "Chart purpose: Show the raw-score network structure as nodes and weighted edges.\n"
                    "Axes: No numeric axes; layout is force-directed for readability.\n"
                    "Legend: Blue edge = positive relation; red edge = negative relation; thicker line = larger absolute weight.\n"
                    "Current data takeaway: Read node neighborhoods and labeled edges to see strongest direct relationships.\n"
                    "Common pitfall: Node proximity in this layout is visual convenience, not a direct metric.\n"
                    "Quick metric definitions: Edge labels are exact weights; line width scales with |weight|."
                )
            elif chart == "Network Graph - IRT Weights":
                full_text = (
                    "Bottom line: This chart shows which raw-network connections remain stable after IRT scoring.\n"
                    "Chart purpose: Show network structure after IRT-based scoring to test robustness of raw topology.\n"
                    "Axes: No numeric axes; same layout logic as raw graph.\n"
                    "Legend: Blue edge = positive relation; red edge = negative relation; thicker line = larger absolute weight.\n"
                    "Current data takeaway: Compare this graph edge-by-edge against Raw Weights to see which links are stable.\n"
                    "Common pitfall: Treating small visual shifts as major; use edge labels to confirm meaningful differences.\n"
                    "Quick metric definitions: IRT scores adjust for item characteristics before network estimation."
                )
            elif chart == "Scoring Method Correlation with NEO":
                df = self._load_csv("scoring_method_comparison.csv")
                means = df.groupby("method")["r_neo"].mean().sort_values(ascending=False)
                best = means.index[0]
                best_val = means.iloc[0]
                full_text = (
                    f"Bottom line: {best} has the best average alignment with NEO in this run.\n"
                    "Chart purpose: Compare criterion alignment of scoring methods against NEO for each facet.\n"
                    "Axes: X = facet; Y = correlation with NEO (higher is stronger alignment).\n"
                    "Legend: each color is one scoring method listed in the legend.\n"
                    f"Current data takeaway: Highest mean method is {best} (mean r={best_val:.3f}).\n"
                    "Common pitfall: Looking at a single facet only; check consistency across all six facets.\n"
                    "Quick metric definitions: Correlation r ranges -1 to +1; higher positive values indicate better agreement."
                )
            elif chart == "Item-Level Reliability (Alpha if Dropped)":
                df = self._load_csv("item_level_metrics.csv")
                worst = df.sort_values("alpha_if_dropped", ascending=False).iloc[0]
                full_text = (
                    f"Bottom line: {worst['item']} is the strongest candidate for review because dropping it yields the highest alpha.\n"
                    "Chart purpose: Show how reliability changes if each item is removed from its facet scale.\n"
                    "Axes: X = alpha-if-dropped; Y = item code, grouped by facet panel.\n"
                    "Legend: Single-color bars; this chart uses value and rank, not multi-series color coding.\n"
                    f"Current data takeaway: Highest alpha-if-dropped item is {worst['item']} ({worst['facet']}, {worst['alpha_if_dropped']:.3f}).\n"
                    "Common pitfall: Assuming high alpha-if-dropped is good; it can indicate the item is weakening scale consistency.\n"
                    "Quick metric definitions: Alpha = internal consistency reliability of a scale."
                )
            elif chart == "RF Feature Importance by Item":
                df = self._load_csv("rf_item_importance.csv")
                top = df.sort_values("rf_importance", ascending=False).iloc[0]
                full_text = (
                    f"Bottom line: {top['item']} is currently the most useful predictor in the RF ranking.\n"
                    "Chart purpose: Rank items by model-estimated predictive usefulness.\n"
                    "Axes: X = RF importance; Y = item code.\n"
                    "Legend: Single-color bars; interpretation is by bar length/value.\n"
                    f"Current data takeaway: Top item is {top['item']} ({top['facet']}, importance={top['rf_importance']:.4f}).\n"
                    "Common pitfall: Treating RF importance as causal effect; it is a predictive ranking only.\n"
                    "Quick metric definitions: RF importance approximates contribution to model performance."
                )
            elif chart == "2.5x Equivalence Comparison (OSF)":
                edge_diff = abs(0.2425 - 0.2490)
                rank_diff = abs(0.4552 - 0.4679)
                full_text = (
                    "Bottom line: The two 2.5x comparison bars are very close, supporting practical equivalence here.\n"
                    "Chart purpose: Test the specific docs claim that 2-item@84 is close to 1-item@212.\n"
                    "Axes: X = condition; Y = correlation metric value.\n"
                    "Legend: Left panel = edge correlation, right panel = centrality rank correlation.\n"
                    f"Current data takeaway: Differences are edge={edge_diff:.4f}, centrality={rank_diff:.4f}, which is small.\n"
                    "Common pitfall: Reading 2.5x as a y-axis multiplier; here it refers to sample-size ratio context.\n"
                    "Quick metric definitions: Edge correlation compares edge patterns; rank correlation compares centrality ordering."
                )
            elif chart == "Redundancy Proof: Anxiety Item + Facet Overlap":
                full_text = (
                    "Bottom line: The Anxiety/Depression split is only modest, so discriminant separation is limited in this setup.\n"
                    "Chart purpose: Show one weak Anxiety item plus Anxiety/Depression overlap in facet prediction.\n"
                    "Axes: Left panel X = RF importance percent by item; right panel Y = R^2 for own vs best-other facet prediction.\n"
                    "Legend: Left panel red bars mark very low-importance items; right panel compares own R^2 (green) vs best-other R^2 (orange).\n"
                    "Current data takeaway: Ratio near 1.42 indicates Anxiety and Depression are weakly separated in this setup.\n"
                    "Common pitfall: Equating overlap with identical constructs; overlap indicates limited discriminant separation, not perfect sameness.\n"
                    "Quick metric definitions: Discriminant ratio = own R^2 / best-other R^2; values near 1 imply overlap."
                )
            else:
                full_text = (
                    "Bottom line: No chart-specific guide is available for this selection yet.\n"
                    "Chart purpose: No explanation available for this chart."
                )
        except Exception as e:
            full_text = (
                "Bottom line: The chart can still be interpreted, but explanation details failed to generate.\n"
                "Chart purpose: Explanation fallback due to data read issue.\n"
                "How to read: Use axis labels, legend, and numeric annotations on the chart itself.\n"
                f"Current data takeaway: explanation builder error: {e}"
            )

        self._set_help_text(full_text)

    def _set_help_text(self, text):
        """Render explanation text with color tags for interpretation bands."""
        self.viz_help_text.config(state="normal")
        self.viz_help_text.delete("1.0", tk.END)
        heading_prefixes = [
            "Bottom line:",
            "Chart purpose:",
            "Axes:",
            "Legend:",
            "Current data takeaway:",
            "Common pitfall:",
            "How to read:",
            "Quick metric definitions:",
        ]
        for line in text.splitlines():
            if (
                line.startswith("Bottom line:")
                or line.startswith("Chart purpose:")
                or line.startswith("Axes:")
                or line.startswith("Legend:")
                or line.startswith("Current data takeaway:")
                or line.startswith("Common pitfall:")
                or line.startswith("How to read:")
                or line.startswith("Quick metric definitions:")
            ):
                if ":" in line:
                    key, rest = line.split(":", 1)
                    self.viz_help_text.insert(tk.END, key + ":", "heading")
                    self.viz_help_text.insert(tk.END, rest + "\n")
                else:
                    self.viz_help_text.insert(tk.END, line + "\n", "heading")
            else:
                self.viz_help_text.insert(tk.END, line + "\n")
        self.viz_help_text.config(state="disabled")

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
        pretty_labels = {
            "raw_strength": "Raw",
            "irt_strength": "IRT",
            "discrim_strength": "Discrimination-weighted",
            "disatt_strength": "Disattenuated (measurement-error corrected)",
        }
        for i, col in enumerate(strength_cols):
            ax.bar(x + i * w, df[col], w,
                   label=pretty_labels.get(col, col.replace("_strength", "")),
                   color=colors[i % len(colors)])
        ax.set_xticks(x + w * (len(strength_cols) - 1) / 2)
        ax.set_xticklabels(df["facet"], rotation=30, ha="right")
        ax.set_ylabel("Strength Centrality")
        ax.set_title("Network Centrality (Strength) by Facet")
        ax.grid(axis="y")
        ax.legend(loc="upper center", bbox_to_anchor=(0.5, 1.16), ncol=2, frameon=False)
        ax.text(
            0.01,
            0.98,
            "Purple = Disattenuated (measurement-error corrected)",
            transform=ax.transAxes,
            va="top",
            fontsize=8,
        )
        self.viz_fig.tight_layout(rect=[0, 0, 1, 0.94])

    def _chart_edges(self):
        df = self._load_csv("network_edge_comparison.csv")
        ax = self.viz_fig.add_subplot(111)
        y = np.arange(len(df))
        h = 0.24
        palette = {
            "raw": "#1F77B4",
            "irt": "#FF7F0E",
            "disattenuated": "#2CA02C",
        }
        pretty = {
            "raw": "Raw",
            "irt": "IRT",
            "disattenuated": "Disattenuated",
        }
        for i, col in enumerate(["raw", "irt", "disattenuated"]):
            if col in df.columns:
                bars = ax.barh(y + (i - 1) * h, df[col], h, label=pretty.get(col, col), color=palette[col])
                ax.bar_label(bars, fmt="%.2f", fontsize=7, padding=2)
        ax.set_yticks(y)
        ax.set_yticklabels(df["edge"], fontsize=8)
        ax.set_xlabel("Edge Weight")
        ax.set_title("Edge Weights: Raw vs IRT vs Disattenuated")
        ax.grid(axis="x")
        ax.legend(loc="lower right", frameon=False)
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
                         font_size=9, font_weight="bold")
        edge_labels = {(u, v): f"{G[u][v]['weight']:.2f}" for u, v in G.edges()}
        nx.draw_networkx_edge_labels(
            G,
            pos,
            edge_labels=edge_labels,
            font_size=7,
            ax=ax,
            bbox={"alpha": 0.6, "facecolor": "white", "edgecolor": "none"},
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
        ax.grid(axis="y")
        ax.legend(loc="upper center", bbox_to_anchor=(0.5, 1.14), ncol=3, frameon=False)
        self.viz_fig.tight_layout(rect=[0, 0, 1, 0.93])

    def _chart_item_reliability(self):
        df = self._load_csv("item_level_metrics.csv")
        facets = df["facet"].unique()[:6]
        n = len(facets)
        cols_n = 2
        rows_n = (n + cols_n - 1) // cols_n
        for idx, facet in enumerate(facets):
            ax = self.viz_fig.add_subplot(rows_n, cols_n, idx + 1)
            sub = df[df["facet"] == facet].sort_values("item")
            ax.barh(sub["item"], sub["alpha_if_dropped"], color="#2196F3")
            ax.set_title(facet, fontsize=10)
            ax.grid(axis="x")
            ax.tick_params(labelsize=8)
        self.viz_fig.suptitle("Alpha if Item Dropped", fontsize=11)
        self.viz_fig.tight_layout(rect=[0, 0, 1, 0.96])

    def _chart_rf_importance(self):
        df = self._load_csv("rf_item_importance.csv")
        df = df.sort_values("rf_importance", ascending=True).tail(30)
        ax = self.viz_fig.add_subplot(111)
        ax.barh(df["item"], df["rf_importance"], color="#4CAF50")
        ax.set_xlabel("RF Importance")
        ax.set_title("Top 30 Items by Random Forest Importance")
        ax.grid(axis="x")
        ax.tick_params(axis="y", labelsize=8)
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
