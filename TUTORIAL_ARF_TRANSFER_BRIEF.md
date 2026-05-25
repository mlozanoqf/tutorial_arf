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

- Prefer a Quarto book structure if the tutorial has multiple conceptual chapters and students benefit from left navigation, search, previous/next page navigation, and stable sections.
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
- Use a concise introductory panel or paragraph that explains what the tutorial is and how to use it.
- Contact/social icons should be visually clear and large enough to read.
- If the tutorial is more like a technical book than a syllabus, adapt the home page tone accordingly.

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

- Render with Quarto after meaningful edits.
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

These choices are useful references for `tutorial_arf`, but the tutorial may need a different chapter structure because it is instructional content rather than a syllabus.

## First questions for tutorial_arf

When starting in `tutorial_arf`, answer these before editing:

1. Is the tutorial currently a single-page Quarto document, a website, or a book?
1. What are the natural conceptual chapters?
1. Which content is active and which content is historical or support material?
1. What should be on the landing page?
1. Which ARF1 UI helpers should be reused as-is, adapted, or ignored?
1. What should remain course-specific to ARF and what should become reusable tutorial structure?
