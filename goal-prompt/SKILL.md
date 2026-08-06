---
name: goal-prompt
description: Convert natural-language objectives, existing repository context, and threat models into copy-paste-ready Codex goal prompts that define a precise end state, qualification boundaries, required evidence or artifacts, and persistent completion conditions without prescribing methods. Use when the user invokes $goal-prompt or asks to formulate or rewrite a security-audit, research, debugging, or engineering objective as an outcome-only persistent Codex goal.
---

# Goal Prompt

Generate a goal prompt, not a plan. Return only the finished prompt unless the user asks for commentary. Do not undertake the goal or call `create_goal` unless the user explicitly asks to start or register it.

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

Retain the first six classes. Remove the method class. When a method statement implies a genuine acceptance property, retain only that property and discard the procedure. If removing a method statement does not change whether the final result passes or fails, omit it entirely.

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

Optimize for completeness of the acceptance boundary, not brevity. Use as many words as necessary to make the predicate unambiguous, but include no sentence that lacks a testable effect on acceptance, delivery, or termination.

## Add Persistence Semantics

Make success the only completion state unless the user explicitly permits another terminal state.

- Keep the goal incomplete until the entire acceptance predicate is true and every required artifact exists.
- Treat candidates, hypotheses, partial evidence, near misses, duplicates, out-of-scope results, weaker results, and rejected results as non-terminal.
- Require continued work through dead ends and recoverable failures while success remains false.
- Keep all scope, capability, configuration, severity, evidence, novelty, and cardinality constraints invariant throughout the work.
- Forbid fabricated certainty or weakened criteria as a means of completion.
- Stop as soon as the requested cardinality is satisfied when the request sets an exact limit.
- Keep "no result found yet" distinct from success.
- Include a blocker terminal state only when requested, and define it using an external condition plus evidence that no safe in-scope continuation remains.

## Eliminate Hints About How

Reject any generated sentence that prescribes phases, ordering, intermediate tasks, prioritization, investigative heuristics, attack-surface checklists, candidate-generation strategies, files or subsystems to inspect, searches, tools, commands, tests, techniques, or proof-construction methods.

Do not copy attack ideas from the threat model. Carry forward only facts that alter qualification, especially actor powers, trust boundaries, operating configuration, allowed control, and excluded preconditions.

For every sentence, apply both tests:

1. Would changing or removing this sentence change whether the final result qualifies, whether the deliverable is complete, or whether the goal may terminate?
2. Does this sentence constrain what must be true, rather than choosing a route for making it true?

Delete the sentence unless both answers are yes.

## Render the Goal

Write self-contained imperative prose. Order the content as the required result, qualification and threat boundary, evidence and deliverable, then persistence and termination. Prefer dense paragraphs; use structure only when needed to keep the acceptance predicate unambiguous.

Output only the finished goal prompt. Add no preface, analysis, examples, quotation marks, or code fence. Do not mention this skill or explain the transformation.
