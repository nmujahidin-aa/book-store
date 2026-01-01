import 'package:dio/dio.dart';
import '../../../core/env/env.dart';
import '../../models/book_model.dart';

class BookApiFailure implements Exception {
  final String message;
  const BookApiFailure(this.message);
  @override
  String toString() => message;
}

class BookPageResponse {
  final List<BookModel> items;
  final int currentPage;
  final int totalPages;
  final bool hasNextPage;

  const BookPageResponse({
    required this.items,
    required this.currentPage,
    required this.totalPages,
    required this.hasNextPage,
  });
}

class BookApiClient {
  BookApiClient(this._dio);
  final Dio _dio;

  Future<BookPageResponse> fetchBooksPage({
    required int page,
    required int limit,
  }) async {
    try {
      final url = '${Env.bookApiBaseUrl}${Env.bookApiBookPath}';

      final res = await _dio.get(
        url,
        queryParameters: {'page': page, 'limit': limit},
        options: Options(headers: {'Accept': 'application/json'}),
      );

      final data = res.data as Map<String, dynamic>;

      final rawBooks = (data['books'] as List?) ?? const [];
      final pagination = (data['pagination'] as Map<String, dynamic>?) ?? const {};

      final currentPage = (pagination['currentPage'] as int?) ?? page;
      final totalPages = (pagination['totalPages'] as int?) ?? currentPage;
      final hasNextPage = (pagination['hasNextPage'] as bool?) ?? (currentPage < totalPages);

      final items = rawBooks
          .map((e) => BookModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return BookPageResponse(
        items: items,
        currentPage: currentPage,
        totalPages: totalPages,
        hasNextPage: hasNextPage,
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        throw BookApiFailure('Server error (${e.response?.statusCode ?? '-'}) dari Buku Acak.');
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const BookApiFailure('Koneksi timeout. Coba lagi.');
      }
      if (e.type == DioExceptionType.connectionError) {
        throw const BookApiFailure('Tidak ada koneksi internet.');
      }
      throw const BookApiFailure('Gagal memuat data buku.');
    }
  }
}