# Formalization of JSP-000745 (Erdős Problem #894)

## Problem Overview

**Catalog ID:** [JSP-000745](https://github.com/TheJustinSunPrize/awards/blob/main/problems/catalog-0701-0800.md#JSP-000745)  
**Erdős Problem:** [#894](https://www.erdosproblems.com/894)  
**Mathematical Area:** Number theory / Ramsey theory  

### Problem Statement
Can the integers be finitely colored so that no same-colored pair has difference in a prescribed sparse set?

Specifically, Erdős asked whether for every lacunary sequence $n_k$ of positive integers (where $n_{k+1} / n_k \ge 1 + \varepsilon$ for some $\varepsilon > 0$), there exists a finite coloring of $\mathbb{N}$ (or $\mathbb{Z}$) such that no two integers of the same color have a difference belonging to $\{n_k\}$.

### Resolution
Affirmatively resolved by Yuval Peres and Wilhelm Schlag (2010):
- **Reference:** Y. Peres and W. Schlag, *Two Erdős problems on lacunary sequences: Chromatic number and Diophantine approximation*, Bull. Lond. Math. Soc. 42 (2010), 295–300. [doi:10.1112/blms/bdp126](https://doi.org/10.1112/blms/bdp126).

## Formalization Details

- **Target File:** `JSP_000745.lean`
- **Underlying Formalization:** `Erdos894.lean`
- **Main Theorem:**
  ```lean
  theorem jsp_000745_solved {n : ℕ → ℕ} (hn : Erdos894.IsLacunary n) :
      Erdos894.HasAvoidingColoring n :=
    Erdos894.erdos_894 hn
  ```
- **Axioms Check:**
  `#print axioms jsp_000745_solved` depends strictly on standard foundational Lean axioms:
  ```lean
  [propext, Classical.choice, Quot.sound]
  ```
  Zero `sorry`, zero `admit`, zero custom axioms.

## Build & Verification Instructions

### Toolchain
- **Lean:** `leanprover/lean4:v4.33.0`
- **Mathlib:** `v4.33.0`

### Build
```bash
lake exe cache get
lake build
```

## Attribution & Provenance
- **Mathematical Solution:** Yuval Peres and Wilhelm Schlag (2010).
- **Formal Authors:** Codex, GPT-5.6 Sol, with upstream formalization in `plby/lean-proofs` (`src/latest/ErdosProblems/Erdos894.lean`).
- **Packaging & Verification:** Maintained and verified by 赵钦 (Qin Zhao, GitHub: [@Drag0ndddd1118](https://github.com/Drag0ndddd1118)).
