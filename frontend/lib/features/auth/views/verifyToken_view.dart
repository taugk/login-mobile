import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';

class VerifyTokenView extends StatefulWidget {
  const VerifyTokenView({super.key});

  @override
  State<VerifyTokenView> createState() => _VerifyTokenViewState();
}

class _VerifyTokenViewState extends State<VerifyTokenView> {
  final tokenCtrl = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _hasSubmitted = false;

  @override
  void dispose() {
    tokenCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _submitToken(BuildContext context, AuthViewModel authVM) async {
    final token = tokenCtrl.text.trim();
    if (token.length != 5 || _hasSubmitted) return;

    _hasSubmitted = true;
    final isValid = await authVM.verifyResetToken(token);

    if (!context.mounted) return;

    if (isValid) {
      Navigator.pushNamed(context, '/reset', arguments: token);
    } else {
      _hasSubmitted = false;
      tokenCtrl.clear();
      _showError(context, "Kode tidak valid atau kedaluwarsa");
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF2563EB);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: const BackButton(color: Colors.black),
      ),
      body: SafeArea(
        // LayoutBuilder & SingleChildScrollView adalah kunci anti-overflow
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  // Memastikan konten bisa di tengah (Center) jika layar cukup tinggi
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const Icon(
                        Icons.security_rounded,
                        size: 80,
                        color: primaryColor,
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Verify Your Account',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Enter the 5-digit code sent to your email',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 48),

                      // Box OTP Section
                      _buildOtpSection(context),

                      const SizedBox(height: 48),

                      // Tombol diletakkan di bawah menggunakan Spacer jika ingin tetap di bawah,
                      // atau cukup SizedBox jika ingin mengikuti alur scroll.
                      const Spacer(),

                      Consumer<AuthViewModel>(
                        builder: (context, authVM, child) {
                          return SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: authVM.isLoading
                                  ? null
                                  : () => _submitToken(context, authVM),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: authVM.isLoading
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'Verify Code',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOtpSection(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authVM, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: 0,
              child: TextField(
                controller: tokenCtrl,
                focusNode: _focusNode,
                keyboardType: TextInputType.number,
                maxLength: 5,
                autofocus: true,
                onChanged: (val) {
                  setState(() {});
                  if (val.length == 5) _submitToken(context, authVM);
                },
              ),
            ),
            GestureDetector(
              onTap: () => _focusNode.requestFocus(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(5, (index) => _buildOtpBox(index)),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOtpBox(int index) {
    String char = tokenCtrl.text.length > index ? tokenCtrl.text[index] : "";
    bool isFocused = tokenCtrl.text.length == index;

    return Container(
      width: 50, // Dikecilkan sedikit agar lebih aman di layar kecil
      height: 60,
      decoration: BoxDecoration(
        color: isFocused ? Colors.white : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isFocused ? const Color(0xFF2563EB) : Colors.transparent,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          char,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _showError(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }
}
