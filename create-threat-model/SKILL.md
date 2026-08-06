---
name: create-threat-model
description: Turn completed security-audit context—such as scope facts, context or architecture maps, deployment facts, invariants, and carried leads—into an evidence-bound threat model with protected assets, actors, trust boundaries, lifecycle state machines, structured threat hypotheses, coverage reconciliation, and explicit proof gates. Use when the user invokes $create-threat-model or asks to create, regenerate, or update a threat-model.md from an existing audit context without beginning vulnerability hunting.
---

# Create Threat Model

Convert established audit context into a threat model, not a vulnerability report. Keep every threat as a hypothesis until separate verification proves its reachability, invariant break, and impact. Do not resume an audit workflow, launch a hunt, test exploits, or promote a threat into a finding unless the user separately requests that work.

## Establish the Evidence Base

Locate the audit root and all relevant context artifacts. Prefer explicit paths from the user, then repository instructions and durable audit state, then conventional files such as `scope-facts.md`, `context-map.md`, `scope-files.txt`, architecture maps, deployment inventories, known-issue lists, and existing lead registers.

Read every selected artifact completely, chunking large files as needed. Do not build the model from headings, search snippets, or summaries alone. Record each artifact's snapshot, revision, and authority. If an audit runner exists, inspect its status read-only when needed to establish artifact compatibility; do not advance gates or mutate the run.

Apply this precedence when facts conflict:

1. Preserve the user's current explicit scope and threat assumptions.
2. Preserve approved scope and verified deployment facts.
3. Use source-grounded context-map facts and invariants.
4. Retain unresolved or external claims as unverified rather than choosing one silently.

Treat recorded live facts as facts at their stated snapshot, not automatically as current state. Resolve a decisive gap from primary evidence when safe and in scope; otherwise label the gap. Ask one concise question only when an unresolved conflict would materially change the model boundary.

## Freeze the Modeling Boundary

State the target, source revision, in-scope components, deployed instances or supported environments, excluded roots and impacts, trusted roles, attacker capabilities, prohibited assumptions, known accepted behavior, and validation restrictions.

Keep design and deployment models distinct. Source behavior does not establish live reachability, and runtime identity alone does not establish proxy state, dependency bindings, configuration, balances, or enabled modes.

Define evidence labels suited to the engagement. For a live smart-contract audit, use these when applicable:

- `LIVE-CONFIRMED`: observed at the recorded live snapshot; not proof of exploitability.
- `SOURCE-CONFIRMED`: present in pinned source; deployment correspondence unproved.
- `NEEDS-LIVE-PROOF`: source/runtime drift or an unreconstructed live path blocks an impact claim.
- `CONFIG-INACTIVE`: a required mode is disabled and has no established untrusted transition.
- `SCOPE-FILTERED`: the required root, actor, or impact is excluded.
- `EXT-UNVERIFIED`: a third-party, chain, or environmental property remains unproved.

Omit irrelevant labels and define any additional label before using it.

## Build the Model Independently

Build the following layers from architecture, flows, and invariants before consulting carried leads. This prevents the threat model from inheriting the lead list's blind spots.

### 1. System and value flows

Draw the smallest useful system diagram. Represent value, authority, identity, accounting, messages, and trusted configuration crossing component boundaries. Identify dangerous cycles spanning multiple components; do not reduce the model to isolated entrypoints.

### 2. Protected assets and objectives

Assign stable `A-NN` identifiers. Include custody, backing or supply integrity, authorization, claims, configuration, availability, deployment correspondence, and environmental interpretation when relevant. For each asset, name its beneficiary and a testable security property.

### 3. Security invariants

Assign stable `INV-NN` identifiers. Express conservation equations, authorization predicates, lifecycle uniqueness, synchronization requirements, bounded progress, exact delivery, and configuration consistency as conditions that must remain true. Attach source or context evidence to every invariant. Preserve documented invariants and add derived cross-contract invariants only when their premises are supported.

### 4. Actors and trust assumptions

Separate permissionless actors, object owners, delegated actors, keepers or liquidators, trusted administrators, protocol companions, external dependencies, and environmental actors. State exact capabilities and exclusions. Model unintended privilege expansion and permissionless abuse after ordinary trusted configuration; do not model malicious trusted behavior as an eligible attack when scope excludes it.

### 5. Trust boundaries and entrypoints

For each crossing, record the source, destination, externally controlled inputs, authority or value transferred, and required validation or postcondition. Include proxy/runtime, callbacks, token semantics, oracle/time, arbitrary calldata, and cross-domain boundaries when present.

### 6. Lifecycle state machines

Model each critical object or value lifecycle as states and transitions. For every transition capture:

- actor and authorization;
- entrypoint or trigger;
- state read and written;
- value or authority moved;
- external interaction and reordering opportunity;
- required preconditions and postconditions;
- failure or partial-progress behavior.

List forbidden transitions explicitly. Include deployment and configuration as a lifecycle when source-to-live correspondence affects validity.

## Derive the Threat Register

Cross each high-value flow and lifecycle seam with the applicable lenses:

- identity, authentication, and authorization;
- accounting, conservation, and state synchronization;
- economic manipulation, rounding, caps, fees, and incentives;
- external calls, callbacks, return semantics, and integration drift;
- ordering, atomicity, replay, time, oracle, and chain behavior;
- configuration, initialization, upgrades, roles, and deployment correspondence;
- availability, bounded progress, gas, and dependency failure;
- state-machine violations and incomplete settlement.

Use STRIDE where it adds coverage, but do not force low-value categories or let STRIDE replace economic and state-machine analysis.

Assign stable `TM-NNN` identifiers. Each threat entry must contain:

| Field | Requirement |
|---|---|
| Hypothesis | Describe a plausible failure condition, not an asserted bug. |
| Assets / invariants | Link every threat to protected properties. |
| Actor and preconditions | State the least-privileged actor and all required conditions. |
| Boundary / surface | Identify the crossed boundary or lifecycle seam. |
| Evidence / reachability | Distinguish source, deployment, configuration, and external evidence. |
| Existing controls / exclusions | Record why the threat may be bounded or non-qualifying. |
| Required proof | State what separate verification must demonstrate to promote it. |
| Priority / disposition | Rank investigation value without assigning finding severity. |

Prioritize using eligible impact, attacker reachability, deployed presence, attacker cost and repeatability, control strength, trust assumptions, and known-issue overlap. Priority is an investigation order, not a severity verdict.

## Reconcile Existing Context

After independent derivation, map every carried lead, invariant, scoped component, and documented boundary to one or more threat IDs or an explicit disposition. Preserve original lead identifiers exactly and enumerate ranges as individual IDs so coverage can be checked mechanically. Mapping a lead does not validate it.

Merge duplicate hypotheses by root cause without losing distinct actors, configurations, or impacts. Retain unsupported leads as unverified or scope-filtered rather than inventing evidence. Add threats that the independent pass discovered even when no carried lead maps to them.

Write a few end-to-end abuse-case narratives for the highest-risk multi-component paths. Name the actor and action at each step, the expected invariant drift, and the linked threat IDs. Label every narrative as a test story rather than a proven exploit.

Build a flow-by-lens coverage matrix. A checked cell means the lens was considered and mapped to threats or an explicit no-applicable-threat rationale; it does not mean the component is safe.

## Render `threat-model.md`

Write to the user-specified path, or `<audit-root>/threat-model.md` by default. Adapt the structure to the available evidence while preserving this order:

1. provenance, purpose, and non-finding disclaimer;
2. scope decisions, evidence labels, and priority semantics;
3. deployment or environment anchors when applicable;
4. system and value-flow model;
5. protected assets and security objectives;
6. core security invariants;
7. actors and trust assumptions;
8. trust boundaries and entrypoints;
9. lifecycle state machines and forbidden transitions;
10. structured threat register grouped by domain;
11. abuse-case narratives;
12. lens coverage matrix;
13. reconciliation of carried inputs;
14. optional future investigation queue and completion criteria.

Keep claims traceable with repository-relative `file:line`, artifact section, deployment address, transaction/block, or other precise evidence. Do not copy unsupported certainty from prior leads. Do not include exploit instructions that exceed the authorized audit context.

## Validate Completion

Before finishing, verify that:

- every in-scope component and material value or authority flow appears in the model;
- every protected asset and invariant maps to at least one threat or explicit disposition;
- every critical lifecycle includes forbidden transitions;
- every threat names an actor, preconditions, evidence state, and required proof;
- every carried lead is explicitly reconciled without being promoted to a finding;
- source/live drift, trusted-role exclusions, inactive configuration, known behavior, and external uncertainty remain visible at triage points;
- threat IDs, asset IDs, invariant IDs, cross-references, and Markdown are internally consistent;
- the artifact says what remains outside this modeling step: validation, refutation, exploit chaining, PoCs, deduplication, severity assignment, and reporting.

Run deterministic text checks where useful, including missing-ID comparisons for numbered carried leads and a whitespace/Markdown sanity check. Report the output path, modeled counts, reconciliation result, and validation status concisely. Do not claim completeness merely because the document is long; completion means the evidence and coverage conditions above are satisfied.
