# Iteration 4: Imports hub, saved views, program ROC/ROS, account overhaul, favicon, loading luxuries

This ExecPlan is a living document. The sections `Progress`, `Surprises & Discoveries`, `Decision Log`, and `Outcomes & Retrospective` must be kept up to date as work proceeds.

This plan must be maintained in accordance with `.agent/PLANS.md` if it exists in the repository. The executor must keep this document self-contained and update it as new information is discovered. :contentReference[oaicite:4]{index=4}


## Purpose / Big Picture

Users need a single, consistent way to import operational data (costs, milestones, delivery units) with downloadable templates, program-scoped validation, and clear error messages. They also need a faster, more configurable experience for reviewing contracts and costs through saved views. Program pages must show meaningful return metrics (Return on Cost and Return on Sales). The account page should feel like a real profile surface with avatar upload, lifetime stats, and a simplified theme system with three curated themes. Finally, the app should adopt the provided image as the favicon and add a small set of UI luxuries like a premium loading indicator, improving perceived performance and polish.

A human should be able to verify success by:
1) Logging in and using the Imports hub to download each template and import a sample file for each tab.
2) Visiting Contracts and seeing current-year active contracts by default, changing the filter, saving a default, and seeing it persist after reload.
3) Visiting Cost Hub, applying filters, saving view, and seeing it persist after reload.
4) Visiting Program page and seeing ROC/ROS with correct “N/A” behavior and tooltip definitions.
5) Visiting Account page, uploading an avatar, seeing lifetime stats, switching themes among 3 options, and seeing the choice persist.
6) Seeing the new favicon in the browser tab and iOS home screen icon link tags present.
7) Seeing a slick progress/loading indicator during navigation or form submission.


## Progress

- [ ] (YYYY-MM-DD HH:MM) Milestone 0: repo orientation completed (key files identified; notes recorded in issue_log).
- [ ] (YYYY-MM-DD HH:MM) Milestone 1: Imports hub implemented (Costs, Milestones, Delivery Units) with templates and validation.
- [ ] (YYYY-MM-DD HH:MM) Milestone 1 tests added and passing; screenshots added for Imports hub.
- [ ] (YYYY-MM-DD HH:MM) Milestone 2: Contracts default view is current-year active + filters + saved view.
- [ ] (YYYY-MM-DD HH:MM) Milestone 2 tests passing; screenshots added for contracts views.
- [ ] (YYYY-MM-DD HH:MM) Milestone 3: Program ROC/ROS implemented with tooltips and edge-case handling.
- [ ] (YYYY-MM-DD HH:MM) Milestone 3 tests passing; screenshots added for Program page.
- [ ] (YYYY-MM-DD HH:MM) Milestone 4: Cost Hub saved view implemented and tested; screenshots added.
- [ ] (YYYY-MM-DD HH:MM) Milestone 5: Account overhaul implemented (profile, avatar, stats, 3 themes) and tested; screenshots added.
- [ ] (YYYY-MM-DD HH:MM) Milestone 6: Favicon update implemented and verified.
- [ ] (YYYY-MM-DD HH:MM) Milestone 7: Loading luxuries implemented and verified across themes.
- [ ] (YYYY-MM-DD HH:MM) Final validation: all AGENTS.md commands run; results recorded; logs updated; PR prepared.


## Surprises & Discoveries

- Observation:
  Evidence:

- Observation:
  Evidence:


## Decision Log

- Decision:
  Rationale:
  Date/Author:

- Decision:
  Rationale:
  Date/Author:


## Outcomes & Retrospective

- Summary:
- Remaining gaps:
- Lessons learned:


## Context and Orientation

This repository is a Rails web application with a left navigation layout and several key surfaces: Costs (Cost Hub), Contracts, Programs, Imports, and Account/Profile. There is already an existing cost import workflow and cost hub. The goal is to generalize the import experience into a unified Imports hub with multiple import types, while enforcing the business rule that costs are scoped to a single Program and cannot be shared between Programs.

“Saved views” means persisting a user’s preferred filters for a page (for example: current year contracts, next year contracts, date range and program filters) in the database, so the page loads with those filters automatically next time.

The “favicon” is the icon shown in the browser tab. Rails provides helpers to link favicons that are managed by the asset pipeline using `favicon_link_tag`. Mobile Safari can use `rel: apple-touch-icon` for home screen icons. :contentReference[oaicite:5]{index=5}

Turbo Drive includes a built-in progress bar and toggles `aria-busy` on the `<html>` element during navigation and form submissions. We will leverage this to create a polished loading experience. :contentReference[oaicite:6]{index=6}


## Plan of Work

We will implement this change set in milestones that each produce observable behavior and passing tests. The work will be mostly additive, minimizing risk by refactoring existing cost import code into a shared import service and layering new import types on top.

High level structure:

1) Imports hub: a single page under Imports navigation with three tabs (Costs, Milestones, Delivery Units), each with template download and upload handling. Each import validates Program scoping and produces row-level errors. Static .xlsx templates are committed and served from a stable path.

2) Saved views: introduce a per-user preferences store (a table or structured preference model) that can persist page-level filter state for Contracts index and Cost Hub.

3) Program ROC/ROS: compute Profit, Return on Sales, Return on Cost from existing revenue and cost totals, with “N/A” handling for division by zero, plus tooltip descriptions.

4) Account overhaul: implement profile and avatar (Active Storage), lifetime stats, and a simplified theme system with three curated options.

5) Favicon: add source image asset, wire up favicon link tags in layout, and optionally add /favicon.ico fallback.

6) Loading luxuries: style Turbo progress bar and add a global spinner tied to Turbo’s aria-busy behavior, ensuring it works across all themes and respects reduced motion preferences.

At each milestone, add tests and UI screenshots. Update docs/quality logs continuously.


## Concrete Steps

Milestone 0: Orient and audit

- From repo root:
    - Read AGENTS.md chain and summarize it in the PR notes.
    - Identify existing routes and controllers for:
      - cost imports
      - cost hub
      - milestones
      - delivery units
      - contracts
      - programs
      - account/profile
    - Identify how “contract active in year” can be computed using existing contract fields.
    - Identify how theming is implemented now (CSS variables, classes, Tailwind, stored preferences).
    - Record audit notes in docs/quality/issue_log.md under “Iteration 4 audit notes”.

Acceptance:
- issue_log contains a short orientation that a new contributor can use to find the relevant files.

Milestone 1: Imports hub (Costs, Milestones, Delivery Units)

- Create or refactor Imports navigation:
  - Rename “Cost Imports” to “Imports”.
  - Ensure the Imports hub is the single entry point for importing.

- UI:
  - Implement an Imports hub page with 3 tabs.
  - Each tab shows:
    - Program select (required)
    - File input
    - Download template link
    - Required headers list
    - Submit/import button
    - Errors summary area

- Templates:
  - Commit static templates:
    - public/templates/costs.xlsx
    - public/templates/milestones.xlsx
    - public/templates/delivery_units.xlsx
  - Ensure download endpoints return correct filename.

- Import behavior:
  - Costs:
    - Remove contract_code from cost template requirements.
    - Enforce Program scoping. All imported cost entries must attach to selected Program.
  - Milestones and delivery units:
    - Require contract_code per row.
    - Validate each contract_code belongs to the selected Program.
    - Provide row-level errors (row number + message).
    - Decide and document “all-or-nothing” vs “partial success with error list” behavior. Default to all-or-nothing for safety unless product requirements call for partial.

- Styling:
  - Fix dark-mode select readability issues on the Imports hub.

Acceptance:
- A user can download each template and import a valid file for each tab.
- Invalid rows produce a clear row-level error report.
- Costs cannot be imported into the wrong Program.

Milestone 1 tests and screenshots:
- Add system specs:
  - Template download works for all 3 templates.
  - Each import type can import a valid file and creates records.
  - Invalid contract_code rows are rejected with clear messages.
- Update bin/ui-screenshots to capture:
  - Imports hub, each tab
  - Output under tmp/screenshots/ui/imports/{costs,milestones,delivery_units}

Milestone 2: Contracts default current-year active + saved views

- Define “active in year”:
  - Implement a scope on Contract (or a query object) that returns contracts active in a given year using existing fields.

- Contracts index behavior:
  - Default to current year.
  - Add filter bar: this year, next year, select year, all.
  - Add “Save as default view”.
  - Persist preference per user in DB (UserPreference style).

Acceptance:
- Default contracts list is current-year active.
- User can change filter and save it.
- Reloading page applies the saved view automatically.

Tests and screenshots:
- System spec: default is current year, filter works, saved view persists.
- Screenshots:
  - contracts default
  - contracts next year
  - contracts all
  - desktop/iPad/iPhone viewports

Milestone 3: Program ROC/ROS metrics

- Implement calculations:
  - Profit = Revenue - Cost
  - ROS = Profit / Revenue, show “N/A” when Revenue == 0
  - ROC = Profit / Cost, show “N/A” when Cost == 0
- Add tooltip help text defining both metrics.
- Ensure cost totals are program-scoped.

Acceptance:
- Program page displays ROC and ROS with correct formatting and correct “N/A” behavior.

Tests and screenshots:
- Unit spec for metric calculations including zero revenue/cost and negative profit.
- System spec for rendering.
- Screenshot of Program page showing metrics.

Milestone 4: Cost Hub saved views

- Persist filter state:
  - program
  - start date
  - end date
  - period_type (if present)
- Add “Save as default view” and “Reset” controls.

Acceptance:
- Saved view applies on load and can be reset.

Tests and screenshots:
- System spec for persistence.
- Screenshots of default and saved view.

Milestone 5: Account page overhaul

- Profile:
  - display name, email, optional role/title
  - member since
  - avatar upload
- Lifetime stats:
  - program count
  - contract count
  - delivered unit count
  - total revenue
  - total cost
  - average cost per unit when units > 0

- Theme system:
  - Replace theme selector with 3 fixed theme cards:
    - Dark + Coral (existing)
    - Dark + Blue (new)
    - Light (new)
  - Persist selection per user.
  - Apply using a single attribute/class on html/body and CSS variables.

Acceptance:
- Avatar upload works and displays.
- Lifetime stats render with sensible defaults.
- Theme changes apply globally and persist across reload.

Tests and screenshots:
- System spec: avatar upload, theme persist, stats visible.
- Screenshots: account page in all 3 themes, desktop/iPad/iPhone.

Milestone 6: Favicon

- Add the provided image to the repo as app/assets/images/brand/favicon.png (or equivalent).
- Update the main layout head tags:
  - Use Rails `favicon_link_tag` to link the PNG as the icon.
  - Add `rel: apple-touch-icon` using the same helper so iOS home screen icon works.
- Optional but preferred:
  - Add a public/favicon.ico fallback for browsers that request /favicon.ico automatically.

Acceptance:
- Browser tab shows the new favicon after cache refresh.
- Layout includes icon and apple-touch-icon link tags.

Milestone 7: UI luxuries (loading)

- Style Turbo progress bar:
  - Add CSS overrides for `.turbo-progress-bar` that match theme accent and feel premium.
- Add a global spinner:
  - Use Turbo’s `aria-busy` toggling on `<html>` to show/hide the spinner with CSS, so it works for both navigation and form submissions.
  - Respect reduced motion preferences.

Acceptance:
- On navigation or form submit, the progress bar and spinner appear and disappear cleanly.
- Works in all three themes.

Tests and screenshots:
- Add a system spec that triggers navigation and asserts the presence of loading indicator elements (high-level assertion).
- Add screenshots of a representative page mid-load only if the screenshot harness supports deterministic capture. If not deterministic, document and skip mid-load screenshot, but keep final-state screenshots.

Final validation and reporting

- Run all AGENTS.md commands and record results.
- Run bin/ui-screenshots and list the output folders created under tmp/screenshots/ui.
- Update docs/quality logs with evidence and a summary of work done.


## Validation and Acceptance

Acceptance is met when:
1) Imports hub exists with 3 tabs, each has a working template download and import path with program scoping and row-level errors.
2) Contracts default is current-year active, user can filter and save default view, which persists.
3) Cost Hub view can be saved and persists.
4) Program page shows ROC/ROS with correct definitions, edge cases, tooltips.
5) Account page is overhauled: profile section, avatar upload, lifetime stats, 3 theme options, persistent selection.
6) New favicon is applied using Rails asset helper link tags and apple-touch icon link tag. :contentReference[oaicite:7]{index=7}
7) Loading luxuries are present: Turbo progress bar styled and global spinner tied to aria-busy. :contentReference[oaicite:8]{index=8}
8) All required tests and bin/ui-screenshots run and results recorded, with no new failures introduced.


## Idempotence and Recovery

- Database migrations must be reversible.
- Imports must be safe to retry:
  - If an import creates records, either prevent duplicates with a checksum/import batch record or clearly document how to delete a bad batch.
- Theme and saved views should be safe to update repeatedly.
- If Active Storage setup is required, document steps to prepare storage in dev and test environments and ensure tests use local disk service.


## Artifacts and Notes

- Keep UI screenshots under tmp/screenshots/ui/ and ensure gitignore includes tmp/screenshots.
- Record screenshot paths in the PR description.
- For each milestone, include a short “what changed” note and the test commands run.


## Interfaces and Dependencies

- Prefer existing libraries already in Gemfile for .xlsx parsing and upload workflows.
- Do not add new production dependencies unless required, and if added, document rationale in Decision Log.
- Use Rails asset helpers for favicon linking. :contentReference[oaicite:9]{index=9}
- Use Turbo’s built-in progress bar and aria-busy behavior for loading indicators. :contentReference[oaicite:10]{index=10}


Change note:
- This ExecPlan was created to cover Iteration 4 scope: unified Imports hub, saved views for Contracts and Cost Hub, Program ROC/ROS metrics, Account overhaul with 3 themes and avatar, favicon update using provided asset, and UI loading luxuries. It adds explicit acceptance criteria, test requirements, and screenshot expectations to keep work verifiable and consistent.
