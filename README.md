# 🛡️ Coralis Auth: Fullstack Authentication System

Sistem autentikasi lengkap yang mengintegrasikan aplikasi mobile **Flutter (Frontend)** dengan server **Node.js (Backend)**. Proyek ini mendukung alur registrasi, login, dan reset password menggunakan verifikasi token 5-digit via email dengan arsitektur **MVVM**.

---

## 🛠️ Tech Stack

### Frontend (Mobile)

- **Framework**: Flutter (v3.22+)
- **Dart**: v3.4+
- **Architecture**: MVVM (Model-View-ViewModel)
- **State Management**: `ChangeNotifier`
- **Local Storage**: `shared_preferences` & `flutter_dotenv`

### Backend (Server)

- **Runtime**: Node.js & Express
- **Database**: MySQL with Sequelize ORM
- **Security**: JWT (JSON Web Token) & Bcrypt (Password Hashing)
- **Mail Service**: Nodemailer (SMTP)

## ⬇️ Instalasi dari GitHub (Clone Langsung)

```bash
# Clone repository
git clone

# Masuk ke folder project
cd login-mobile

# Setup Backend
cd backend
npm install
cp .env.example .env
npm run dev

# Setup Frontend
cd ../frontend
flutter pub get
flutter run
```

## ⚙️ Panduan Koneksi & Instalasi (Penting!)

Agar aplikasi Flutter dapat berkomunikasi dengan Backend pada Emulator Android, keduanya harus dikonfigurasi dengan benar dalam jaringan.

### 1. Database & Backend Setup (Node.js)

1. Persiapan Database:

- Buat database baru di MySQL (misal: `coralis_auth`).
- Konfigurasi tabel akan dilakukan otomatis oleh Sequelize (`sync`).

2. Install Dependensi:

```bash
cd backend
npm install

```

3. Konfigurasi `.env`: Buat file `.env` di folder backend:

```env
PORT=5000
DB_NAME=coralis_auth
DB_USER=root
DB_PASSWORD=
DB_HOST=localhost
DB_DIALECT=mysql
JWT_SECRET=coralis_secret_key_123
EMAIL_USER=email_anda@gmail.com
EMAIL_PASS=16_digit_app_password

```

4. Jalankan Server:

```bash
npm run dev

```

> **Perhatikan Terminal!** Backend akan menampilkan alamat IP lokal Anda, misalnya: `Server running on http://192.168.1.15:5000`.

---

### 2. Frontend Setup (Flutter)

1. Install Dependensi:

```bash
cd frontend
flutter pub get

```

2. Konfigurasi `.env`: Buat file `.env` di root folder Flutter. **Ganti IP sesuai dengan yang didapat dari terminal backend**:

```env
# Ganti IP ini sesuai output terminal backend Anda
BASE_URL=http://192.168.1.15:5000/api/auth

```

> **⚠️ Emulator Note**: Jika menggunakan Emulator Android standar, Anda juga bisa menggunakan `http://10.0.2.2:5000/api/auth`, namun menggunakan IP lokal (192.168.x.x) lebih disarankan agar bisa diakses dari device fisik juga.

3. Update `pubspec.yaml`:
   Pastikan `.env` terdaftar di bagian assets:

```yaml
flutter:
  assets:
    - .env
```

4. Jalankan Aplikasi:

```bash
flutter run

```

---

## 🌐 API Reference

| Method | Endpoint                       | Deskripsi                                                   |
| ------ | ------------------------------ | ----------------------------------------------------------- |
| `GET`  | `/ping`                        | Cek status aktif server.                                    |
| `POST` | `/api/auth/register`           | Pendaftaran pengguna baru (Password di-hash dengan Bcrypt). |
| `POST` | `/api/auth/login`              | Autentikasi & generate token JWT.                           |
| `POST` | `/api/auth/forgot-password`    | Request kode OTP 5-digit via email.                         |
| `POST` | `/api/auth/verify-reset-token` | Validasi token/OTP reset.                                   |
| `POST` | `/api/auth/reset-password`     | Update password baru ke MySQL.                              |

---

## 🚦 Navigasi Flutter (Routes)

Aplikasi menggunakan `onGenerateRoute` untuk menangani navigasi dan argumen secara dinamis:

| Nama Rute   | Halaman              | Deskripsi                        |
| ----------- | -------------------- | -------------------------------- |
| `/login`    | `LoginView`          | Halaman autentikasi utama.       |
| `/register` | `RegisterView`       | Form pendaftaran user baru.      |
| `/forgot`   | `ForgotPasswordView` | Form input email untuk recovery. |
| `/verify`   | `VerifyTokenView`    | Input kode 5-digit dari email.   |
| `/reset`    | `ResetPasswordView`  | Form password baru.              |
| `/home`     | `HomeView`           | Dashboard sederhana pasca-login. |

---

## 🏗️ Alur Fitur Lupa Kata Sandi

1. **Request**: User mengirim email melalui aplikasi.
2. **OTP Generation**: Backend membuat kode 5-digit acak dan menyimpannya di DB dengan masa berlaku 10 menit.
3. **Email Delivery**: Kode dikirim ke email user menggunakan Nodemailer.
4. **Verification**: User memasukkan kode di aplikasi. Jika cocok dan belum expired, user lanjut ke tahap akhir.
5. **Update**: User menginput password baru yang kemudian di-hash dan disimpan kembali ke MySQL.

---

## 🔑 Persiapan Email (SMTP)

Untuk fitur pengiriman kode OTP, Anda perlu menggunakan **Google App Password**:

1. Aktifkan **2-Step Verification** di akun Google Anda.
2. Cari menu **"App Passwords"**.
3. Pilih aplikasi "Lainnya", beri nama "Coralis Auth", dan salin kode 16 digit yang muncul.
4. Tempel kode tersebut di `EMAIL_PASS` pada file `.env` backend.

---

## 📄 Lisensi

Distribusi di bawah Lisensi MIT.

© 2026 Coralis Auth - Developed with ❤️
