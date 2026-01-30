import SwiftUI

struct DeadlineRow: View {
  let deadline: Deadline
  let compact: Bool

  init(deadline: Deadline, compact: Bool = false) {
    self.deadline = deadline
    self.compact = compact
  }

  var body: some View {
    HStack(alignment: .center, spacing: 16) {
      VStack(alignment: .leading, spacing: 4) {
        Text(deadline.title)
          .font(.inter(size: compact ? 12 : 14, weight: .medium))
          .foregroundColor(.black)

        Text("\(deadline.course) - Due \(deadline.formattedDate) at \(deadline.dueTime)")
          .font(.inter(size: compact ? 11 : 12))
          .foregroundColor(.black.opacity(0.7))
      }
      .frame(maxWidth: .infinity, alignment: .leading)

      VStack(alignment: .trailing, spacing: 2) {
        Text("\(deadline.daysLeft)")
          .font(.inter(size: compact ? 20 : 24, weight: .semibold))
          .foregroundColor(.black)

        Text("DAYS")
          .font(.inter(size: 10))
          .foregroundColor(.black)
          .tracking(0.2)
      }
    }
    .padding(.vertical, 12)
  }
}
