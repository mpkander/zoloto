---
name: spec-architecture
description: >-
  Define architecture for a feature based on requirements and acceptance
  criteria. Covers project structure, component design, technology decisions,
  code style, and testing strategy. Use this skill whenever the user wants to
  define architecture, architectural rules, technical boundaries, or coding
  conventions for a feature — even if they say "what patterns should we use",
  "define architecture", or "write the architecture doc".
---

# Spec: Architecture

Analyze requirements and acceptance criteria alongside the project's tech stack
to produce an architecture document that guides implementation.

## Required Inputs

Three files must be attached or referenced:

| Input | Purpose | File |
|-------|---------|------|
| **Feature request** | Feature context and scope | `feature-request.md` |
| **Requirements document** | What the feature must do | `requirements.md` |
| **Acceptance criteria document** | Behavioral expectations | `acceptance-criteria.md` |

### Input Validation

Before starting, verify all inputs are present:

```
IF no feature request is attached:
    STOP and ask: "Please attach the feature request
    (feature-request.md) for feature context."

IF no requirements document is attached:
    STOP and ask: "Please attach the requirements document
    (e.g. requirements.md)."

IF no acceptance criteria document is attached:
    STOP and ask: "Please attach the acceptance criteria document
    (e.g. acceptance-criteria.md)."
```

## Process

### Step 1 — Analyze Tech Stack

Examine the project to understand the existing tech stack, patterns, and
conventions. Look at:

- `pubspec.yaml` / `package.json` / build files — dependencies and SDK versions
- Existing source code — patterns already in use (architecture, naming, etc.)
- Test files — testing approach and frameworks
- Linter configuration — code style rules already established

### Step 2 — Define Architecture

For each category below, define architectural decisions using three levels of obligation:

| Level | Meaning |
|-------|---------|
| **MUST** | Mandatory requirement — violation is a defect |
| **SHOULD** | Strong preference — deviation needs justification |
| **MUST NOT** | Explicit prohibition — doing this is a defect |

### Architectural Categories

1. **Project structure** — packages, modules, directory layout
2. **Component design** — classes, interfaces, design patterns
3. **Technology decisions** — specific libraries, versions, configurations
4. **Code style** — naming conventions, patterns to follow, anti-patterns to avoid
5. **Testing strategy** — what to test, how to test, coverage expectations

### Step 3 — Cross-reference

Verify each architectural decision is traceable to a requirement or acceptance criterion.
Link decisions to the specs they support.

## Output

Write the results to a file the user specifies, or default to
`spec/<feature-name>/architecture.md`.

### Output Format

```markdown
# Architecture: <Feature Name>

## 1. Project Structure

- MUST: ...
- SHOULD: ...
- MUST NOT: ...

## 2. Component Design

- MUST: ...
- SHOULD: ...
- MUST NOT: ...

## 3. Technology Decisions

- MUST: ...
- SHOULD: ...

## 4. Code Style

- MUST: ...
- SHOULD: ...
- MUST NOT: ...

## 5. Testing Strategy

- MUST: ...
- SHOULD: ...
```
