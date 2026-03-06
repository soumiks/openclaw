; ============================================================================
; P1 — Dangerous Tool Bypass
; ============================================================================
; Can any pipeline config allow dangerous tools (exec, gateway, cron, message)
; when some step explicitly denies them? SAT = bypass found.
; ============================================================================

(set-logic ALL)
(include "../model/tools.smt2")
(include "../model/pipeline.smt2")

; --- P1.1–P1.7: exec denied at each step ---
(push 1)
(echo "P1.1: Can exec bypass a deny at step 1?")
(assert step1_active) (assert (step1_deny exec_)) (assert (pipeline_allows exec_))
(check-sat) ; Expected: UNSAT
(pop 1)

(push 1)
(echo "P1.2: Can exec bypass a deny at step 2?")
(assert step2_active) (assert (step2_deny exec_)) (assert (pipeline_allows exec_))
(check-sat) ; Expected: UNSAT
(pop 1)

(push 1)
(echo "P1.3: Can exec bypass a deny at step 3?")
(assert step3_active) (assert (step3_deny exec_)) (assert (pipeline_allows exec_))
(check-sat) ; Expected: UNSAT
(pop 1)

(push 1)
(echo "P1.4: Can exec bypass a deny at step 4?")
(assert step4_active) (assert (step4_deny exec_)) (assert (pipeline_allows exec_))
(check-sat) ; Expected: UNSAT
(pop 1)

(push 1)
(echo "P1.5: Can exec bypass a deny at step 5?")
(assert step5_active) (assert (step5_deny exec_)) (assert (pipeline_allows exec_))
(check-sat) ; Expected: UNSAT
(pop 1)

(push 1)
(echo "P1.6: Can exec bypass a deny at step 6?")
(assert step6_active) (assert (step6_deny exec_)) (assert (pipeline_allows exec_))
(check-sat) ; Expected: UNSAT
(pop 1)

(push 1)
(echo "P1.7: Can exec bypass a deny at step 7?")
(assert step7_active) (assert (step7_deny exec_)) (assert (pipeline_allows exec_))
(check-sat) ; Expected: UNSAT
(pop 1)

; --- P1.5: gateway denied at some step but pipeline allows it ---
(push 1)
(echo "P1.8: Can gateway bypass a deny at any step?")
(declare-const which_step Int)
(assert (and (>= which_step 1) (<= which_step 7)))
(assert (ite (= which_step 1) (and step1_active (step1_deny gateway_))
        (ite (= which_step 2) (and step2_active (step2_deny gateway_))
        (ite (= which_step 3) (and step3_active (step3_deny gateway_))
        (ite (= which_step 4) (and step4_active (step4_deny gateway_))
        (ite (= which_step 5) (and step5_active (step5_deny gateway_))
        (ite (= which_step 6) (and step6_active (step6_deny gateway_))
                               (and step7_active (step7_deny gateway_)))))))))
(assert (pipeline_allows gateway_))
(check-sat) ; Expected: UNSAT
(pop 1)

; --- P1.6: cron denied at some step but pipeline allows it ---
(push 1)
(echo "P1.9: Can cron bypass a deny at any step?")
(declare-const which_step Int)
(assert (and (>= which_step 1) (<= which_step 7)))
(assert (ite (= which_step 1) (and step1_active (step1_deny cron_))
        (ite (= which_step 2) (and step2_active (step2_deny cron_))
        (ite (= which_step 3) (and step3_active (step3_deny cron_))
        (ite (= which_step 4) (and step4_active (step4_deny cron_))
        (ite (= which_step 5) (and step5_active (step5_deny cron_))
        (ite (= which_step 6) (and step6_active (step6_deny cron_))
                               (and step7_active (step7_deny cron_)))))))))
(assert (pipeline_allows cron_))
(check-sat) ; Expected: UNSAT
(pop 1)

; --- P1.7: message denied at some step but pipeline allows it ---
(push 1)
(echo "P1.10: Can message bypass a deny at any step?")
(declare-const which_step Int)
(assert (and (>= which_step 1) (<= which_step 7)))
(assert (ite (= which_step 1) (and step1_active (step1_deny message_))
        (ite (= which_step 2) (and step2_active (step2_deny message_))
        (ite (= which_step 3) (and step3_active (step3_deny message_))
        (ite (= which_step 4) (and step4_active (step4_deny message_))
        (ite (= which_step 5) (and step5_active (step5_deny message_))
        (ite (= which_step 6) (and step6_active (step6_deny message_))
                               (and step7_active (step7_deny message_)))))))))
(assert (pipeline_allows message_))
(check-sat) ; Expected: UNSAT
(pop 1)

(echo "P1 complete.")
