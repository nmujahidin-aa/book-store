import '../../domain/repositories/book_repository.dart';
import '../datasources/remote/book_api_client.dart';

class BookRepositoryImpl implements BookRepository {
  BookRepositoryImpl(this._api);
  final BookApiClient _api;

  @override
  Future<BookPage> fetchBooksPage({required int page, required int limit}) async {
    final res = await _api.fetchBooksPage(page: page, limit: limit);

    return BookPage(
      items: res.items.map((m) => m.toEntity()).toList(),
      currentPage: res.currentPage,
      totalPages: res.totalPages,
      hasNextPage: res.hasNextPage,
    );
  }
}