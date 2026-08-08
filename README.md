# swift-proof-fixture

Minimal native SwiftUI iOS app for dogfooding Revyl **proof of changes**.

This is a tiny rebuild-first fixture (one Xcode target, no CocoaPods/SPM). Open a PR that changes visible UI; Revyl builds a simulator `.app`, then a proof agent installs that build and verifies the diff on a cloud device.

## Layout

- `SwiftMinimal.xcodeproj` / scheme `SwiftMinimal` — kept from the monorepo `swift-minimal` template
- `.revyl/config.yaml` — CLI build metadata + `pr_review` with `proof_of_changes`
- `versions/v*.swift` + `scripts/change-version.sh` — swap `ContentView.swift` for a visible UI delta

## Smoke a proof run

```bash
# From a clean checkout of main:
./scripts/change-version.sh v1
git checkout -b proof/v1-marker
git add SwiftMinimal/ContentView.swift
git commit -m "Change home UI marker to v1"
git push -u origin HEAD
gh pr create --title "Proof: visible UI marker v1" --body "Exercises proof-of-changes on the native Swift fixture."
```

Or edit the home title / build marker in `SwiftMinimal/ContentView.swift` by hand.

## Local build (optional)

```bash
xcodebuild -project SwiftMinimal.xcodeproj -scheme SwiftMinimal -configuration Debug -sdk iphonesimulator -destination 'generic/platform=iOS Simulator' -derivedDataPath build CODE_SIGNING_ALLOWED=NO build
```

## Revyl wiring (local / revyl-dev)

This fixture dogfoods against the **local** Revyl stack and the **revyl-dev** GitHub App
(not production `revyl` / `app.revyl.ai`).

- Org app: `swift-proof-fixture` (iOS) on the local/staging org
- GitHub App: [revyl-dev](https://github.com/apps/revyl-dev) installed on `nofone1` (or this repo)
- Apply config with the worktree CLI against localhost:

```bash
revyl-copenhagen github push --repo nofone1/swift-proof-fixture
# or: revyl --dev github push --repo nofone1/swift-proof-fixture
```

Do **not** use the global production `revyl github push` for this repo — that attaches
production `revyl[bot]` instead of `revyl-dev`.
