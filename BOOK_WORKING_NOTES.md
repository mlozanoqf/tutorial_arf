# Book working notes for tutorial_arf

Last updated: 2026-05-27

This is the continuity note for the `tutorial_arf` repository. The project should be treated as a Quarto book, not as a tutorial. The rendered book is created in `_book`; that folder is generated output.

## Current workflow

- Current branch: `main`.
- Current publishing flow: edit sources on `main`, render locally when useful, commit to `main`, push to `origin/main`, and let GitHub Actions render and publish `_book`.
- `_book` is a generated output directory, not a branch. It is ignored by git and uploaded by the GitHub Pages workflow after `quarto render`.
- Use targeted renders while editing content:
  - Logistic chapter: `quarto render 01-logistic.qmd`
  - Tree and XGBoost chapter: `quarto render 02-tree-based.qmd`
  - Merton chapter: `quarto render 02-merton.qmd`
  - Gaussian copula chapter: `quarto render 03-gaussian-copula.qmd`
- Use full `quarto render` only before a publishing check, before commit/push, or when the user explicitly asks for the complete book.
- The user inspects `_book/index.html` locally. Browser search and some behavior can differ under `file://`, but that is acceptable unless we need deeper browser QA.
- Do not use root `index.html` or `Logistic.html` for content QA. They were legacy render artifacts from the old root-level build and were removed from version control on 2026-05-27. The GitHub Pages workflow renders and uploads `_book`.
- Do not commit or push unless the user explicitly asks.

## Architecture

- The project is now a Quarto book-style project.
- `index.qmd` is the home/preface page and is unnumbered.
- Chapter 1 is `01-logistic.qmd`: Logistic credit scoring.
- Chapter 2 is `02-tree-based.qmd`: Tree-based credit scoring.
- Chapter 3 is `02-merton.qmd`: The Merton model.
- Chapter 4 is `03-gaussian-copula.qmd`: The Gaussian copula model.
- Credit VaR is now handled inside chapter 4 as the final bridge/application section. There is no separate chapter 5 in the book flow.
- Chapter 4 now includes a t-copula extension before the Credit VaR close, so the final application treats capital as sensitive to copula tail behavior.
- Chapter files include smaller section fragments so content can be edited and rendered in focused passes.
- Section numbering is enabled with hierarchical book numbering, so sections appear as 1.1, 1.2, etc., and figure numbers remain chapter-aware.
- `sidebar-chapter-sections.html` adds collapsible subsection links under each chapter in the left sidebar.
- The sidebar toggle was difficult to integrate cleanly; current behavior should remain stable unless the user explicitly reopens that UI issue.

## Home page and metadata

- The book should not call itself a tutorial.
- The home page uses `R/book-edition.R` to show a short content-based edition hash in monospace, for example `Book edition: a7ca4ee`.
- The visible publication number is `Publication: N`, computed from `git rev-list --count HEAD`.
- `.github/workflows/publish.yml` needs `actions/checkout` with `fetch-depth: 0` so publication count is stable in GitHub Actions.
- The metadata labels should include `First publication:` with a colon.
- The home page now includes an unnumbered `What's new in this edition` section. Keep it reader-facing and focused on substantive changes since the previous published version, not minor maintenance details.
- The home page should not repeat the book title inside `index.qmd`; Quarto already renders the visible title. `Preface` should appear directly below the generated title area.
- The `What's new in this edition` section should be a concise bullet list, not cards. The user prefers short reader-facing bullets over paragraph-length change descriptions.
- The user observed a time difference between local and GitHub Pages dates. Prefer the local index timestamp as the reference if this comes up again.

## User preferences

- Call it a book, except when referring to the repository name.
- Keep the style detailed, explicit, and pedagogical. The goal is to connect model logic, equations, code, and interpretation.
- Concepts should be technically correct but explained in accessible steps.
- Preserve useful material unless the user approves removal.
- Keep `sex` and `region` in the logistic material.
- Prefer source edits over generated-output edits.
- Use targeted renders during active editing to save time.
- Inputs and teaching assumptions can be written directly, but values produced by code/model estimation/simulation should be computed in chunks or inline R and formatted with helpers from `R/format-helpers.R`.
- The user prefers chapter 3 to have only two numbered section levels. Use `##` for numbered Merton sections and visual `.merton-subhead` blocks for internal labels; avoid `###` headings in Merton unless the user changes this preference.
- Avoid repeatedly explaining by first negating a weak interpretation and then clarifying the intended one. State the intended logic directly whenever possible.
- Avoid overusing colons in prose and section titles. Use complete sentences or cleaner headings unless a colon is genuinely useful.

## Chapter 1: Logistic credit scoring

Completed work:

- Reorganized the chapter so `Logistic credit scoring` is the chapter and its internal topics are subsections.
- Added clearer discussions of model evaluation, ROC/AUC, calibration, Brier score, and why accuracy can be misleading.
- Added bank strategy and net payoff material after the evaluation sections.
- Corrected confusion-matrix interpretation.
- Corrected the acceptance-rate logic by using quantiles of predicted default probabilities.
- Clarified sensitivity, specificity, false positive rate, AIC, prediction ranges, and cutoff interpretation.
- Added calibration comparison between the full model and the age-only model.

Keep in mind:

- The user wants explicit links between equations, model objects, and R code.
- The John Doe example is present in the tree/XGBoost chapter for comparison; in chapter 1 it was not developed for `logi_full` in the same way.

## Chapter 2: Tree-based credit scoring

Completed work:

- Added a new chapter for decision trees and XGBoost.
- Kept the chapter naturally connected to chapter 1 by using the same data, train/test split, and evaluation logic.
- Included model interpretation with variable importance, SHAP-style local contributions, partial dependence, ROC/AUC, calibration, bad-rate curves, and net payoff comparison.
- The stronger comparison with logistic regression is concentrated in a comparison section after XGBoost is explained.

Keep in mind:

- The user likes XGBoost as a modern, visually rich, credit-risk-relevant contrast with logistic regression.
- Avoid presenting XGBoost as a pure black box. Explain additive trees, margins/log-odds, probabilities, and local contributions.

## Chapter 4: Gaussian copula portfolio credit risk

Current state:

- On 2026-05-27, chapter 4 was substantially rebuilt from a general Gaussian-copula introduction into a portfolio credit-risk chapter.
- The chapter title is now `The Gaussian copula model for portfolio credit risk`.
- The chapter is anchored in Hull's discussion of default correlation in section 24.8 of the 11th edition. Verified local page anchors: default correlation starts on p. 577, the Gaussian copula transformation and Example 24.7 are on pp. 579-580, and Credit VaR / Example 24.8 are on pp. 580-581. The old reference to Example 24.6 as the copula example was corrected; Example 24.6 is CVA, while Example 24.7 is the ten-firm Gaussian copula example.
- The chapter's thesis says that individual PDs give marginal default risk, the copula adds dependence, and exposures plus recoveries convert dependent defaults into a portfolio loss distribution.
- New chapter flow:
  - 4.1 Default correlation and the portfolio problem.
  - 4.2 Hull Example 24.7 from cumulative PDs to thresholds.
  - 4.3 One firm and the marginal default rule.
  - 4.4 Two firms and joint defaults.
  - 4.5 Ten firms in the Hull portfolio default simulation.
  - 4.6 From correlated defaults to portfolio losses.
  - 4.7 Concentration risk with different exposure weights.
  - 4.8 Tail dependence with a t-copula.
  - 4.9 Credit VaR under copula model risk.
- New files added for the rebuilt chapter: `03-gaussian-example-247.qmd`, `03-gaussian-portfolio-losses.qmd`, `03-gaussian-concentration-risk.qmd`, `03-gaussian-t-copula.qmd`, and `03-gaussian-credit-var-bridge.qmd`.
- `03-gaussian-example-246.qmd` was replaced by `03-gaussian-example-247.qmd`.
- The old `04-cvar.qmd` chapter was removed from `_quarto.yml` and deleted after its useful content was absorbed into section 4.9. The book now goes from chapter 4 to references.
- `R/gaussian-common.R` now contains reusable copula simulation helpers for correlation matrices, Gaussian and t-copula latent credit variables, default matrices, default-count summaries, portfolio losses, and loss-risk summaries.
- `R/format-helpers.R` now includes `fmt_musd()` for formatting dollar millions.
- `sidebar-chapter-sections.html` was updated to match the new chapter 4 section anchors.
- A targeted render of `03-gaussian-copula.qmd` succeeded after adding sections 4.8 and 4.9. A full local `quarto render` also succeeded after the t-copula/Credit VaR model-risk addition.
- A later chapter 4 visual pass corrected the custom sidebar labels for sections 4.8 and 4.9, added a zoomed threshold figure, improved default-region shading, made two-firm scatter panels square, and strengthened point/ tail colors in the portfolio figures.

Keep in mind:

- The user explicitly wants this chapter to avoid abstract copula exposition. Every equation should be tied to code and to a credit-risk interpretation.
- Keep showing what changes numerically when dependence changes. Do not merely say that correlation affects risk.
- The distinction between copula correlation of latent variables and correlation of default indicators is important and now stated in section 4.1.
- The t-copula extension is now included because it has a clear financial payoff: same PD/EAD/LGD/correlation inputs can produce much larger tail capital under heavier joint tails.
- Figure numbering in chapter 4 changed after adding the zoom figure. When discussing the visuals, refer to captions or source chunk labels rather than old figure numbers.

## Chapter 3: Merton model

Current focus:

- The user is reviewing the Merton chapter in small parts.
- Point (1), risk-neutral valuation and risk-neutral default probability, has been revised but may still need another reader-level pass.
- The chapter now introduces risk-neutral valuation before the numerical Merton estimation.
- The risk-neutral section uses a simple one-period example with:
  - `V0 = 100`
  - `Vu = 110`
  - `Vd = 85`
  - `D = 100`
  - `R = 5%`
  - risk-neutral survival weight `q = 0.80`
  - risk-neutral default weight `1 - q = 0.20`
- The section then connects that simple branch logic to the continuous Merton expression `P^Q(V_T < D) = N(-d_2)`.
- `02-merton-estimation.qmd` explains that `N(x)` is the standard normal CDF and that `N(-d_2)` is the red default area in Figure 3.1.
- `02-merton-estimation.qmd` now introduces Hull equations 24.3 and 24.4 before the R implementation. Equation 24.3 values equity as a call option on assets; equation 24.4 links observed equity volatility to unobserved asset volatility through the option delta. This motivates why the code solves two equations for `V0` and `sigmaV`.
- The spread/intensity point has been revised. The chapter no longer uses the old `lambda` shortcut for the spread. It now computes the Merton-implied market value of debt as `B0 = V0 - E0`, backs out the implied zero-coupon debt yield `y = (1/T) log(D/B0)`, and defines the spread as `y - rf`. In the Hull example, this gives `B0 = 9.3954`, `y = 6.2366%`, and a spread of about `123.7` basis points.
- The numerical estimation in `02-merton-estimation.qmd` now uses economically motivated starting values: `start_V0 = E0 + D exp(-rf T)` and `start_sigmaV = sigmaE E0 / start_V0`. The optimizer uses `L-BFGS-B` with positive lower bounds and scale information for `optim()`.
- Avoid writing calculated Merton outputs by hand in prose. Section 3.2 now uses inline R formatting for `pd`, `N(d2)`, `N(-d2)`, debt value, yield, and spread. `R/merton-common.R` has been aligned with the same optimizer so later sections use the same `V0`, `sigmaV`, and `pd_merton`.
- `02-merton-inside-view.qmd` no longer recalculates `E0` with a separate Black-Scholes call example. That check was redundant because `E0` is an observed input used to calibrate `V0` and `sigmaV`; the inside-view section should focus on the future payoff `E_T = max(V_T - D, 0)` and the distinction between `E_T`, `E_0`, `V_0`, and `D`.
- Block 4 coherence pass was completed for the Merton chapter. Section titles now use the narrative sequence: `Why risk-neutral valuation works here`, `Estimating asset value and risk-neutral PD`, `Risk-neutral simulations and equity payoff`, `Equity as a call option payoff`, `Model-implied PD sensitivity analyses`, and `Capital-structure scenarios`. The sidebar section anchors were updated in `sidebar-chapter-sections.html`.
- Figures 3.13 through 3.18 were converted from base R plotting to `ggplot2`. Figure 3.13 now shows the equity call payoff with ggplot, and the one-input sensitivity curves in section 3.5 share a common ggplot style with the original Hull/Merton case marked by dashed guides and a highlighted point.
- The Merton estimation section now has internal subsections for inputs/Hull equations, solving the two equations, interpreting `d2`, checking the numerical solution, and model-implied debt spread. The sensitivity and capital-structure sections now have internal subsections that make their roles clearer.
- The internal Merton labels are now visual subheads rather than `###` headings, so the rendered chapter shows only two numbered levels such as `3.1`, `3.2`, etc., not `3.2.1`.
- `02-merton-minimize.qmd` was removed from the chapter flow because the minimization section felt unnecessary in its old position, but the file still exists.

Integrated Merton adjustment list:

1. Keep the distinction between risk-neutral/implied PD and real-world/physical PD explicit throughout the chapter.
   - Status: revised in sections 3.1 and 3.2; continue checking later sections for loose wording.
2. Clarify that Merton default occurs at maturity, when `V_T < D`.
   - Check especially simulation text that discusses paths crossing below `D` before maturity.
3. Correct references to `E_T < 0`.
   - Equity payoff should be zero in default, not negative: `E_T = max(V_T - D, 0)`.
4. Use consistent language for `D`.
   - Prefer "promised debt payment at maturity", "debt face value", or "debt due at maturity"; avoid ambiguous "debt value" where it could mean market value of debt.
5. Keep `E_0`, `V_0`, and firm value/equity value distinct.
   - `E_0` is equity value / market capitalization.
   - `V_0` is asset value / firm value in the Merton model.
   - Status: revised in `02-merton-inside-view.qmd` by removing the redundant `E0.theo()` check and stating that `E_0` is observed equity value today, `V_0` is model asset value today, and `D` is the promised debt payment at maturity.
6. Make risk-neutral simulations sound like valuation scenarios, not real-world forecasts.
   - Avoid "real life" phrasing unless clearly qualified.
   - Keep the distinction between `V_t < D` before maturity and default at `V_T < D`.
7. Clarify spread and intensity logic.
   - Formulas using an intensity require care because risk-neutral PD over a horizon is not automatically the same object as `lambda`.
   - Status: revised in `02-merton-estimation.qmd` by replacing the intensity shortcut with a direct Merton-implied debt-yield spread.
8. State that capital-structure scenarios are model-implied sensitivity analyses.
   - They change observed inputs, keep remaining observed inputs and model assumptions fixed, re-estimate `V_0` and `sigma_V`, and then show the new model-implied risk-neutral PD.
   - Status: revised in `02-merton-pd-parameters.qmd` and `02-merton-capital-structure.qmd`; section names and scenario headings now reinforce this interpretation.
9. Add clearer conclusions to capital-structure scenarios.
   - Each scenario should say what changes, what is held fixed, and why the model-implied PD moves.
   - Status: revised in `02-merton-capital-structure.qmd` with scenario-specific conclusions and caveats.
10. Nuance conclusions about risk-free rate and maturity.
    - Avoid implying simple real-world policy rules from one-parameter model changes.
11. Improve optimization constraints so asset value and volatility remain positive.
    - Consider constrained optimization or parameter transformations for `V_0 > 0` and `sigma_V > 0`.
    - Status: revised in `02-merton-estimation.qmd` with economically motivated starting values and `L-BFGS-B` lower bounds.
12. Clean up local wording issues while editing.
   - Example: "With these seven parameters" should become "Using these inputs, we estimate `V_0` and `sigma_V`..."
   - Clarify "increase capital" as an increase in equity value `E_0`, such as through a capital injection.
   - Status: ongoing cleanup done in the Merton coherence pass; remaining future edits should keep section titles and sidebar anchors in sync.

Relevant local source:

- `Hull 11th.pdf` is present locally and was used as reference material. Do not commit this PDF unless the user explicitly asks.
- Useful Hull anchors: section 15.7 on risk-neutral valuation and chapter 24 on credit risk/Merton.

## Current technical state

- A full `quarto render` succeeded on 2026-05-26.
- The render processed 7 inputs and created `_book/index.html`.
- After the render, root `index.html` and `index_files` were restored to avoid generated deletion noise. This reflected the old repository state before the legacy root artifacts were removed.
- A later full `quarto render` also succeeded after the Merton block 4 coherence pass. It refreshed `_book/index.html` and all chapter pages so the shared sidebar anchors match the new Merton section titles.
- The main content batch was committed and pushed as `28bd579` (`Expand book chapters and Merton valuation notes`).
- GitHub Actions/Pages failed after the push, but the push itself succeeded.
- GitHub Status reported an active incident with Actions and Pages on 2026-05-26, including failures starting Actions runs and downloading actions from `codeload.github.com`.
- Additional workflow commits were pushed while diagnosing:
  - `45c47a3` added `xgboost` to the publishing workflow R package installation.
  - `8933026` pinned the build runner to `windows-2022`.
  - `f445c55` removed third-party setup actions for R/Quarto and uses Chocolatey instead.
- A later workflow run reached `quarto render` but failed at `01-logistic.qmd` while invoking Chocolatey's latest `R-4.6.0` with `The pipe is being closed`; local targeted render succeeded under `R-4.5.2`, so the workflow pins Chocolatey's `r.project` package to `4.5.2`.
- The workflow can still fail while GitHub Actions/Pages is degraded, especially when downloading official actions such as `actions/configure-pages`.
- On 2026-05-27, a complete local `quarto render` succeeded before publishing the Merton revision.
- On 2026-05-27, another complete local `quarto render` succeeded after the chapter 4 copula/t-copula/Credit VaR revision and visual polish.
- On 2026-05-27, legacy root render artifacts were removed from version control: `index.html`, `Logistic.html`, `index_files/`, `Logistic_files/`, and `libs/`. These files contained stale pre-book output and should not be restored unless the user explicitly asks to recover the old static render from history.
- On 2026-05-27, the simplification was verified end to end with commit `bd8b114` (`Simplify book publishing artifacts`). A full local `quarto render` succeeded, the commit was pushed to `origin/main`, GitHub Actions completed successfully, and GitHub Pages showed visible `Publication: 91`.
- The last confirmed good published version is now `bd8b114` (`Simplify book publishing artifacts`). The previous good published checkpoint was `ac224d2` (`Revise copula chapter with tail risk`), visible as `Publication: 90`.
- On 2026-05-27, chapter 4 received a reader-first clarity pass around section 4.1. The section now defines co-default, separates marginal cumulative PDs, dependence, and loss severity, uses "default driver" consistently, distinguishes default-driver correlation from default-indicator correlation, and adds a numerical `qnorm()`/`pnorm()` bridge for the 5-year cumulative PD.
- The Hull Example 24.7 threshold table now explains why the threshold check reproduces the same cumulative PDs: the final column applies `pnorm()` back to the `qnorm()` thresholds. This is intentional, not a duplicated input column.
- The latest published source commit before the chapter 4 revision was `8b3c0cc` (`Revise Merton chapter and reproducible outputs`), pushed to `origin/main` after the successful full render.
- `Hull 11th.pdf` remains local and untracked. Do not commit it unless the user explicitly asks.

## Next session

- If context is lost after a Codex update, start by reading this file, checking `git status -sb`, and checking `git log -1 --oneline` to identify the latest pushed source commit.
- If the user is worried about publication, verify the current source commit against GitHub Pages by checking the visible `Publication` number on the site and the latest `Publish Quarto book` workflow run. The confirmed checkpoint before the 4.1 clarity pass was `bd8b114` / `Publication: 91`; after the next successful push, the visible publication marker should increment.
- Continue with chapter 4 only if the user asks for another visual/text pass. The current chapter 4 direction is portfolio credit risk, t-copula tail dependence, and Credit VaR model risk.
- Continue with the Merton chapter only if the user asks for more Merton work. Merton block 4 has been completed; if continuing Merton, do a final reader pass only for style and flow, not another conceptual rewrite unless a specific weakness appears.
- Do not restore the removed root render artifacts after a full render. They were removed specifically to avoid stale duplicate book output in the repository root.
