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

## Dogfood the Atlas annotation lifecycle

Use one pull request and two pushes to exercise the complete finding lifecycle:

1. Add a visible user task with an explicit expected result, then deliberately
   leave that result broken. State the expected behavior in the pull request.
2. On the broken push, require Proof of Changes to reproduce the failure, add
   one screenshot-grounded finding, assign an evidence-based confidence score,
   and link the finding into Atlas.
3. Fix the same task in a second push. The proof agent should list the earlier
   finding, resolve or reply to that thread instead of duplicating it, and leave
   the pull-request comment linked to the newly exercised build in Atlas.

The checkout fixture in `SwiftMinimal/ContentView.swift` is designed for this:
`Place order` should reveal `Order confirmed`, and the broken/fixed transition
is the single assignment to `orderConfirmed` inside the button action.

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
