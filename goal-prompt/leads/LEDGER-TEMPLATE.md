# Lead Ledger

One file holding every parked, off-goal lead. Append one section per lead and update the index; never rewrite or delete an existing section. A lead is promoted to a candidate or finding only under a separate request or goal.

## Index

| ID | Status | Summary |
| --- | --- | --- |
| LEAD-NNN | PARKED | <one-line issue summary> |

## LEAD-NNN — <one-line issue summary>

- **Status:** PARKED (open) — not promoted without a separate request or goal
- **Date / goal:** <date> — <goal summary or reference>
- **Source references:** <`file:line`, address, tx/block, or artifact>

### Issue

<What was observed, in plain terms.>

### Why off-goal

<Which acceptance dimension this fails: severity, impact class, cardinality, novelty, scope, or actor/environment boundary. Must be explicit so the entry cannot be mistaken for the goal's result.>

### Evidence state

<One tag: SOURCE-CONFIRMED | LIVE-CONFIRMED | NEEDS-LIVE-PROOF | CONFIG-INACTIVE | SCOPE-FILTERED | EXT-UNVERIFIED>

### Current blocker

<The single next confirmation that would promote this to a candidate. Do not pursue it under the current goal.>

### Promotion criteria

<What a follow-up goal must demonstrate to accept this finding.>
