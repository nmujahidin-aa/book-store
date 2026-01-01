import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

enum BookSortKey { newest, oldest, titleAZ, titleZA, priceLowHigh, priceHighLow }

class BookQueryState {
  final String keyword;
  final String? year;
  final String? genre;
  final BookSortKey sortKey;

  const BookQueryState({
    required this.keyword,
    required this.year,
    required this.genre,
    required this.sortKey,
  });

  factory BookQueryState.initial() => const BookQueryState(
        keyword: '',
        year: null,
        genre: null,
        sortKey: BookSortKey.newest,
      );

  BookQueryState copyWith({
    String? keyword,
    String? year,
    String? genre,
    BookSortKey? sortKey,
  }) {
    return BookQueryState(
      keyword: keyword ?? this.keyword,
      year: year,
      genre: genre,
      sortKey: sortKey ?? this.sortKey,
    );
  }
}

final bookQueryProvider = StateProvider<BookQueryState>((ref) => BookQueryState.initial());