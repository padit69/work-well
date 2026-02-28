
<a href="https://unikorn.vn/p/work-well?ref=embed" target="_blank"><img src="https://unikorn.vn/api/widgets/badge/work-well?theme=light" alt="WorkWell on Unikorn.vn" style="width: 256px; height: 64px;" width="256" height="64" /></a>

# WorkWell – Healthy Work Reminder

[![Build](https://github.com/padit69/work-well/actions/workflows/build.yml/badge.svg)](https://github.com/padit69/work-well/actions/workflows/build.yml)
[![Release](https://github.com/padit69/work-well/actions/workflows/release.yml/badge.svg)](https://github.com/padit69/work-well/actions/workflows/release.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

**WorkWell** is a macOS app that helps you work more healthily by reminding you to drink water, rest your eyes (20–20–20 rule), and take short movement breaks. Designed for desk workers, developers, designers, and students.

---

## 🌟 Why WorkWell?

- **Full-screen reminders** — Modern, Minimal, or Bold overlay so you can’t miss a break; optional per-reminder background (clear/blur/solid) and accent color, with live preview.
- **Focus mode** — Optional countdown before “I drank” / “Skip” / “Done” so you actually take the break instead of dismissing it.
- **Smart hydration** — Daily water goal auto-calculated from weight and gender; log by glass (200/250 ml or oz); 7-day chart and today’s total on the dashboard.
- **Respects your schedule** — Work hours and lunch break; reminders only during work time.


---

## ✨ Features

| Feature | Description |
|--------|-------------|
| 💧 **Drink water** | **Auto daily goal** from weight & gender (optional override). Reminders every **5–60 min** (step 5). Log by glass (200/250 ml or oz). **7-day chart** and today’s total in the **dashboard**. **Focus action**: optional countdown (10–100 sec) before “I drank” / “Skip”. |
| 👀 **Eye rest (20–20–20)** | Look 20 feet away for 20 seconds. Reminders every **5–60 min**. **Configurable countdown** (10–60 sec). **Silent mode** (no sound). **Focus action**: Skip disabled until countdown ends. Per-reminder style (background + accent color) and **preview** in settings. |
| 🚶 **Stand up & move** | Reminders every **15–60 min**. **Random suggestions**: stretch back, neck roll, or walk. **“In a meeting”** snooze (5/10/15 min). **Focus action**: optional countdown before “Done” / “In a meeting”. Same customizable full-screen style and preview. |
| 📊 **Dashboard & streak** | **Today at a glance**: water (ml + glasses), eye rest completed, movement completed. **Current streak** — consecutive days with at least one activity (water, eye rest, or movement). |

### Settings (overview)

- **General** — Work hours (start/end), lunch break; dashboard with today’s stats and streak.
- **Reminders** — Enable/disable each type; intervals (water & eye 5–60 min, movement 15–60 min); **full-screen reminder** on/off; banner, sound, haptic; snooze 5/10/15 min; **reminder style** (Modern / Minimal / Bold); **preview** buttons for each type.
- **Water** — Weight (kg), gender, unit (ml/oz), default glass (200/250 ml); focus action + min countdown; full-screen style (background + primary color).
- **Eye rest** — Countdown (10–60 sec), silent mode; focus action; full-screen style + preview.
- **Movement** — Random suggestion on/off; focus action + min countdown; full-screen style + preview.
- **Appearance** — Theme (Light/Dark/System), language (English/Tiếng Việt), minimal mode.
- **About** — Version, build, **Check for Updates** (GitHub), short description, privacy note.

### Permissions & privacy

- Only **Notification** permission is requested.
- Data is stored **locally** on your device; no sensitive data collection by default.

---

## 📋 Requirements

- **macOS** 14.0 (Sonoma) or later
- **Xcode** 15+ (only when building from source)

---

## 🚀 Installation

### Option 1: Download release (recommended)

1. Go to [Releases](https://github.com/padit69/work-well/releases).
2. Download the latest **WorkWell-vX.X.X.dmg** (or `.zip`).
3. Open the DMG and drag **WorkWell.app** to **Applications**.
4. Run the app; on first launch you may need to allow it in **System Settings → Privacy & Security**.

### Option 2: Build from source

```bash
# Clone repo
git clone https://github.com/padit69/work-well.git
cd work-well

# Build with script (recommended)
./scripts/test-build.sh

# Or build manually
cd WorkWell
xcodebuild \
  -project WorkWell.xcodeproj \
  -scheme WorkWell \
  -configuration Release \
  -derivedDataPath ./build \
  build
```

The built app will be at: `WorkWell/build/Build/Products/Release/WorkWell.app`.

---

## 🛠️ Tech Stack

| Component | Technology |
|-----------|------------|
| **Platform** | macOS (SwiftUI) |
| **Language** | Swift |
| **Storage** | Local (UserDefaults / file) |
| **Notifications** | Local Notifications |
| **CI/CD** | GitHub Actions (build, release, DMG) |

---

## 📁 Project structure

```
work-well/
├── WorkWell/                    # Xcode project
│   ├── WorkWell.xcodeproj
│   └── WorkWell/               # Source code (SwiftUI)
│       ├── Core/
│       ├── Features/
│       ├── Models/
│       ├── Services/
│       └── ...
├── scripts/
│   ├── test-build.sh              # Quick build check
│   ├── release.sh                 # Create release (tag, notes)
│   └── create-dmg.sh              # Create DMG file
├── .github/workflows/
│   ├── build.yml                  # CI: build on push/PR
│   ├── release.yml                # Release: build + DMG on tag v*
│   └── pr-check.yml               # PR checks
├── README.md
├── LICENSE
└── CONTRIBUTING.md                # Contribution guide (if present)
```

---

## 🔐 Signing & notarization (for maintainers)

To avoid **"damaged and can't be opened"** for users, enable **code signing** and **notarization** in CI. See the full guide: [docs/SIGNING.md](docs/SIGNING.md).

---

## 🤝 Contributing

Contributions are welcome (bug reports, feature ideas, pull requests). To contribute code:

1. **Fork** the repo and create a branch from `main` (e.g. `feature/your-feature` or `fix/issue-123`).
2. Ensure the project builds: run `./scripts/test-build.sh`.
3. Open a **Pull Request** to `main` with a clear description and (if applicable) link to the issue.

If the repo has **CONTRIBUTING.md**, please read it for more details.

---

## 📄 License

This project is under the **MIT License**. See [LICENSE](LICENSE).

---

## 🗺️ Roadmap (suggested)

- ⏱ Pomodoro mode
- 🧍 Posture reminders
- ⌚ Apple Watch / Wear OS
- 💤 Sleep & rest reminders

---

## 📜 Changelog

Notable changes are listed in [Releases](https://github.com/padit69/work-well/releases). Versions follow [Semantic Versioning](https://semver.org/) (e.g. `v1.0.0`, `v1.1.0`).

---

**WorkWell** – Stay healthy every day while working at your computer. 💧👀🚶
