; ============================================================================
; P3 — Allowlist Stripping Soundness
; ============================================================================
; stripPluginOnlyAllowlist: if an allowlist contains ONLY plugin/unknown
; entries, the allowlist is cleared (allow_empty = true) so core tools
; aren't accidentally blocked. But can this let a dangerous core tool
; through that a non-empty allowlist would have blocked?
;
; Model: A step has allow entries that are all PLUGIN. Stripping sets
; allow_empty=true. Without stripping, allow_empty=false and no core tool
; is in the allow set. Check if a dangerous tool passes after stripping.
; ============================================================================

(set-logic ALL)
(include "../model/tools.smt2")
(include "../model/pipeline.smt2")

; --- P3.1: After stripping, does a dangerous tool pass a step it shouldn't? ---
; Scenario: Step 3 had allow=[some_plugin], deny=[]. After stripping,
; allow_empty becomes true. All other steps inactive.
(push 1)
(echo "P3.1: Stripping plugin-only allowlist — can exec pass?")
; All steps inactive except step 3
(assert (not step1_active))
(assert (not step2_active))
(assert step3_active)
(assert (not step4_active))
(assert (not step5_active))
(assert (not step6_active))
(assert (not step7_active))

; Before stripping: allow has only PLUGIN, no core tool in allow
(assert (not (step3_deny exec_)))

; After stripping: allow_empty = true (the strip happened)
(assert step3_allow_empty)

; Can exec pass?
(assert (pipeline_allows exec_))
(check-sat) ; Expected: SAT — yes, stripping DOES let exec through.
; This is BY DESIGN: the allowlist only had plugins, so it shouldn't
; restrict core tools. The intent is that plugin-only allowlists don't
; accidentally block core tools. This is correct behavior.
(pop 1)

; --- P3.2: Can stripping let exec through when deny is present? ---
(push 1)
(echo "P3.2: Stripping with deny present — exec still blocked?")
(assert (not step1_active))
(assert (not step2_active))
(assert step3_active)
(assert (not step4_active))
(assert (not step5_active))
(assert (not step6_active))
(assert (not step7_active))

; Stripped allow (empty) but exec is in deny
(assert step3_allow_empty)
(assert (step3_deny exec_))
(assert (pipeline_allows exec_))
(check-sat) ; Expected: UNSAT — deny still blocks even after stripping
(pop 1)

; --- P3.3: Stripping at one step, deny at another step ---
(push 1)
(echo "P3.3: Step 3 stripped (allow_empty), step 5 denies exec")
(assert (not step1_active))
(assert (not step2_active))
(assert step3_active)
(assert step3_allow_empty)
(assert (not (step3_deny exec_)))
(assert (not step4_active))
(assert step5_active)
(assert (step5_deny exec_))
(assert (not step6_active))
(assert (not step7_active))
(assert (pipeline_allows exec_))
(check-sat) ; Expected: UNSAT — deny at step 5 blocks even if step 3 is open
(pop 1)

; --- P3.4: Stripping should NOT happen if a core tool is in the allow list ---
; This is a model constraint: if any core tool is in allow, stripping doesn't apply.
; We verify: if allow contains a core tool AND allow_empty is true, is that inconsistent
; with the stripping semantics?
(push 1)
(echo "P3.4: Stripping invariant — core tool in allow prevents stripping")
; Model the invariant: if any core tool is in step3_allow, then allow_empty must be false
; (stripping only happens when ALL allow entries are plugins)
(declare-const ct Tool)
(assert (is_core_tool ct))
(assert (step3_allow ct))
; If stripping incorrectly set allow_empty = true despite core tool in allow:
(assert step3_allow_empty)
; This combination should be impossible in a correct implementation
; We're just checking the model admits it (it will, since these are uninterpreted)
; This is a SANITY CHECK — in real configs, the translator must enforce this.
(check-sat) ; Expected: SAT — the symbolic model doesn't enforce the stripping invariant
; (that's the translator's job). This confirms we need the config-to-SMT
; translator to correctly set allow_empty.
(pop 1)

(echo "P3 complete.")
