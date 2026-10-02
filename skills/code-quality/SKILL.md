---
name: code-quality
description: Use when the user wants the quality of a codebase or a change measured — e.g. "assess code quality", "how maintainable is this", "is this PR up to our quality bar", "give me a quality scorecard", "is the AI-generated code any good". Produces normalized, reproducible numbers graded against named public benchmarks, not an impression.
---

# Code Quality

## Overview

Measure the quality of a codebase, a module, or a single change, and report
it as a scorecard where every number is normalized, reproducible, and graded
against a named public benchmark.

A quality review that ends in adjectives ("fairly clean", "some duplication")
cannot be compared to last month, to another repository, or to a claim that
the code got better. Three rules turn it into something that can. **Every
count gets a denominator**, because forty smells means nothing until you know
whether it is per thousand lines or per million. **Every metric uses the name
and formula the industry already uses**, so the team's own analysis tooling
reproduces the same number. **Every threshold traces to a public source**; a
number without one is a guess, not a target.

Metrics are grouped into families, and they are not equal. The three headline
families decide whether the code passes; the supporting families explain why.

| # | Family | Role | How it is judged |
|---|---|---|---|
| 1 | Correctness & reliability | headline | every test and the build pass; reliability rating A where rated |
| 2 | Security | headline | zero new critical or high findings |
| 3 | Duplication & maintainability | headline | new-code targets met, and no regression against the baseline |
| 4 | Complexity & structure | supporting | per-function ceiling |
| 5 | Coupling & cohesion | supporting | trend only, never a hard cutoff |
| 6 | Testing effectiveness | supporting | coverage is never reported alone |
| 7 | Documentation & type safety | supporting | explains the headline numbers |
| 8 | Dependency health | supporting | explains the headline numbers |

Formulas, tools per stack, and normalization rules for every metric are in
`references/metric-model.md`. Threshold bands and the sources behind them are
in `references/benchmarks.md`. Read both before measuring anything.

**Announce at start:** "I'm using the code-quality skill to measure this code against named quality benchmarks."

## Process Flow

1. **Scope the assessment.** Ask what to measure (a whole repository, a
   module, a change, or a commit range) and what the result is for: a merge
   gate, a first baseline, a comparison between two sets of code, or a figure
   someone intends to quote outside the team. The purpose sets the rigor. A
   number that will be quoted externally must be reproducible by a stranger;
   a first baseline mostly needs to be repeatable next month. A comparison
   between repositories is only valid for metrics computed with the same
   tool, version, and rule configuration on both sides. Smell density and
   debt ratio in particular move with the rule set, so name any metric that
   is not comparable.
2. **Clarifying questions.** Ask one at a time. Which languages and
   frameworks are in scope? What quality tooling already runs, and where
   (a static analysis server, linters, a coverage report in CI)? Which logic
   is business-critical, since that is where expensive checks are worth
   running? Does the issue tracker link bugs back to the change that caused
   them? Is authorship known, i.e. which changes were AI-generated and which
   were written by hand, and where is it recorded (commit trailers such as
   `Co-authored-by`, a pull request label, assistant telemetry)? Without a
   recorded source, treat authorship as unknown; never infer it from how the
   code looks.
3. **Find the tooling that already exists before adding any.** Read the lint
   configuration, the CI workflows, the coverage configuration, and any
   analysis-server project file. A number produced by the project's own
   configured tool is one the team can reproduce tomorrow; the same metric
   computed by a tool you brought, with default settings, is a different
   number wearing the same name. Where a metric has no tool in the project,
   name the one to use from `references/metric-model.md`, then **ask before
   installing anything, adding configuration, or changing CI** — each has
   lock-file and pipeline consequences and is the team's decision, not a
   side effect of an assessment.
4. **Measure in stages, and never estimate what a tool should produce.**
   Each metric in the reference carries a stage. Stage 1 metrics need one
   off-the-shelf tool and are always attempted. Stage 2 metrics need a
   scoping decision first (a defect-attribution window, a coverage scope, a
   documentation floor); ask for it or skip the metric. Stage 3 metrics need
   custom scripting or are expensive to run; do them only when asked or when
   an earlier baseline exists to compare against. If a tool cannot run here,
   say so. Either run it on a stated sample and label the result as sampled,
   or leave the cell empty. A plausible number nobody can reproduce is worse
   than a gap.
5. **Normalize every count and state the denominator.** Per thousand lines,
   per function, per merged change, per thousand changed lines, or a
   percentage, as the reference specifies for that metric. The only raw
   counts allowed are dependency vulnerabilities and license risks, and those
   are always split by severity band.
6. **Score new code first.** When the scope is a change or a commit range,
   the headline numbers are computed on the changed code, with whole-repository
   numbers alongside as context. Old debt should not fail a clean change, and
   a tidy repository should not hide a messy one.
7. **Apply the headline gate before anything else.** Only the gate metrics
   listed under Headline gate in `references/benchmarks.md` decide a family;
   the rest of the family is reported but does not vote. A family fails when
   any gate metric misses its gate value on new code, or has regressed
   against the baseline.
   - For a change or commit range, the baseline is the base commit, measured
     in this same run with the same tools and configuration.
   - For a whole repository, the baseline is the previous assessment doc,
     and only if its reproduction section shows the same tools, versions,
     and configuration. Otherwise, skip the regression check and say why.
   - On a first run there is no baseline: apply the gate values only, and
     record this run as the baseline.
   - A comparison between two codebases has no gate. Grade both against the
     bands, side by side.

   For each headline family state pass, fail, or cannot be determined, with
   the number that decided it. A family none of whose gate metrics could be
   measured is "cannot be determined", never "pass". A failure in any
   headline family fails the gate no matter what improved elsewhere. Give
   this verdict before a single supporting number, so it cannot be buried.
8. **Grade against named bands, not invented ones.** For each graded metric,
   report where it lands against the floor, target, and stretch bands in
   `references/benchmarks.md`, and cite the source of the band. Floor is the
   minimum credible result; target is the day-to-day gate; stretch is what it
   takes to claim the code beats the current industry baseline rather than
   matching it. Where the reference gives no band for a metric, report the
   value without a grade rather than making one up.
9. **Report trends where a snapshot would mislead.** The object-oriented design suite
   and coupling instability predict defects but have no safe universal
   cutoff. Report their direction per module against the previous
   baseline. If this is the first run, record the values as the baseline and
   say that no verdict is possible yet. Show the headline metrics as a
   four-week trend as well, so that one good week cannot stand in for
   sustained quality. Take the earlier values from previous assessments in
   `docs/code-quality/`, or, if the user accepts the cost, measure the
   commit at each of the last four weekly boundaries with the same tools. If
   neither is possible, say that the headline numbers are a single snapshot.
10. **Pair the numbers that lie when read alone.** Coverage is never shown
    without mutation score, or without a line saying mutation testing was not
    run and coverage alone says little about test strength. Duplication and
    error-masking counts are shown next to coverage, because the cheap way to
    lower them (deleting tests, catching exceptions more broadly) shows up
    there. Whenever deploy and incident data exist, show change failure rate
    in the headline scorecard against its band, as the stability guardrail;
    it does not decide a family's gate. When the assessment backs a claim
    that the team got faster, it is required: if the data is missing, say
    that the claim has no stability guardrail. When authorship is known,
    show the AI-authored share of the code in scope beside the headline
    block, and split the headline numbers by authorship if they can be
    computed that way. The thresholds are identical for both; generated code
    never gets a lighter gate.
11. **Rank the findings behind the numbers.** For every failing or
    near-failing metric, name the files and functions driving it, with the
    measured value for each, ranked by which headline gate they block. For
    each, give the smallest change that would move the number honestly. A
    flaky test in changed code is always a finding, ranked under the
    correctness gate, because it may be an intermittent real bug.
    Never recommend a change that games a metric: splitting a function
    mechanically to lower its complexity score, excluding files from
    analysis, wrapping failures in broader error handling, or deleting the
    tests that covered duplicated code.
12. **Write the doc** to
    `docs/code-quality/YYYY-MM-DD-<scope-slug>-code-quality-assessment.md`
    in the user's project (create `docs/code-quality/` if it doesn't exist).
    Include the reproduction section: every tool, its version, the
    configuration it ran with, the command, the analysis-server project if
    one was used, and the commit range measured. Any figure quoted outside
    the team should link back to this doc. For each metric that was not
    measured, name where it would run in CI: the lint stage (smells,
    complexity, duplication), the security stage (static analysis,
    dependency audit), the test stage (pass rate, coverage), or a scheduled
    job (mutation testing). Where the repository spans several stacks,
    recommend one analysis project covering all of them, so the ratings come
    from one quality gate rather than several disconnected reports.
13. **Self-review.** Check that every number traces to tool output from this
    run, or is labeled as sampled or not measured; that every count has its
    denominator; that coverage never appears without its pairing note; that
    every grade cites its band's source; that every security count went through the severity mapping; that the
    verdict names any gate metric that could not be measured; and that the
    gate verdict is stated before the supporting detail.
14. **User review gate.** Point the user to the file and ask them to review
    before treating it as final. This skill measures and reports; it does not
    refactor code, install tools, or change CI unless the user asks for that
    separately.

## Output Template

```markdown
# <Scope> — Code Quality Assessment

> Generated by the code-quality skill on <date>. Review and edit before treating this as final.

## 1. Scope Assessed (what, why, commit range, stacks)
## 2. Quality Gate Verdict (per headline family)
## 3. Headline Scorecard

| Family | Metric | Value | Denominator | Floor / Target / Stretch | Band reached | Band source | 4-week trend |
|---|---|---|---|---|---|---|---|

## 4. Supporting Metrics
## 5. Trend-Only Metrics (direction since baseline)
## 6. Paired Context (coverage and mutation, authorship share)
## 7. Findings Driving the Numbers (ranked)
## 8. How to Reproduce These Numbers
## 9. Not Measured / Low Confidence (and where each would run in CI)
```
