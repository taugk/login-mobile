const jwt = require("jsonwebtoken");
const User = require("../models/User");

const protect = async (req, res, next) => {
  let token;

  // Cek apakah ada token di header 'Authorization' dengan format 'Bearer <token>'
  if (
    req.headers.authorization &&
    req.headers.authorization.startsWith("Bearer")
  ) {
    try {
      // Ambil tokennya saja
      token = req.headers.authorization.split(" ")[1];

      // Verifikasi token
      const decoded = jwt.verify(token, process.env.JWT_SECRET);

      // Cari user berdasarkan ID dari token dan masukkan ke object req.user (kecuali password)
      req.user = await User.findByPk(decoded.id, {
        attributes: { exclude: ["password"] },
      });

      next(); // Lanjut ke controller berikutnya
    } catch (error) {
      console.error(error);
      return res.status(401).json({ message: "Tidak diizinkan, token gagal" });
    }
  }

  if (!token) {
    return res
      .status(401)
      .json({ message: "Tidak diizinkan, tidak ada token" });
  }
};

module.exports = { protect };
