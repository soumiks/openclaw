; ============================================================================
; P2 — Deny Dominance
; ============================================================================
; If a tool appears in ANY active step's deny list, the pipeline blocks it.
; For a symbolic tool t, assert step_i_deny(t) for each step AND
; pipeline_allows(t). Should be UNSAT for all steps.
; ============================================================================

(set-logic ALL)
(include "../model/tools.smt2")
(include "../model/pipeline.smt2")

(declare-const t Tool)

; --- P2.1: Deny at step 1 blocks any tool ---
(push 1)
(echo "P2.1: Deny at step 1 implies pipeline blocks (symbolic tool)")
(assert step1_active)
(assert (step1_deny t))
(assert (pipeline_allows t))
(check-sat) ; Expected: UNSAT — denied at step 1 means survives_step1 is false
(pop 1)

; --- P2.2: Deny at step 2 ---
(push 1)
(echo "P2.2: Deny at step 2 implies pipeline blocks")
(assert step2_active)
(assert (step2_deny t))
(assert (pipeline_allows t))
(check-sat) ; Expected: UNSAT
(pop 1)

; --- P2.3: Deny at step 3 ---
(push 1)
(echo "P2.3: Deny at step 3 implies pipeline blocks")
(assert step3_active)
(assert (step3_deny t))
(assert (pipeline_allows t))
(check-sat) ; Expected: UNSAT
(pop 1)

; --- P2.4: Deny at step 4 ---
(push 1)
(echo "P2.4: Deny at step 4 implies pipeline blocks")
(assert step4_active)
(assert (step4_deny t))
(assert (pipeline_allows t))
(check-sat) ; Expected: UNSAT
(pop 1)

; --- P2.5: Deny at step 5 ---
(push 1)
(echo "P2.5: Deny at step 5 implies pipeline blocks")
(assert step5_active)
(assert (step5_deny t))
(assert (pipeline_allows t))
(check-sat) ; Expected: UNSAT
(pop 1)

; --- P2.6: Deny at step 6 ---
(push 1)
(echo "P2.6: Deny at step 6 implies pipeline blocks")
(assert step6_active)
(assert (step6_deny t))
(assert (pipeline_allows t))
(check-sat) ; Expected: UNSAT
(pop 1)

; --- P2.7: Deny at step 7 ---
(push 1)
(echo "P2.7: Deny at step 7 implies pipeline blocks")
(assert step7_active)
(assert (step7_deny t))
(assert (pipeline_allows t))
(check-sat) ; Expected: UNSAT
(pop 1)

(echo "P2 complete.")
