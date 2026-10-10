# Formalization of JSP-000745 (Erdős Problem #894 / #897)

This repository contains the standalone Lean 4 formalization and DefEq bridge verification for **JSP-000745** (Erdős Problem #894 / #897).

## Problem Statement

> Can the integers be finitely colored so that no same-colored pair has difference in a prescribed sparse set?

**Mathematical Resolution:**
Yuval Peres and Wilhelm Schlag (2010) resolved this conjecture of Erdős, proving that for any positive lacunary sequence of natural numbers, there exists a finite colouring of the natural numbers having no monochromatic difference in the sequence.

## Verification

To verify the formalization locally:

```bash
lake exe cache get
lake build
python3 check.py
```

### Axioms

The proof depends strictly on standard foundational Lean axioms:
- `propext`
- `Classical.choice`
- `Quot.sound`

Zero custom axioms, zero `sorry`, zero `admit`.
