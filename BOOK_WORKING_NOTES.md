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
- The user observed a time difference between local and GitHub Pages dates. Prefer the local index timestamp as the reference if this comes up again.

## User preferences

- Call it a book, except when referring to the repository name.
- Keep the style detailed, explicit, and pedagogical. The goal is to connect model logic, equations, code, and interpretation.
- Concepts should be technically correct but explained in accessible steps.
- Preserve useful material unless the user approves removal.
- Keep `sex` and `region` in the logistic material.
- Prefer source edits over generated-output edits.
- Use targeted renders during active editing to save time.

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
- `02-merton-minimize.qmd` was removed from the chapter flow because the minimization section felt unnecessary in its old position, but the file still exists.

Remembered Merton adjustment list:

1. Distinguish risk-neutral PD from real-world or physical PD.
2. Clarify that Merton default occurs at maturity, when `V_T < D`.
3. Correct references to `E_T < 0`; equity payoff should be zero in default, not negative.
4. Remove or adjust loose language such as "undervalued".
5. Clarify that spread formulas using an intensity require care because PD is not the same object as `lambda`.
6. Add clearer conclusions to capital-structure scenarios.
7. State that scenario exercises are comparative statics holding other inputs fixed.
8. Nuance conclusions about risk-free rate and maturity.
9. Improve optimization constraints so asset value and volatility remain positive.

Relevant local source:

- `Hull 11th.pdf` is present locally and was used as reference material. Do not commit this PDF unless the user explicitly asks.
- Useful Hull anchors: section 15.7 on risk-neutral valuation and chapter 24 on credit risk/Merton.

## Current technical state

- A full `quarto render` succeeded on 2026-05-26.
- The render processed 7 inputs and created `_book/index.html`.
- After the render, root `index.html` and `index_files` were restored to avoid generated deletion noise.
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
- First likely task: polish the opening of the risk-neutral valuation section so it says very clearly what is being valued, why equity payoff and default are linked, and why risk-neutral valuation gives a valid price in a risky world.
- Then continue through Merton adjustment points 2 through 9.
- If GitHub Actions has recovered, re-run the latest failed workflow or trigger a new push.
- Consider simplifying the publication workflow or adding a documented fallback for local publishing if Actions keeps being fragile.
