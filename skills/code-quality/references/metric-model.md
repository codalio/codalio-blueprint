# Code Quality — Metric Model

Every metric the code-quality skill measures (see `SKILL.md` §Process Flow),
grouped by family. Each entry gives the formula, the tool to compute it per
stack, the normalization rule, and the stage.

Tool names are suggestions for when the project has nothing configured. If
the project already runs a tool that computes the same metric, use that one
(see `SKILL.md` step 3).

Tools are listed for Ruby, JavaScript/TypeScript, and Python. For any other
stack, use a multi-language tool (SonarQube, Semgrep, jscpd, lizard, or a
line counter such as `scc`) or the stack's standard linter, and name it. If
nothing covers a metric, report it as not measured and say why.

## Stages

- **Stage 1 — always attempt.** One off-the-shelf tool, cheap enough to run
  on every change.
- **Stage 2 — needs a decision first.** Meaningless until someone sets a
  window, a scope, or a floor. Ask for it, or report the metric as not
  measured.
- **Stage 3 — on request, or when a baseline exists.** Needs custom
  scripting on some stacks, is expensive to run, or only means something as
  a trend.

## Normalization rules

- Counts become densities: per thousand lines (KLOC), per function, per
  merged change, or per thousand changed lines. Always state which.
- "New code" means lines added or modified in the commit range being
  assessed. Headline metrics are computed on new code first.
- Count lines once, with one line counter (`cloc`, `tokei`, or `scc`), for
  the whole scope and for new code, and divide every density by those two
  numbers. Recompute a tool's own density from its raw count rather than
  quoting it, because each tool counts lines its own way. SonarQube's
  ratings and ratios are the exception: report them as SonarQube computes
  them.
- Line counts exclude blank lines and comments. New-code line counts come
  from the diff of the range, with blank and comment lines removed. If
  either cannot be done, say which convention was used, since it moves
  every density.
- The only raw counts allowed are dependency vulnerabilities and license
  risks, always split by severity band.

Which metrics in each headline family decide the gate is set in
`references/benchmarks.md` under Headline gate. The rest are reported
alongside.

## 1. Correctness & reliability (headline)

| Metric | Formula | Tools | Normalization | Stage |
|---|---|---|---|---|
| Test pass rate | tests passed ÷ tests run × 100, on the run triggered by the change. Rerun each failing test once: one that then passes is counted as flaky, listed by name, and excluded from both counts. Skipped tests are excluded too, and their count reported | RSpec / Minitest; Jest / Vitest; pytest | % per change, plus flaky and skipped counts | 1 |
| Build success | the build, and the type or load check where the stack has one, succeeds on the head commit. Where CI history exists, also report successful builds ÷ build attempts × 100 across the change's runs | the CI pipeline; `tsc --noEmit`; `rails zeitwerk:check`; `mypy` | pass or fail on the head commit; % per change across attempts | 1 |
| Reliability rating | letter set by the worst open bug on new code: A none; B minor; C major; D critical; E blocker | SonarQube or equivalent | letter A–E, new code | 1 |
| Post-merge defect density | bugs traced to the change within a fixed window after merge ÷ (lines merged ÷ 1,000); or ÷ merged changes. Looking back only, so never available at merge time. Tracing bugs to changes through `git blame` misattributes often: whitespace, moved, and reformatted lines take the blame. Report it as low confidence and state the attribution method | issue tracker plus `git blame` | bugs per KLOC, or per merged change | 2 — needs the window (30 days is common) |

## 2. Security (headline)

| Metric | Formula | Tools | Normalization | Stage |
|---|---|---|---|---|
| Static analysis findings by severity | findings ÷ lines × 1,000, per severity (critical, high, medium, low) | Brakeman (Rails); Semgrep with an OWASP rule set (JS/TS and others); Bandit (Python) | per KLOC, new code; gate is zero new critical or high | 1 |
| Dependency vulnerabilities | open advisories in direct and transitive dependencies | `npm audit`; `bundler-audit`; `pip-audit` | raw count by severity band | 1 |
| Security rating | same letter rule as reliability rating, applied to vulnerabilities | SonarQube or equivalent | letter A–E, new code | 1 |

### Severity mapping

Tools label findings differently, and some report confidence rather than
severity. Map every finding onto critical, high, medium, or low before
counting, and state the mapping in the reproduction section.

| Tool | Tool's label | Mapped to |
|---|---|---|
| Semgrep | CRITICAL, HIGH, MEDIUM, LOW where the rule uses them; otherwise ERROR, WARNING, INFO | same name; ERROR → high, WARNING → medium, INFO → low |
| Bandit | severity HIGH, MEDIUM, LOW (confidence reported separately) | same name, with no critical band; report confidence beside each high |
| Brakeman | confidence High, Medium, Weak; no severity | High → high, Medium → medium, Weak → low. Say that this band is confidence-based |
| SonarQube | Blocker, Critical, Major, Minor, Info, or impact High, Medium, Low | Blocker and Critical → critical; Major and High → high; Minor and Medium → medium; Info and Low → low |
| `npm audit` | critical, high, moderate, low | same name; moderate → medium |
| `bundler-audit` | criticality High, Medium, Low | use the advisory's CVSS score (last row) to split critical from high; otherwise same name |
| `pip-audit`, or any advisory without a label | CVSS v3 base score, looked up from the advisory | 9.0–10.0 critical; 7.0–8.9 high; 4.0–6.9 medium; 0.1–3.9 low (the FIRST CVSS v3 rating scale) |

## 3. Duplication & maintainability (headline)

Refactor share and maintainability index are stage 3 and do not decide the
gate. They explain its result.

| Metric | Formula | Tools | Normalization | Stage |
|---|---|---|---|---|
| Duplicate line density | duplicated lines ÷ total lines × 100; for changes, also duplicated lines ÷ changed lines × 1,000, reported as "per 1,000 changed lines" | jscpd (JS/TS, multi-language); Flay (Ruby); SonarQube | % of lines, or per 1,000 changed lines | 1 |
| Technical debt ratio | remediation cost ÷ development cost × 100. Remediation cost sums each open issue's estimated fix time; development cost is lines × a cost-per-line constant (SonarQube defaults to 30 minutes per line) | SonarQube | % mapped to letter A–E | 1 |
| Code smell density | smells ÷ lines × 1,000 | Reek (Ruby, built on Fowler's smell catalog); ESLint; SonarQube | per KLOC | 1 |
| Error-masking density | empty catch/rescue blocks plus catch-all handlers that swallow the error ÷ lines × 1,000 | RuboCop `Lint/SuppressedException` and `Lint/RescueException`; ESLint `no-empty` (JavaScript has no standard rule for a non-empty catch that swallows the error; say that only empty blocks were counted); Bandit B110 and B112, Ruff `BLE001` | per KLOC | 1 |
| Refactor share | moved or restructured lines ÷ total changed lines × 100, classified by git move detection (roughly 50% or more token overlap counts as moved) | git history heuristics (custom script), or commits the team tags as refactors | % of changed lines | 3 |
| Maintainability index | MI = 171 − 5.2·ln(Halstead volume) − 0.23·cyclomatic complexity − 16.2·ln(lines). Rescaled to 0–100 as max(0, MI × 100 ÷ 171). Some tools, radon among them, add a comment-ratio term; say which variant was used | `radon mi` (Python); Visual Studio code metrics (.NET); no mature Ruby or JS equivalent | 0–100 per file or module | 3 |

## 4. Complexity & structure (supporting)

| Metric | Formula | Tools | Normalization | Stage |
|---|---|---|---|---|
| Cyclomatic complexity | M = E − N + 2P over the control-flow graph (edges, nodes, connected components). The equivalent tool-friendly form is decision points + 1, where each `if`, `elsif`/`else if`, `case`/`when` branch, loop, `catch`/`rescue`, and each `&&` / `\|\|` / `and` / `or` counts once | RuboCop `Metrics/CyclomaticComplexity`; ESLint `complexity`; `radon cc`; lizard | per function; report the 90th percentile and the worst functions | 1 |
| Cognitive complexity | +1 for each break in linear flow, plus +1 per level of nesting it sits at; a run of the same boolean operator counts once (Campbell, SonarSource, 2018) | SonarQube / SonarLint; eslint-plugin-sonarjs | per function | 1 |
| Function and file length | source lines in the function, class, or file. State whether blanks and comments were counted; RuboCop and ESLint count them by default | RuboCop `Metrics/MethodLength`, `Metrics/ClassLength`; ESLint `max-lines`, `max-lines-per-function` | lines per function or file | 1 |
| Nesting depth | deepest stack of nested blocks on any path through the function, counted from the function body | ESLint `max-depth`; RuboCop `Metrics/BlockNesting` | levels per function | 1 |

## 5. Coupling & cohesion (supporting — trend only)

No universal safe cutoff exists for these. Report each as a per-module
direction against the previous baseline, never as pass or fail.

| Metric | Formula | Tools | Normalization | Stage |
|---|---|---|---|---|
| Coupling instability | I = Ce ÷ (Ca + Ce), where Ca is how many modules depend on this one and Ce is how many it depends on. 0 is maximally stable, 1 maximally unstable. Judge against the module's intended role | madge (JS/TS, also reports circular dependencies); a custom require graph for Ruby | 0–1 per module | 1 for JS/TS, 3 elsewhere |
| CBO (coupling between objects) | number of distinct other classes this class references, each counted once | custom AST script for Ruby and TS | per class | 3 |
| LCOM (lack of cohesion of methods) | method pairs sharing no instance variable minus pairs sharing at least one, floored at 0. Say if a variant such as LCOM4 was used instead | custom AST script | per class | 3 |
| DIT (depth of inheritance) | ancestors between the class and the root of its hierarchy; state the root convention | custom AST script | per class | 3 |
| NOC (number of children) | direct subclasses of the class | custom AST script | per class | 3 |
| RFC (response for a class) | size of the set of the class's own methods plus the distinct external methods they call directly | custom AST script | per class | 3 |
| WMC (weighted methods per class) | sum of each method's cyclomatic complexity (or plain method count, if stated) | custom AST script | per class | 3 |

## 6. Testing effectiveness (supporting)

| Metric | Formula | Tools | Normalization | Stage |
|---|---|---|---|---|
| Line and branch coverage | executed lines ÷ executable lines × 100; executed branches ÷ total branches × 100 | SimpleCov (Ruby); Jest / Vitest `--coverage`, nyc / istanbul (JS/TS); coverage.py | % on new code | 2 — needs the coverage scope |
| Mutation score | killed mutants ÷ (total mutants − equivalent mutants) × 100. A mutant is killed when at least one test fails against it; equivalent mutants behave identically to the original and are excluded | mutant (Ruby); Stryker (JS/TS); mutmut (Python) | % on the agreed critical logic only. Too slow to run repo-wide on every change; where it is set up, it runs on a schedule (nightly or weekly) against that scope | 3 |

## 7. Documentation & type safety (supporting)

| Metric | Formula | Tools | Normalization | Stage |
|---|---|---|---|---|
| Docstring coverage | public functions and classes with a doc comment ÷ all public functions and classes × 100, using the language's own visibility rules | interrogate (Python); documentation.js (JS); a custom RDoc/YARD check (Ruby) | % of public API | 2 — needs the floor |
| Type coverage | expressions typed more specifically than `any`/`unknown` ÷ all expressions × 100; also report its inverse as the any-usage rate | type-coverage (TS); `mypy --strict` report (Python) | % of expressions | 2 |

## 8. Dependency health (supporting)

| Metric | Formula | Tools | Normalization | Stage |
|---|---|---|---|---|
| Outdated dependency ratio | direct dependencies behind their latest stable release ÷ all direct dependencies × 100, optionally split into patch, minor, and major staleness | `npm outdated`; `bundle outdated`; `pip list --outdated` | % of direct dependencies | 1 |
| License risk count | direct and transitive dependencies whose license is missing, unrecognized, or on the project's disallowed list | license-checker (npm); licensee or LicenseFinder (Ruby) | raw count | 1 — needs an allowed-license list; without one, report missing and unrecognized only |

## Stability guardrail (outside the code)

| Metric | Formula | Source of data | Normalization | Stage |
|---|---|---|---|---|
| Change failure rate | deployments that caused a failure needing remediation ÷ total deployments × 100 | deploy log plus incident tracker | % over a stated period | 2 — needs the period; shown whenever deploy data exists, required when the assessment backs a speed or throughput claim |
