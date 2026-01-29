"use client";

import { useState } from "react";

type Deadline = {
  title: string;
  course: string;
  due: string;
  time: string;
  daysLeft: number;
};

const deadlines: Deadline[] = [
  {
    title: "Senior thesis draft",
    course: "ENGL 492",
    due: "Mar 12",
    time: "11:59 PM",
    daysLeft: 18,
  },
  {
    title: "Algorithms problem set 6",
    course: "CPSC 323",
    due: "Mar 18",
    time: "11:59 PM",
    daysLeft: 24,
  },
  {
    title: "Modern history proposal",
    course: "HIST 375",
    due: "Mar 24",
    time: "5:00 PM",
    daysLeft: 30,
  },
  {
    title: "Final seminar presentation",
    course: "SENR 410",
    due: "Apr 02",
    time: "9:00 AM",
    daysLeft: 39,
  },
];

function DeadlineRow({
  item,
  compact = false,
}: {
  item: Deadline;
  compact?: boolean;
}) {
  return (
    <div className="flex items-center justify-between gap-4 py-3">
      <div className="min-w-0">
        <p className={`font-medium ${compact ? "text-xs" : "text-sm"}`}>
          {item.title}
        </p>
        <p
          className={`text-black/70 ${compact ? "text-[11px]" : "text-xs"}`}
        >
          {item.course} - Due {item.due} at {item.time}
        </p>
      </div>
      <div className="text-right">
        <p className={`${compact ? "text-xl" : "text-2xl"} font-semibold`}>
          {item.daysLeft}
        </p>
        <p className="text-[10px] uppercase tracking-[0.2em]">days</p>
      </div>
    </div>
  );
}

export default function PrivacyCountdownWidgetPage() {
  const [isRevealed, setIsRevealed] = useState(false);

  const handleToggleReveal = () => {
    setIsRevealed((prev) => !prev);
  };

  const mostPressing = deadlines[0];

  return (
    <div
      className="min-h-screen bg-white text-black"
      style={{ fontFamily: '"Enter", "Inter", "Arial", sans-serif' }}
    >
      <main className="mx-auto flex max-w-6xl flex-col gap-12 px-6 py-12">
        <header className="space-y-4">
          <p className="text-xs uppercase tracking-[0.2em]">
            Labs - Widget prototype
          </p>
          <h1 className="text-4xl font-semibold">Privacy Countdown Widget</h1>
          <p className="max-w-2xl text-sm text-black/70">
            A minimalist black and white widget that pulls from a dedicated
            Google Calendar of critical deadlines. Countdown details stay
            blurred by default and reveal on press, so you can keep important
            dates hidden until you want the signal.
          </p>
        </header>

        <section className="grid gap-10 lg:grid-cols-[1fr_1.2fr]">
          <div className="space-y-6">
            <div className="border border-black p-6">
              <div className="flex items-center justify-between">
                <h2 className="text-lg font-semibold">First-time setup</h2>
                <span className="text-xs uppercase tracking-[0.2em] text-black/70">
                  Read-only
                </span>
              </div>
              <ol className="mt-4 space-y-3 text-sm text-black/80">
                <li className="flex gap-3">
                  <span className="w-5 text-black/60">1.</span>
                  <span>Connect Google Calendar and grant read-only access.</span>
                </li>
                <li className="flex gap-3">
                  <span className="w-5 text-black/60">2.</span>
                  <span>Select your Yale assignment deadlines calendar.</span>
                </li>
                <li className="flex gap-3">
                  <span className="w-5 text-black/60">3.</span>
                  <span>Choose widget sizes and the default blur behavior.</span>
                </li>
              </ol>

              <div className="mt-6 space-y-3 text-sm">
                <div className="flex items-center justify-between border border-black px-3 py-2">
                  <span>Calendar connection</span>
                  <button
                    type="button"
                    className="border border-black px-3 py-1 text-xs uppercase tracking-[0.2em]"
                  >
                    Connect
                  </button>
                </div>
                <div className="border border-black px-3 py-2">
                  <p className="text-xs uppercase tracking-[0.2em] text-black/70">
                    Active calendar
                  </p>
                  <p className="mt-1 text-sm">Yale Deadlines - Final Semester</p>
                </div>
              </div>
            </div>

            <div className="border border-black p-6">
              <h2 className="text-lg font-semibold">Widget behavior</h2>
              <div className="mt-4 space-y-3 text-sm">
                <div className="flex items-center justify-between border border-black px-3 py-2">
                  <span>Blur countdowns by default</span>
                  <span className="text-black/70">On</span>
                </div>
                <div className="flex items-center justify-between border border-black px-3 py-2">
                  <span>Reveal on press</span>
                  <span className="text-black/70">Enabled</span>
                </div>
                <div className="flex items-center justify-between border border-black px-3 py-2">
                  <span>Home screen behavior</span>
                  <span className="text-black/70">Next deadline only</span>
                </div>
                <div className="flex items-center justify-between border border-black px-3 py-2">
                  <span>Font</span>
                  <span className="text-black/70">Enter</span>
                </div>
              </div>
              <p className="mt-4 text-sm text-black/70">
                Widgets are minimal: black and white, no gradients, no shadows,
                and no distracting decoration.
              </p>
            </div>
          </div>

          <div className="space-y-6">
            <div>
              <h2 className="text-lg font-semibold">Widget previews</h2>
              <p className="mt-2 text-sm text-black/70">
                Tap the macOS widget to reveal or hide the countdowns. iOS home
                screen widgets show only the next deadline without a reveal
                state.
              </p>
            </div>

            <button
              type="button"
              onClick={handleToggleReveal}
              aria-pressed={isRevealed}
              className="w-full border border-black bg-white p-5 text-left"
            >
              <div className="flex items-center justify-between text-xs uppercase tracking-[0.2em]">
                <span>macOS large widget</span>
                <span>{isRevealed ? "Revealed" : "Hidden"}</span>
              </div>
              <div
                className={`mt-4 divide-y divide-black ${
                  isRevealed ? "" : "blur-sm select-none"
                }`}
              >
                {deadlines.map((item) => (
                  <DeadlineRow key={item.title} item={item} />
                ))}
              </div>
              <div className="mt-4 flex items-center justify-between text-xs uppercase tracking-[0.2em]">
                <span>{isRevealed ? "Tap to hide" : "Tap to reveal"}</span>
                <span className="border border-black px-3 py-1">
                  {isRevealed ? "Hide" : "Reveal"}
                </span>
              </div>
            </button>

            <div className="grid gap-6 md:grid-cols-2">
              <div className="border border-black bg-white p-4">
                <div className="flex items-center justify-between text-xs uppercase tracking-[0.2em]">
                  <span>iOS medium widget</span>
                  <span>Home screen</span>
                </div>
                <div className="mt-3 divide-y divide-black">
                  {deadlines.slice(0, 2).map((item) => (
                    <DeadlineRow key={item.title} item={item} compact />
                  ))}
                </div>
                <p className="mt-3 text-xs text-black/70">
                  Keeps the list short and focused.
                </p>
              </div>

              <div className="border border-black bg-white p-4">
                <p className="text-xs uppercase tracking-[0.2em]">
                  iOS small widget
                </p>
                <div className="mt-4 flex items-end justify-between gap-3">
                  <div className="min-w-0">
                    <p className="text-sm font-medium">{mostPressing.title}</p>
                    <p className="mt-1 text-xs text-black/70">
                      Due {mostPressing.due} at {mostPressing.time}
                    </p>
                  </div>
                  <div className="text-right">
                    <p className="text-3xl font-semibold">
                      {mostPressing.daysLeft}
                    </p>
                    <p className="text-[10px] uppercase tracking-[0.2em]">
                      days
                    </p>
                  </div>
                </div>
                <p className="mt-4 text-xs text-black/70">
                  Always visible for quick access.
                </p>
              </div>
            </div>
          </div>
        </section>
      </main>
    </div>
  );
}
