---
disable-model-invocation: true
description: Write or Refine a Software Ticket about a Feature and User-Story.
name: swe-story
---

# Execution

1. LOAD `caveman` SKILL in `ultra` MODE (RUN `/caveman ultra`), AND
   LOAD `ponytail` SKILL in `ultra` MODE (RUN `/ponytail ultra`)
2. LOAD `./wiki/ARCHITECTURE.md` for TECHNICAL OVERVIEW, AND
   LOAD `./AGENTS.md` for INSTRUCTIONS
3. LOAD `./wiki/decisions/*.md` for TECHNICAL CONSTRAINTS, AND
   LOOKUP `./wiki/patterns/*.md` to FIND APPLICABLE EXAMPLE
4. PARSE OR ASK for USER input about the short description what the ticket should
   contain with the direction provided.
5. LOAD any reference links provided for additional context.
6. ASK for the details WITHOUT assuming or choosing for the USER.
7. WRITE the full-featured ticket description and SHOW to the USER,
   AVOID complex sentences, em-dash, repeated needs and wants.
8. REPEAT 4-8 until USER APPROVES.
9. PRINT tokens used in the current Context.

# Rendering

Use `skill-macros` MCP with `format-to-<target>` tool to convert the custom DSL generated into the various target systems such as Jira, Confluence, GitHub, or AFFiNE. Use `supported-targets` tool to get which systems are available.

# Placeholders

Template placeholders use `[Variable]` square brackets. NEVER use `{Variable}`: the
curly braces collide with skill macro syntax and risk being parsed on push. Reserve `{}`
strictly for actual skill macros.

# Ticket Outline

Combines multiple header separated segments:

- Use-Case: the "description" without header to lead the feature request.
- Viability: for giving limitations, context, and architecture details.
- Open Questions: unresolved points that need an answer before or during work.
- Solutions: Ideas or directions to choose from.
- Decision: for locking in the Solution with concrete plans.
- Implementation: step-by-step instruction list for agents.
- Scenarios: to explain the intended testing methodology.
- Requirements: both technical and business goals to meet.

Apply only the segments relevant to the ticket. Omit a segment rather than padding it.
Open Questions and Decision are often empty early: include Open Questions when unknowns
exist, leave Decision as a placeholder until a direction is locked.

# Ticket Content

The final result should look something like:

```markdown
As [Actor], I want [Outcome] when [Trigger] so that [Goal] achieved for [Reward].
For this, the [Component] should use [Detail] during [Process].

---

### Viability

{panel:title=Context}[Behaviour or architecture detail]{panel}

{panel:title=Limitation}Limited by [Reason]{panel}

{panel:title=Reference}[Documentation]{panel}

---

### Solutions

**Option A: [Direction: Least Effort]**

- [Result]
- [TechnicalDebt]
- [Estimation]
- [Cost]

**Option B: [Direction: Quality Effort]**

- [Result]
- [Estimation]
- [Cost]

**Option C: [Direction: Compromise]**

- [Result]
- [Consequence]
- [TechnicalDebt]
- [Estimation]
- [Cost]

---

### Decision

{panel:title=Decision}Option X chosen by [Stakeholder]{panel}

{panel:title=Benefit}[Benefit]{panel}

{panel:title=Drawback}[Drawback]{panel}

---

### Implementation

1. [Action] on [Component] by [introducing / modifying] [Feature].
2. [implement / refactor] [Dependency].
3. [implement / refactor] [Dependency].
4. [implement / refactor] [Dependency].
5. [verify / test] [Scenarios] that the solution works as expected.

---

### Scenarios

Scenario: [short intent]

- Given [precondition / starting state]
- When [trigger occurs in system]
- Then [observable outcome in system]
- And [reward / secondary outcome]

Scenario: [short intent]

- Given [precondition / starting state]
- When [trigger occurs in system]
- Then [observable outcome in system]
- And [reward / secondary outcome]

---

### Requirements

1. The [Feature] MUST BE fully implemented OR technical debt RAISED and AGREED.
2. [Consequence] SHOULD BE taken into account by [Solution].
3. [Consequence] SHOULD BE taken into account by [Solution].
4. [Dependency] MUST BE [implemented / changed] AND verified by its OWNER: [Owner].
5. All scenarios MUST pass on STAGING and verified by [Stakeholder].
6. The [engineering standards|https://...] are applied OR challenged.
7. Documentation on the [Component] MUST BE updated with [Feature].
```

# Variables

CAN BE inferred BUT ALWAYS ASK when NOT CERTAIN! Owners and Stakeholders are
frequently NOT inferable: ASK rather than invent a name.

- **Actor**: the role whose goal drives the work (e.g. procurement, developers).
- **Beneficiary**: who gains downstream (may differ from Actor).
- **Goal / Reward**: the business value when done.
- **Trigger**: the event or condition that starts it.
- **Outcome**: the observable end state.
- **Component**: the architecture component or pipeline involved.
- **Behaviour**: current operation flow as documented or observed.
- **Owner / Stakeholder**: the person accountable for a dependency or sign-off.
- **Detail**: the technical key detail the component uses (field, API, mechanism).
- **Process**: the process or flow stage where the change occurs.
- **Feature**: the capability being added or changed, named consistently throughout.
- **Dependency**: a component or integration the work relies on or must change.
- **Result**: the concrete outcome a solution option delivers.
- **TechnicalDebt**: shortcuts or follow-up work an option leaves behind.
- **Estimation**: rough effort size for an option (e.g. small, medium, large).
- **Cost**: relative cost or trade-off of an option.
- **Consequence**: a downstream effect a solution must account for.
- **Benefit / Drawback**: the upside and downside of the chosen decision.
- **Reason**: the cause of a limitation in Viability.
