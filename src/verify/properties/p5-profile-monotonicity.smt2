; ============================================================================
; P5 — Profile Monotonicity
; ============================================================================
; Check: minimal ⊆ coding, messaging ⊆ full, coding ⊆ full,
;        minimal ⊆ messaging (if true)
; ============================================================================

(set-logic ALL)
(include "../model/tools.smt2")
(include "../model/profiles.smt2")

(declare-const t Tool)

; --- P5.1: minimal ⊆ coding ---
(push 1)
(echo "P5.1: minimal subset of coding?")
(assert (profile_minimal_allows t))
(assert (not (profile_coding_allows t)))
(check-sat) ; Expected: UNSAT — everything minimal allows, coding also allows
(pop 1)

; --- P5.2: minimal ⊆ messaging ---
(push 1)
(echo "P5.2: minimal subset of messaging?")
(assert (profile_minimal_allows t))
(assert (not (profile_messaging_allows t)))
(check-sat) ; Expected: UNSAT — minimal only has session_status, messaging also has it
(pop 1)

; --- P5.3: coding ⊆ full ---
(push 1)
(echo "P5.3: coding subset of full?")
(assert (profile_coding_allows t))
(assert (not (profile_full_allows t)))
(check-sat) ; Expected: UNSAT — full allows everything
(pop 1)

; --- P5.4: messaging ⊆ full ---
(push 1)
(echo "P5.4: messaging subset of full?")
(assert (profile_messaging_allows t))
(assert (not (profile_full_allows t)))
(check-sat) ; Expected: UNSAT — full allows everything
(pop 1)

; --- P5.5: coding ⊆ messaging? ---
(push 1)
(echo "P5.5: coding subset of messaging? (expected: NO)")
(assert (profile_coding_allows t))
(assert (not (profile_messaging_allows t)))
(check-sat) ; Expected: SAT — coding has exec, write etc. that messaging doesn't
; This confirms coding and messaging are NOT ordered; they're parallel branches.
(pop 1)

; --- P5.6: messaging ⊆ coding? ---
(push 1)
(echo "P5.6: messaging subset of coding? (expected: NO)")
(assert (profile_messaging_allows t))
(assert (not (profile_coding_allows t)))
(check-sat) ; Expected: SAT — messaging has message_ which coding doesn't
(pop 1)

; --- P5.7: (coding ∪ messaging) ⊆ full ---
(push 1)
(echo "P5.7: coding union messaging subset of full?")
(assert (or (profile_coding_allows t) (profile_messaging_allows t)))
(assert (not (profile_full_allows t)))
(check-sat) ; Expected: UNSAT — full allows everything
(pop 1)

(echo "P5 complete.")
