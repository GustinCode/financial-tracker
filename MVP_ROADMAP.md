# Financial Tracker - Product Analysis and MVP Roadmap

## Product Intention

The project is a personal finance assistant focused on helping people organize their money with a simple, local-first mobile app.

The current direction of the codebase shows a clear intention:

- Record income and expense transactions manually.
- Categorize transactions for better organization.
- Show balance, income, and expenses in real time.
- Keep a transaction history organized by date.
- Support editing and deleting entries.
- Use local storage so the app works offline and keeps user data on the device.

This is a strong foundation for an MVP because it solves the most common pain point in personal finance apps: knowing where money goes without requiring a complex setup.

## Current Scope Observed In The Project

What already exists today:

- Flutter mobile app for Android.
- Provider for state management.
- Hive for local persistence.
- Localization support.
- Manual transaction entry.
- Transaction history.
- Balance summary.
- Categories and category translation.
- Settings screen.

What the backlog suggests for later phases:

- Authentication and recovery.
- Bank connection and Open Finance.
- Budgets and goals.
- Dashboard analytics and comparison.
- Privacy and consent flows.

## MVP Goal

The MVP should focus on one core promise:

help users record transactions quickly and understand their financial situation at a glance.

That means the MVP should stay narrow and avoid features that add integration cost, compliance overhead, or backend complexity too early.

## Recommended MVP Features

### Must Have

- Add income and expense transactions.
- Edit and delete transactions.
- Categorize transactions.
- Show current balance, total income, and total expenses.
- Show transaction history by date.
- Support category filtering.
- Keep data stored locally offline.
- Support basic localization.

### Should Have

- Search or filter transactions by title or category.
- Monthly summary screen.
- Simple onboarding or empty-state guidance.
- Export backup to CSV.
- Darker visual hierarchy for key numbers and actions.

### Could Have

- Budgets by category.
- Savings goals.
- Charts and trends.
- Custom categories with icons and colors.
- Basic reminders for recurring expenses.

## Future Upgrades To Build The App Toward A Strong MVP

### Phase 1 - Stabilize the Core

- Improve form validation and error feedback.
- Make date formatting and localization fully testable.
- Add widget tests for critical flows.
- Strengthen empty states and first-run experience.
- Simplify navigation so the user reaches the add transaction flow faster.

### Phase 2 - MVP Growth

- Add transaction search.
- Add monthly filters.
- Add category-level summaries.
- Add CSV export and import.
- Improve dashboard cards with clearer hierarchy and faster scanability.

### Phase 3 - Product Expansion

- Add budgets per category.
- Add financial goals.
- Add charts and comparisons between months.
- Add recurring transactions.
- Add backup and restore.

### Phase 4 - Advanced Financial App

- Add authentication.
- Add cloud sync.
- Add bank aggregation via Open Finance.
- Add consent and privacy management.
- Add alerts for overspending and bill reminders.

## Suggested MVP Priorities

1. Make the transaction flow frictionless.
2. Improve visibility of the financial summary.
3. Add meaningful filtering and search.
4. Add export or backup so users trust the app with their data.
5. Only after that, consider account sync or bank integration.

## Product Risks To Avoid Early

- Open Finance before proving daily manual usage.
- Authentication before the app has strong local value.
- Too many charts before users can reliably add data.
- Complex budgeting before the transaction flow is simple.

## Conclusion

The app is best positioned as a lightweight personal finance tracker with local storage and a fast manual entry workflow.

The MVP should optimize for clarity, speed, and trust. Advanced financial automation can come later, once the core habit of recording transactions is established.