# Privacy Countdown Widget (Apple)

A native SwiftUI + WidgetKit alternative to the web prototype. This folder
contains a multi-platform app layout (iOS + macOS) with a WidgetKit extension,
using Inter for typography and a black-and-white minimal UI.

## Highlights
- iOS + macOS SwiftUI app scaffold.
- WidgetKit extension with large widget blur + reveal intent.
- Inter font styling wired throughout the UI.
- Shared data model and sample Yale deadline data.

## Folder structure
- `Sources/App`: app entry and UI.
- `Sources/Shared`: shared models, styles, and views.
- `Sources/Widgets`: WidgetKit extension + AppIntent.
- `Resources/Shared/Fonts`: drop Inter font files here.
- `project.yml`: XcodeGen config to generate iOS + macOS targets.

## Build & run (XcodeGen)
1. Install XcodeGen: `brew install xcodegen`
2. From this folder, run: `xcodegen`
3. Open `PrivacyCountdownWidget.xcodeproj` in Xcode.
4. Select a signing team for the app and widget targets.
5. Ensure the App Group identifier matches `WidgetSettings.appGroupID`.
6. Download Inter font files (Regular, SemiBold, Bold) and place them in
   `Resources/Shared/Fonts`. If filenames differ, update `UIAppFonts` in
   `Resources/App/Info.plist`.
7. Build the iOS or macOS scheme and add the widget in the OS widget gallery.

## Notes
- Calendar sync is mocked with sample data; hook in EventKit or a Google
  Calendar sync service as needed.
- The macOS widget uses a reveal button (via AppIntents). The iOS widget shows
  the next deadline without a reveal state.
