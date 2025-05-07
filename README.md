# Auto Sertif

<p align="center">
  <img src="assets/logo.png" alt="Auto Sertif Logo" width="100" height="100">
</p>

Auto Sertif adalah aplikasi pembuatan sertifikat yang memudahkan pengguna untuk membuat sertifikat profesional secara massal. Dengan tema gelap yang elegan dan efek gradien ungu/biru, aplikasi ini menyediakan pengalaman pengguna yang modern dan intuitif.

## Fitur Utama

- **Pemilihan Template**: Pilih template sertifikat dari galeri atau kamera
- **Kustomisasi Teks**: Atur posisi dan gaya teks dengan ukuran, warna, dan jenis font yang dapat disesuaikan
- **Input Data Individual**: Masukkan data peserta satu per satu dengan form yang sederhana
- **Pembuatan Sertifikat**: Buat sertifikat untuk semua peserta berdasarkan template dan pengaturan teks
- **Ekspor**: Kemas semua sertifikat yang dihasilkan ke dalam file ZIP dan simpan ke perangkat Anda

## Tangkapan Layar

*(Tangkapan layar akan ditambahkan di sini)*

## Unduh Aplikasi

Anda dapat mengunduh versi terbaru Auto Sertif dari halaman [Releases](https://github.com/gerrymoeis/auto_sertif/releases/latest).

Tersedia untuk:
- Android (.apk)
- Windows (.exe)

## Persyaratan Sistem

### Android
- Android 5.0 (API level 21) atau lebih tinggi
- Izin kamera dan penyimpanan

### Windows
- Windows 10 atau lebih tinggi

## Pengembangan

Auto Sertif dibangun dengan Flutter, menjadikannya kompatibel dengan berbagai platform.

### Dependensi

- `flutter`: SDK
- `image_picker`: Untuk memilih gambar dari galeri atau kamera
- `image`: Untuk pemrosesan dan manipulasi gambar
- `path_provider`: Untuk penanganan path
- `archive`: Untuk membuat arsip ZIP
- `flutter_colorpicker`: Untuk pemilihan warna di UI
- `google_fonts`: Untuk menggunakan font kustom
- `permission_handler`: Untuk menangani izin

### Persyaratan Pengembangan

Untuk mengembangkan atau membangun aplikasi dari source code, Anda memerlukan:

1. **Flutter SDK** (versi 3.19.0 atau lebih tinggi)
2. **Android Studio** (untuk pengembangan Android)
3. **Visual Studio 2022** dengan "Desktop development with C++" (untuk pengembangan Windows)
4. **Git** untuk clone repository

### Membangun dari Source Code

1. Clone repository:
   ```
   git clone https://github.com/gerrymoeis/auto_sertif.git
   ```

2. Masuk ke direktori proyek:
   ```
   cd auto_sertif
   ```

3. Instal dependensi:
   ```
   flutter pub get
   ```

4. Jalankan aplikasi dalam mode debug:
   ```
   flutter run
   ```

5. Build versi release (pastikan semua persyaratan terpenuhi):
   ```
   # Untuk Android
   flutter build apk --release
   
   # Untuk Windows
   flutter build windows --release
   ```

### Troubleshooting Build

Jika Anda mengalami masalah saat build:

#### Untuk Android:
- Pastikan Android SDK terinstal dan diperbarui
- Jalankan `flutter doctor` untuk memeriksa konfigurasi
- Jika ada masalah dengan shrinkResources, coba build dengan flag `--no-shrink`

#### Untuk Windows:
- Pastikan Visual Studio 2022 terinstal dengan "Desktop development with C++"
- Jalankan `flutter doctor` dan ikuti instruksi untuk memperbaiki masalah
- Pastikan Windows 10 SDK terinstal

## Lisensi

Proyek ini dilisensikan di bawah Lisensi MIT - lihat file LICENSE untuk detailnya.

## Ucapan Terima Kasih

- Terima kasih kepada semua kontributor yang telah membantu membuat proyek ini lebih baik
- Tim Flutter untuk framework yang luar biasa
