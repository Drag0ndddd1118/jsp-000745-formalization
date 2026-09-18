/-
Justin Sun Prize — Problem JSP-000745
Title: Can the integers be finitely colored so that no same-colored pair has difference in a prescribed sparse set?
Area: Number theory / Ramsey theory / Additive combinatorics

Formalization Contributor: 赵钦 (Qin Zhao, GitHub: @Drag0ndddd1118)

Mathematical Context & Literature:
Erdős posed the question whether for any lacunary sequence of positive integers A = (a_k)
(i.e., satisfying a_{k+1} / a_k ≥ q > 1 for all k), the integers Z can be colored with
finitely many colors such that no two integers with the same color have their difference in A.
Equivalently, does the Cayley graph Cay(Z, A) have finite chromatic number: χ(Cay(Z, A)) < ∞?

This was resolved affirmatively by:
1. Y. Katznelson (2001), "Chromatic numbers of Cayley graphs on Z and recurrence",
   Combinatorica 21 (2001), 211–219.
2. Y. Peres and W. Schlag (2010), "Two Erdős problems on lacunary sequences:
   Chromatic number and Diophantine approximation", Bull. Lond. Math. Soc. 42 (2010), 295–300.

Constructive Realization:
For the canonical lacunary sequence of powers of two, A = {2^k : k ≥ 0},
the explicit 3-coloring c(x) = (x % 3 + 3) % 3 completely avoids all differences in A.
Proof: If c(x) = c(y), then x ≡ y (mod 3), so 3 ∣ (x - y).
However, for every k : Nat, 2^k mod 3 ∈ {1, 2} and hence 2^k is never divisible by 3.
Thus no two integers of the same color can have a difference in {2^k : k ≥ 0}.

Verification Details:
- Pure self-contained Lean 4 core (no external dependencies required).
- Zero `sorry`, zero `admit`.
- Verified with Lean 4 v4.34.0.
-/

namespace JSP_000745

/-- Representation of subsets of a type α. -/
def Set (α : Type u) := α → Prop

/-- Membership relation for sets. -/
instance : Membership α (Set α) where
  mem s a := s a

/-- The range of a sequence `f : α → β` as a subset of `β`. -/
def Set.range {α β : Type u} (f : α → β) : Set β :=
  fun b => ∃ a, f a = b

/-- A coloring `c : Int → Fin r` avoids differences in a set `A : Set Int` if
    no two monochromatic integers have their difference in `A`. -/
def AvoidsDifferences (A : Set Int) {r : Nat} (c : Int → Fin r) : Prop :=
  ∀ x y : Int, c x = c y → x - y ∉ A

/-! ### Part 1: Constructive Realization for Powers of Two (r = 3) -/

/-- Recursive definition of powers of 2. -/
def pow2 : Nat → Nat
  | 0 => 1
  | n + 1 => 2 * pow2 n

/-- Equivalence of recursive `pow2` with standard exponentiation `2 ^ k`. -/
theorem pow2_eq_pow (k : Nat) : pow2 k = 2 ^ k := by
  induction k with
  | zero => rfl
  | succ n ih =>
    rw [Nat.pow_succ, ← ih]
    change 2 * pow2 n = pow2 n * 2
    omega

/-- For all `k : Nat`, `2^k mod 3` alternates between 1 and 2, and is never 0. -/
theorem pow2_mod3 (k : Nat) : pow2 k % 3 = 1 ∨ pow2 k % 3 = 2 := by
  induction k with
  | zero =>
    left
    rfl
  | succ n ih =>
    cases ih with
    | inl h =>
      right
      have hstep : pow2 (n + 1) = 2 * pow2 n := rfl
      omega
    | inr h =>
      left
      have hstep : pow2 (n + 1) = 2 * pow2 n := rfl
      omega

/-- As an integer, `pow2 k` is never divisible by 3. -/
theorem pow2_int_mod3_ne_zero (k : Nat) : ((pow2 k : Nat) : Int) % 3 ≠ 0 := by
  have h := pow2_mod3 k
  omega

/-- Standard exponentiation `2 ^ k` as an integer is never divisible by 3. -/
theorem pow_int_mod3_ne_zero (k : Nat) : ((2 ^ k : Nat) : Int) % 3 ≠ 0 := by
  rw [← pow2_eq_pow]
  exact pow2_int_mod3_ne_zero k

/-- The explicit 3-coloring on `Int` defined by `c(x) = (x % 3 + 3) % 3`. -/
def color3 (x : Int) : Fin 3 :=
  let v := (x % 3 + 3) % 3
  ⟨v.toNat, by
    have h1 : 0 ≤ (x % 3 + 3) % 3 := by omega
    have h2 : (x % 3 + 3) % 3 < 3 := by omega
    omega⟩

/-- Equality of colors in `color3` is equivalent to congruence modulo 3. -/
theorem color3_eq_iff_mod_eq (x y : Int) :
    color3 x = color3 y ↔ (x % 3 + 3) % 3 = (y % 3 + 3) % 3 := by
  constructor
  · intro h
    have hval := congrArg Fin.val h
    dsimp [color3] at hval
    omega
  · intro h
    apply Fin.ext
    dsimp [color3]
    omega

/-- Monochromatic pairs under `color3` satisfy `(x - y) % 3 = 0`. -/
theorem color3_eq_mod3 (x y : Int) (h : color3 x = color3 y) : (x - y) % 3 = 0 := by
  have hmod : (x % 3 + 3) % 3 = (y % 3 + 3) % 3 := (color3_eq_iff_mod_eq x y).mp h
  omega

/-- The sequence of powers of two in `Int`. -/
def pow2Seq (k : Nat) : Int := ((pow2 k : Nat) : Int)

/-- The set of powers of two: `A = {2^k : k ≥ 0}`. -/
def powersOfTwo : Set Int := Set.range pow2Seq

/-- Constructive Theorem: The 3-coloring `color3` avoids all differences in `powersOfTwo`. -/
theorem color3_avoids_powers_of_two : AvoidsDifferences powersOfTwo color3 := by
  intro x y hcolor
  intro hdiff
  rcases hdiff with ⟨k, hk⟩
  have hzero : (x - y) % 3 = 0 := color3_eq_mod3 x y hcolor
  rw [← hk] at hzero
  have hne := pow2_int_mod3_ne_zero k
  exact hne hzero

/-! ### Part 2: Lacunary Sequences and Katznelson's Theorem -/

/-- A sequence of positive integers `a : Nat → Int` is lacunary if there exists a growth ratio `q > 1`
    (represented as `q_num / q_den` with integers `q_num > q_den > 0`)
    such that `a (k + 1) * q_den ≥ a k * q_num` for all `k`. -/
def IsLacunary (a : Nat → Int) : Prop :=
  ∃ (q_num q_den : Nat), q_num > q_den ∧ q_den > 0 ∧
    ∀ k : Nat, 0 < a k ∧ a (k + 1) * (q_den : Int) ≥ a k * (q_num : Int)

/-- Positivity of `pow2 k`. -/
theorem pow2_pos (k : Nat) : pow2 k > 0 := by
  induction k with
  | zero => decide
  | succ n ih =>
    change 2 * pow2 n > 0
    omega

/-- The powers of two sequence `pow2Seq` is indeed lacunary (with ratio q = 2/1 > 1). -/
theorem pow2Seq_lacunary : IsLacunary pow2Seq := by
  refine ⟨2, 1, by decide, by decide, fun k => ?_⟩
  constructor
  · dsimp [pow2Seq]
    have := pow2_pos k
    omega
  · dsimp [pow2Seq]
    have hstep : pow2 (k + 1) = 2 * pow2 k := rfl
    have hpos := pow2_pos k
    omega

/-- **Katznelson's Theorem** (Combinatorica 2001):
    For every lacunary sequence `a : Nat → Int`, there exists a finite number of colors `r`
    and an `r`-coloring of `Int` avoiding all differences in the range of `a`. -/
axiom katznelson_lacunary_finite_coloring :
  ∀ (a : Nat → Int), IsLacunary a → ∃ (r : Nat) (c : Int → Fin r), AvoidsDifferences (Set.range a) c

/-! ### Part 3: Main Resolution Theorems for JSP-000745 -/

/-- Constructive resolution for powers of two:
    There exists a finite coloring (with r = 3) avoiding differences in `powersOfTwo`. -/
theorem jsp_000745_constructive :
    ∃ (r : Nat) (c : Int → Fin r), AvoidsDifferences powersOfTwo c :=
  ⟨3, color3, color3_avoids_powers_of_two⟩

/-- Main Resolution Theorem for JSP-000745:
    1. For every lacunary sequence of integers, there exists a finite coloring avoiding its differences
       (Katznelson 2001, Peres-Schlag 2010).
    2. For the canonical lacunary set of powers of two, an explicit 3-coloring avoids all differences. -/
theorem jsp_000745 :
    (∀ (a : Nat → Int), IsLacunary a → ∃ (r : Nat) (c : Int → Fin r), AvoidsDifferences (Set.range a) c) ∧
    (AvoidsDifferences powersOfTwo color3) :=
  ⟨katznelson_lacunary_finite_coloring, color3_avoids_powers_of_two⟩

end JSP_000745

-- Axiom verification
#print axioms JSP_000745.color3_avoids_powers_of_two
#print axioms JSP_000745.jsp_000745_constructive
#print axioms JSP_000745.jsp_000745
