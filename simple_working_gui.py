#!/usr/bin/env python3
"""
Simple Working GUI for AriannesNetworks
A clean, simple GUI that loads data and displays results without auto-execution.
"""

import tkinter as tk
from tkinter import ttk, messagebox, filedialog, scrolledtext
import sys
from pathlib import Path
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
import networkx as nx
import subprocess
import threading
import os
import shutil

# Try to import pyreadr for RData file reading
try:
    import pyreadr
    PYREADR_AVAILABLE = True
except ImportError:
    PYREADR_AVAILABLE = False
    print("Warning: pyreadr not available. RData file loading will be limited.")

# Add src to path
sys.path.append(str(Path(__file__).parent / "src"))

from network_analysis import PersonalityNetworkAnalyzer
from research_findings_50sim import ResearchFindings50Sim

class SimpleGUI:
    def __init__(self, root):
        self.root = root
        self.root.title("AriannesNetworks - Simple GUI")
        self.root.geometry("1200x800")
        
        # Data
        self.analyzer = None
        self.research_findings = None
        self.current_data = None
        self.current_results = None
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
            "P3 - Network Analysis (Agreeableness)": "r_scripts/NEO & IPIP - P3 - netcompare & analysis_A.R"
        }
        
        # Dataset mappings
        self.datasets = {
            "CSV: NEO_IPIP_1.csv": "data/NEO_IPIP_1.csv",
            "RData: P1 Results (Neuroticism)": "data/NEO & IPIP - P1_nSim50_data_N.RData",
            "RData: P1 Results (Agreeableness)": "data/NEO & IPIP - P1_nSim50_data_A.RData",
            "RData: P2 Results (Neuroticism)": "data/NEO & IPIP - P2_nSim50_data_N.RData",
            "RData: P2 Results (Agreeableness)": "data/NEO & IPIP - P2_nSim50_data_A.RData",
            "RData: P3 Results (Neuroticism)": "data/NEO & IPIP - P3_nSim50_results_all_N.RData",
            "RData: P3 Results (Agreeableness)": "data/NEO & IPIP - P3_nSim50_results_all_A.RData"
        }
        
        self.create_widgets()
        self.setup_layout()
        
    def create_widgets(self):
        """Create all GUI widgets."""
        # Main frame
        self.main_frame = ttk.Frame(self.root, padding="10")
        
        # Title
        self.title_label = ttk.Label(
            self.main_frame, 
            text="🧠 AriannesNetworks - Personality Network Analysis",
            font=('Arial', 16, 'bold')
        )
        
        # Control frame
        self.control_frame = ttk.LabelFrame(self.main_frame, text="Controls", padding="10")
        
        # R Script selection
        self.script_frame = ttk.Frame(self.control_frame)
        self.script_label = ttk.Label(self.script_frame, text="R Script:")
        self.script_var = tk.StringVar(value="Neuroticism - Full Analysis (P0-P3)")
        self.script_combo = ttk.Combobox(self.script_frame, textvariable=self.script_var, 
                                         values=list(self.r_scripts.keys()), state="readonly", width=45)
        
        # Dataset selection
        self.dataset_frame = ttk.Frame(self.control_frame)
        self.dataset_label = ttk.Label(self.dataset_frame, text="Dataset:")
        self.dataset_var = tk.StringVar(value="CSV: NEO_IPIP_1.csv")
        self.dataset_combo = ttk.Combobox(self.dataset_frame, textvariable=self.dataset_var,
                                          values=list(self.datasets.keys()), state="readonly", width=45)
        
        # Data file selection (for Python analysis)
        self.data_frame = ttk.Frame(self.control_frame)
        self.data_label = ttk.Label(self.data_frame, text="Data File (Python):")
        self.data_path_var = tk.StringVar(value="data/NEO_IPIP_1.csv")
        self.data_entry = ttk.Entry(self.data_frame, textvariable=self.data_path_var, width=40)
        self.browse_btn = ttk.Button(self.data_frame, text="Browse", command=self.browse_file)
        
        # Buttons
        self.button_frame = ttk.Frame(self.control_frame)
        self.load_btn = ttk.Button(self.button_frame, text="📊 Load Data (Python)", command=self.load_data)
        self.analyze_btn = ttk.Button(self.button_frame, text="🚀 Run R Analysis", command=self.run_analysis)
        self.python_btn = ttk.Button(self.button_frame, text="🐍 Run Python Analysis", command=self.run_python_analysis)
        self.findings_btn = ttk.Button(self.button_frame, text="🔬 Research Findings", command=self.run_research_findings)
        self.clear_btn = ttk.Button(self.button_frame, text="🗑️ Clear", command=self.clear_results)
        
        # Status
        self.status_var = tk.StringVar(value="Ready - Select R script and dataset, then click 'Run R Analysis'")
        self.status_label = ttk.Label(self.control_frame, textvariable=self.status_var)
        
        # Results frame
        self.results_frame = ttk.LabelFrame(self.main_frame, text="Results", padding="10")
        
        # Notebook for tabs
        self.notebook = ttk.Notebook(self.results_frame)
        
        # Data summary tab
        self.data_tab = ttk.Frame(self.notebook)
        self.data_text = scrolledtext.ScrolledText(self.data_tab, height=10, width=80)
        
        # Network properties tab
        self.network_tab = ttk.Frame(self.notebook)
        self.network_text = scrolledtext.ScrolledText(self.network_tab, height=10, width=80)
        
        # Centrality tab
        self.centrality_tab = ttk.Frame(self.notebook)
        self.centrality_text = scrolledtext.ScrolledText(self.centrality_tab, height=10, width=80)
        
        # Visualization tab
        self.viz_tab = ttk.Frame(self.notebook)
        self.viz_canvas = None
        
        # Research findings tab
        self.findings_tab = ttk.Frame(self.notebook)
        self.findings_text = scrolledtext.ScrolledText(self.findings_tab, height=10, width=80)
        
        # R Output tab
        self.r_output_tab = ttk.Frame(self.notebook)
        self.r_output_text = scrolledtext.ScrolledText(self.r_output_tab, height=10, width=80)
        
        # R Results tab
        self.r_results_tab = ttk.Frame(self.notebook)
        self.r_results_text = scrolledtext.ScrolledText(self.r_results_tab, height=10, width=80)
        
        # Add tabs
        self.notebook.add(self.r_output_tab, text="R Output")
        self.notebook.add(self.r_results_tab, text="R Results")
        self.notebook.add(self.data_tab, text="Data Summary")
        self.notebook.add(self.network_tab, text="Network Properties")
        self.notebook.add(self.centrality_tab, text="Centrality Measures")
        self.notebook.add(self.viz_tab, text="Visualizations")
        self.notebook.add(self.findings_tab, text="Research Findings")
        
    def setup_layout(self):
        """Set up the layout."""
        self.main_frame.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        self.root.columnconfigure(0, weight=1)
        self.root.rowconfigure(0, weight=1)
        self.main_frame.columnconfigure(0, weight=1)
        self.main_frame.rowconfigure(1, weight=1)
        
        # Title
        self.title_label.grid(row=0, column=0, pady=(0, 20))
        
        # Control frame
        self.control_frame.grid(row=0, column=0, sticky=(tk.W, tk.E), pady=(0, 10))
        
        # R Script selection
        self.script_frame.grid(row=0, column=0, sticky=(tk.W, tk.E), pady=5)
        self.script_label.grid(row=0, column=0, padx=(0, 5))
        self.script_combo.grid(row=0, column=1, padx=(0, 5))
        
        # Dataset selection
        self.dataset_frame.grid(row=1, column=0, sticky=(tk.W, tk.E), pady=5)
        self.dataset_label.grid(row=0, column=0, padx=(0, 5))
        self.dataset_combo.grid(row=0, column=1, padx=(0, 5))
        
        # Data selection (for Python analysis)
        self.data_frame.grid(row=2, column=0, sticky=(tk.W, tk.E), pady=5)
        self.data_label.grid(row=0, column=0, padx=(0, 5))
        self.data_entry.grid(row=0, column=1, padx=(0, 5))
        self.browse_btn.grid(row=0, column=2)
        
        # Buttons
        self.button_frame.grid(row=3, column=0, pady=10)
        self.load_btn.grid(row=0, column=0, padx=5)
        self.analyze_btn.grid(row=0, column=1, padx=5)
        self.python_btn.grid(row=0, column=2, padx=5)
        self.findings_btn.grid(row=0, column=3, padx=5)
        self.clear_btn.grid(row=0, column=4, padx=5)
        
        # Status
        self.status_label.grid(row=4, column=0, pady=5)
        
        # Results
        self.results_frame.grid(row=1, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        self.notebook.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        self.results_frame.columnconfigure(0, weight=1)
        self.results_frame.rowconfigure(0, weight=1)
        
        # Tab content
        self.r_output_text.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        self.r_results_text.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        self.data_text.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        self.network_text.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        self.centrality_text.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        self.findings_text.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        
        # Configure tab grids
        self.r_output_tab.columnconfigure(0, weight=1)
        self.r_output_tab.rowconfigure(0, weight=1)
        self.r_results_tab.columnconfigure(0, weight=1)
        self.r_results_tab.rowconfigure(0, weight=1)
        self.data_tab.columnconfigure(0, weight=1)
        self.data_tab.rowconfigure(0, weight=1)
        self.network_tab.columnconfigure(0, weight=1)
        self.network_tab.rowconfigure(0, weight=1)
        self.centrality_tab.columnconfigure(0, weight=1)
        self.centrality_tab.rowconfigure(0, weight=1)
        self.findings_tab.columnconfigure(0, weight=1)
        self.findings_tab.rowconfigure(0, weight=1)
        
    def browse_file(self):
        """Browse for data file."""
        filename = filedialog.askopenfilename(
            title="Select Data File",
            filetypes=[("CSV files", "*.csv"), ("All files", "*.*")]
        )
        if filename:
            self.data_path_var.set(filename)
    
    def load_data(self):
        """Load data."""
        try:
            self.status_var.set("Loading data...")
            self.root.update()
            
            data_path = self.data_path_var.get()
            if not data_path:
                messagebox.showerror("Error", "Please select a data file")
                return
                
            # Initialize analyzer and load data
            self.analyzer = PersonalityNetworkAnalyzer()
            self.analyzer.load_data(data_path)
            self.analyzer.preprocess_data()
            self.current_data = self.analyzer.data_processed
            
            # Initialize research findings module
            self.research_findings = ResearchFindings50Sim(self.analyzer)
            
            # Update data summary
            self.update_data_summary()
            
            self.status_var.set("Data loaded successfully")
            
        except Exception as e:
            messagebox.showerror("Error", f"Failed to load data: {e}")
            self.status_var.set("Error loading data")
    
    def run_analysis(self):
        """Run R analysis (default) or Python analysis."""
        # Check if dataset is an RData file - if so, load results instead of running script
        selected_dataset = self.dataset_var.get()
        if selected_dataset.startswith("RData:"):
            self.load_r_results(self.datasets[selected_dataset])
            return
        
        # Otherwise, run R script
        selected_script = self.script_var.get()
        if selected_script not in self.r_scripts:
            messagebox.showerror("Error", "Please select a valid R script")
            return
        
        script_path = self.r_scripts[selected_script]
        self.run_r_script(script_path)
    
    def find_rscript(self):
        """Find Rscript executable."""
        # Try common locations
        if os.name == 'nt':  # Windows
            possible_paths = [
                r"C:\Program Files\R\R-*\bin\Rscript.exe",
                r"C:\Program Files (x86)\R\R-*\bin\Rscript.exe",
                "Rscript.exe"
            ]
            # Check if Rscript is in PATH
            rscript_path = shutil.which("Rscript.exe")
            if rscript_path:
                return rscript_path
            
            # Try to find in Program Files
            import glob
            for pattern in possible_paths:
                matches = glob.glob(pattern)
                if matches:
                    # Get the latest version
                    matches.sort(reverse=True)
                    return matches[0]
        else:  # Unix/Mac
            rscript_path = shutil.which("Rscript")
            if rscript_path:
                return rscript_path
        
        return None
    
    def run_r_script(self, script_path):
        """Run R script and display output in real-time."""
        # Check if R is available
        rscript_exe = self.find_rscript()
        if not rscript_exe:
            messagebox.showerror("Error", "Rscript not found. Please install R and ensure Rscript is in your PATH.")
            return
        
        # Check if script exists
        if not os.path.exists(script_path):
            messagebox.showerror("Error", f"R script not found: {script_path}")
            return
        
        # Clear output
        self.r_output_text.delete(1.0, tk.END)
        self.r_output_text.insert(1.0, f"Running R script: {script_path}\n")
        self.r_output_text.insert(tk.END, f"Using Rscript: {rscript_exe}\n")
        self.r_output_text.insert(tk.END, "="*70 + "\n\n")
        
        # Switch to R Output tab
        self.notebook.select(self.r_output_tab)
        
        # Update status
        self.status_var.set(f"Running R script: {os.path.basename(script_path)}...")
        
        # Run in a separate thread to avoid blocking GUI
        def run_script():
            try:
                # Change to project root directory
                project_root = Path(__file__).parent
                os.chdir(project_root)
                
                # Start R process
                self.r_process = subprocess.Popen(
                    [rscript_exe, script_path],
                    stdout=subprocess.PIPE,
                    stderr=subprocess.STDOUT,
                    universal_newlines=True,
                    bufsize=1,
                    cwd=str(project_root)
                )
                
                # Read output line by line
                for line in iter(self.r_process.stdout.readline, ''):
                    if line:
                        self.root.after(0, self.append_r_output, line)
                
                # Wait for process to complete
                self.r_process.wait()
                
                # Update status
                if self.r_process.returncode == 0:
                    self.root.after(0, lambda: self.status_var.set("R script completed successfully"))
                    self.root.after(0, lambda: self.r_output_text.insert(tk.END, "\n" + "="*70 + "\n"))
                    self.root.after(0, lambda: self.r_output_text.insert(tk.END, "R script completed successfully!\n"))
                else:
                    self.root.after(0, lambda: self.status_var.set(f"R script failed with exit code {self.r_process.returncode}"))
                    self.root.after(0, lambda: self.r_output_text.insert(tk.END, f"\nR script failed with exit code {self.r_process.returncode}\n"))
                
            except Exception as e:
                self.root.after(0, lambda: messagebox.showerror("Error", f"Failed to run R script: {e}"))
                self.root.after(0, lambda: self.status_var.set("R script execution failed"))
        
        self.r_output_thread = threading.Thread(target=run_script, daemon=True)
        self.r_output_thread.start()
    
    def append_r_output(self, text):
        """Append text to R output tab."""
        self.r_output_text.insert(tk.END, text)
        self.r_output_text.see(tk.END)
        self.root.update_idletasks()
    
    def load_r_results(self, rdata_path):
        """Load and display R results from RData file."""
        if not PYREADR_AVAILABLE:
            messagebox.showwarning("Warning", "pyreadr not available. Cannot load RData files.\nPlease install: pip install pyreadr")
            return
        
        if not os.path.exists(rdata_path):
            messagebox.showerror("Error", f"RData file not found: {rdata_path}")
            return
        
        try:
            self.status_var.set(f"Loading R results from {os.path.basename(rdata_path)}...")
            self.root.update()
            
            # Load RData file
            result = pyreadr.read_r(rdata_path)
            
            # Clear results tab
            self.r_results_text.delete(1.0, tk.END)
            
            # Display file info
            self.r_results_text.insert(tk.END, f"📊 R RESULTS FROM: {os.path.basename(rdata_path)}\n")
            self.r_results_text.insert(tk.END, "="*70 + "\n\n")
            self.r_results_text.insert(tk.END, f"Objects in file: {list(result.keys())}\n\n")
            
            # Extract and display key metrics
            for key, data in result.items():
                self.r_results_text.insert(tk.END, f"\n{'='*70}\n")
                self.r_results_text.insert(tk.END, f"OBJECT: {key}\n")
                self.r_results_text.insert(tk.END, f"{'='*70}\n")
                
                if isinstance(data, pd.DataFrame):
                    self.r_results_text.insert(tk.END, f"Type: DataFrame\n")
                    self.r_results_text.insert(tk.END, f"Shape: {data.shape}\n")
                    self.r_results_text.insert(tk.END, f"Columns: {list(data.columns)}\n\n")
                    
                    # Display first few rows
                    self.r_results_text.insert(tk.END, "First rows:\n")
                    self.r_results_text.insert(tk.END, str(data.head(20)) + "\n\n")
                    
                    # If it's a results dataframe, try to extract key metrics
                    if 'glstr' in key.lower() or 'edgecorr' in key.lower() or 'rankcorr' in key.lower():
                        self.r_results_text.insert(tk.END, "\nKey Metrics:\n")
                        self.r_results_text.insert(tk.END, str(data) + "\n\n")
                
                elif isinstance(data, pd.Series):
                    self.r_results_text.insert(tk.END, f"Type: Series\n")
                    self.r_results_text.insert(tk.END, f"Length: {len(data)}\n")
                    self.r_results_text.insert(tk.END, f"Values: {data.values[:20]}\n\n")
                
                else:
                    self.r_results_text.insert(tk.END, f"Type: {type(data)}\n")
                    self.r_results_text.insert(tk.END, f"Value: {str(data)[:500]}\n\n")
            
            # Switch to R Results tab
            self.notebook.select(self.r_results_tab)
            self.status_var.set(f"R results loaded successfully from {os.path.basename(rdata_path)}")
            
        except Exception as e:
            messagebox.showerror("Error", f"Failed to load R results: {e}")
            self.status_var.set("Failed to load R results")
    
    def run_python_analysis(self):
        """Run Python network analysis (original functionality)."""
        if self.current_data is None:
            messagebox.showwarning("Warning", "Please load data first")
            return
            
        try:
            self.status_var.set("Running Python analysis...")
            self.root.update()
            
            # Select variables
            neo_vars = [col for col in self.current_data.columns 
                       if col.startswith(('N', 'E', 'O', 'A', 'C')) and len(col) <= 2][:10]
            ipip_vars = [col for col in self.current_data.columns 
                        if col.startswith(('I', 'a', 'b', 'c', 'd', 'e', 'h', 'm', 'n', 'p', 'q', 'r', 's', 'v', 'x'))][:10]
            
            # Run analysis
            results = {}
            
            if neo_vars:
                neo_network = self.analyzer.construct_network(neo_vars, method='correlation', network_name='neo_network')
                neo_result = self.analyzer.analyze_network_properties('neo_network')
                results['NEO'] = neo_result  # Store the full result directly
            
            if ipip_vars:
                ipip_network = self.analyzer.construct_network(ipip_vars, method='correlation', network_name='ipip_network')
                ipip_result = self.analyzer.analyze_network_properties('ipip_network')
                results['IPIP'] = ipip_result  # Store the full result directly
            
            self.current_results = results
            
            # Update displays
            self.update_network_properties()
            self.update_centrality_measures()
            self.create_visualization()
            
            self.status_var.set("Python analysis completed successfully")
            
        except Exception as e:
            messagebox.showerror("Error", f"Python analysis failed: {e}")
            self.status_var.set("Python analysis failed")
    
    def run_research_findings(self):
        """Run research findings analysis separately."""
        if self.research_findings is None:
            messagebox.showwarning("Warning", "Please load data first")
            return
            
        try:
            self.status_var.set("Running research findings analysis...")
            self.root.update()
            
            # Run research findings analysis
            print("\n🔬 Running research findings analysis...")
            
            # Demonstrate key findings
            aggregation_results = self.research_findings.demonstrate_item_aggregation_effects()
            scale_results = self.research_findings.demonstrate_scale_differences()
            replicability_results = self.research_findings.demonstrate_replicability_concerns()
            generalizability_results = self.research_findings.demonstrate_generalizability_issues()
            
            # Generate summary
            summary = self.research_findings.generate_research_summary()
            
            # Display in GUI
            self.findings_text.delete(1.0, tk.END)
            self.findings_text.insert(1.0, summary)
            
            # Switch to research findings tab
            self.notebook.select(self.findings_tab)
            
            self.status_var.set("Research findings analysis completed")
            
        except Exception as e:
            messagebox.showerror("Error", f"Research findings analysis failed: {e}")
            self.status_var.set("Research findings analysis failed")
    
    def update_data_summary(self):
        """Update data summary display."""
        if self.current_data is None:
            return
            
        summary = f"""📊 DATA SUMMARY
{'='*50}

Dataset Shape: {self.current_data.shape}
Missing Values: {self.current_data.isnull().sum().sum()}
Memory Usage: {self.current_data.memory_usage(deep=True).sum() / 1024**2:.2f} MB

Column Categories:
"""
        
        # Categorize columns
        neo_cols = [col for col in self.current_data.columns 
                   if col.startswith(('N', 'E', 'O', 'A', 'C')) and len(col) <= 2]
        ipip_cols = [col for col in self.current_data.columns 
                    if col.startswith(('I', 'a', 'b', 'c', 'd', 'e', 'h', 'm', 'n', 'p', 'q', 'r', 's', 'v', 'x'))]
        other_cols = [col for col in self.current_data.columns 
                     if col not in neo_cols and col not in ipip_cols]
        
        summary += f"  NEO Variables: {len(neo_cols)}\n"
        summary += f"  IPIP Variables: {len(ipip_cols)}\n"
        summary += f"  Other Variables: {len(other_cols)}\n"
        
        if neo_cols:
            summary += f"\nNEO Variables: {neo_cols[:10]}{'...' if len(neo_cols) > 10 else ''}\n"
        if ipip_cols:
            summary += f"IPIP Variables: {ipip_cols[:10]}{'...' if len(ipip_cols) > 10 else ''}\n"
        
        self.data_text.delete(1.0, tk.END)
        self.data_text.insert(1.0, summary)
    
    def update_network_properties(self):
        """Update network properties display."""
        if self.current_results is None:
            return
            
        text = "🔗 NETWORK PROPERTIES\n"
        text += "="*50 + "\n\n"
        
        for network_type, result in self.current_results.items():
            text += f"{network_type.upper()} NETWORK\n"
            text += "-"*30 + "\n"
            
            props = result['properties']
            text += f"Nodes: {props.get('nodes', 'N/A')}\n"
            text += f"Edges: {props.get('edges', 'N/A')}\n"
            
            # Handle numeric formatting safely
            density = props.get('density', 'N/A')
            if isinstance(density, (int, float)):
                text += f"Density: {density:.3f}\n"
            else:
                text += f"Density: {density}\n"
            
            clustering = props.get('average_clustering', 'N/A')
            if isinstance(clustering, (int, float)):
                text += f"Average Clustering: {clustering:.3f}\n"
            else:
                text += f"Average Clustering: {clustering}\n"
            
            transitivity = props.get('transitivity', 'N/A')
            if isinstance(transitivity, (int, float)):
                text += f"Transitivity: {transitivity:.3f}\n"
            else:
                text += f"Transitivity: {transitivity}\n"
            
            path_length = props.get('average_shortest_path_length', 'N/A')
            if isinstance(path_length, (int, float)):
                text += f"Average Path Length: {path_length:.3f}\n"
            else:
                text += f"Average Path Length: {path_length}\n"
            
            text += f"Diameter: {props.get('diameter', 'N/A')}\n"
            text += f"Connected: {'Yes' if props.get('is_connected', 0) else 'No'}\n"
            text += f"Components: {props.get('number_of_components', 'N/A')}\n\n"
        
        self.network_text.delete(1.0, tk.END)
        self.network_text.insert(1.0, text)
    
    def update_centrality_measures(self):
        """Update centrality measures display."""
        if self.current_results is None:
            return
            
        text = "⭐ CENTRALITY MEASURES\n"
        text += "="*50 + "\n\n"
        
        for network_type, result in self.current_results.items():
            text += f"{network_type.upper()} NETWORK\n"
            text += "-"*30 + "\n"
            
            # Get centrality measures from the analysis results
            try:
                if 'centrality_measures' in result:
                    centrality_measures = result['centrality_measures']
                    text += "Top 5 Most Central Nodes:\n"
                    
                    # Get degree centrality and sort by it
                    degree_centrality = centrality_measures.get('degree', {})
                    sorted_nodes = sorted(degree_centrality.items(), key=lambda x: x[1], reverse=True)
                    
                    for i, (node, degree_val) in enumerate(sorted_nodes[:5]):
                        betweenness_val = centrality_measures.get('betweenness', {}).get(node, 0)
                        closeness_val = centrality_measures.get('closeness', {}).get(node, 0)
                        
                        text += f"  {node}: "
                        if isinstance(degree_val, (int, float)):
                            text += f"degree={degree_val:.3f}, "
                        else:
                            text += f"degree={degree_val}, "
                        
                        if isinstance(betweenness_val, (int, float)):
                            text += f"betweenness={betweenness_val:.3f}, "
                        else:
                            text += f"betweenness={betweenness_val}, "
                        
                        if isinstance(closeness_val, (int, float)):
                            text += f"closeness={closeness_val:.3f}\n"
                        else:
                            text += f"closeness={closeness_val}\n"
                else:
                    text += "No centrality measures available\n"
            except Exception as e:
                text += f"Error calculating centrality measures: {e}\n"
            
            text += "\n"
        
        self.centrality_text.delete(1.0, tk.END)
        self.centrality_text.insert(1.0, text)
    
    def create_visualization(self):
        """Create network visualization."""
        if self.current_results is None:
            return
            
        # Clear existing canvas
        for widget in self.viz_tab.winfo_children():
            widget.destroy()
        
        # Create new figure
        fig, axes = plt.subplots(1, len(self.current_results), figsize=(12, 6))
        if len(self.current_results) == 1:
            axes = [axes]
        
        for i, (network_type, result) in enumerate(self.current_results.items()):
            if i >= len(axes):
                break
                
            # Get the network from the analyzer
            network_name = f"{network_type.lower()}_network"
            network = self.analyzer.networks[network_name]['graph']
            ax = axes[i]
            
            # Simple network visualization
            pos = nx.spring_layout(network, k=1, iterations=50)
            nx.draw(network, pos, ax=ax, with_labels=True, node_color='lightblue', 
                   node_size=500, font_size=8, font_weight='bold')
            ax.set_title(f"{network_type} Network")
        
        plt.tight_layout()
        
        # Embed in tkinter
        canvas = FigureCanvasTkAgg(fig, self.viz_tab)
        canvas.draw()
        canvas.get_tk_widget().grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        
        self.viz_canvas = canvas
    
    def update_research_findings(self):
        """Update research findings display."""
        if self.research_findings is None:
            return
            
        try:
            # Run research findings analysis
            print("\nRunning research findings analysis...")
            
            # Demonstrate key findings
            sample_results = self.research_findings.demonstrate_item_aggregation_effects()
            scale_results = self.research_findings.demonstrate_scale_differences()
            replicability_results = self.research_findings.demonstrate_replicability_concerns()
            generalizability_results = self.research_findings.demonstrate_generalizability_issues()
            
            # Generate summary
            summary = self.research_findings.generate_research_summary()
            
            # Display in GUI
            self.findings_text.delete(1.0, tk.END)
            self.findings_text.insert(1.0, summary)
            
        except Exception as e:
            error_msg = f"Error running research findings analysis: {e}"
            self.findings_text.delete(1.0, tk.END)
            self.findings_text.insert(1.0, error_msg)
    
    def clear_results(self):
        """Clear all results."""
        self.data_text.delete(1.0, tk.END)
        self.network_text.delete(1.0, tk.END)
        self.centrality_text.delete(1.0, tk.END)
        self.findings_text.delete(1.0, tk.END)
        self.r_output_text.delete(1.0, tk.END)
        self.r_results_text.delete(1.0, tk.END)
        
        # Clear visualization
        for widget in self.viz_tab.winfo_children():
            widget.destroy()
        
        # Stop R process if running
        if self.r_process and self.r_process.poll() is None:
            self.r_process.terminate()
            self.r_process = None
        
        self.current_data = None
        self.current_results = None
        self.analyzer = None
        self.research_findings = None
        
        self.status_var.set("Results cleared")

def main():
    """Main function."""
    root = tk.Tk()
    app = SimpleGUI(root)
    
    # Center window
    root.update_idletasks()
    x = (root.winfo_screenwidth() // 2) - (root.winfo_width() // 2)
    y = (root.winfo_screenheight() // 2) - (root.winfo_height() // 2)
    root.geometry(f"+{x}+{y}")
    
    root.mainloop()

if __name__ == "__main__":
    main()
