import SwiftUI

struct ContentView: View {
  @EnvironmentObject var deadlineStore: DeadlineStore
  @State private var isRevealed = WidgetSettings.isRevealed

  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(alignment: .leading, spacing: 48) {
          headerSection

          HStack(alignment: .top, spacing: 24) {
            settingsSection
            widgetPreviewsSection
          }
        }
        .padding(24)
      }
      .background(Color.white)
      .navigationBarTitleDisplayMode(.inline)
    }
  }

  private var headerSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("LABS - WIDGET PROTOTYPE")
        .font(.inter(size: 12))
        .foregroundColor(.black)
        .tracking(0.2)

      Text("Privacy Countdown Widget")
        .font(.inter(size: 36, weight: .semibold))
        .foregroundColor(.black)

      Text("A minimalist black and white widget that pulls from a dedicated Google Calendar of critical deadlines. Countdown details stay blurred by default and reveal on press, so you can keep important dates hidden until you want the signal.")
        .font(.inter(size: 14))
        .foregroundColor(.black.opacity(0.7))
        .frame(maxWidth: 600, alignment: .leading)
    }
  }

  private var settingsSection: some View {
    VStack(alignment: .leading, spacing: 24) {
      setupCard
      behaviorCard
    }
    .frame(maxWidth: 400)
  }

  private var setupCard: some View {
    VStack(alignment: .leading, spacing: 16) {
      HStack {
        Text("First-time setup")
          .font(.inter(size: 18, weight: .semibold))
          .foregroundColor(.black)

        Spacer()

        Text("READ-ONLY")
          .font(.inter(size: 12))
          .foregroundColor(.black.opacity(0.7))
          .tracking(0.2)
      }

      VStack(alignment: .leading, spacing: 12) {
        setupStep(number: 1, text: "Connect Google Calendar and grant read-only access.")
        setupStep(number: 2, text: "Select your Yale assignment deadlines calendar.")
        setupStep(number: 3, text: "Choose widget sizes and the default blur behavior.")
      }
      .font(.inter(size: 14))
      .foregroundColor(.black.opacity(0.8))

      Divider()
        .background(Color.black)

      VStack(spacing: 12) {
        HStack {
          Text("Calendar connection")
            .font(.inter(size: 14))
            .foregroundColor(.black)

          Spacer()

          Button("Connect") {
            WidgetSettings.calendarConnected = true
            WidgetSettings.calendarName = "Yale Deadlines - Final Semester"
          }
          .font(.inter(size: 12))
          .foregroundColor(.black)
          .tracking(0.2)
          .padding(.horizontal, 12)
          .padding(.vertical, 4)
          .border(Color.black, width: 1)
        }
        .padding(12)
        .border(Color.black, width: 1)

        VStack(alignment: .leading, spacing: 4) {
          Text("ACTIVE CALENDAR")
            .font(.inter(size: 12))
            .foregroundColor(.black.opacity(0.7))
            .tracking(0.2)

          Text(WidgetSettings.calendarConnected ? WidgetSettings.calendarName : "Not connected")
            .font(.inter(size: 14))
            .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .border(Color.black, width: 1)
      }
    }
    .padding(24)
    .border(Color.black, width: 1)
  }

  private func setupStep(number: Int, text: String) -> some View {
    HStack(alignment: .top, spacing: 12) {
      Text("\(number).")
        .font(.inter(size: 14))
        .foregroundColor(.black.opacity(0.6))
        .frame(width: 20, alignment: .leading)

      Text(text)
        .font(.inter(size: 14))
        .foregroundColor(.black.opacity(0.8))
    }
  }

  private var behaviorCard: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Widget behavior")
        .font(.inter(size: 18, weight: .semibold))
        .foregroundColor(.black)

      VStack(spacing: 12) {
        behaviorRow(label: "Blur countdowns by default", value: "On")
        behaviorRow(label: "Reveal on press", value: "Enabled")
        behaviorRow(label: "Home screen behavior", value: "Next deadline only")
        behaviorRow(label: "Font", value: "Inter")
      }

      Text("Widgets are minimal: black and white, no gradients, no shadows, and no distracting decoration.")
        .font(.inter(size: 14))
        .foregroundColor(.black.opacity(0.7))
    }
    .padding(24)
    .border(Color.black, width: 1)
  }

  private func behaviorRow(label: String, value: String) -> some View {
    HStack {
      Text(label)
        .font(.inter(size: 14))
        .foregroundColor(.black)

      Spacer()

      Text(value)
        .font(.inter(size: 14))
        .foregroundColor(.black.opacity(0.7))
    }
    .padding(12)
    .border(Color.black, width: 1)
  }

  private var widgetPreviewsSection: some View {
    VStack(alignment: .leading, spacing: 24) {
      VStack(alignment: .leading, spacing: 8) {
        Text("Widget previews")
          .font(.inter(size: 18, weight: .semibold))
          .foregroundColor(.black)

        Text("Tap the macOS widget to reveal or hide the countdowns. iOS home screen widgets show only the next deadline without a reveal state.")
          .font(.inter(size: 14))
          .foregroundColor(.black.opacity(0.7))
      }

      macWidgetPreview
      iosWidgetPreviews
    }
    .frame(maxWidth: .infinity)
  }

  private var macWidgetPreview: some View {
    Button {
      isRevealed.toggle()
      WidgetSettings.isRevealed = isRevealed
    } label: {
      VStack(alignment: .leading, spacing: 16) {
        HStack {
          Text("MACOS LARGE WIDGET")
            .font(.inter(size: 12))
            .foregroundColor(.black)
            .tracking(0.2)

          Spacer()

          Text(isRevealed ? "Revealed" : "Hidden")
            .font(.inter(size: 12))
            .foregroundColor(.black)
            .tracking(0.2)
        }

        VStack(spacing: 0) {
          ForEach(deadlineStore.deadlines) { deadline in
            DeadlineRow(deadline: deadline)
            if deadline.id != deadlineStore.deadlines.last?.id {
              Divider()
                .background(Color.black)
            }
          }
        }
        .blur(radius: isRevealed ? 0 : 4)
        .allowsHitTesting(false)

        HStack {
          Text(isRevealed ? "Tap to hide" : "Tap to reveal")
            .font(.inter(size: 12))
            .foregroundColor(.black)
            .tracking(0.2)

          Spacer()

          Text(isRevealed ? "Hide" : "Reveal")
            .font(.inter(size: 12))
            .foregroundColor(.black)
            .tracking(0.2)
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .border(Color.black, width: 1)
        }
      }
      .padding(20)
      .frame(maxWidth: .infinity, alignment: .leading)
      .border(Color.black, width: 1)
      .background(Color.white)
    }
    .buttonStyle(.plain)
  }

  private var iosWidgetPreviews: some View {
    HStack(spacing: 24) {
      iosMediumWidget
      iosSmallWidget
    }
  }

  private var iosMediumWidget: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack {
        Text("IOS MEDIUM WIDGET")
          .font(.inter(size: 12))
          .foregroundColor(.black)
          .tracking(0.2)

        Spacer()

        Text("Home screen")
          .font(.inter(size: 12))
          .foregroundColor(.black)
          .tracking(0.2)
      }

      VStack(spacing: 0) {
        ForEach(Array(deadlineStore.deadlines.prefix(2))) { deadline in
          DeadlineRow(deadline: deadline, compact: true)
          if deadline.id != deadlineStore.deadlines.prefix(2).last?.id {
            Divider()
              .background(Color.black)
          }
        }
      }

      Text("Keeps the list short and focused.")
        .font(.inter(size: 12))
        .foregroundColor(.black.opacity(0.7))
    }
    .padding(16)
    .border(Color.black, width: 1)
    .background(Color.white)
  }

  private var iosSmallWidget: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("IOS SMALL WIDGET")
        .font(.inter(size: 12))
        .foregroundColor(.black)
        .tracking(0.2)

      if let mostPressing = deadlineStore.mostPressing {
        HStack(alignment: .bottom, spacing: 12) {
          VStack(alignment: .leading, spacing: 4) {
            Text(mostPressing.title)
              .font(.inter(size: 14, weight: .medium))
              .foregroundColor(.black)

            Text("Due \(mostPressing.formattedDate) at \(mostPressing.dueTime)")
              .font(.inter(size: 12))
              .foregroundColor(.black.opacity(0.7))
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

      Text("Always visible for quick access.")
        .font(.inter(size: 12))
        .foregroundColor(.black.opacity(0.7))
    }
    .padding(16)
    .border(Color.black, width: 1)
    .background(Color.white)
  }
}
