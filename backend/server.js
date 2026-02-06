const express = require("express");
const cors = require("cors");
const os = require("os");
require("dotenv").config();

// Import konfigurasi database dan model
const { db, connectDB } = require("./config/db");
const User = require("./models/User");

const app = express();
const PORT = process.env.PORT || 5000;

// --- 1. MIDDLEWARE ---
app.use(cors());
app.use(express.json());

// --- 2. TEST ROUTE ---
app.get("/ping", (req, res) => {
  res.status(200).json({ message: "Pong! Server is running" });
});

// --- 3. ROUTES ---
// Mengarahkan semua request /api/auth ke authRoutes
app.use("/api/auth", require("./routes/authRoutes"));

// --- 4. DATABASE & SERVER START ---
const startServer = async () => {
  try {
    // 1. Hubungkan ke MySQL
    await connectDB();

    // 2. Sinkronisasi Tabel (Membuat/Update tabel jika ada perubahan skema)
    await db.sync({ alter: true });
    console.log("✅ Database & Tables synced");

    // 3. Deteksi IP Lokal Secara Dinamis
    const networkInterfaces = os.networkInterfaces();
    let localIp = "localhost";

    for (const interfaceName in networkInterfaces) {
      for (const iface of networkInterfaces[interfaceName]) {
        // Mencari alamat IPv4 yang bukan loopback internal
        if (iface.family === "IPv4" && !iface.internal) {
          localIp = iface.address;
          break;
        }
      }
    }

    // 4. Jalankan Server di 0.0.0.0 agar bisa diakses dari perangkat lain (HP/Frontend)
    app.listen(PORT, "0.0.0.0", () => {
      console.log(`\n🚀 Server berhasil dijalankan!`);
      console.log(`🏠 Local:   http://localhost:${PORT}`);
      console.log(`🌐 Network: http://${localIp}:${PORT}\n`);
      console.log(`Tekan CTRL+C untuk menghentikan server`);
    });
  } catch (error) {
    console.error("❌ Gagal menjalankan server:", error.message);
    process.exit(1);
  }
};

startServer();
