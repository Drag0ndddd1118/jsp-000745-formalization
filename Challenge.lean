import Erdos894

namespace JSP000745

/--
Formal statement for JSP-000745 (Erdős Problem #894 / #897):
For any positive lacunary sequence of natural numbers, there exists a finite colouring
of the natural numbers such that no two elements of the same colour have difference
belonging to the sequence.

Mathematical resolution: Yuval Peres and Wilhelm Schlag (2010).
-/
def jsp000745Statement : Prop :=
  ∀ {n : ℕ → ℕ}, Erdos894.IsLacunary n → Erdos894.HasAvoidingColoring n

end JSP000745
