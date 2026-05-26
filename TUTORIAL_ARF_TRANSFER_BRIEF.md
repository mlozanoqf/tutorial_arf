# Transfer brief for tutorial_arf

Date: 2026-05-25

This note transfers the reusable work from the ARF1 syllabus refactor to the `tutorial_arf` project. It is not a full project plan yet. Its purpose is to let Codex continue in `tutorial_arf` without requiring the user to explain the same design and architecture decisions again.

## Main objective

Update `tutorial_arf` with the same general modernization logic used in the ARF1 syllabus:

- architecture first;
- content second;
- preserve useful existing material during the first pass;
- avoid deleting substantive content without explicit user approval;
- make the rendered HTML easier to navigate, inspect, and use on desktop and mobile;
- keep a detailed academic/professional style, but reduce clutter, obsolete material, and confusing navigation.

## Expected workflow

1. Inspect the current `tutorial_arf` structure before editing.
1. Identify the current Quarto format: single document, website, book, or hybrid.
1. Propose an architecture before rewriting content.
1. Create or use a branch before major changes.
1. Render frequently and inspect the generated HTML.
1. Keep historical or old material available until the user approves deletion.
1. Make changes in small reviewable passes.

## Reusable ARF1 design decisions

The following ARF1 files contain reusable design and navigation work that may be adapted for `tutorial_arf` after inspecting its current structure:

- `13_styles.css`: global design, link colors, home panel, contact icons, responsive behavior, local navigation styling, tables, back-to-top button, and dark/light-mode refinements.
- `11_back-to-top.html`: improved bottom-right back-to-top button.
- `12_progressbar.html`: thin top reading-progress bar.
- `14_local-navigation.html`: local link fixes useful when viewing rendered HTML through `file://`.
- `15_page-sections.html`: sticky top local navigation with breadcrumb text and an in-page "In this page" / sections dropdown.
- `16_sidebar-accordion.html`: sidebar accordion behavior and bold active top-level navigation group.
- `8 contact.html`: contact/social icon area for the home page.

Do not copy these files blindly. First compare existing files in `tutorial_arf`, especially `styles.css`, `back-to-top.html`, `progressbar.html`, `contact.html`, and `_quarto.yml`.

## Navigation principles

- Prefer a Quarto book structure if the material has multiple conceptual chapters and students benefit from left navigation, search, previous/next page navigation, and stable sections.
- Keep the number of visible navigation levels low.
- Use top-level groups for broad conceptual blocks.
- Avoid extra "quick links" that create confusion about where the reader is.
- Keep a sticky local navigation bar on chapter pages when useful.
- The local navigation should let the reader jump to sections inside the current page.
- If a sticky header/navigation bar is used, headings need scroll offset so anchor jumps do not hide the target heading behind the fixed area.
- Active top-level sidebar group should be indicated with simple bold text, not a heavy background highlight.

## Home page principles

- The home page should be a real entry point, not a long duplicated chapter.
- Avoid repeating the Quarto title/subtitle as body text.
- Use a concise introductory panel or paragraph that explains what the book is and how to use it.
- Contact/social icons should be visually clear and large enough to read.
- Keep the home page tone aligned with a technical book rather than a syllabus.

## Visual principles

- Links must be readable in both light and dark mode.
- Avoid blue/black link combinations that disappear in dark mode.
- Back-to-top button should have a transparent or semi-transparent background and a visible, centered arrow.
- Footer/contact information should fit cleanly in one line when possible.
- Tables should use stable widths and responsive behavior.
- Do not create excessive nested cards or confusing UI layers.

## Content principles

- First pass: reorganize and modernize structure.
- Second pass: revise content chapter by chapter.
- Keep the user's detailed academic style, but improve clarity, English, sequence, and searchability.
- Remove or archive obsolete technical references only after confirming they are no longer useful.
- When updating external resources, verify pages directly and do not invent references.
- Current/2026 technical resources should rely primarily on official documentation, stable open books, and recognized institutions.

## Technical principles

- Render with Quarto after meaningful edits, but use targeted renders by default during iterative work.
- For content edits, render only the edited page or the active part:
  - Credit Scoring and Data: render `01-logistic.qmd`; its section fragments are included from `01-logistic-*.qmd`.
  - Structural Models: render `02-merton.qmd`; its section fragments are included from `02-merton-*.qmd`.
  - Portfolio Models: render `03-gaussian-copula.qmd` for the Gaussian copula chapter, or `04-cvar.qmd` for Credit VaR.
- Run a full `quarto render` only when the user asks for the complete book, before a final publishing check, or before a commit/push meant to update GitHub Pages.
- If viewing locally through `file://`, remember that search and some embeds can behave differently than on GitHub Pages or a local web server.
- If `_book` or generated HTML is ignored by Git, source edits must be verified by rendering.
- Keep generated output and source cleanup conceptually separate.
- Use `git status` before and after edits.
- Do not overwrite user changes or delete historical files without permission.

## ARF1 state to remember

The ARF1 syllabus is currently a Quarto book with:

- a cleaner landing page;
- three broad navigation groups;
- semantic chapter filenames;
- custom CSS and HTML helpers for navigation, progress bar, contact icons, and back-to-top behavior;
- improved light/dark link colors;
- a sticky local navigation bar on chapter pages;
- scroll-offset fixes so internal section jumps remain visible;
- an accordion-style sidebar;
- a preserved `index-single.qmd` alternative for single-document rendering.

These choices are useful references for `tutorial_arf`, but the book may need a different chapter structure because it is instructional content rather than a syllabus.

## First questions for tutorial_arf

When starting in `tutorial_arf`, answer these before editing:

1. Is the project currently a single-page Quarto document, a website, or a book?
1. What are the natural conceptual chapters?
1. Which content is active and which content is historical or support material?
1. What should be on the landing page?
1. Which ARF1 UI helpers should be reused as-is, adapted, or ignored?
1. What should remain course-specific to ARF and what should become reusable book structure?

## Current working state after 2026-05-25 session

Branch and workflow:

- Current branch: `main`.
- Do not commit or push until the user explicitly asks.
- The user wants to accumulate several content changes locally before making a commit.
- The active objective is to make GitHub Pages update automatically after commits/pushes to `main`, but content cleanup is still ongoing before the next commit.

Architecture/navigation already changed:

- The project has been converted into a Quarto book-style architecture.
- The left navigation now uses the real book chapters as the main visible units, with JavaScript-added internal section links under each major chapter.
- `sidebar-toggle.html` creates a real fallback sidebar-toggle button, moves it next to the dark-mode tool in the sidebar when JavaScript runs, hides Quarto's native icon-only toggle once ready, and uses `book-sidebar-hidden` to hide the left menu while leaving a small floating icon to restore it.
- Section numbering is enabled in `_quarto.yml` with `number-sections: true` and `number-depth: 3`, so chapters and subsections use book-style numbering and figure references keep chapter-aware numbering.
- `index.qmd` uses an unnumbered `# Credit Risk with R` title and an unnumbered `## Preface`, so the home/preface page does not consume chapter 1; the first numbered chapter is `Logistic credit scoring`.
- The unwanted left-sidebar `index.html` entry was removed; the book title should take the reader home.
- Subsections are kept as separate source fragments for easier editing, but they are included inside the main chapter files rather than listed as separate book chapters.
- Chapter numbering is intentionally hierarchical:
  - Chapter 1: `01-logistic.qmd` (`Logistic credit scoring`), with sections such as `1.1 Loan analysis`.
  - Chapter 2: `02-merton.qmd` (`The Merton model`), with sections such as `2.1 Minimize a function in R`.
  - Chapter 3: `03-gaussian-copula.qmd` (`The Gaussian copula model`), with sections such as `3.1 The basics`.
  - Chapter 4: `04-cvar.qmd` (`Credit VaR`) unless the user later changes this structure.
- Merton was separated from the Gaussian copula and Credit VaR portfolio material.
- `sidebar-chapter-sections.html` adds collapsible internal subsection links to the sidebar without listing those subsections as Quarto chapters.
- Quarto code tools were adjusted so pages with R code show only show/hide code controls, not source view.
- Pages without R code, such as the home page, should not show a code button.
- The home page title/subtitle/author were restored after a JS/CSS issue made them appear and disappear.
- The home page uses `R/book-edition.R` to show `Book edition: <hash>` with the 7-character hash in code-style monospace, plus publication metadata.
- The visible publication number is shown as `Publication: N`, not as "N commits"; it is computed from `git rev-list --count HEAD`.
- `.github/workflows/publish.yml` must keep `actions/checkout` with `fetch-depth: 0` so the publication count is stable in GitHub Actions.

Important user preferences:

- Refer to the project as a book, except where the repository name `tutorial_arf` is unavoidable.
- Keep the book detailed and specific; it should help students more than a regular compact textbook.
- Improve technical precision, sequence, and clarity, but avoid unnecessary simplification.
- Remove redundancy when it does not add pedagogical value.
- Do not remove or change `sex` or `region`; these variables must remain as they are.
- Do not make commits or pushes unless the user asks directly.

Content work completed in the first logistic part:

- Reviewed the first part for logic, structure, detail, redundancy, and technical correctness.
- Corrected the confusion-matrix explanation in `01-logistic-model-evaluation.qmd`: 2,081 are no-defaults misclassified as defaults, and 308 are defaults misclassified as no-defaults.
- Clarified that prediction range is not a performance metric by itself.
- Clarified that AIC is an in-sample criterion and must be complemented with test-set evaluation.
- Fixed minor wording/grammar issues in the logistic model discussion.
- Corrected the bank-strategy section so 80% and 65% acceptance rates are calculated with quantiles of predicted default probabilities.
- Replaced the incorrect direct-threshold logic that treated `0.20` and `0.35` as acceptance rates.
- Added a `classification_metrics()` helper for sensitivity and specificity.
- Corrected the explanation of ROC: false positive rate is `1 - specificity`.
- Corrected the sensitivity/specificity trade-off under the rule "reject if predicted probability of default is above the cutoff".
- Fixed the typo `5.76%%`.
- Improved the accept/reject evaluation labels to distinguish good decisions, bad decisions, correct rejections, and lost good customers.
- Updated `R/logistic-models.R` with the quantile-based helper values while keeping `sex` and `region` in `logi_full`.

Verification already done:

- Ran `quarto render` successfully after the latest content edits.
- Render completed for 21 pages without error.
- Verified the rendered HTML contains the corrected confusion-matrix text, AIC/range caveats, ROC explanation, and quantile-based acceptance-rate results.
- After rendering, restored root `index.html` and `index_files` to avoid generated deletion noise in git status.
- Browser verification through Codex may block `file://` and `localhost`; the user can inspect `_book/index.html` directly in their own browser.

Current uncommitted state to expect:

- Modified tracked files include:
  - `01-logistic.qmd`
  - `02-merton.qmd`
  - `03-gaussian-copula.qmd`
  - `_quarto.yml`
  - `page-sections.html`
  - `styles.css`
  - this transfer brief
- New untracked files include the split chapter pages:
  - `01-logistic-bank-strategy.qmd`
  - `01-logistic-explore-database.qmd`
  - `01-logistic-loan-analysis.qmd`
  - `01-logistic-model-evaluation.qmd`
  - `01-logistic-models.qmd`
  - `02-merton-*.qmd`
  - `03-gaussian-*.qmd`
  - `R/` helper scripts

Good next steps:

1. Reopen the rendered book locally at `_book/index.html` and inspect the first logistic pages as a reader.
1. Continue content review page by page, probably starting with `01-logistic-explore-database.qmd` or the next logistic page the user wants.
1. Keep `sex` and `region` untouched unless the user changes that instruction.
1. When the user is satisfied with this batch, stage the new split pages and modified configuration/helpers, then commit and push to `main`.
