---
name: spec-request-to-requirements
description: >-
  Analyze a feature request to identify ambiguities, missing information,
  implicit assumptions, and edge cases — then conduct a structured Q&A with
  the user and produce a requirements document. Use this skill whenever the
  user wants to turn a raw idea or feature request into formal requirements —
  even if they say "analyze this feature", "what's missing from this spec",
  or "help me write requirements".
---

# Spec: Request to Requirements

Turn a raw feature request into a structured requirements document through
interactive analysis and stakeholder Q&A.

## Required Input

The user must attach or reference a **feature request** (`feature-request.md`) —
this is the raw material you'll analyze.

### Input Validation

Before starting, verify the input is present:

```
IF no feature request is attached or referenced:
    STOP and ask the user:
    "Please attach the feature request file (feature-request.md)
     or paste the feature request directly."
```

## Process

### Step 1 — Analyze the Feature Request

Read the provided document and identify:

1. **AMBIGUITIES** — unclear or vague statements that need clarification
2. **MISSING INFORMATION** — what's not specified but needed for implementation
3. **IMPLICIT ASSUMPTIONS** — things that seem assumed but should be explicit
4. **EDGE CASES** — scenarios not addressed in the description
5. **CLARIFYING QUESTIONS** — questions to ask the stakeholder

### Step 2 — Interactive Q&A

Ask the user clarifying questions **one at a time, sequentially**. For each
question, explain WHY the information matters for implementation. Wait for the
answer before asking the next question.

This is the most important part of the process — the quality of the
requirements depends on how well you understand the user's intent. Don't rush
through it; each answer may change what you ask next.

### Step 3 — Write Requirements

Once you have enough clarity, synthesize everything into a structured
requirements document.

## Output

Write the results to a file the user specifies, or default to
`spec/<feature-name>/requirements.md`.

### Output Format

Use structured sections with numbered requirements:

```markdown
# Requirements: <Feature Name>

## Context
Brief summary of the feature and its purpose.

## Functional Requirements
- REQ-1: ...
- REQ-2: ...

## Non-Functional Requirements
- REQ-N1: ...

## Assumptions
- ...

## Open Questions
- Any remaining questions that couldn't be resolved.
```
