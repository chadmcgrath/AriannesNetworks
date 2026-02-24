# Formal Mathematical Theory: Item-Doubling vs Sample-Size Equivalence

This document summarizes the formal mathematical frameworks that describe the phenomenon: **doubling items per facet yields equivalent improvement to 2.5x sample size** in network consistency. Based on the search plan for formal mathematical theory (Tier 1-4 terminology).

---

## The Phenomenon (from Herrera-Bennett & Rhemtulla, 2021)

**2 items per facet @ 84 samples** produces approximately the same **network consistency** (edge correlation, centrality rank correlation) as **1 item per facet @ 212 samples** (2.5x sample size).

---

## 1. Spearman-Brown Prophecy Formula (Classical Test Theory)

**Primary formal framework** for the item-aggregation effect.

### Formula

$$\rho'_{xx} = \frac{n \cdot \rho_{xx}}{1 + (n-1) \cdot \rho_{xx}}$$

Where:
- \(n\) = factor by which test length changes (e.g., \(n=2\) for doubling items)
- \(\rho_{xx}\) = reliability of the current test

### When doubling items (\(n=2\))

$$\rho'_{xx} = \frac{2\rho_{xx}}{1 + \rho_{xx}}$$

Example: If single-item reliability is 0.4, doubling gives \(\rho' = 2(0.4)/(1.4) \approx 0.57\).

### Formal derivation

Allison (1975, *Psychometrika*) provides a direct proof for any positive real length multiplier \(k\), using Lord & Novick's (1968) generalized CTT. The proof uses correlation between parallel measures and variance components:

$$\rho_{X(k)X'(k)} = \frac{k \cdot \rho_{xx'}}{1 + (k-1) \cdot \rho_{xx'}}$$

### Relation to SEM

Standard Error of Measurement: \(\text{SEM} = \sigma \sqrt{1 - r_{xx}}\)

Higher reliability → lower SEM. Spearman-Brown predicts how reliability (and thus SEM) changes with more items.

### Caveat

The formula does **not** contain 2.5. The equivalence depends on base reliability \(\rho\). The 2.5x sample-size multiplier may be **empirically calibrated** for specific network conditions rather than derived from first principles.

---

## 2. Variance of the Mean (Probability Theory)

**Fundamental law** for averaging independent measurements.

### Formula

For \(n\) independent, identically distributed observations \(X_1, \ldots, X_n\) with variance \(\sigma^2\):

$$\text{Var}(\bar{X}) = \frac{\sigma^2}{n}$$

### Proof

1. \(\text{Var}(\bar{X}) = \text{Var}\left(\frac{1}{n}\sum_{i=1}^n X_i\right) = \frac{1}{n^2} \text{Var}\left(\sum_{i=1}^n X_i\right)\)
2. For independent \(X_i\): \(\text{Var}(\sum X_i) = \sum \text{Var}(X_i) = n\sigma^2\)
3. Therefore: \(\text{Var}(\bar{X}) = \frac{n\sigma^2}{n^2} = \frac{\sigma^2}{n}\)

### Implication

Doubling items (\(n=2\)) halves the variance of the facet mean. This is the **discrete math** for the variance-reduction effect of item aggregation.

---

## 3. Standard Error and Sample Size

**Square-root law** for sampling precision.

### Formula

For many statistics (e.g., sample mean, correlation): \(\text{SE} \propto \frac{1}{\sqrt{n}}\)

Where \(n\) = sample size.

### Fisher's z for correlation

For correlation coefficient \(r\): \(\text{SE} \approx \frac{1}{\sqrt{n-3}}\) (Fisher z-transformation)

### Implication

To halve standard error, sample size must quadruple. The relationship is **non-linear** (sqrt), which may explain why the items-vs-samples equivalence is not a simple 2:1 ratio.

---

## 4. Fisher Information (Rasch / IRT)

**Unified framework** for precision from items and persons.

### Definition

For a single dichotomous item: \(I = \frac{1}{P(1-P)}\) where \(P\) = probability of correct response.

For Rasch: \(I = \frac{4}{\text{SE}^2}\) (information in "EQUITs").

### Additivity

Fisher information from **independent observations is additive**. Doubling items doubles information.

### Asymptotic variance

$$\text{Var}(\hat{\theta}) \propto \frac{1}{N \cdot I}$$

Where \(N\) = sample size, \(I\) = information per observation. Sample size and per-observation information enter **multiplicatively**.

### Rasch symmetry

The Rasch model exhibits **specific objectivity**: persons and items are treated symmetrically. Item comparisons are independent of persons; person comparisons are independent of items. The same mathematical structure governs "more items" and "more persons" in some models.

### Bernoulli variance

The Rasch logistic ogive satisfies \(dp/dx = p(1-p)\). The slope equals Bernoulli variance; its reciprocal is Fisher information. Fisher and Shannon information are linked through the Rasch ogive (Linacre, 2006, RMT).

---

## 5. Classical Test Theory (CTT)

**Foundation**: \(X = T + E\) (observed = true + error).

### Reliability

\(r_{xx} = \frac{\sigma^2_T}{\sigma^2_X}\) (proportion of variance due to true score)

### SEM

\(\text{SEM} = \sigma \sqrt{1 - r_{xx}}\)

Higher reliability → lower SEM. Spearman-Brown predicts how \(r_{xx}\) changes with test length.

---

## 6. Generalizability Theory (G-Theory)

**Extension** of CTT that decomposes variance into multiple facets.

### Facets

- **Persons**: object of measurement
- **Items**: source of measurement error (can be increased to reduce error)
- **Raters, time, settings**: other facets

### D-study

Simulates "what if we used 10 items instead of 2?" or "what if 1000 persons instead of 100?" to estimate how generalizability coefficients change.

### Relevance

G-theory provides a formal framework for the **items vs. persons trade-off** in design decisions. The 2.5x equivalence could be modeled as a D-study comparison.

---

## 7. Law of Large Numbers

**Probability principle**: As \(n \to \infty\), \(\bar{X} \to \mu\) with probability 1.

### Variance reduction

\(\text{Var}(\bar{X}) = \frac{\sigma^2}{n} \to 0\) as \(n\) increases.

Averaging multiple independent measurements reduces error.

---

## Summary: Why "Discrete Math" Applies

| Framework | Discrete/Formal Aspect | Relevance to 2.5x |
|-----------|------------------------|-------------------|
| **Spearman-Brown** | Closed-form formula for reliability with \(n\) items | Predicts reliability gain from doubling items; does not yield 2.5x directly |
| **Var(X̄) = σ²/n** | Exact variance reduction for averaging | Doubling items halves variance of facet mean |
| **SE ∝ 1/√n** | Sample size precision | Explains sqrt relationship; 2.5x may be empirical |
| **Fisher information** | Additive; I = 1/SE² | Items and sample size both contribute to precision multiplicatively |
| **Rasch symmetry** | Persons and items symmetric | Same math governs both dimensions |
| **G-theory** | Variance decomposition by facets | Formal framework for items vs. persons trade-off |

---

## The 2.5x: Empirical vs. Theoretical

The **2.5x** multiplier may be **empirically observed** rather than derived from first principles. The Spearman-Brown formula depends on base reliability \(\rho\); the variance reduction formula gives exactly 2x for doubling items; the sample-size side uses \(\sqrt{n}\). The 2.5x could be:

1. **Calibrated** for a specific reliability range in personality network data
2. **Context-dependent** (network structure, partial correlations, regularization)
3. **Approximate** (84 × 2.52 ≈ 212; 2.5 is a round number)

The original Herrera-Bennett & Rhemtulla (2021) paper may provide the theoretical derivation in its supplementary materials. The preprint is available at PsyArXiv (osf.io/preprints/psyarxiv/an3yb).

---

## References

- Allison, P. D. (1975). A simple proof of the Spearman-Brown formula for continuous test lengths. *Psychometrika*, 40(4), 135-136.
- Lord, F. M., & Novick, M. R. (1968). *Statistical theories of mental test scores*. Addison-Wesley.
- Linacre, J. M. (2006). Bernoulli trials, Fisher information, Shannon information and Rasch. *Rasch Measurement Transactions*, 20(3), 1062-1063.
- Cronbach, L. J., Rajaratnam, N., & Gleser, G. C. (1963). Theory of generalizability. *British Journal of Statistical Psychology*, 16, 137-163.
- Herrera-Bennett, A., & Rhemtulla, M. (2021). Network replicability & generalizability. *Multivariate Behavioral Research* (manuscript). PsyArXiv: osf.io/preprints/psyarxiv/an3yb
