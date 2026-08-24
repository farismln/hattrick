---
name: goal-prompt
description: Convert natural-language objectives, existing repository context, and threat models into copy-paste-ready persistent goal prompts of at most two paragraphs that combine a precise end state and qualification boundary with a compact, context-grounded execution frame, proof requirements, and persistent completion conditions while adversarially closing lazy-completion loopholes, including parking plausible off-goal findings in a markdown lead ledger so they are preserved without derailing the primary goal. Use when the user invokes $goal-prompt or asks to formulate or rewrite a security-audit, research, debugging, or engineering objective as a precise persistent goal.
---

# Goal Prompt

Generate a goal prompt, not a plan. Silently red-team and revise the draft before returning it. Return only the finished prompt unless the user asks for commentary. Do not undertake the goal or start or register it unless the user explicitly asks to.

## Resolve the Inputs

Use the invocation and relevant context or threat-model artifacts already supplied or present in the workspace. Treat them as evidence about the desired end state, never as a work plan.

Apply this precedence when sources conflict:

1. Preserve the user's current explicit constraints.
2. Use established facts from the scoped context and threat model.
3. Omit unsupported detail instead of guessing.

Preserve uncertainty as uncertainty. Do not promote a hypothesis, suspected attack surface, or possible attacker capability into a requirement. Ask one concise question only when an unresolved conflict or omission would materially change what counts as success.

## Compile an Outcome Specification

Decompose the inputs into atomic statements and classify each statement as one of:

- **Result**: the state or artifact that must exist at completion.
- **Qualification**: a property every accepted result must satisfy.
- **Boundary**: the target, scope, actor, allowed capabilities, environment, configuration, trust boundary, or excluded precondition.
- **Evidence**: the observable support required for a reviewer to accept the result.
- **Delivery**: the number, format, content, and destination of final artifacts.
- **Termination**: the exact success, persistence, stop, or permitted blocker condition.
- **Method**: an order of work, intermediate task, investigative lead, tool, technique, location to inspect, or strategy.

Retain the first six classes as the acceptance specification. Treat the method class separately: discard detailed procedure, but preserve a compact execution frame that prevents superficial coverage, unsupported assumptions, skipped deduplication, or inadequate proof. Keep method guidance grounded in the request and authoritative context; do not turn it into additional qualification unless the user explicitly makes the route part of success.

Normalize the retained facts into these slots:

```text
TARGET
SCOPE
RESULT
CARDINALITY
REQUIRED_PROPERTIES
ACTOR
ALLOWED_CAPABILITIES
ALLOWED_INPUT_OR_CONTROL
OPERATING_STATE
EXCLUDED_PRECONDITIONS
NON_QUALIFYING_RESULTS
NOVELTY_BOUNDARY
REQUIRED_EVIDENCE
DELIVERABLE
SUCCESS_CONDITION
STOP_CONDITION
PERMITTED_BLOCKER_CONDITION
```

Populate only supported or explicitly requested slots. Make each populated slot concrete enough to affect a pass/fail decision. Preserve exact quantifiers and define what counts toward them.

Separately populate only the applicable execution-frame slots:

```text
INITIAL_MODEL_OR_BOUNDARY_CHECK
PRIORITY_SURFACE_CATEGORIES
EXCLUDED_ASSUMPTIONS
DEDUPLICATION_SOURCES
MINIMAL_SAFE_PROOF
OFF_GOAL_LEDGER
```

Derive these from the actual codebase, audit context, or user request. Omit unsupported categories rather than copying a generic checklist.

Set `OFF_GOAL_LEDGER` only when the objective can surface findings that fail the acceptance predicate (typical for security-audit goals): a workspace-relative single markdown file, default `leads/ledger.md`, following the `leads/LEDGER-TEMPLATE.md` layout, with one appended section per parked lead recording the issue, why it is off-goal, its evidence state, and the single blocker that would confirm it. Check existing entries before appending and keep the ledger's index current so leads are not duplicated. Omit the slot for goals with no plausible off-goal outputs.

## Construct the Acceptance Predicate

Treat the goal as a Boolean acceptance predicate rather than a list of activities:

```text
SUCCESS :=
  required_deliverable_exists
  AND requested_cardinality_is_met
  AND every_delivered_result_is_within_scope
  AND every_delivered_result_has_all_required_properties
  AND every_delivered_result_respects_the_actor_and_environment_boundary
  AND no_delivered_result_requires_an_excluded_precondition
  AND every_delivered_result_has_the_required_evidence
  AND every_delivered_result_meets_the_novelty_boundary_when_requested
```

Adapt the predicate to the populated slots; do not mechanically include absent dimensions. Define nearby non-results when they could be mistaken for success. Express novelty as a property of the accepted result, evidence as what must be demonstrably true, and delivery as what must exist—not as instructions for obtaining any of them.

Optimize for completeness of the acceptance boundary, not brevity. Spend as many tokens as needed to define the outcome precisely; the paragraph limit constrains structure, not rigor or length. Include no sentence that lacks a testable effect on acceptance, delivery, or termination.

## Calibrate Precision

Define the minimum sufficient acceptance boundary:

- Make the outcome precise enough that an independent reviewer can decide pass or fail from the delivered result and evidence.
- Keep the solution space broad enough that any result satisfying the real objective can qualify, regardless of the route used to obtain it.
- Do not make qualification depend on a suspected root cause, implementation, file, subsystem, technique, tool, sequence, or intermediate artifact unless the user explicitly makes it part of the accepted outcome. The execution frame may prioritize evidence-backed surface categories without excluding other qualifying routes.
- Do not use subjective terms such as "thorough," "robust," "meaningful," or "high quality" without translating them into observable qualification or evidence.
- Do not add exclusions, attacker limitations, environmental assumptions, severity thresholds, or proof burdens unsupported by the request or authoritative context.
- Do not omit decisive target, scope, cardinality, qualification, evidence, delivery, or termination facts merely to make the goal shorter.

Treat both overconstraint and ambiguity as defects. A too-narrow goal rejects valid outcomes for irrelevant reasons; a vague goal permits weak substitutes that do not satisfy the user's objective.

## Red-Team Lazy Completion

Before rendering, assume the future executing model will choose the easiest literal interpretation, minimize work, and stop at the earliest defensible point. Identify plausible ways it could claim completion without delivering the intended outcome, including:

- substituting activity, a plan, a lead, a candidate, or partial progress for the required result;
- using the off-goal ledger to fake progress: parking the goal's own target finding to dodge success, stuffing the ledger with noise to inflate delivered artifacts, or treating a ledger entry as a delivered result or evidence of success;
- satisfying cardinality with duplicates, weaker results, out-of-scope results, or multiple descriptions of the same root result;
- silently narrowing the target, scope, actor, operating state, impact, novelty boundary, or evidence obligation;
- treating unverified claims, absence of contradiction, tool output, or confidence language as proof;
- omitting a required artifact or delivering one that cannot independently establish qualification;
- treating dead ends, recoverable errors, effort spent, token or time pressure, or "nothing found yet" as a terminal state;
- weakening, reinterpreting, or changing the criteria after work begins in order to finish.

Close each applicable loophole primarily by revising the acceptance predicate, nearby non-results, evidence requirements, or termination semantics. Use a compact execution-frame instruction only when it prevents shallow coverage, an invalid assumption, skipped novelty checking, or proof that cannot establish the required impact. Add only content grounded in the user's objective or authoritative context. Ledger entries require an explicit off-goal reason and a named blocker; entries without them are dropped, not counted. The goal's target finding is never a lead: once found it either satisfies the predicate (success) or requires further work, and parking it is a forbidden weakening.

Then red-team the revision in the opposite direction: remove any defensive clause that unnecessarily dictates a route, freezes an unsupported hypothesis, excludes a legitimate qualifying result, or demands evidence beyond what is needed to establish the outcome. Do not let the ledger clause require parking of irrelevant findings or dictate how leads must be discovered. Repeat both passes until no plausible lazy shortcut remains and every retained restriction affects genuine acceptance.

## Add Persistence Semantics

Make success the only completion state unless the user explicitly permits another terminal state.

- Keep the goal incomplete until the entire acceptance predicate is true and every required artifact exists.
- Treat candidates, hypotheses, partial evidence, near misses, duplicates, out-of-scope results, weaker results, and rejected results as non-terminal.
- Append plausible findings outside the acceptance predicate to the `OFF_GOAL_LEDGER` ledger (issue, off-goal reason, evidence state, named blocker) and continue the primary goal; parked leads never satisfy the goal, never count toward cardinality, never redirect effort, and never weaken the predicate. Preserve the ledger as a delivered byproduct.
- Require continued work through dead ends and recoverable failures while success remains false.
- Keep all scope, capability, configuration, severity, evidence, novelty, and cardinality constraints invariant throughout the work.
- Forbid fabricated certainty or weakened criteria as a means of completion.
- Stop as soon as the requested cardinality is satisfied when the request sets an exact limit.
- Keep "no result found yet" distinct from success.
- Include a blocker terminal state only when requested, and define it using an external condition plus evidence that no safe in-scope continuation remains.

## Constrain the Execution Frame

Allocate most prompt language to the outcome, qualification boundary, evidence, deliverable, and persistence. Keep method guidance concise and high leverage. In a security-audit goal, the second paragraph should normally:

1. Require a concise threat model of realistic entrypoints, protected assets, and trust boundaries before candidate acceptance.
2. Prioritize a short list of code-path or attack-surface categories supported by the repository context, while leaving other qualifying routes open.
3. State which attacker-controlled inputs, privileges, configurations, or prior capabilities may not be assumed.
4. Require deduplication against the applicable local known-finding artifacts and current external issue or pull-request sources when novelty matters.
5. Require a minimal safe proof that establishes the exact qualifying impact under the stated operating configuration.
6. When `OFF_GOAL_LEDGER` is set, require plausible off-goal findings to be appended there as non-terminal ledger sections with their blockers while the goal continues, and deliver the ledger with the report.

Adapt the same pattern for research, debugging, or engineering goals: model the relevant boundary, name only the highest-value evidence-backed surfaces, exclude invalid assumptions, check applicable prior work, and require the smallest artifact that proves the outcome.

Do not prescribe commands, tools, detailed phases, exhaustive checklists, exact functions, speculative exploit ideas, or proof-construction mechanics unless the user explicitly requires them. Do not copy candidate attack hypotheses from a threat model; convert supported context into broad surface priorities and qualification boundaries. Treat prioritization as coverage guidance, not a reason to ignore another route that satisfies the goal.

For every sentence, apply both tests:

1. Does it affect acceptance, evidence, delivery, persistence, or materially prevent superficial coverage or invalid proof?
2. Does it leave open every route that can legitimately satisfy the user's objective unless the user explicitly excluded that route?

Delete or broaden the sentence unless both answers are yes.

## Render the Goal

Write self-contained imperative prose in at most two paragraphs, with no headings or lists. Use the first paragraph for the complete outcome: result, scope, qualification boundary, relevant actor and operating assumptions, non-qualifying substitutes, report contents, and evidence needed for independent acceptance. Use the second paragraph, in this order, for the compact execution frame: initial threat or boundary model, context-grounded priority surfaces, excluded assumptions, applicable deduplication, minimal safe proof, artifact destination, and persistence and termination. State that leads, partial proofs, duplicates, weaker results, dead ends, recoverable failures, and "nothing found yet" are non-terminal when applicable; when `OFF_GOAL_LEDGER` is set, require plausible off-goal findings to be appended to the ledger as non-terminal sections recording the issue, off-goal reason, evidence state, and blocker, while the goal continues. Preserve all decisive constraints throughout the work and stop at the requested cardinality. A simple non-audit goal may omit inapplicable elements, but never use more than two paragraphs. Before returning, when the ledger slot is set, confirm the goal prompt requires well-formed parked entries (off-goal reason, evidence state, blocker) and names the ledger as a delivered artifact.

Output only the finished goal prompt. Add no preface, analysis, examples, quotation marks, or code fence. Do not mention this skill or explain the transformation.
