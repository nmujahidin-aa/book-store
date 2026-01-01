import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get bookApiBaseUrl =>
      dotenv.env['BOOK_API_BASE_URL'] ?? 'https://bukuacak-9bdcb4ef2605.herokuapp.com';

  static String get bookApiBookPath =>
      dotenv.env['BOOK_API_BOOK_PATH'] ?? '/api/v1/book';
}