import AppIntents
import Foundation

struct ToggleRevealIntent: AppIntent {
  static var title: LocalizedStringResource = "Toggle Reveal"

  func perform() async throws -> some IntentResult {
    WidgetSettings.isRevealed.toggle()
    return .result()
  }
}
