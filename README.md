# Jihati

Jihati adalah aplikasi panduan keislaman berbasis Flutter yang dirancang untuk memudahkan umat Muslim dalam mengakses berbagai konten ibadah harian, termasuk Al-Quran, bacaan jihati (wirid, shalawat, doa), dan jadwal shalat.

---

## Daftar Isi

- [Tentang Aplikasi](#tentang-aplikasi)
- [Fitur Utama](#fitur-utama)
- [Teknologi yang Digunakan](#teknologi-yang-digunakan)
- [Struktur Proyek](#struktur-proyek)
- [Cara Menjalankan](#cara-menjalankan)
- [Prasyarat](#prasyarat)
- [Lisensi](#lisensi)

---

## Tentang Aplikasi

Jihati hadir sebagai panduan digital keislaman yang mudah digunakan. Aplikasi ini menyediakan konten berupa teks Arab beserta transliterasi Latin untuk berbagai bacaan ibadah yang umum digunakan dalam tradisi Islam, khususnya lingkungan pesantren dan Nahdlatul Ulama (NU). Seluruh data tersimpan secara lokal sehingga dapat diakses tanpa koneksi internet.

---

## Fitur Utama

### Al-Quran
- Daftar 114 surah lengkap dengan nama Arab, translasi, dan jumlah ayat
- Tampilan ayat dengan font Arab khusus (LPMQ-IsepMisbah, OmarNaskh)
- Pencarian surah berdasarkan nama
- Navigasi antar surah

### Jihati (Bacaan Ibadah)
Lebih dari 60 konten bacaan ibadah, antara lain:
- Tawassul dan Tawassul Bin Nadham
- Surat-surat pilihan: Yasin, Al-Waqi'ah, As-Sajdah, Ad-Dukhan, Al-Mulk, Al-Jinn, Al-Kahf, Ar-Rahman
- Ratib Al-Haddad
- Asmaul Husna dan Mandhumat Asmaul Husna
- Berbagai shalawat: Nariyah, Munjiyat, Kubra, Al-Fatih, Tibbiyah, Azhimiyah
- Tahlil
- Dzikir setelah shalat (sirriyah dan jahriyah)
- Qasidah Burdah dan Maulid Barzanji
- Aqidatul Awam
- Istighatsah
- Bilal shalat Jumat, Tarawih, dan Aidain
- Dan masih banyak lagi

### Penanda dan Riwayat
- Simpan bacaan favorit ke daftar Bookmark
- Pantau riwayat bacaan yang telah dibuka

### Pengaturan
- Dukungan tema terang dan gelap (Light/Dark Mode)
- Preferensi tampilan ukuran teks bacaan

### Onboarding
- Tampilan perkenalan aplikasi saat pertama kali digunakan

---

## Teknologi yang Digunakan

| Teknologi | Keterangan |
|-----------|------------|
| Flutter | Framework utama pengembangan aplikasi |
| Dart | Bahasa pemrograman |
| GetX | State management, routing, dan dependency injection |
| GetStorage | Penyimpanan lokal (local storage) |
| flutter_svg | Render aset SVG |
| flutter_lucide | Ikon antarmuka |
| lottie | Animasi Lottie |
| share_plus | Berbagi konten |
| url_launcher | Membuka tautan eksternal |
| intl | Internalisasi dan format tanggal |

---

## Struktur Proyek

```
lib/
├── main.dart                   # Entry point aplikasi
├── app/
│   ├── bindings/               # Dependency injection (GetX)
│   ├── controllers/            # Controller global (tema, tab)
│   ├── data/                   # Data source lokal
│   ├── models/                 # Model data
│   ├── modules/                # Modul fitur
│   │   ├── onboarding/         # Layar onboarding
│   │   ├── introduction/       # Layar intro/splash
│   │   ├── main_navigation/    # Navigasi utama (bottom bar)
│   │   ├── quran/              # Daftar surah Al-Quran
│   │   ├── quran-detail/       # Detail surah dan ayat
│   │   ├── jihati/             # Daftar bacaan jihati
│   │   ├── jihati-detail/      # Detail bacaan jihati
│   │   ├── bookmark/           # Daftar bookmark
│   │   ├── history/            # Riwayat bacaan
│   │   ├── setting/            # Halaman pengaturan
│   │   ├── aboutme/            # Halaman tentang pembuat
│   │   └── accountme/          # Halaman akun
│   ├── routes/                 # Konfigurasi routing
│   ├── services/               # Layanan penyimpanan lokal
│   └── widgets/                # Widget yang dapat digunakan ulang
assets/
├── data/
│   ├── alquran/                # Data ayat dan daftar surah (JSON)
│   ├── jihati/                 # Konten bacaan jihati (JSON, 60+ file)
│   └── location/               # Data lokasi
├── fonts/                      # Font Arab dan Latin kustom
├── images/                     # Ikon dan ilustrasi
└── lottie/                     # Animasi Lottie
```

---

## Prasyarat

Pastikan lingkungan pengembangan telah terpasang:

- [Flutter SDK](https://flutter.dev/docs/get-started/install) versi `^3.8.1` atau lebih baru
- Dart SDK (sudah termasuk dalam Flutter SDK)
- Android Studio / VS Code dengan ekstensi Flutter

---

## Cara Menjalankan

1. Clone repositori ini:
   ```bash
   git clone https://github.com/username/jihati.git
   cd jihati
   ```

2. Install dependensi:
   ```bash
   flutter pub get
   ```

3. Jalankan aplikasi:
   ```bash
   flutter run
   ```

4. Untuk melakukan build APK:
   ```bash
   flutter build apk --release
   ```

---

## Lisensi

Proyek ini dilisensikan di bawah [Lisensi MIT](LICENSE).  
Bebas digunakan, dimodifikasi, dan didistribusikan dengan tetap mencantumkan atribusi kepada penulis asli.

---

> README ini juga tersedia dalam [Bahasa Inggris](README.en.md).
