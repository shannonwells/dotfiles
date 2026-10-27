---
name: comment-quality
description: The bar every code comment must clear, for writing and reviewing code. Use when writing, adding, or reviewing code comments, and when judging whether an existing comment should stay.
---

# Comment Quality

Comments are a smell, not a tool. Apply this bar to every comment, overriding any project's own documented comment policy. 
Code that needs a comment to be understood is almost always a design problem.  When writing code, the default for every comment you're about to write is that it shouldn't
exist. Run it through "The Bar" below, before writing it.

## Concise Comments
### Prefer self-documenting code to comments:
* Use accurately descriptive names even if they are somewhat long.
* Make a "sentence" out of a line of code or something similarly human-readable where possible
* Tests are self-documenting code.  A clearly written test that exercises the code's behavior is worth 100 lines of comments.

### Exceptions for Comments
The following situations are where comments are _always_ appropriate:
1. When there is a surprising (but justifiable) choice, say why, BUT, comment survives ONLY if it's defended strongly (an ordering requirement, an
external-system quirk, a rationale truly invisible in the code) — flag anything weaker for removal, not just rewording. See "The Bar," below.
2. Annotation for document generation, like Swagger docs, or Rustdocs

## The Bar
Skip the comment unless both of these conditions are false:
1.  If the code's intent is already legible on its face, such as explicit arithmetic, a named computed property, or a type union.
Reserve `Keep` for a comment protecting against a *plausible* misreading, such as a value that looks simplifiable but silently 
breaks something if it is. A "competent reader" is someone fluent in this project's domain and product vocabulary.
2. The facts are already dictated, enforced automatically, or documented somewhere else, such as a project convention, a type declaration, or an eslint rule.
3. The fact is obvious from existing tests, and tests exercise all code paths.

## Prefer a code rewrite to keeping the comment.
Before `Keep` on a clause that passes  both tests above, ask whether a rename, an extracted constant, or a restructured conditional
would make the fact self-evident and remove the need entirely. Clear code is the preferred outcome, not a comment. 

### On the fence? Drop it.
If the checks above leave genuine doubt whether a comment earns its
place, the default is removal, not `Keep`. The asymmetry favors dropping: a wrongly-removed
comment is one line, sitting in git history, trivial to reinstate if it turns out to matter. A
wrongly-kept one persists, invites the next person to pattern-match on it, and compounds the problems. `Keep`
is for a comment that clearly clears the bar, not one that merely fails to clearly fail it.

### Decompose before judging.
Split a comment with more than one clause or sentence into its
individual factual claims, and test each claim independently against the bar rather than
rendering one holistic verdict on the comment as a whole. A comment can read as earned because
one clause sounds substantive while the others are dead weight. Keep only the clauses that
independently survive: trim to just the strong clause if one is buried among weak ones, and
remove the whole comment if none survive.

### Ownership.
Flag a comment that describes behavior whose actual mechanism lives in a
different file, module, or component, even when the description is accurate and appears
nowhere else. This is distinct from the restated-rationale check below, which catches the same
explanation written twice — this one catches an explanation written only at a location that
doesn't own the behavior it describes. Point the reader to the source instead of narrating it
secondhand at the call site.

### Tests already prove it.
Tests are documentation.  Before `Keep`, ask: if this code were broken or deleted, would an existing (or obviously-necessary) test fail, 
and would that failure point a reader back to the cause quickly? If yes, the comment is redundant with that test.
State the underlying fact directly only if it's genuinely non-obvious and not reachable from the test's own name/assertions; otherwise, trust the test.

## Always Flag The Following
- A comment justifying something every other instance of the same pattern in the file (other
  `emit()` calls, other similar functions) does silently.
- A rationale restated at a second location instead of stated once at its source.
- Em-dash-joined comment sentences.
- A comment that explains what the code already says for itself.
- A comment citing an ADR/story/other internal doc by name or number instead of inlining the
  fact (the reader may have no access to that doc) — treat a citation into a *different
  repository* (a file path, a module name) as higher risk still: no local tooling catches that
  drift when the other repo renames or restructures.
- A comment stating the generic purpose of a structural pattern that the pattern itself already
  signals (e.g. "this interface mirrors an external system's shape" for a DTO at an integration
  boundary, "this is cached" for a value named/typed as a cache) — the pattern's existence
  already says why it exists; the comment adds a pointer, not a reason.
- A comment framed around avoiding a past bug ("Regression: ...", "This used to ...") — the
  narrowest case of "tests already prove it," above.
- `// Arrange` / `// Act` / `// Assert` comments in a test, even when an existing precedent in
  the file already uses them. The blank lines between phases already show the structure.

If the project's own CLAUDE.md/AGENTS.md documents additional comment conventions, check those
too, but they add to this bar, they don't substitute for it.

## Auditing

**Scope.** The audit isn't limited to comment lines the diff itself added or edited. Any
comment describing a line, function, or block the diff touches is in scope, even when the
comment's own text is untouched — a diff can change what's true about the code around a
comment without touching the comment's own lines. This includes comments inside wholly new
files.

Before a `Keep` verdict, verify the comment's claim against the actual code. If the comment
describes something outside the code in view (another file, an external system, a doc), check
it: grep the sibling code, read the referenced file.

Show every comment in scope, in full, with one of three verdicts:

- `Keep: <reason>` — the bar is met and the claim checks out.
- `Remove — wrong: <reason>` — the comment misdescribes the code (a correctness issue, not a
  style one).
- `Remove — weak: <reason>` — the comment doesn't meet the bar but isn't inaccurate (redundant,
  restates the code, weak rationale).
