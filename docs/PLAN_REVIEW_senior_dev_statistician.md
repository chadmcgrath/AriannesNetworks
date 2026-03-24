# Senior Dev + Statistician Review: GUI Redesign Plan

**Reviewed:** Plan for Results Dashboard GUI  
**Reviewers:** Senior developer + statistical analyst perspective

---

## Summary Verdict

**Overall:** Solid, decision-oriented structure with good coverage of the analyses. Several technical gaps and statistical caveats should be addressed before or during implementation.

---

## Strengths

1. **Decision framework is coherent** — Organizing around Five Decisions matches the summary doc and makes the UI narrative clear.

2. **Data-to-view mapping is correct** — CSVs align with the intended views (facet_level_metrics → Overview, scoring_method_comparison → D2, etc.).

3. **Tooltip approach** — Keeping labels neutral and putting methodology + thresholds in tooltips is appropriate for mixed audiences.

4. **Green/red with icons** — Pairing color with ✓/⚠ for accessibility is correct. Don't rely on color alone.

5. **Findings audit** — Good checklist to avoid omitting results from the paper.

---

## Technical Gaps

### 1. Sample size inconsistency

**Issue:** Plan says "Sample size (488)". Data sources vary:
- `compute_tiers_1_to_3.py`: N=488 (complete cases on IPIP+NEO Neuroticism items)
- `compute_tier4_irt.R`: N=539 (IPIP-only complete cases)
- `compute_tier4_ml_corrected.R`: N=488

**Recommendation:** Show context-specific N where it matters. E.g. "N=488 (full NEO+IPIP)" for cross-instrument; "N=539" for IRT. Add a tooltip: "Sample size depends on listwise deletion; IRT uses IPIP-only, RF uses both instruments."

### 2. Community detection source

**Issue:** Plan references `community_detection.csv` and "modularity 0.183, NMI 0.530". 
- `community_detection.csv` is produced by `compute_tier4_ml.R` (not `_corrected`)
- Modularity and NMI are computed in `compute_tier4_ml.R` but **not written to CSV**

**Recommendation:** Either:
- (a) Add modularity/NMI to `community_detection.csv` or a new `community_metrics.csv`, or
- (b) Recompute in `results_loader.py` from `mutual_information_matrix.csv` + community assignments (requires igraph/networkx)

### 3. Run-order dependencies

**Issue:** "Run analyses" lists scripts but not order. Dependencies:
1. `build_item_mapping.py` (optional, for item text)
2. `compute_tiers_1_to_3.py`
3. `compute_tier4_irt.R`
4. `compute_tier4_ml.R` (for community) + `compute_tier4_ml_corrected.R` (for RF)
5. `compute_decisions_2_to_5.R` (needs `irt_item_parameters.csv`)
6. `merge_item_text_into_results.py` (needs `item_code_to_text.csv`)

**Recommendation:** Document run order in the plan. Implement as a single orchestration script or Makefile.

### 4. Missing CSV: modularity/NMI

**Issue:** Plan displays "modularity 0.183, NMI 0.530" but no CSV contains these. They come from the R console output of `compute_tier4_ml.R`.

**Recommendation:** Extend `compute_tier4_ml.R` to write a `results/community_metrics.csv` with columns: `modularity`, `nmi`, `n_communities`.

### 5. Person-fit counts

**Issue:** D3 shows "Immoderation 2.2% flagged". `person_fit_all_facets.csv` has Zh per person per facet. The GUI must count `Zh < -2` per facet. `confidence_classifier_results.csv` has `n_flagged` and `base_rate` — use those for display; no need to recompute.

---

## Statistical Caveats

### 1. Threshold justification

**Issue:** Plan uses heuristic thresholds (α≥0.88 green, α<0.80 red; r<0.15 for pairs). These are conventional, not from formal power analysis.

**Recommendation:** In tooltips, say e.g. "Green: α≥0.88 (commonly considered strong). Red: α<0.80 (concerning). These thresholds are heuristic."

### 2. Immoderation classifier (n=11 positives)

**Issue:** Base rate 2.3%, n_flagged=11. AUC 0.82 (LR) and 0.69 (RF) are unstable with so few positives. Precision/recall are noisy.

**Recommendation:** Add tooltip: "Immoderation has only 11 flagged persons; precision/recall/AUC are unstable. Interpret with caution." Consider graying out or de-emphasizing Immoderation in the classifier chart.

### 3. Discriminant ratio "items bleed"

**Issue:** Tooltip says "Red: <1.5 (items bleed across facets)". "Bleed" is causal language. Statistically it means "IPIP items predict other facets' NEO scores almost as well as their own."

**Recommendation:** Use neutral wording: "Red: <1.5 (items predict other facets nearly as well as their own)."

### 4. Disattenuated r > 1.0

**Issue:** N5 disattenuated r = 0.988, N4 = 0.951. These are high but not "near-perfect" in a strict sense. Disattenuated r can exceed 1.0 in theory (sampling); values near 1.0 suggest high convergent validity.

**Recommendation:** Tooltip: "Disattenuated r corrects for measurement error. Values near 1.0 suggest IPIP and NEO measure the same construct."

---

## Inconsistencies

### 1. D1 Chart 4 label

**Issue:** Line 105: "red highlight on e57+h2029 r=0.081 **(binge eating–binge spending)**" — We removed that framing elsewhere per user request.

**Recommendation:** Change to: "red highlight on e57+h2029 r=0.081 (lowest within-facet r)."

### 2. facet_level_metrics: IPIP vs NEO

**Issue:** `facet_level_metrics.csv` has two rows per facet (IPIP and NEO). Overview alpha chart should use **IPIP rows only** (10 items per facet). Ensure `results_loader` filters `instrument == "IPIP"` for that chart.

### 3. item_text in CSVs

**Issue:** `item_level_metrics.csv` has multiline `item_text` (e.g. "Am relaxed most\nof the time."). Chart labels may wrap awkwardly. Consider truncating or using item codes with tooltip for full text.

---

## Architecture Suggestions

### 1. results_loader contract

Define explicit functions and return types, e.g.:

```python
def get_facet_metrics(instrument: Literal["IPIP", "NEO", "both"]) -> pd.DataFrame
def get_scoring_comparison() -> pd.DataFrame
def get_confidence_classifier_results() -> pd.DataFrame
# etc.
```

Handle missing files: return `None` or empty DataFrame, and let views show "Run analyses to load" message.

### 2. Chart functions: stateless

`charts.py` functions should take data as arguments, not read from disk. That keeps them testable and allows the loader to own I/O.

### 3. Threshold config

Consider a `thresholds.yaml` or dict so green/red cutoffs are centralized and documented. Avoid magic numbers in view code.

---

## Implementation Order Suggestion

1. `results_loader.py` — single source of truth for CSV loading
2. `charts.py` — one chart function per chart type, data-in/figure-out
3. `overview.py` — simplest view, validates the pipeline
4. Remaining views (D1–D5)
5. Tooltips and green/red
6. Run-analyses orchestration

---

## Summary of Required Plan Updates

| # | Item | Action |
|---|------|--------|
| 1 | D1 Chart 4 | Remove "binge eating–binge spending", use neutral "lowest within-facet r" |
| 2 | Run order | Add dependency order for scripts; include compute_tier4_ml.R for community |
| 3 | Modularity/NMI | Add step: write modularity/NMI to CSV from compute_tier4_ml.R, or compute in loader |
| 4 | Sample size | Specify which N for which view; add tooltip |
| 5 | Immoderation caveat | Add tooltip for classifier instability when n_flagged &lt; 15 |
| 6 | Threshold disclaimer | Note in plan that thresholds are heuristic/conventional |
| 7 | IPIP filter | Clarify that Overview alpha uses instrument==IPIP rows only |
