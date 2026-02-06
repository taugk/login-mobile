# 🛡️ Coralis Auth - Flutter MVVM Documentation

Aplikasi Flutter dengan implementasi autentikasi lengkap menggunakan arsitektur **MVVM (Model-View-ViewModel)**. Mendukung alur registrasi, login, dan reset password menggunakan verifikasi token 5-digit.

---

## 🏗️ Arsitektur Proyek

Proyek ini menggunakan **Feature-First Layered Architecture** untuk memastikan pemisahan tanggung jawab yang jelas.

### Struktur Direktori

- **`lib/app/`**: Pengaturan rute (`routes.dart`) dan entry point aplikasi (`app.dart`).
- **`lib/core/`**: Infrastruktur dasar seperti `ApiService` (HTTP), `LocalStorage` (Shared Preferences), dan `AppConfig`.
- **`lib/features/`**: Folder berbasis fitur (Auth & Home). Setiap fitur memiliki Model, View, ViewModel, dan Repository sendiri.
- **`main.dart`**: Titik awal eksekusi aplikasi.

---

## 🚀 Fitur Utama

- **Authentication Flow**: Login & Register terintegrasi dengan backend.
- **Secure Recovery**: Reset password dengan alur: _Input Email_ -> _Verify 5-Digit Token_ -> _New Password_.
- **JWT Management**: Token disimpan otomatis di penyimpanan lokal setelah login berhasil.
- **Centralized Routing**: Navigasi menggunakan `onGenerateRoute` untuk penanganan argumen yang dinamis.
- **State Management**: Menggunakan `ChangeNotifier` untuk reaktivitas UI dan status loading.

---

## ⚙️ Instalasi & Persiapan

### 1. Prasyarat

- Flutter SDK v3.10 atau lebih baru.
- Backend API yang sudah berjalan.

### 2. Clone & Install

```bash
# Clone repositori
git clone https://github.com/username/coralis-auth.git

# Masuk ke direktori
cd coralis-auth

# Install dependensi
flutter pub get

```

### 3. Konfigurasi Environment

Buat file `.env` di root project (sejajar dengan `pubspec.yaml`):

```env
BASE_URL=http://192.168.1.xx:5000/api/auth

```

_Catatan: Gunakan IP address lokal (bukan localhost) jika menjalankan di device fisik._

### 4. Update pubspec.yaml

Pastikan file `.env` terdaftar di bagian assets:

```yaml
flutter:
  assets:
    - .env
```

---

## 🌐 API Reference

| Endpoint              | Method | Deskripsi                              |
| --------------------- | ------ | -------------------------------------- |
| `/register`           | `POST` | Membuat akun baru.                     |
| `/login`              | `POST` | Autentikasi dan mendapatkan JWT.       |
| `/forgot-password`    | `POST` | Request kode 5 digit ke email.         |
| `/verify-reset-token` | `POST` | Validasi token reset.                  |
| `/reset-password`     | `POST` | Mengganti password dengan token valid. |

---

## 🚦 Navigasi (Routes)

Aplikasi menggunakan `AppRoutes` untuk mengelola perpindahan halaman:

| Nama Rute   | Halaman              | Deskripsi                                      |
| ----------- | -------------------- | ---------------------------------------------- |
| `/login`    | `LoginView`          | Halaman utama saat aplikasi dibuka.            |
| `/register` | `RegisterView`       | Halaman pendaftaran.                           |
| `/forgot`   | `ForgotPasswordView` | Form input email lupa password.                |
| `/verify`   | `VerifyTokenView`    | Form input kode 5 digit.                       |
| `/reset`    | `ResetPasswordView`  | Form password baru (Menerima argumen `token`). |
| `/home`     | `HomeView`           | Landing page setelah sukses login.             |

---

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev)
- **HTTP Client**: `http`
- **Local Storage**: `shared_preferences`
- **Env Management**: `flutter_dotenv`
- **Architecture**: MVVM (Model-View-ViewModel)

---

## 📄 Lisensi

Distribusi di bawah Lisensi MIT. Lihat `LICENSE` untuk informasi lebih lanjut.
