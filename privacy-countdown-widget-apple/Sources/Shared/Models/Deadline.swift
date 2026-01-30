import Foundation

struct Deadline: Identifiable, Codable {
  let id: UUID
  let title: String
  let course: String
  let dueDate: Date
  let dueTime: String

  var daysLeft: Int {
    let calendar = Calendar.current
    let now = Date()
    let components = calendar.dateComponents([.day], from: now, to: dueDate)
    return max(0, components.day ?? 0)
  }

  var formattedDate: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM d"
    return formatter.string(from: dueDate)
  }
}
