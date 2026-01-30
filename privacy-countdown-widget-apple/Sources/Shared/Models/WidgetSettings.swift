import Foundation

struct WidgetSettings {
  static let appGroupID = "group.com.labs.privacycountdown"
  static let userDefaults = UserDefaults(suiteName: appGroupID) ?? UserDefaults.standard

  enum Keys {
    static let isRevealed = "isRevealed"
    static let calendarConnected = "calendarConnected"
    static let calendarName = "calendarName"
  }

  static var isRevealed: Bool {
    get { userDefaults.bool(forKey: Keys.isRevealed) }
    set { userDefaults.set(newValue, forKey: Keys.isRevealed) }
  }

  static var calendarConnected: Bool {
    get { userDefaults.bool(forKey: Keys.calendarConnected) }
    set { userDefaults.set(newValue, forKey: Keys.calendarConnected) }
  }

  static var calendarName: String {
    get { userDefaults.string(forKey: Keys.calendarName) ?? "" }
    set { userDefaults.set(newValue, forKey: Keys.calendarName) }
  }
}
