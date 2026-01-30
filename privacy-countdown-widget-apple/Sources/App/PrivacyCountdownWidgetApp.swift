import SwiftUI

@main
struct PrivacyCountdownWidgetApp: App {
  @StateObject private var deadlineStore = DeadlineStore()

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(deadlineStore)
    }
  }
}
