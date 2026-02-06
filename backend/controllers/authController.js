const User = require("../models/User");
const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");
const sendEmail = require("../utils/sendEmail");
const { Op } = require("sequelize");

const generateToken = (id) => {
  return jwt.sign({ id }, process.env.JWT_SECRET, { expiresIn: "1d" });
};

// ================= REGISTER =================
exports.register = async (req, res) => {
  try {
    const { email, password } = req.body;

    const userExists = await User.findOne({ where: { email } });
    if (userExists) {
      return res.status(400).json({ message: "Email sudah terdaftar" });
    }

    const user = await User.create({ email, password });

    res.status(201).json({
      success: true,
      message: "Registrasi berhasil",
      data: { id: user.id, email: user.email },
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// ================= LOGIN =================
exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await User.findOne({ where: { email } });

    if (user && (await bcrypt.compare(password, user.password))) {
      return res.json({
        success: true,
        token: generateToken(user.id),
        user: { id: user.id, email: user.email },
      });
    }

    res.status(401).json({ message: "Email atau password salah" });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// ================= FORGOT PASSWORD =================
exports.forgotPassword = async (req, res) => {
  try {
    const { email } = req.body;
    const user = await User.findOne({ where: { email } });

    if (!user) {
      return res.status(404).json({ message: "Email tidak terdaftar" });
    }

    const resetToken = Math.floor(10000 + Math.random() * 90000).toString();

    user.resetPasswordToken = resetToken;
    user.resetPasswordExpires = Date.now() + 10 * 60 * 1000;
    await user.save();

    await sendEmail({
      email: user.email,
      subject: "Kode Reset Password",
      message: `Kode reset password Anda: ${resetToken}`,
      token: resetToken,
    });

    res.status(200).json({
      success: true,
      message: "Kode reset telah dikirim ke email",
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// ================= VERIFY RESET TOKEN =================
exports.verifyResetToken = async (req, res) => {
  try {
    const { token } = req.body;

    if (!token) {
      return res.status(400).json({
        success: false,
        message: "Token wajib diisi",
      });
    }

    const user = await User.findOne({
      where: {
        resetPasswordToken: token,
        resetPasswordExpires: {
          [Op.gt]: Date.now(),
        },
      },
    });

    if (!user) {
      return res.status(400).json({
        success: false,
        message: "Token tidak valid atau kadaluwarsa",
      });
    }

    res.status(200).json({
      success: true,
      message: "Token valid",
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "Internal server error",
    });
  }
};

// ================= RESET PASSWORD =================
exports.resetPassword = async (req, res) => {
  try {
    const { token, newPassword } = req.body;

    const user = await User.findOne({
      where: {
        resetPasswordToken: token,
        resetPasswordExpires: { [Op.gt]: Date.now() },
      },
    });

    if (!user) {
      return res.status(400).json({
        message: "Token tidak valid atau kadaluwarsa",
      });
    }

    user.password = newPassword;
    user.resetPasswordToken = null;
    user.resetPasswordExpires = null;
    await user.save();

    res.status(200).json({
      success: true,
      message: "Password berhasil diperbarui",
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
