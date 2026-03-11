# Jihati

Jihati is a Flutter-based Islamic guidance application designed to help Muslims easily access various daily worship content, including the Al-Quran, Jihati readings (wirid, shalawat, supplications), and prayer schedules.

---

## Table of Contents

- [About](#about)
- [Key Features](#key-features)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [License](#license)

---

## About

Jihati is a digital Islamic guide built to be simple and easy to use. It provides Arabic text alongside Latin transliterations for a wide range of commonly practiced recitations, particularly those common in the pesantren (Islamic boarding school) tradition and Nahdlatul Ulama (NU) community. All data is stored locally, so the app works fully offline.

---

## Key Features

### Al-Quran
- Full list of 114 surahs with Arabic names, translations, and verse counts
- Arabic verse display using dedicated fonts (LPMQ-IsepMisbah, OmarNaskh)
- Surah search by name
- Navigation between surahs

### Jihati (Worship Readings)
More than 60 categories of Islamic recitations, including:
- Tawassul and Tawassul Bin Nadham
- Selected surahs: Yasin, Al-Waqi'ah, As-Sajdah, Ad-Dukhan, Al-Mulk, Al-Jinn, Al-Kahf, Ar-Rahman
- Ratib Al-Haddad
- Asmaul Husna and Mandhumat Asmaul Husna
- Various shalawat: Nariyah, Munjiyat, Kubra, Al-Fatih, Tibbiyah, Azhimiyah
- Tahlil
- Post-prayer dhikr (sirriyah and jahriyah)
- Qasidah Burdah and Maulid Barzanji
- Aqidatul Awam
- Istighatsah
- Bilal recitations for Jumat, Tarawih, and Eid prayers
- And many more

### Bookmarks and History
- Save favorite readings to a Bookmark list
- Track reading history of previously opened content

### Settings
- Light and Dark theme support
- Reading text size preferences

### Onboarding
- Introduction screen shown on first launch

---

## Tech Stack

| Technology | Description |
|------------|-------------|
| Flutter | Main application framework |
| Dart | Programming language |
| GetX | State management, routing, and dependency injection |
| GetStorage | Local storage persistence |
| flutter_svg | SVG asset rendering |
| flutter_lucide | UI icons |
| lottie | Lottie animation support |
| share_plus | Content sharing |
| url_launcher | External link handling |
| intl | Internationalization and date formatting |

---

## Project Structure

```
lib/
├── main.dart                   # Application entry point
├── app/
│   ├── bindings/               # GetX dependency injection
│   ├── controllers/            # Global controllers (theme, tabs)
│   ├── data/                   # Local data sources
│   ├── models/                 # Data models
│   ├── modules/                # Feature modules
│   │   ├── onboarding/         # Onboarding screen
│   │   ├── introduction/       # Intro/splash screen
│   │   ├── main_navigation/    # Main navigation (bottom bar)
│   │   ├── quran/              # Al-Quran surah list
│   │   ├── quran-detail/       # Surah and verse detail
│   │   ├── jihati/             # Jihati readings list
│   │   ├── jihati-detail/      # Jihati reading detail
│   │   ├── bookmark/           # Bookmarks list
│   │   ├── history/            # Reading history
│   │   ├── setting/            # Settings page
│   │   ├── aboutme/            # About the developer
│   │   └── accountme/          # Account page
│   ├── routes/                 # Route configuration
│   ├── services/               # Local storage services
│   └── widgets/                # Reusable widgets
assets/
├── data/
│   ├── alquran/                # Quran verse and surah data (JSON)
│   ├── jihati/                 # Jihati reading content (JSON, 60+ files)
│   └── location/               # Location data
├── fonts/                      # Custom Arabic and Latin fonts
├── images/                     # Icons and illustrations
└── lottie/                     # Lottie animations
```

---

## Prerequisites

Make sure the development environment is set up:

- [Flutter SDK](https://flutter.dev/docs/get-started/install) version `^3.8.1` or newer
- Dart SDK (included with the Flutter SDK)
- Android Studio or VS Code with the Flutter extension

---

## Getting Started

1. Clone this repository:
   ```bash
   git clone https://github.com/username/jihati.git
   cd jihati
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the application:
   ```bash
   flutter run
   ```

4. To build a release APK:
   ```bash
   flutter build apk --release
   ```

---

## License

This project is licensed under the [MIT License](LICENSE).  
Feel free to use, modify, and distribute it with appropriate attribution to the original author.

---

> This README is also available in [Bahasa Indonesia](README.md).
