; ============================================================================
; P6 — Owner-Only Completeness
; ============================================================================
; For non-owner senders, can gateway/cron/whatsapp_login ever be in the
; effective tool set regardless of pipeline config?
; effective_allows(t) = pipeline_allows(t) AND passes_owner_gate(t)
; ============================================================================

(set-logic ALL)
(include "../model/tools.smt2")
(include "../model/pipeline.smt2")
(include "../model/owner-only.smt2")

; Compose pipeline + owner gate
(define-fun effective_allows ((t Tool)) Bool
  (and (pipeline_allows t) (passes_owner_gate t)))

; --- P6.1: Non-owner cannot access gateway ---
(push 1)
(echo "P6.1: Non-owner effective access to gateway?")
(assert (not sender_is_owner))
(assert (effective_allows gateway_))
(check-sat) ; Expected: UNSAT — gateway is owner-only, non-owner blocked
(pop 1)

; --- P6.2: Non-owner cannot access cron ---
(push 1)
(echo "P6.2: Non-owner effective access to cron?")
(assert (not sender_is_owner))
(assert (effective_allows cron_))
(check-sat) ; Expected: UNSAT
(pop 1)

; --- P6.3: Non-owner cannot access whatsapp_login ---
(push 1)
(echo "P6.3: Non-owner effective access to whatsapp_login?")
(assert (not sender_is_owner))
(assert (effective_allows whatsapp_login_))
(check-sat) ; Expected: UNSAT
(pop 1)

; --- P6.4: Non-owner CAN access exec (it's not owner-only) ---
(push 1)
(echo "P6.4: Non-owner can access exec if pipeline allows? (sanity check)")
(assert (not sender_is_owner))
; Make all steps inactive so pipeline allows everything
(assert (not step1_active))
(assert (not step2_active))
(assert (not step3_active))
(assert (not step4_active))
(assert (not step5_active))
(assert (not step6_active))
(assert (not step7_active))
(assert (not (effective_allows exec_)))
(check-sat) ; Expected: UNSAT — exec is not owner-only, so non-owner can use it
(pop 1)

; --- P6.5: Owner CAN access all owner-only tools (if pipeline allows) ---
(push 1)
(echo "P6.5: Owner can access gateway if pipeline allows?")
(assert sender_is_owner)
(assert (not step1_active))
(assert (not step2_active))
(assert (not step3_active))
(assert (not step4_active))
(assert (not step5_active))
(assert (not step6_active))
(assert (not step7_active))
(assert (not (effective_allows gateway_)))
(check-sat) ; Expected: UNSAT — owner passes gate, inactive pipeline allows all
(pop 1)

(echo "P6 complete.")
