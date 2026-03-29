# TwoUpTracker

iOS app scaffolded from [skorulis/templates/ios-2026](https://github.com/skorulis/templates/tree/main/ios-2026) (SwiftUI, ASKCoordinator, ASKCore, Knit, SwiftGen, SwiftLint).

## Commands

From the repository root:

```bash
swiftgen
xcodebuild -scheme TwoUpTracker -configuration Debug build
swiftlint lint --strict
```

Regenerate the Xcode project after editing `project.yml`:

```bash
xcodegen generate
```

Asset codegen uses a local SwiftGen stencil (`Templates/xcassets/swift5.stencil`) so generated color assets are Swift 6 concurrency–friendly. `knitconfig.json` is listed in the Xcode project (via `fileGroups` and Copy Bundle Resources) so Knit’s build plugin can resolve it.
