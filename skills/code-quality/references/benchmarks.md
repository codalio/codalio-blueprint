# Code Quality — Benchmarks and Bands

The bands the code-quality skill grades against (see `SKILL.md` step 8), and
the public source behind each. A metric with no band here is reported as a
value without a grade.

Three tiers per metric:

- **Floor** — the minimum credible result. Below it, the code should not ship
  or be cited as an example of quality.
- **Target** — the gate to enforce day to day.
- **Stretch** — what it takes to claim the code beats the current industry
  baseline, not just matches it.

## Headline gate

The metrics that decide each headline family (see `SKILL.md` step 7). Every
other metric in a headline family is still reported, but does not decide
the gate. That includes refactor share and maintainability index, which are
stage 3, and post-merge defect density, which can only be measured after
the fact.

| Family | Gate metric | Gate value on new code | Regression check | Needs |
|---|---|---|---|---|
| Correctness & reliability | Test pass rate | 100% of the non-flaky tests that ran. The verdict names every flaky test, and each flaky test in changed code goes on the findings list | — | the test runner |
| Correctness & reliability | Build success | build and type check succeed | — | CI or a local build |
| Correctness & reliability | Reliability rating | A | yes | SonarQube or equivalent |
| Security | Static analysis criticals and highs | 0, after the severity mapping in `references/metric-model.md` | — | one static analysis tool |
| Security | Dependency advisories introduced in scope | 0 critical or high | — | the stack's audit tool |
| Security | Security rating | A | yes | SonarQube or equivalent |
| Duplication & maintainability | Duplicate line density | < 3% | yes | jscpd, Flay, or SonarQube |
| Duplication & maintainability | Technical debt ratio | ≤ 5% (A) | yes | SonarQube |
| Duplication & maintainability | Error-masking density | no gate value | yes | the linter rules in `references/metric-model.md` |
| Duplication & maintainability | Code smell density | no gate value | yes | Reek, ESLint, or SonarQube |

A gate metric whose tool is not available here is left out of the gate
rather than counted as passing. The family is decided by the gate metrics
that were measured, and the verdict names the ones that were missing.

**Regression check.** Compare the value for the whole scope at the head of
the range against the same value at the baseline. Any increase in a density,
or any drop in a letter rating, at the precision the tool reports, is a
regression. Comparing the whole scope, rather than new code alone, catches
a change that copies existing code or silences existing errors.

## Bands

| Metric | Floor | Target | Stretch | Source |
|---|---|---|---|---|
| Cyclomatic complexity, 90th percentile per function | ≤ 20 (SEI moderate-risk ceiling) | ≤ 10 (McCabe's recommended maximum) | ≤ 7 | SEI risk bands; McCabe (1976) |
| Duplicate line density, new code | — (no published line-density floor exists) | < 3% (Sonar way default) | < 1% | SonarSource Sonar way |
| Duplicated block density, per 1,000 changed lines | ≤ 73 (at or below the AI-era baseline, see note 1) | — | — | GitClear (2026) |
| Coverage, new code | ≥ 70% | ≥ 80% (Sonar way default) | ≥ 90%, plus mutation score ≥ 80% on critical logic | SonarSource Sonar way; Just et al. (2014) on why coverage alone is not enough at the stretch tier |
| Technical debt ratio | ≤ 10% (band B) | ≤ 5% (band A) | ≤ 3% | SQALE, Letouzey (2012) |
| Static analysis criticals and highs, new code | 0 | 0 | 0, plus dependency advisories patched within the team's agreed window | SonarSource Sonar way; Pearce et al. (2022) |
| Refactor share | ≥ 3.8% (at or above the AI-era baseline) | ≥ 8% | ≥ 15% | GitClear (2026): industry refactor share has collapsed, so holding steady is already a differentiator |
| Change failure rate | ≤ 15% | ≤ 5% | 0–2% | floor: DORA (2023) medium cluster; target: DORA (2023) elite cluster; stretch: DORA (2025) best response bucket |

Reference scales used for grading without their own floor/target/stretch row:

| Scale | Bands | Source |
|---|---|---|
| Cyclomatic complexity per function | 1–10 simple; 11–20 moderate risk; 21–50 high risk; over 50 untestable. Anything over 20 goes on the findings list for a refactor review, not just a warning | SEI; McCabe (1976) |
| Technical debt ratio letters | A ≤ 5%; B 6–10%; C 11–20%; D 21–50%; E over 50% | SQALE, Letouzey (2012) |
| Maintainability index, rescaled 0–100 (the scale `references/metric-model.md` reports) | 20–100 good maintainability; 10–19 moderate; 0–9 low, refactor candidate | Microsoft Visual Studio code metrics documentation; radon uses the same cut-offs for its A/B/C ranks |

The 85/65 cut-offs from Oman & Hagemeister (1992) apply only to the raw,
unscaled index. Never grade a 0–100 score against them.
| Reliability and security ratings | A on new code | SonarSource Sonar way |

## Why each source is here

- **SonarSource "Sonar way" default quality gate.** Vendor defaults (new-code
  coverage at least 80%, duplicated lines on new code at most 3%, no new
  bugs or vulnerabilities, A ratings on new code) that most installations
  run unchanged. Using them means a team already running SonarQube reads the
  result without translation.
- **McCabe (1976) and the SEI risk bands.** The original complexity metric
  and the widely reused risk categorization built on it. McCabe's own
  suggested ceiling is 10.
- **SQALE, Letouzey (2012).** The technical debt ratio method and its letter
  bands, which SonarQube reports natively.
- **Oman & Hagemeister (1992).** The original maintainability index, and the
  85/65 cut-offs on its raw scale.
- **Microsoft Visual Studio code metrics.** The 0–100 rescale this skill
  reports, and the 20/10 cut-offs that go with it. A familiar scale to
  reviewers who have used Visual Studio.
- **GitClear (2026), AI-era code quality research.** Telemetry over hundreds
  of millions of changed lines. As AI authorship rises, it reports
  duplicated blocks at 73 per 1,000 changed lines (up 81% since 2023),
  copy/paste at 15.7% of changed lines, refactor share collapsing to 3.8%,
  14-day churn up 15%, and error-masking constructs up 47%. Treat it as the
  average AI-assisted team: matching it is not a differentiator, beating it
  is.
- **DORA (2023), Accelerate State of DevOps.** The change failure rate
  bands: 15% for the medium performance cluster and 5% for the elite
  cluster.
- **DORA (2025), State of AI-assisted Software Development.** Why change
  failure rate is the stability guardrail. AI adoption tends to raise
  throughput while hurting stability unless the supporting practices are in
  place, so any quality or speed claim is shown next to it. This edition
  replaced the performance clusters with team archetypes. It reports change
  failure rate as a distribution whose best bucket, 0–2%, holds about 8.5%
  of respondents; that bucket is the stretch band, not an "elite" tier.
- **Basili, Briand & Melo (1996).** Validated the object-oriented design
  suite (WMC, DIT, NOC, RFC, CBO; LCOM weakest) as predictors of
  fault-proneness, but found no universal safe cutoff. This is why those
  metrics are trend-only.
- **Inozemtseva & Holmes (2014); Just et al. (2014).** Coverage correlates
  only weakly with how well a suite finds faults; mutation score correlates
  much more strongly. This is why coverage is never reported alone.
- **Pearce et al. (2022), "Asleep at the Keyboard?".** Found that roughly 40%
  of assistant-generated completions in the studied scenarios contained a
  vulnerability from the CWE Top 25. This is why static security analysis is
  a headline, gate-blocking family for generated code.

## Notes

1. **Keep the duplication baseline in its own unit.** GitClear's 2026 report
   gives 73 duplicated *blocks* per 1,000 changed lines. Blocks are not
   lines, so that figure is not a floor for duplicate line density and must
   not be converted into a percentage. Grade block density against 73, and
   line density against the Sonar way threshold only. GitClear's detector
   and yours will differ, so name the tool used when grading against it.
2. **Re-verify the AI-era figures before quoting them.** The GitClear and
   DORA numbers move with each yearly report. Before any assessment is
   quoted outside the team, check the band sources against the current
   primary reports and note the edition used.
3. **Same bands for every author.** Nothing in this file changes based on
   whether code was written by a person or generated.

## Sources

- McCabe, T.J. (1976). "A Complexity Measure." *IEEE Transactions on Software Engineering.*
- Software Engineering Institute. Cyclomatic complexity risk-band categorization, as applied by McCabe IQ and derived tooling.
- Campbell, G.A. (2018). "Cognitive Complexity: A New Way of Measuring Understandability." SonarSource white paper.
- Fowler, M. (1999). *Refactoring: Improving the Design of Existing Code.*
- Chidamber, S.R. & Kemerer, C.F. (1994). "A Metrics Suite for Object Oriented Design." *IEEE Transactions on Software Engineering.*
- Basili, V.R., Briand, L.C. & Melo, W.L. (1996). "A Validation of Object-Oriented Design Metrics as Quality Indicators." *IEEE Transactions on Software Engineering.*
- Oman, P. & Hagemeister, J. (1992). "Metrics for Assessing a Software System's Maintainability." *IEEE Conference on Software Maintenance.*
- Letouzey, J.-L. (2012). "The SQALE Method for Evaluating Technical Debt." *MTD Workshop, ICSE.*
- DeMillo, R.A., Lipton, R.J. & Sayward, F.G. (1978). "Hints on Test Data Selection: Help for the Practicing Programmer."
- Inozemtseva, L. & Holmes, R. (2014). "Coverage Is Not Strongly Correlated with Test Suite Effectiveness." *ICSE.*
- Just, R. et al. (2014). "Are Mutants a Valid Substitute for Real Faults in Software Testing?" *FSE.*
- Pearce, H. et al. (2022). "Asleep at the Keyboard? Assessing the Security of GitHub Copilot's Code Contributions." *IEEE Symposium on Security and Privacy.*
- FIRST. "Common Vulnerability Scoring System v3.1: Specification Document" (qualitative severity rating scale). https://www.first.org/cvss/
- Martin, R.C. (2002). *Agile Software Development, Principles, Patterns, and Practices* (instability metric).
- GitClear. "The Maintainability Gap: 2026 AI code quality research." https://www.gitclear.com/the_ai_code_quality_maintainability_gap
- DORA. "Accelerate State of DevOps Report 2023." https://dora.dev/research/2023/dora-report/
- DORA. "State of AI-assisted Software Development 2025." https://dora.dev/dora-report-2025/
- Microsoft. "Code metrics — Maintainability index range and meaning." Visual Studio documentation. https://learn.microsoft.com/visualstudio/code-quality/code-metrics-maintainability-index-range-and-meaning
- SonarSource. "Sonar way" quality gate documentation. https://www.sonarsource.com
