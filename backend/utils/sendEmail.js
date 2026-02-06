const nodemailer = require("nodemailer");

const transporter = nodemailer.createTransport({
  host: process.env.EMAIL_HOST,
  port: Number(process.env.EMAIL_PORT),
  secure: false, // port 587
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS,
  },
});

const sendEmail = async ({ email, subject, message, token }) => {
  await transporter.verify();
  console.log("✅ SMTP siap kirim email");

  const htmlTemplate = `
  <!DOCTYPE html>
  <html>
  <head>
    <meta charset="UTF-8" />
    <title>${subject}</title>
  </head>
  <body style="margin:0; padding:0; background:#f4f6f8; font-family:Arial, sans-serif;">
    <table width="100%" cellpadding="0" cellspacing="0">
      <tr>
        <td align="center" style="padding:40px 0;">
          <table width="100%" max-width="480" cellpadding="0" cellspacing="0"
            style="background:#ffffff; border-radius:10px; padding:30px; box-shadow:0 10px 30px rgba(0,0,0,0.05);">
            
            <tr>
              <td align="center">
                <h2 style="margin:0; color:#2c3e50;">🔐 Reset Password</h2>
              </td>
            </tr>

            <tr>
              <td style="padding:20px 0; color:#555; font-size:14px; line-height:1.6;">
                Halo,<br /><br />
                Kami menerima permintaan untuk mereset password akun Anda.
                Gunakan kode verifikasi di bawah ini untuk melanjutkan proses reset password.
              </td>
            </tr>

            <tr>
              <td align="center" style="padding:20px 0;">
                <div style="
                  display:inline-block;
                  padding:15px 25px;
                  font-size:28px;
                  letter-spacing:6px;
                  font-weight:bold;
                  background:#f1f3f5;
                  border-radius:8px;
                  color:#111;
                ">
                  ${token}
                </div>
              </td>
            </tr>

            <tr>
              <td style="color:#777; font-size:13px; line-height:1.5;">
                Kode ini berlaku selama <strong>10 menit</strong>.
                Jika Anda tidak merasa melakukan permintaan ini, abaikan email ini.
              </td>
            </tr>

            <tr>
              <td style="padding-top:30px; font-size:12px; color:#aaa;" align="center">
                © ${new Date().getFullYear()} Coralis Auth<br />
                Jangan membagikan kode ini kepada siapa pun.
              </td>
            </tr>

          </table>
        </td>
      </tr>
    </table>
  </body>
  </html>
  `;

  const mailOptions = {
    from: `"Coralis Auth" <${process.env.EMAIL_USER}>`,
    to: email,
    subject,
    text: message, // fallback
    html: htmlTemplate,
  };

  console.log(`📨 Mengirim email ke ${email}`);
  await transporter.sendMail(mailOptions);
  console.log("✅ Email berhasil dikirim");
};

module.exports = sendEmail;
