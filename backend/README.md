# Coralis Auth Backend 🔐

Sistem backend autentikasi yang dibangun dengan **Node.js**, **Express**, dan **Sequelize**. Proyek ini mendukung fitur registrasi, login, dan alur reset password otomatis melalui email.

---

## 🚀 Fitur Utama

- **User Authentication**: Registrasi dan Login menggunakan JWT (JSON Web Token).
- **Sequelize ORM**: Integrasi MySQL dengan fitur sinkronisasi tabel otomatis (`alter: true`).
- **Secure Password**: Enkripsi password menggunakan `bcrypt` hooks pada level model.
- **Dynamic IP Detection**: Server otomatis mendeteksi alamat IP lokal (LAN) untuk mempermudah koneksi dari perangkat luar (Mobile/Frontend).
- **Email System**: Pengiriman kode OTP reset password menggunakan Nodemailer dengan template HTML.

---

## 🛠️ Persiapan Lingkungan (Penting)

### 1. Menonaktifkan Apache

Karena backend ini mungkin menggunakan port yang bentrok dengan layanan web default (seperti Apache/XAMPP), pastikan untuk mematikan layanan tersebut terlebih dahulu:

**Windows (PowerShell Admin):**

```powershell
Stop-Service -Name "Apache2.4"
# Atau matikan "Apache" melalui XAMPP Control Panel.

```

**Linux (Ubuntu/Debian):**

```bash
sudo systemctl stop apache2
sudo systemctl disable apache2

```

### 2. Cara Mendapatkan Google App Password

Untuk fitur pengiriman email, Anda wajib menggunakan **App Password**, bukan password utama Gmail Anda:

1. Buka [Akun Google](https://myaccount.google.com/) Anda.
2. Pastikan **Verifikasi 2 Langkah** sudah aktif.
3. Cari menu **"App Passwords"** atau "Sandi Aplikasi".
4. Pilih aplikasi "Lainnya" dan beri nama (misal: `Coralis Auth`).
5. Salin kode **16 digit** yang muncul untuk digunakan pada `EMAIL_PASS` di `.env`.

### 3. Konfigurasi Environment (`.env`)

Buat file `.env` di root folder dan sesuaikan konfigurasinya:

```env
PORT=5000
DB_NAME=nama_db
DB_USER=root
DB_PASSWORD=password
DB_HOST=localhost
DB_DIALECT=mysql

JWT_SECRET=rahasia_sangat_kuat_123

EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USER=email_anda@gmail.com
EMAIL_PASS=abcdefghijklmnop # Masukkan 16 digit App Password di sini

```

---

## 🚦 Endpoint & Akses Server

Aplikasi dikonfigurasi menggunakan `0.0.0.0` agar bisa diakses dalam jaringan lokal (Wi-Fi yang sama).

### Cara Akses

Saat menjalankan server, perhatikan terminal untuk melihat alamat IP dinamis Anda:

- **Lokal**: `http://localhost:5000`
- **Network**: `http://[IP_ADDRESS_ANDA]:5000` (Gunakan IP ini untuk pengujian dari HP/Frontend)

### API Endpoints

| Method | Endpoint                       | Deskripsi                  |
| ------ | ------------------------------ | -------------------------- |
| `GET`  | `/ping`                        | Cek status aktif server    |
| `POST` | `/api/auth/register`           | Pendaftaran pengguna baru  |
| `POST` | `/api/auth/login`              | Login & generate token JWT |
| `POST` | `/api/auth/forgot-password`    | Request kode OTP via email |
| `POST` | `/api/auth/verify-reset-token` | Validasi token/OTP reset   |
| `POST` | `/api/auth/reset-password`     | Simpan password baru       |

---

## 🔒 Alur Reset Password

1. **Request**: User mengirim email melalui endpoint `/forgot-password`.
2. **OTP**: Sistem mengirim kode 5-digit unik ke email user yang berlaku selama 10 menit.
3. **Verify**: User melakukan verifikasi kode melalui `/verify-reset-token`.
4. **Update**: User mengirim password baru beserta token yang telah divalidasi ke `/reset-password`.

---

## 💻 Cara Menjalankan

**Mode Pengembangan (Auto-restart):**

```bash
npm run dev

```

**Mode Produksi:**

```bash
npm start

```

Setelah dijalankan, Sequelize akan otomatis melakukan sinkronisasi tabel ke database MySQL Anda menggunakan `db.sync({ alter: true })`.

---

© 2026 Coralis Auth - Developed with ❤️
