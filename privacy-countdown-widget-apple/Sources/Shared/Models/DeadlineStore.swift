import Foundation

@MainActor
class DeadlineStore: ObservableObject {
  @Published var deadlines: [Deadline] = []

  init() {
    loadSampleData()
  }

  private func loadSampleData() {
    let calendar = Calendar.current
    let now = Date()

    deadlines = [
      Deadline(
        id: UUID(),
        title: "Senior thesis draft",
        course: "ENGL 492",
        dueDate: calendar.date(byAdding: .day, value: 18, to: now) ?? now,
        dueTime: "11:59 PM"
      ),
      Deadline(
        id: UUID(),
        title: "Algorithms problem set 6",
        course: "CPSC 323",
        dueDate: calendar.date(byAdding: .day, value: 24, to: now) ?? now,
        dueTime: "11:59 PM"
      ),
      Deadline(
        id: UUID(),
        title: "Modern history proposal",
        course: "HIST 375",
        dueDate: calendar.date(byAdding: .day, value: 30, to: now) ?? now,
        dueTime: "5:00 PM"
      ),
      Deadline(
        id: UUID(),
        title: "Final seminar presentation",
        course: "SENR 410",
        dueDate: calendar.date(byAdding: .day, value: 39, to: now) ?? now,
        dueTime: "9:00 AM"
      ),
    ]
  }

  var mostPressing: Deadline? {
    deadlines.sorted { $0.daysLeft < $1.daysLeft }.first
  }
}
