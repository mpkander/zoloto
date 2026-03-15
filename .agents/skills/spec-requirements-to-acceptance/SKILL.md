---
name: spec-requirements-to-acceptance
description: >-
  Convert a requirements document into acceptance criteria using WHEN-THEN-SHALL
  format. Use this skill whenever the user wants to write, generate, or derive
  acceptance criteria from requirements — even if they say "write acceptance
  tests", "define behavior specs", "what should we test", or "create ACs".
---

# Spec: Acceptance Criteria

Transform requirements into testable acceptance criteria using the
WHEN-THEN-SHALL behavioral format.

## Required Inputs

Two files must be attached or referenced:

| Input | Purpose | File |
|-------|---------|------|
| **Feature request** | Provides context about the feature | `feature-request.md` |
| **Requirements document** | The requirements to convert into ACs | `requirements.md` |

### Input Validation

Before starting, verify both inputs are present:

```
IF no feature request is attached:
    STOP and ask: "Please attach the feature request
    (feature-request.md) so I have context for the feature."

IF no requirements document is attached:
    STOP and ask: "Please attach the requirements document
    (requirements.md) that I should convert into acceptance criteria."
```

## Process

### Step 1 — Understand Context

Read the feature request to understand the feature's purpose, scope,
and user-facing behavior.

### Step 2 — Analyze Requirements

Read each requirement and determine the behavioral expectations it implies.
Identify happy paths, edge cases, and error scenarios.

### Step 3 — Write Acceptance Criteria

For each requirement (or logical group of related requirements), write
acceptance criteria using the WHEN-THEN-SHALL format.

## WHEN-THEN-SHALL Format

| Element | Role |
|---------|------|
| **WHEN** | Describes the precondition or trigger |
| **THEN** | Describes the action or input |
| **SHALL** | Describes the expected observable outcome |

### Rules

- Each criterion must be independently testable
- Focus on BEHAVIOR, not implementation details
- Include happy path, edge cases, and error scenarios
- Group criteria by category or feature area
- Use precise, unambiguous language — avoid "should work correctly"

### Example

```markdown
### User Authentication

**AC-1: Successful login**
- WHEN a registered user exists in the system
- THEN the user submits valid credentials
- SHALL receive an authentication token and be redirected to the dashboard

**AC-2: Invalid password**
- WHEN a registered user exists in the system
- THEN the user submits an incorrect password
- SHALL see an error message "Invalid credentials" and remain on the login page
```

## Output

Write the results to a file the user specifies, or default to
`spec/<feature-name>/acceptance-criteria.md`.

### Output Format

```markdown
# Acceptance Criteria: <Feature Name>

## <Category 1>

**AC-1: <descriptive name>**
- WHEN ...
- THEN ...
- SHALL ...

**AC-2: <descriptive name>**
- WHEN ...
- THEN ...
- SHALL ...

## <Category 2>
...
```
