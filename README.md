# 🛒 Flutter Marketplace App

Aplikasi **Flutter Marketplace** adalah sebuah platform e-commerce mobile modern yang dibangun dengan mengedepankan performa, skalabilitas, dan pengalaman pengguna yang optimal. Aplikasi ini menggunakan **Clean Architecture** untuk memastikan kode yang maintainable, serta diintegrasikan dengan backend Golang melalui REST API dan Firebase untuk autentikasi yang aman.

## ✨ Fitur Utama

- 🔐 **Firebase Authentication**: Sistem login yang aman dan terpercaya.
- ✉️ **Email Verification**: Keamanan tambahan dengan verifikasi email saat registrasi.
- 👤 **Login & Register**: Alur autentikasi pengguna yang mulus.
- 🛍️ **Product Catalog**: Menampilkan daftar produk dengan tampilan grid yang responsif dan performa scroll yang optimal.
- 🔍 **Product Detail**: Halaman detail produk yang komprehensif.
- 🛒 **Shopping Cart**: Pengelolaan keranjang belanja yang dinamis.
- 💳 **Checkout**: Alur checkout yang terintegrasi.
- 🔄 **State Management**: Menggunakan `Provider` untuk manajemen state yang reaktif dan efisien.
- 🌐 **REST API Integration**: Komunikasi data yang cepat dengan backend Golang.
- 🏗️ **Clean Architecture**: Pemisahan logic untuk mempermudah testing dan pengembangan.

## 🛠️ Tech Stack

- **Frontend Framework**: Flutter
- **Language**: Dart
- **State Management**: Provider
- **Authentication**: Firebase Authentication
- **Network Client**: Dio
- **Backend API**: Golang (Go)
- **Database**: PostgreSQL
- **Design Pattern**: Clean Architecture

## 🏗️ Arsitektur Project

Project ini mengimplementasikan **Clean Architecture** untuk memisahkan *concern* ke dalam beberapa layer independen:
- **Presentation Layer**: Menangani UI dan State Management (Widget, Screen, Provider).
- **Domain Layer**: Menyimpan *Business Logic* murni (Entities, Repositories Interfaces, Usecases).
- **Data Layer**: Menangani pengambilan dan penyimpanan data (Models, Datasources, Repositories Implementations).

### Struktur Folder Utama
```text
lib/
├── core/         # Konfigurasi inti (Constants, Routes, Services, Theme)
├── features/     # Modul fitur-fitur aplikasi
├── main.dart     # Entry point aplikasi
└── firebase_options.dart
```

## 📂 Struktur Feature

Setiap fitur dalam folder `features/` (seperti `auth`, `cart`, `dashboard`) dipecah kembali berdasarkan lapisan arsitektur:

```text
features/
└── feature_name/
    ├── data/           # Datasources, Models, Repositories
    ├── domain/         # Entities, Repositories (Interface), Usecases
    └── presentation/   # Pages, Widgets, Providers
```

## 🚀 Instalasi dan Menjalankan Project

### Prasyarat
- Flutter SDK `^3.11.4` atau lebih baru
- Firebase Project
- Backend Service yang sedang berjalan

### Langkah-langkah

1. **Clone repository ini**
   ```bash
   git clone https://github.com/cendyal-hub/marketplace-flutter.git
   cd marketplace-flutter
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Konfigurasi Firebase**
   - Buat project di Firebase Console.
   - Jalankan `flutterfire configure` untuk men-generate file `firebase_options.dart`.
   - Pastikan Anda menambahkan file `google-services.json` (untuk Android) ke dalam `android/app/` dan `GoogleService-Info.plist` (untuk iOS) ke dalam `ios/Runner/`.

4. **Jalankan Backend**
   Pastikan backend API Golang Anda sudah berjalan dan dapat diakses. (Cek dokumentasi backend untuk cara menjalankannya).

5. **Jalankan aplikasi Flutter**
   ```bash
   flutter run
   ```

## ⚙️ Konfigurasi Environment

Aplikasi ini membutuhkan beberapa konfigurasi agar dapat berjalan dengan sempurna:
- **`firebase_options.dart`**: File hasil generate Firebase CLI untuk menghubungkan aplikasi dengan layanan Firebase.
- **`google-services.json`**: File credential Firebase untuk platform Android (jangan di-commit ke public repository).
- **Endpoint API Backend**: URL utama API backend perlu disesuaikan pada file konfigurasi jaringan (misal di `lib/core/constants/` atau service Dio) agar aplikasi dapat berkomunikasi dengan REST API.

## 📱 Demo Fitur (Alur Penggunaan)

Aplikasi dirancang dengan alur pengguna sebagai berikut:
1. **Register**: Pengguna baru mendaftarkan akun.
2. **Verifikasi Email**: Pengguna menerima email untuk verifikasi agar akun aktif.
3. **Login**: Masuk menggunakan kredensial yang telah diverifikasi. Backend akan memvalidasi Firebase token.
4. **Browse Catalog**: Pengguna melihat daftar produk (beranda/dashboard).
5. **Add to Cart**: Menambahkan produk pilihan dari katalog atau halaman detail ke keranjang. Notifikasi auto-dismiss akan muncul.
6. **Checkout**: Melakukan konfirmasi pesanan dari keranjang belanja.

## 🔄 State Management

Project ini sepenuhnya menggunakan **Provider** untuk mengelola state aplikasi:
- **Authentication**: `AuthProvider` mengelola status login, token session, dan proses verifikasi.
- **Catalog**: `ProductProvider` mengatur pengambilan data list produk dan detail produk dari API.
- **Cart**: `CartProvider` menyimpan daftar barang di keranjang, mengelola penambahan/pengurangan kuantitas, dan menghitung total harga secara *real-time*.
- **Checkout**: Mengelola status pengiriman pesanan ke backend.

## 🔌 API Integration

Komunikasi dengan backend ditangani secara profesional menggunakan **Dio**:
- **Dio Client**: Konfigurasi base URL, timeout, dan header default terpusat.
- **Authentication Interceptor**: Interceptor khusus untuk otomatis menyematkan Bearer token di setiap *request* yang membutuhkan autentikasi.
- **Firebase Token Verification**: Frontend mengirimkan ID Token Firebase ke backend Golang untuk validasi *session* yang ekstra aman.
- **Error Handling**: Penanganan response error secara global (seperti 401 Unauthorized, 404 Not Found, atau 500 Server Error) menjadi pesan UI yang ramah pengguna.

<!-- ## 📸 Screenshot

<div align="center">
  <img src="https://via.placeholder.com/200x400.png?text=Login+Screen" alt="Login Screen" width="200"/>
  <img src="https://via.placeholder.com/200x400.png?text=Register+Screen" alt="Register Screen" width="200"/>
  <img src="https://via.placeholder.com/200x400.png?text=Catalog+Screen" alt="Catalog Screen" width="200"/>
  <img src="https://via.placeholder.com/200x400.png?text=Cart+Screen" alt="Cart Screen" width="200"/>
  <img src="https://via.placeholder.com/200x400.png?text=Checkout+Screen" alt="Checkout Screen" width="200"/>
</div> -->

## 🎥 Video Demonstration

[![Marketplace Demo](https://youtu.be/BqcNfZU4iBA)


## 📦 Struktur Dependency (`pubspec.yaml`)

Beberapa library utama yang mendasari project ini:
- **`dio: ^5.9.2`**: HTTP client untuk REST API.
- **`provider: ^6.1.5`**: State management.
- **`firebase_auth: ^6.3.0` & `firebase_core: ^4.6.0`**: Layanan autentikasi Firebase.
- **`google_sign_in: ^6.2.2`**: Plugin untuk login Google.
- **`flutter_secure_storage: ^10.0.0`**: Penyimpanan lokal terenkripsi untuk session token.
- **`equatable: ^2.0.5`**: Mempermudah komparasi *value* antar objek di Dart.
- **`email_validator: ^3.0.0`**: Validasi form input email.
- **`flutter_svg: ^2.2.4`**: Render asset berformat SVG.


