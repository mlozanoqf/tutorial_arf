# Credit Risk with R

This repository contains the source files for **Credit Risk with R**, a Quarto book by Dr. Martin Lozano. The book develops credit-risk models with reproducible R code, numerical examples, tables, and graphics.

Published site: <https://mlozanoqf.github.io/tutorial_arf/>

## Scope

The current version focuses on:

- Logistic credit scoring, predicted PDs, cutoff rules, bad rates, ROC/AUC, calibration, and lending decisions
- Tree-based credit scoring with a single decision tree and XGBoost
- Structural credit risk with the Merton model, risk-neutral valuation, and model-implied default probabilities
- Portfolio credit risk with Gaussian copulas, t-copulas, correlated defaults, portfolio losses, Credit VaR, expected shortfall, and economic capital

## Book Structure

- `index.qmd`: preface, publication metadata, and edition notes
- `01-logistic.qmd`: logistic credit scoring
- `02-tree-based.qmd`: tree-based credit scoring
- `02-merton.qmd`: the Merton model
- `03-gaussian-copula.qmd`: copula models for portfolio credit risk
- `references.qmd`: references

The book configuration lives in `_quarto.yml`.

## Repository Layout

- `R/`: helper scripts for data preparation, model estimation, formatting, and chapter setup
- `loan_data_*.rds`: loan data used in the credit-scoring chapters
- `_book/`: generated HTML output created by `quarto render`
- `.github/workflows/publish.yml`: GitHub Actions workflow for rendering and deploying the book to GitHub Pages
- `styles.css` and `*.html` partials: custom layout, navigation, progress, and page behavior
- `_extensions/quarto-ext/fontawesome/`: local Quarto extension used for icons
- `references.bib`: bibliography

Legacy `.Rmd` files and media assets are kept in the repository, but the active book build is driven by the `.qmd` files listed in `_quarto.yml`.

## Render Locally

Install Quarto and R, then render the book from the repository root:

```bash
quarto render
```

For interactive local preview:

```bash
quarto preview
```

The GitHub Actions workflow installs the R packages needed for deployment. For local rendering, the main package set is:

- `dplyr`
- `gmodels`
- `ggplot2`
- `knitr`
- `mnormt`
- `plotly`
- `pROC`
- `rmarkdown`
- `rayshader`
- `scatterplot3d`
- `Sim.DiffProc`
- `tidyr`
- `vembedr`
- `viridis`
- `xgboost`

## Publication

Pushing to `main` triggers `.github/workflows/publish.yml`. The workflow:

1. Checks out the repository.
2. Installs Quarto.
3. Installs R 4.5.2.
4. Installs the required R packages.
5. Runs `quarto render`.
6. Uploads `_book/` as a GitHub Pages artifact.
7. Deploys the artifact to GitHub Pages.

## Maintenance Notes

- Edit the source `.qmd` files and helper scripts, not generated files in `_book/`.
- Keep `_quarto.yml` synchronized with chapter additions, removals, or renames.
- If custom navigation changes, review `styles.css` and the HTML partials included in `_quarto.yml`.
- If a chapter needs new R packages, update `.github/workflows/publish.yml` so GitHub Pages can render the book.
- Do not commit large local reference PDFs unless they are intentionally part of the public repository.

## License

This project is licensed under the GNU General Public License v3.0. See `LICENSE`.
