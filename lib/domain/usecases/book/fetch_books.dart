import '../../repositories/book_repository.dart';

class FetchBooksUsecase {
  FetchBooksUsecase(this.repo);
  final BookRepository repo;

  Future<BookPage> call({required int page, required int limit}) {
    return repo.fetchBooksPage(page: page, limit: limit);
  }
}