---
name: spec-verification
description: >-
  Review a specification package (requirements, acceptance criteria, constraints)
  for gaps, contradictions, and ambiguities that could cause implementation
  issues. Use this skill whenever the user wants to verify, review, validate, or
  audit a spec — even if they say "check the spec", "is this spec complete",
  "find gaps in the requirements", or "review before implementation".
---

# Spec: Verification

Review a specification package and surface any gaps, contradictions, or
ambiguities before implementation begins. Think of this as a pre-flight
checklist — catching issues here is orders of magnitude cheaper than catching
them during development.

## Required Inputs

Three files must be attached or referenced:

| Input | Purpose | Examples |
|-------|---------|----------|
| **Requirements document** | What the feature must do | `requirements.md` |
| **Acceptance criteria document** | Expected behavior | `acceptance-criteria.md` |
| **Constraints document** | Technical boundaries | `constraints.md` |

### Input Validation

Before starting, verify all inputs are present:

```
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

## Verification Checklist

Work through each section systematically. Check every item; don't skip any.

### Completeness

- [ ] Every acceptance criterion has a clear test strategy
- [ ] All error scenarios have defined behavior
- [ ] Edge cases are explicitly addressed
- [ ] Performance requirements are measurable

### Consistency

- [ ] No contradictions between acceptance criteria and constraints
- [ ] Package structure supports all specified components
- [ ] Data types are consistent throughout

### Implementability

- [ ] Technical constraints are specific enough to be validated
- [ ] No circular dependencies in component design
- [ ] All external dependencies are identified

### Testability

- [ ] Each acceptance criterion maps to at least one test case
- [ ] Test data requirements are clear
- [ ] Success/failure conditions are unambiguous

## Output

Present findings directly to the user (or write to a file if requested).

### Severity Levels

| Severity | Meaning |
|----------|---------|
| **BLOCKER** | Cannot proceed with implementation until resolved |
| **MAJOR** | Implementation possible but risks incorrect behavior |
| **MINOR** | Cosmetic or nice-to-have clarification |

### Output Format

```markdown
# Spec Verification: <Feature Name>

## Summary
- Total issues: N
- Blockers: N | Major: N | Minor: N

## Issues

### BLOCKER-1: <title>
- **Category:** Completeness / Consistency / Implementability / Testability
- **Description:** What the issue is
- **Impact:** What goes wrong if not fixed
- **Suggested resolution:** How to fix it
- **Affected specs:** Which documents need updating

### MAJOR-1: <title>
...

### MINOR-1: <title>
...

## Checklist Results
<filled-in checklist from above>
```
