---
name: spec-task-list-creator
description: >-
  Create a phased execution plan (task list) from a specification package. Produces
  a YAML plan with phases, tasks, dependencies, validation criteria, and
  checkpoints. Use this skill whenever the user wants to create an implementation
  plan, task list, or execution plan from a spec — even if they say "plan the
  work", "break this into tasks", "create a task list", or "what's the
  implementation order".
---

# Spec: Task List

Produce a phased execution plan from a specification package. The plan is
structured so each task is atomic, verifiable, and safe to roll back.

## Required Inputs

Four files must be attached or referenced:

| Input | Purpose | File |
|-------|---------|------|
| **Feature request** | Feature context and scope | `feature-request.md` |
| **Requirements document** | What the feature must do | `requirements.md` |
| **Acceptance criteria document** | Expected behavior | `acceptance-criteria.md` |
| **Constraints document** | Technical boundaries | `constraints.md` |

### Input Validation

Before starting, verify all inputs are present:

```
IF no feature request is attached:
    STOP and ask: "Please attach the feature request
    (feature-request.md)."

IF no requirements document is attached:
    STOP and ask: "Please attach the requirements document
    (e.g. requirements.md)."

IF no acceptance criteria document is attached:
    STOP and ask: "Please attach the acceptance criteria document
    (e.g. acceptance-criteria.md)."

IF no constraints document is attached:
    STOP and ask: "Please attach the constraints document
    (e.g. constraints.md)."
```

## Plan Structure

The plan is organized into phases containing tasks. Each phase ends with a
checkpoint where a human reviews progress before the next phase begins.

### Task Granularity

- Each task should be completable in a single focused effort
- Each task produces a verifiable artifact (file, passing test, etc.)
- Each task is small enough to roll back if wrong

### Dependency Rules

- No circular dependencies
- Minimize cross-phase dependencies
- Infrastructure before business logic
- Interfaces before implementations

### Checkpoint Placement

Place checkpoints after:

- Project structure creation
- Core domain model completion
- Each major component integration
- Test suite completion
- Final integration

## Hard Limits

| Constraint | Limit |
|------------|-------|
| Maximum phases | 5 |
| Maximum tasks per phase | 7 |
| Every task | must have a validation criterion |
| Every phase | must end with a checkpoint |

If the specification cannot fit within these limits, report the issue and
suggest how to split the work.

## Output

Write the plan to a file the user specifies, or default to
`spec/<feature-name>/plan.yaml`.

Do NOT start implementing any tasks — only produce the plan.

### Output Format

```yaml
plan:
  name: "<feature name>"
  phases:
    - id: phase-1
      name: "<phase name>"
      description: "<what this phase accomplishes>"
      tasks:
        - id: task-1.1
          name: "<task name>"
          description: "<what to do>"
          artifact: "<file path or outcome>"
          depends_on: []
          validation: "<how to verify completion>"
        - id: task-1.2
          name: "..."
          description: "..."
          artifact: "..."
          depends_on: ["task-1.1"]
          validation: "..."
      checkpoint:
        description: "<what to review>"
        criteria:
          - "<criterion 1>"
          - "<criterion 2>"
    - id: phase-2
      ...
```
