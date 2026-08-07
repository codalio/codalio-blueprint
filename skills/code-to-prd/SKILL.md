---
name: code-to-prd
description: Use when the user wants a PRD reconstructed from an existing codebase rather than a new idea — e.g. "write a PRD from this codebase", "document what this app already does as a PRD", "reverse-engineer a PRD for this project", "we never wrote a PRD, can you make one from the code". The reverse direction of prd-builder — starts from code, not from a described idea.
---

# Code to PRD

## Overview

Reconstruct a PRD-style document from an existing codebase instead of a
described idea — for a project that shipped without one, or needs its
requirements documented after the fact. Everything in the output is inferred
from what the code actually does; anything that can't be inferred is flagged
as an assumption or open question, never guessed silently.

**Announce at start:** "I'm using the code-to-prd skill to reconstruct a PRD from your codebase."

## Process Flow

1. **Explore the codebase.** Read enough to ground every section below in
   real code: entry points, routes/API surface, data model/schema, UI flows
   if present, README and any existing docs. Don't infer from naming alone —
   confirm behavior against the actual implementation.
2. **Infer the target user and problem.** From what the code lets a user do
   and how it's structured (auth model, roles, domain language in the code),
   infer who this is built for and what problem it solves. Mark this
   inferred, not confirmed — it belongs in step 6's assumptions unless the
   user confirms it.
3. **Infer user stories.** Derive 5-10 "As a [user], I want [capability] so
   that [benefit]" stories from what the code actually implements — each
   should map to a real feature/route/flow found in step 1, not a guess
   about what the product "should" do.
4. **Infer current scope.** What's actually built and working today reads as
   the current MVP scope. Note anything that looks unfinished, feature-
   flagged off, or stubbed — that's a signal, not necessarily "in scope."
5. **Architecture overview.** Core entities and their relationships as they
   actually exist in the code/schema — this section can be higher-confidence
   than the others since it's read directly from the implementation.
6. **Flag gaps explicitly.** Anything about intent, target user, or "why"
   that the code can't answer goes in Open Questions, not into a confident-
   sounding sentence. Never present an inference as a confirmed fact.
7. **Write the doc** to `docs/prd/YYYY-MM-DD-<project-slug>-prd.md` in the
   user's project, using the same output template as `prd-builder` (see
   `../prd-builder/references/lens-prompts.md` §Output Template) so
   reconstructed and freshly-written PRDs look the same — but prefix the
   summary with a note that this was reconstructed from code on `<date>`,
   not authored from a described idea.
8. **Self-review.** Check every user story traces to real code found in step
   1, and every inference not directly confirmed by code is either in Open
   Questions or clearly marked as an assumption.
9. **User review gate.** Point the user to the file, ask them to confirm or
   correct the inferences before treating it as final — this doc is a
   starting point for a conversation, not a finished spec. Wait for their
   response.

## Output Template

Reuses the `prd-builder` output template — see
`../prd-builder/references/lens-prompts.md` §Output Template — with the
summary section prefixed to note the doc was reconstructed from code, not
authored from a described idea.
