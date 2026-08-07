---
name: doc-generation
description: Use when the user wants supporting documents generated from an approved PRD — e.g. "turn my PRD into a backlog", "generate an API contract sketch from this PRD", "write an onboarding doc from this PRD", "generate docs from this PRD". Requires an existing PRD to work from.
---

# Doc Generation

## Overview

Turn an approved PRD into concrete supporting documents: a backlog, an API
contract sketch, and/or an onboarding doc. Each is a distinct, focused
document derived from the same source PRD — not a restatement of the PRD
itself.

**Announce at start:** "I'm using the doc-generation skill to generate docs from your PRD."

## Process Flow

1. **Locate the source PRD.** Look in `docs/prd/` in the user's project. If
   there's exactly one, confirm it's the right one. If there are several, ask
   which. If there's none, tell the user this skill needs an existing PRD
   (e.g. from `prd-builder`) and stop — don't improvise one.
2. **Ask which doc(s) to generate.** Offer the three types as a multi-select-
   style question: backlog, API contract sketch, onboarding doc. Default to
   generating all three only if the user says "everything" or equivalent.
3. **Generate each requested doc** using the matching template in
   `references/doc-templates.md`. Pull directly from the PRD's user stories,
   entities, and MVP scope — don't invent scope the PRD doesn't support.
4. **Write each doc** to its own path in the user's project (see
   `references/doc-templates.md` for exact paths), and add a one-line
   backlink to the source PRD at the top of each.
5. **Self-review.** Check every backlog item traces to a PRD user story,
   every API contract sketch entity matches the PRD's data/architecture
   section, and the onboarding doc doesn't contradict the PRD's MVP scope.
6. **User review gate.** Point the user to the generated file(s), ask them to
   review before treating them as final. Wait for their response.

## Output Documents

See `references/doc-templates.md` for the three document templates
(backlog, API contract sketch, onboarding doc) and their output paths.
