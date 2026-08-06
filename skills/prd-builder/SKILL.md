---
name: prd-builder
description: Use when the user wants to turn a product idea into a written PRD — e.g. "build/write a PRD", "product requirements doc", "help me plan my MVP", "spec out this product idea", "turn this idea into a plan/doc". Runs a product/scope lens, an architecture-lite lens, and a GTM-lite lens, then synthesizes one PRD document.
---

# PRD Builder

## Overview

Turn a rough product idea into a written PRD by running three focused analytical
lenses over the same idea — product/scope, architecture-lite, and GTM-lite — then
synthesizing their findings into one document. Each lens is a distinct pass with
its own questions; none of them is a substitute for the others, and none is
optional.

**Announce at start:** "I'm using the prd-builder skill to build your PRD."

## Process Flow

1. **Gather the idea.** If the user hasn't already described what they're
   building, ask them in one open question. Don't proceed on a one-line idea —
   move to clarifying questions next.
2. **Clarifying questions.** Ask one question at a time, prefer multiple choice
   when there's a natural short list of options. Cover: who's the user, what
   problem, why now, any hard constraints (timeline, platform, must-integrate-with).
   Stop once you can write a real first sentence of an elevator pitch.
3. **Run the three lenses** (see below).
4. **Synthesize.** Merge the three lens outputs into the PRD template. Resolve
   overlaps (e.g. both product and GTM lenses may name a "target user" —
   reconcile into one consistent description). Do not just concatenate the
   three raw lens outputs.
5. **Write the doc** to `docs/prd/YYYY-MM-DD-<project-slug>-prd.md` in the
   user's project (create `docs/prd/` if it doesn't exist).
6. **Self-review.** Re-read once, fresh eyes: placeholder text, contradictions
   between sections, a user story with no corresponding MVP line. Fix inline.
7. **User review gate.** Tell the user where the file is, ask them to review
   before treating it as final. Wait for their response.

## Running the Three Lenses

Each lens is independent — none needs the others' output to run. How you *run*
them depends on what your environment offers, so check once, silently, before
starting:

**Do you have a tool that dispatches an isolated agent/sub-task — with its own
context window, that you hand a prompt to and that returns a result — regardless
of what it's called in your environment (a "Task" tool, a "subagent" tool, a
background/composer agent, or similar)?**

- **Yes → dispatch all three lenses as separate calls to that tool, issued
  together so they run concurrently.** Give each: the idea + clarifying-question
  answers, the lens prompt from `references/lens-prompts.md`, and an instruction
  to return only that lens's findings — nothing else, no cross-talk between lenses.
- **No → run all three lenses yourself, in this same conversation, one after
  another.** Don't skip a lens, don't ask the user to answer lens questions
  themselves. Fully work through lens 1 before starting lens 2. Reuse genuinely
  carried-forward facts (e.g. the target user named in the product lens feeds
  the GTM lens's "who buys first" question) — don't re-derive from scratch.
- **Either path produces the same three write-ups** before synthesis. If you
  can tell from the final doc which path was taken, synthesis didn't do its job.

This is a one-time environment check, not a per-lens decision.

## Lenses

See `references/lens-prompts.md` for exact prompt text and output shape:
Product & Scope, Architecture & Data (lite), GTM (lite).

## Output Template

See `references/lens-prompts.md` §Output Template.
