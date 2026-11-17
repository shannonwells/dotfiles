---
name: pr-description
description: Writes pull request titles and descriptions. Use when creating a PR, writing a PR, or when the user asks to summarize changes for a pull request.
---

When writing a PR title and description:

1. Invoke the `branching-model` skill and resolve the diff base by its rules — the nearest known ancestor among the repo's declared diff base and any release-pipeline branches, not a hardcoded `main`. State the result on one line before using it: `Diff base: <branch> (<source>)`, where the source is the repo's `CLAUDE.md`, the `workloop.integrationBranch` override, or the remote default. Run `git diff <diff-base>...HEAD` to see all changes on this branch.
2. Also resolve `PR title convention` from the same `## Branching` declaration. State it on one line: `PR title convention: <pattern> (<declared | detected | default>)`. Apply it to the title; fall back to a plain sentence with no prefix when nothing is declared or detected, per the `branching-model` skill's fallback.
3. Look for the repo's PR template, matching names case-insensitively: `pull_request_template.md` in `.github/`, the repo root, `docs/`, `.azuredevops/`, or `.vsts/`; any file in `.github/PULL_REQUEST_TEMPLATE/` or `.gitlab/merge_request_templates/`. If several exist, ask which to use. State the result on one line: `PR template: <path | none>`.
4. If a template exists, write the description in its structure: keep its headings and order, fill every section, keep its checklists and check only the items that are true, and write "N/A" in sections that don't apply. Drop the template's instructional comments. Otherwise, write a description following this format:

## What
One sentence explaining what this PR does.

## Why
Brief context on why this change is needed

## Changes
- Bullet points of specific changes made
- Group related changes together
- Mention any files deleted or renamed
