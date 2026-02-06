import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String baseUrl =
      dotenv.env['BASE_URL'] ?? "http://localhost:5000/api/auth";
}
