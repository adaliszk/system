---
disable-model-invocation: true
description: Write or Refine a Software Decision Record.
name: swe-decision
---

# Execution

1. LOAD `caveman` SKILL in `ultra` MODE (RUN `/caveman ultra`), and
   LOAD `ponytail` SKILL in `ultra` MODE (RUN `/ponytail ultra`)
2. LOAD `./wiki/ARCHITECTURE.md` for TECHNICAL OVERVIEW, and
   LOAD `./wiki/GLOSSARY.md` for unambiguous language, and
   LOAD `./AGENTS.md` for INSTRUCTIONS
3. LOAD `./wiki/decisions/*.md` for EXISTING DECISIONS
4. HANDLE USER input: a short description what decision is about.
5. ASK for the details WITHOUT assuming or choosing for the USER.
6. WRITE the full-featured decision description and SHOW to the USER,
   AVOID complex sentences, em-dash, repeated needs and wants.
7. REPEAT 4-7 until USER APPROVES.
8. PRINT tokens used in the current Context.

# Requirements

- Use precise, unambiguous language
- Follow standardized ADR format with front matter
- Include both positive and negative consequences
- Document alternatives with rejection rationale
- Structure for machine parsing and human reference

# Rendering

Use `skill-macros` MCP with `format-to-<target>` tool to convert the custom DSL generated into the various target systems such as Jira, Confluence, GitHub, or AFFiNE. Use `supported-targets` tool to get which systems are available.

# Placeholders

Template placeholders use `[Variable]` square brackets. NEVER use `{Variable}`: the
curly braces collide with skill macro syntax and risk being parsed on push. Reserve `{}`
strictly for actual skill macros.

# Decision Outline

Combines multiple header separated segments:

- Context: the "description" without header to lead the pain points.
- Considerations: references to existing decisions or potential solution tools.
- Decisions: List of individual decisions that solves the pain points.
- Consequences: List of Positives and Negative side effects.
- Implementation: List of items to ship the decision.
- Alternatives Considrered: List of links to alternative documents, intentaionally external!
- References: List of links to the finalized tools.

# Decision Content

The final result should look something like:

```markdown
---
title: "CCC-NNNN: [Decision Title]"
status: "proposed/implemented"
date: "YYYY-MM-DD"
authors: "[Stakeholder Names/Roles]"
tags: ["architecture", "decision"]
supersedes: ""
---

[Problem statement, technical constraints, business requirements, and environmental factors requiring this decision.]

## Decision

{decision}Option X chosen by [Stakeholder]{/decision}

{decision}[Dependent process, tool, or policy]{decision}
{decision}[Dependent process, tool, or policy]{decision}
{decision}[Dependent process, tool, or policy]{decision}

## Consequences

{success}[Benefit]{success}
{success}[Benefit]{success}
{success}[Benefit]{success}
{success}[Benefit]{success}
{success}[Benefit]{success}
{error}[Drawback]{error}
{error}[Drawback]{error}
{error}[Drawback]{error}

## Implementation

1. [Action] on [Component] by [introducing / modifying] [Feature].
2. [implement / refactor] [Dependency].
3. [implement / refactor] [Dependency].
4. [implement / refactor] [Dependency].
5. [verify / test] [Scenarios] that the solution works as expected.

## Alternatives Considered

- [Alt-1 Link](CCC-NNNN/Alt-1.md)
- [Alt-2 Link](CCC-NNNN/Alt-2.md)
- [Alt-3 Link](CCC-NNNN/Alt-3.md)

## References

- [Link]
- [Link]
- [Link]
```

# Variables

CAN BE inferred BUT ALWAYS ASK when NOT CERTAIN! Owners and Stakeholders are
frequently NOT inferable: ASK rather than invent a name.
