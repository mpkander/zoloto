---
name: readme-writer
description: >-
  Generate high-quality, concise README.md documentation for public Dart/Flutter
  packages published to pub.dev. Use this skill whenever the user asks to write,
  rewrite, generate, or improve a README for a Dart or Flutter package — even if
  they just say "write docs", "make a readme", or "document this package".
---

# README Writer for Dart/Flutter Packages

Generate publication-ready README files by analyzing the package source code.
The result should feel like it was written by a seasoned open-source maintainer:
concise, scannable, and immediately useful to a developer evaluating the package.

## Philosophy

A great pub.dev README answers three questions fast:

1. **What is this?** — one sentence, no fluff.
2. **Why should I care?** — core features, briefly.
3. **How do I use it?** — install, import, run.

Everything else is secondary. Resist the urge to be exhaustive — link to detailed
docs or API reference instead of duplicating them in the README.

## Step-by-step process

### 1. Analyze the package

Read these files (in parallel when possible) to understand the package:

- `pubspec.yaml` — name, version, description, dependencies, SDK constraints
- `lib/<package_name>.dart` — public API barrel file; this tells you what's exported
- `lib/src/**` — implementation files referenced by the barrel; scan for public
  classes, functions, typedefs, and their doc comments
- `example/` — look for example apps or test files that demonstrate usage
- `test/` — test names often reveal intended use cases and edge cases
- `CHANGELOG.md` — recent changes can hint at actively developed features
- `LICENSE` — determine license type

Focus on the **public API surface**: exported symbols, their constructors, and
key parameters. Internal implementation details don't belong in the README.

### 2. Determine badge set

Include only badges that are verifiable and useful. Typical set for pub.dev:

```markdown
[![pub package](https://img.shields.io/pub/v/{package_name}.svg)](https://pub.dev/packages/{package_name})
[![License: {LICENSE_TYPE}](https://img.shields.io/badge/License-{LICENSE_TYPE}-blue.svg)](LICENSE)
```

Only add CI/coverage badges if you find evidence of CI configuration (e.g.,
`.github/workflows/`, `.travis.yml`, `codecov.yml`). Don't add badges for
services that aren't set up.

### 3. Write the README

Use the structure below. Every section is short and to the point.

```markdown
# {Package Name}

{badges}

{One-paragraph description — what the package does and who it's for.
Two to three sentences max. No marketing speak.}

## Core Features

- **Feature name** — one-line explanation
- **Feature name** — one-line explanation
- ...

Keep to 4–6 bullet points. Each feature should be something a developer
would search for or compare against alternatives.

## Getting Started

### Installation

```yaml
dependencies:
  {package_name}: ^{version}
```

### Basic Usage

```dart
// A minimal, runnable example that shows the primary use case.
// This should be copy-pasteable and work with minimal setup.
```

## Examples

Show 2–3 focused examples covering the most common scenarios.
Each example should have:
- A short heading describing the scenario
- A brief sentence of context if needed
- A code block

Pull examples from the `example/` directory or `test/` files when possible —
real, tested code is better than invented snippets.

## Configuration

Only include this section if the package has meaningful configuration options.
Use a table or short code block — don't enumerate every parameter.

## Additional Information

- [API Reference](https://pub.dev/documentation/{package_name}/latest/)
- [Changelog](CHANGELOG.md)
- [Contributing](CONTRIBUTING.md) ← only if file exists
- [License]({license_type}) — link to LICENSE file

## License

{One-line license statement, e.g., "This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details."}
```

### 4. Quality checklist

Before finalizing, verify:

- [ ] **Conciseness** — no section is longer than it needs to be. If you can
      cut a sentence without losing information, cut it.
- [ ] **Code examples compile** — every Dart snippet uses real class/function
      names from the package. Don't invent API that doesn't exist.
- [ ] **No placeholder text** — nothing like "TODO", "describe here",
      "your description". Every line is final.
- [ ] **Version is current** — the version in the install snippet matches
      `pubspec.yaml`.
- [ ] **Links work** — all relative links point to files that exist in the repo.
- [ ] **pub.dev conventions** — the first paragraph works as the package
      description on pub.dev (it shows up in search results).
- [ ] **English only** — clear, professional English. No slang, no emojis.

## What NOT to include

- **Full API documentation** — that's what `dart doc` is for.
- **Implementation details** — internal architecture, private classes.
- **Long changelogs** — link to CHANGELOG.md instead.
- **Badges for non-existent services** — no phantom CI badges.
- **"Table of Contents"** — only add if README exceeds ~150 lines.
- **Redundant sections** — if there's nothing to configure, skip Configuration.

## Tone and style

- Write in second person ("you") when addressing the developer.
- Use active voice.
- Prefer short sentences.
- Use fenced code blocks with `dart` or `yaml` language tags.
- Use `**bold**` for feature names in lists, backticks for code references.
- One blank line between sections, no trailing whitespace.
