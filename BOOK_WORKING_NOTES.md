# Book working notes for tutorial_arf

Last updated: 2026-05-26

This is the continuity note for the `tutorial_arf` repository. The project should be treated as a Quarto book, not as a tutorial. The rendered book is created in `_book`; that folder is generated output. The old root `index.html` and `index_files` are tracked historical render artifacts and should normally be restored after a full render if Quarto marks them as deleted.

## Current workflow

- Current branch: `main`.
- Use targeted renders while editing content:
  - Logistic chapter: `quarto render 01-logistic.qmd`
  - Tree and XGBoost chapter: `quarto render 02-tree-based.qmd`
  - Merton chapter: `quarto render 02-merton.qmd`
  - Gaussian copula chapter: `quarto render 03-gaussian-copula.qmd`
  - Credit VaR chapter: `quarto render 04-cvar.qmd`
- Use full `quarto render` only before a publishing check, before commit/push, or when the user explicitly asks for the complete book.
- The user inspects `_book/index.html` locally. Browser search and some behavior can differ under `file://`, but that is acceptable unless we need deeper browser QA.
- Do not commit or push unless the user explicitly asks.

## Architecture

- The project is now a Quarto book-style project.
- `index.qmd` is the home/preface page and is unnumbered.
- Chapter 1 is `01-logistic.qmd`: Logistic credit scoring.
- Chapter 2 is `02-tree-based.qmd`: Tree-based credit scoring.
- Chapter 3 is `02-merton.qmd`: The Merton model.
- Chapter 4 is `03-gaussian-copula.qmd`: The Gaussian copula model.
- Chapter 5 is `04-cvar.qmd`: Credit VaR.
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
- Block 4 coherence pass was completed for the Merton chapter. Section titles now use the narrative sequence: `Why risk-neutral valuation works here`, `Estimating asset value and risk-neutral PD`, `Risk-neutral simulations and equity payoff`, `Model-implied PD sensitivity analyses`, and `Capital-structure scenarios`. The sidebar section anchors were updated in `sidebar-chapter-sections.html`.
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
- After the render, root `index.html` and `index_files` were restored to avoid generated deletion noise.
- A later full `quarto render` also succeeded after the Merton block 4 coherence pass. It refreshed `_book/index.html` and all chapter pages so the shared sidebar anchors match the new Merton section titles. Root `index.html` and `index_files` were restored again after the render.
- The main content batch was committed and pushed as `28bd579` (`Expand book chapters and Merton valuation notes`).
- GitHub Actions/Pages failed after the push, but the push itself succeeded.
- GitHub Status reported an active incident with Actions and Pages on 2026-05-26, including failures starting Actions runs and downloading actions from `codeload.github.com`.
- Additional workflow commits were pushed while diagnosing:
  - `45c47a3` added `xgboost` to the publishing workflow R package installation.
  - `8933026` pinned the build runner to `windows-2022`.
  - `f445c55` removed third-party setup actions for R/Quarto and uses Chocolatey instead.
- A later workflow run reached `quarto render` but failed at `01-logistic.qmd` while invoking Chocolatey's latest `R-4.6.0` with `The pipe is being closed`; local targeted render succeeded under `R-4.5.2`, so the workflow pins Chocolatey's `r.project` package to `4.5.2`.
- The workflow can still fail while GitHub Actions/Pages is degraded, especially when downloading official actions such as `actions/configure-pages`.
- `Hull 11th.pdf` remains local and untracked. Do not commit it unless the user explicitly asks.

## Next session

- Continue with the Merton chapter.
- Merton block 4 has been completed. If continuing Merton, do a final reader pass only for style and flow, not another conceptual rewrite unless a specific weakness appears.
- If GitHub Actions has recovered, re-run the latest failed workflow or trigger a new push.
- Consider simplifying the publication workflow or adding a documented fallback for local publishing if Actions keeps being fragile.
