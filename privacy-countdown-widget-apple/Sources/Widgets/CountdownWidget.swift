import WidgetKit
import SwiftUI

struct CountdownWidget: Widget {
  let kind: String = "CountdownWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: CountdownTimelineProvider()) { entry in
      CountdownWidgetEntryView(entry: entry)
        .containerBackground(.white, for: .widget)
    }
    .configurationDisplayName("Privacy Countdown")
    .description("Shows countdown to your important deadlines with optional blur.")
    .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .systemExtraLarge])
  }
}

struct CountdownTimelineProvider: TimelineProvider {
  func placeholder(in context: Context) -> CountdownEntry {
    CountdownEntry(date: Date(), deadlines: sampleDeadlines(), isRevealed: false)
  }

  func getSnapshot(in context: Context, completion: @escaping (CountdownEntry) -> Void) {
    let entry = CountdownEntry(
      date: Date(),
      deadlines: loadDeadlines(),
      isRevealed: WidgetSettings.isRevealed
    )
    completion(entry)
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<CountdownEntry>) -> Void) {
    let entry = CountdownEntry(
      date: Date(),
      deadlines: loadDeadlines(),
      isRevealed: WidgetSettings.isRevealed
    )

    let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
    let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
    completion(timeline)
  }

  private func loadDeadlines() -> [Deadline] {
    let calendar = Calendar.current
    let now = Date()

    return [
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

  private func sampleDeadlines() -> [Deadline] {
    loadDeadlines()
  }
}

struct CountdownEntry: TimelineEntry {
  let date: Date
  let deadlines: [Deadline]
  let isRevealed: Bool
}

struct CountdownWidgetEntryView: View {
  var entry: CountdownTimelineProvider.Entry
  @Environment(\.widgetFamily) var family

  var body: some View {
    switch family {
    case .systemSmall:
      SmallWidgetView(entry: entry)
    case .systemMedium:
      MediumWidgetView(entry: entry)
    case .systemLarge, .systemExtraLarge:
      LargeWidgetView(entry: entry)
    default:
      SmallWidgetView(entry: entry)
    }
  }
}

struct SmallWidgetView: View {
  let entry: CountdownEntry

  var body: some View {
    if let mostPressing = entry.deadlines.sorted(by: { $0.daysLeft < $1.daysLeft }).first {
      VStack(alignment: .leading, spacing: 12) {
        HStack(alignment: .bottom, spacing: 12) {
          VStack(alignment: .leading, spacing: 4) {
            Text(mostPressing.title)
              .font(.inter(size: 14, weight: .medium))
              .foregroundColor(.black)
              .lineLimit(2)

            Text("Due \(mostPressing.formattedDate) at \(mostPressing.dueTime)")
              .font(.inter(size: 12))
              .foregroundColor(.black.opacity(0.7))
              .lineLimit(1)
          }
          .frame(maxWidth: .infinity, alignment: .leading)

          VStack(alignment: .trailing, spacing: 2) {
            Text("\(mostPressing.daysLeft)")
              .font(.inter(size: 28, weight: .semibold))
              .foregroundColor(.black)

            Text("DAYS")
              .font(.inter(size: 10))
              .foregroundColor(.black)
              .tracking(0.2)
          }
        }
      }
      .padding(16)
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
  }
}

struct MediumWidgetView: View {
  let entry: CountdownEntry

  var body: some View {
    let sortedDeadlines = entry.deadlines.sorted { $0.daysLeft < $1.daysLeft }
    let displayDeadlines = Array(sortedDeadlines.prefix(2))

    VStack(alignment: .leading, spacing: 0) {
      ForEach(Array(displayDeadlines.enumerated()), id: \.element.id) { index, deadline in
        DeadlineRow(deadline: deadline, compact: true)
        if index < displayDeadlines.count - 1 {
          Divider()
            .background(Color.black)
        }
      }
    }
    .padding(16)
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
  }
}

struct LargeWidgetView: View {
  let entry: CountdownEntry

  var body: some View {
    let sortedDeadlines = entry.deadlines.sorted { $0.daysLeft < $1.daysLeft }

    VStack(alignment: .leading, spacing: 0) {
      HStack {
        Text("PRIVACY COUNTDOWN")
          .font(.inter(size: 12))
          .foregroundColor(.black)
          .tracking(0.2)

        Spacer()

        Text(entry.isRevealed ? "Revealed" : "Hidden")
          .font(.inter(size: 12))
          .foregroundColor(.black)
          .tracking(0.2)
      }
      .padding(.bottom, 16)

      VStack(spacing: 0) {
        ForEach(Array(sortedDeadlines.enumerated()), id: \.element.id) { index, deadline in
          DeadlineRow(deadline: deadline)
          if index < sortedDeadlines.count - 1 {
            Divider()
              .background(Color.black)
          }
        }
      }
      .blur(radius: entry.isRevealed ? 0 : 4)
      .allowsHitTesting(false)

      Spacer()

      HStack {
        Text(entry.isRevealed ? "Tap to hide" : "Tap to reveal")
          .font(.inter(size: 12))
          .foregroundColor(.black)
          .tracking(0.2)

        Spacer()

        Button(intent: ToggleRevealIntent()) {
          Text(entry.isRevealed ? "Hide" : "Reveal")
            .font(.inter(size: 12))
            .foregroundColor(.black)
            .tracking(0.2)
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .border(Color.black, width: 1)
        }
        .buttonStyle(.plain)
      }
      .padding(.top, 16)
    }
    .padding(20)
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
  }
}

struct CountdownWidget_Previews: PreviewProvider {
  static var previews: some View {
    CountdownWidgetEntryView(entry: CountdownEntry(
      date: Date(),
      deadlines: [],
      isRevealed: false
    ))
    .previewContext(WidgetPreviewContext(family: .systemLarge))
  }
}
