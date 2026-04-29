# Paywall Demo App

Flutter test app with onboarding, paywall, simulated purchase, and persisted
subscription state.

## Features

- Onboarding flow (2 screens) with `Continue` button.
- Paywall screen with two plans: monthly and yearly (yearly with discount label).
- Simulated purchase flow: loading state (1 second) then success.
- Main screen shown after purchase.
- Persisted subscription using `SharedPreferences`.
- Relaunch behavior: subscribed users open directly on the main screen.

## Architecture

Project follows a layered feature-first structure:

- `presentation` for UI and widget interactions.
- `application` for Cubits and immutable state.
- `domain` for repository interfaces and use-cases.
- `data` for persistence implementations and data sources.

Main source-of-truth for subscription state:

- Domain interface: `SubscriptionRepository`.
- Data implementation: `SubscriptionRepositoryImpl`.
- Local storage adapter: `SubscriptionLocalDataSource`.

## Project Structure

```text
lib/
  app.dart
  main.dart
  core/
    presentation/widgets/
  features/
    home/presentation/
    onboarding/
      application/
      presentation/
    paywall/
      application/
      presentation/
    subscription/
      application/launch/
      domain/{entities,repositories,usecases}
      data/{datasources,repositories}
```

## State Management Notes

- `LaunchCubit`: app-start decision (`loading`, `subscribed`, `unsubscribed`, `failure`).
- `OnboardingCubit`: onboarding progression with explicit immutable state.
- `PaywallCubit`: plan selection + purchase states (`idle`, `loading`, `success`, `failure`).

## Quality

- `dart format .`
- `dart analyze`
- Unit tests for critical logic:
  - subscription status use-case
  - paywall purchase state transitions

## AI-Assisted Development (for screencast)

- Generate baseline feature scaffolding and repetitive boilerplate.
- Refactor Cubits and state models for cleaner responsibilities.
- Validate and fix analyzer/test failures quickly.
- Speed up documentation and architecture outlining.

## What I Would Improve With More Time

- Add dependency injection container (`get_it` or similar) and explicit bindings.
- Add richer error logging/telemetry abstraction in `core/`.
- Add more unit tests and widget tests for navigation and UI behavior.
- Improve paywall visuals and localization readiness.
