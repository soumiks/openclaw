; ============================================================================
; P4 — Subagent Containment
; ============================================================================
; 4.1: At leaf depth, can sessions_spawn be reached without alsoAllow?
; 4.2: Can gateway ever be reached by any subagent (deny_always)?
; 4.3: Can gateway be reached via alsoAllow override?
; ============================================================================

(set-logic ALL)
(include "../model/tools.smt2")
(include "../model/subagent.smt2")

; --- P4.1: Leaf subagent cannot reach sessions_spawn without alsoAllow ---
(push 1)
(echo "P4.1: Leaf subagent — sessions_spawn blocked without explicit_allow?")
(assert is_leaf)
(assert (not (explicit_allow sessions_spawn_)))
(assert (passes_subagent_gate sessions_spawn_))
(check-sat) ; Expected: UNSAT — sessions_spawn in deny_leaf, not overridden
(pop 1)

; --- P4.2: Any subagent (non-leaf) — gateway blocked without alsoAllow? ---
(push 1)
(echo "P4.2: Non-leaf subagent — gateway blocked without explicit_allow?")
(assert (not is_leaf))
(assert (not (explicit_allow gateway_)))
(assert (passes_subagent_gate gateway_))
(check-sat) ; Expected: UNSAT — gateway in deny_always
(pop 1)

; --- P4.3: Can alsoAllow override gateway deny? ---
(push 1)
(echo "P4.3: Can explicit_allow override gateway deny_always?")
(assert (explicit_allow gateway_))
(assert (passes_subagent_gate gateway_))
(check-sat) ; Expected: SAT — alsoAllow CAN override denies (by design).
; This is a feature: if config explicitly allows gateway for subagents,
; it overrides the default deny. Whether this is desired is a policy question.
(pop 1)

; --- P4.4: All deny_always tools blocked without alsoAllow ---
(push 1)
(echo "P4.4: All deny_always tools blocked for non-leaf subagent?")
(declare-const t Tool)
(assert (subagent_deny_always t))
(assert (not (explicit_allow t)))
(assert (passes_subagent_gate t))
(check-sat) ; Expected: UNSAT — any deny_always tool is blocked without override
(pop 1)

; --- P4.5: All deny_leaf tools blocked at leaf without alsoAllow ---
(push 1)
(echo "P4.5: All deny_leaf tools blocked at leaf depth?")
(declare-const t Tool)
(assert is_leaf)
(assert (subagent_deny_leaf t))
(assert (not (explicit_allow t)))
(assert (passes_subagent_gate t))
(check-sat) ; Expected: UNSAT
(pop 1)

; --- P4.6: Non-denied tools pass subagent gate ---
(push 1)
(echo "P4.6: Non-denied tool (e.g., read) passes subagent gate?")
(assert (not is_leaf))
(assert (not (passes_subagent_gate read_)))
(check-sat) ; Expected: UNSAT — read is not in any deny list, so it passes
(pop 1)

(echo "P4 complete.")
