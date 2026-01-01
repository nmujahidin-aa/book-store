import '../entities/book.dart';

class BookPage {
  final List<Book> items;
  final int currentPage;
  final int totalPages;
  final bool hasNextPage;

  const BookPage({
    required this.items,
    required this.currentPage,
    required this.totalPages,
    required this.hasNextPage,
  });
}

abstract class BookRepository {
  Future<BookPage> fetchBooksPage({required int page, required int limit});
}