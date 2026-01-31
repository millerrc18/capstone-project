# Issue Log

This log tracks quality issues and their resolution status. Update entries with dates, evidence, and references.

## ISS-001 Cost Import program select readability

- Status: Done
- Date: 2025-09-21
- Notes: Updated dark theme classes on the program select and added a system spec to assert the class list.
- Evidence: spec/system/cost_hub_import_spec.rb, bin/ui-screenshots (pending due to missing Chrome).

## ISS-002 Program scoped costs

- Status: Done
- Date: 2025-09-21
- Notes: Require program on cost entries, scope summaries and queries by program, and backfill ambiguous entries.
- Evidence: spec/models/cost_entry_spec.rb, spec/system/cost_hub_spec.rb, spec/system/cost_entry_spec.rb.

## ISS-003 Manual cost entry and editing

- Status: Done
- Date: 2025-09-21
- Notes: Add duplicate action, ensure program required in the form, and validate CRUD flows.
- Evidence: spec/system/cost_entry_spec.rb.

## ISS-004 Navigation update

- Status: Done
- Date: 2025-09-21
- Notes: Move Cost Hub under Workspace and place Cost Imports under Imports.
- Evidence: spec/system/navigation_spec.rb and bin/ui-screenshots (pending due to missing Chrome).

## ISS-005 First pass visualizations

- Status: Done
- Date: 2025-09-21
- Notes: Add Chart.js powered charts to Cost Hub and Contract pages with program and period filters.
- Evidence: spec/system/cost_hub_spec.rb, spec/system/contract_charts_spec.rb, bin/ui-screenshots (pending due to missing Chrome).
