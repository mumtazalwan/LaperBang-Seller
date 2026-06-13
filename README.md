# 🚀 LaperBang Seller Application

Repository ini berisi source code untuk aplikasi mobile **LaperBang Seller**. Proyek ini dibangun menggunakan framework Flutter untuk memenuhi kebutuhan para penjual (seller) di platform LaperBang dalam mengelola toko, menerima pesanan, fitur chat real-time, serta pelacakan lokasi berbasis peta.

📂 Struktur Proyek

```text
laperbang_seller/
├── android/          # File konfigurasi dan build khusus platform Android
├── ios/              # File konfigurasi dan build khusus platform iOS
├── lib/              # Kode sumber utama aplikasi (Dart)
│   ├── Models/       # Model data (e.g., auth_model.dart)
│   ├── Pages/        # Halaman antarmuka/UI (login, register, home, map, chat, dll.)
│   ├── Services/     # State Management & Provider logika (auth, chat, seller provider)
│   ├── Widget/       # Komponen UI yang dapat digunakan kembali (reusable widgets)
│   └── main.dart     # Titik masuk utama (entry point) aplikasi Flutter
├── test/             # Skrip pengujian aplikasi (unit & widget test)
├── pubspec.yaml      # File konfigurasi proyek, aset, dan daftar dependensi paket
└── README.md         # Dokumentasi proyek
```

🛠️ Prasyarat (Prerequisites)

Sebelum menjalankan proyek ini di komputermu, pastikan kamu sudah menginstal:
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Versi kompatibel dengan Dart SDK ^3.8.1)
- [Dart SDK](https://dart.dev/get-started/sdk)
- Android Studio / Xcode (untuk menjalankan Emulator/Simulator)
- VS Code atau IntelliJ IDEA yang sudah terpasang ekstensi Flutter & Dart

💻 Panduan Instalasi & Menjalankan Proyek

Ikuti langkah-langkah di bawah ini untuk melakukan setup lingkungan pengembangan lokal dan menjalankan aplikasi.

Langkah 1: Clone Repository
```bash
https://github.com/mumtazalwan/LaperBang-Seller.git
cd LaperBang-47ae905394b8c9dad0dfe86d1a3dde437a7ecaf2
```

Langkah 2: Setup & Install Dependencies ⚙️
Pastikan koneksi internet stabil, lalu unduh semua package dependensi yang terdaftar di dalam file `pubspec.yaml` dengan menjalankan perintah berikut di terminal:
```bash
flutter pub get
```

Langkah 3: Jalankan Aplikasi 📱
1. Pastikan perangkat fisik (HP) dengan USB Debugging aktif atau Emulator/Simulator sudah berjalan di komputermu. Kamu bisa memverifikasinya dengan perintah:
   ```bash
   flutter devices
   ```
2. Jika perangkat sudah terdeteksi, jalankan aplikasi ke perangkat target dengan perintah:
   ```bash
   flutter run
   ```
3. Pilih perangkat yang sesuai, tunggu proses kompilasi selesai, dan aplikasi akan langsung terbuka di layar perangkatmu! 🎉

✨ Fitur & Teknologi

- **Core Framework & Language:** Flutter, Dart SDK (^3.8.1).
- **State Management:** Provider (`provider`) untuk pengelolaan state aplikasi yang reaktif.
- **Maps & Geolocation:** `flutter_map` untuk integrasi peta, `latlong2` untuk koordinat, dan `geolocator` untuk melacak lokasi GPS secara real-time.
- **Responsive UI:** `flutter_screenutil` untuk adaptasi ukuran UI agar proporsional di berbagai ukuran layar device.
- **Local Storage:** `shared_preferences` untuk menyimpan data persisten ringan (seperti token auth atau session login).
