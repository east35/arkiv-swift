# arkiv (SwiftUI)

Universal SwiftUI client for arkiv — personal game / book / film / TV tracker. Targets iOS 17, iPadOS 17, and macOS 14 from a single codebase. Backend is the same Supabase project used by the web app (`arkiv` repo).

> **Brand note:** "arkiv" is always lowercase. Never write "Arkiv".

See `/Users/jimjordan/.windsurf/plans/arkiv-swiftui-migration-f39581.md` for the migration plan.

## Repository Layout

```
arkiv-swift/
  project.yml                 # XcodeGen spec — SOURCE OF TRUTH for the Xcode project
  arkivApp/                   # Thin Xcode app target (@main, assets, Info.plist, entitlements)
  Packages/
    Core/                     # Supabase client, models, networking, utilities
    DesignSystem/             # Design tokens (colors, spacing, typography, sizes)
    Features/
      Games/                  # First vertical slice feature module
  .github/workflows/ci.yml    # xcodegen generate && xcodebuild build test
  BACKEND_CONTRACT.md         # Supabase tables + edge functions consumed by this client
```

## Agent Onboarding (read this first)

This project uses **XcodeGen + local Swift Package Manager packages** specifically so agents can work without touching `project.pbxproj`. Three rules:

1. **Never hand-edit `arkivApp.xcodeproj/project.pbxproj`.** It is generated. Edit `project.yml` and run `xcodegen generate`.
2. **Adding a Swift file = drop it in a package's `Sources/<ModuleName>/` folder.** SwiftPM auto-discovers sources; no project-file edits needed.
3. **Adding a new SPM package or wiring it to the app requires editing `project.yml` and the package's `Package.swift`**, then `xcodegen generate`.

## Prerequisites

- Xcode 15.3+ (Xcode 26.x works; verify with `xcodebuild -version`)
- [XcodeGen](https://github.com/yonaskolb/XcodeGen): `brew install xcodegen`

## First-time Setup

```sh
brew install xcodegen
xcodegen generate
open arkivApp.xcodeproj
```

## Building & Testing from CLI

```sh
# Generate the Xcode project from project.yml
xcodegen generate

# Build for iOS simulator
xcodebuild -project arkivApp.xcodeproj -scheme arkivApp \
  -destination 'generic/platform=iOS Simulator' build

# Build for macOS
xcodebuild -project arkivApp.xcodeproj -scheme arkivApp \
  -destination 'generic/platform=macOS' build

# Run package unit tests (no simulator needed)
swift test --package-path Packages/Core
swift test --package-path Packages/DesignSystem
```

## Configuration

Supabase URL and anon key are read from `arkivApp/Config.xcconfig` (committed with placeholders) and optionally `arkivApp/Secrets.xcconfig` (gitignored, for local overrides). No secrets are committed.

## Branching

- `main` — production
- `feature/...`, `fix/...`, `chore/...`, `security/...` — PRs into `main`
- Never push directly to `main`. CI must pass before merge.
- Never attribute commits to AI tooling (Claude / Codex / Gemini / etc).

## Status

**Phase 0 — Foundation.** Empty shell, tokens ported, CI green. No auth or data yet. See the migration plan for phase sequence.
