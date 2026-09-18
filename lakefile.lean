import Lake
open Lake DSL

package "jsp-000745-formalization" where

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "v4.33.0"

lean_lib Erdos894

@[default_target]
lean_lib «JSP_000745» where
  roots := #[`JSP_000745, `Erdos894]
