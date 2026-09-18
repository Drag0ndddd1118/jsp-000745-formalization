import Erdos894

/-- Formal Lean 4 bridge theorem for JSP-000745 (Erdős Problem #894). -/
theorem jsp_000745_solved {n : ℕ → ℕ} (hn : Erdos894.IsLacunary n) :
    Erdos894.HasAvoidingColoring n :=
  Erdos894.erdos_894 hn

#print axioms jsp_000745_solved
-- 'jsp_000745_solved' depends on axioms: [propext, Classical.choice, Quot.sound]
