import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Pastikan path import ini sesuai dengan struktur folder kamu
import 'features/auth/viewmodels/auth_viewmodel.dart';
import 'app/app.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthViewModel())],
      child: const MyApp(),
    ),
  );
}
