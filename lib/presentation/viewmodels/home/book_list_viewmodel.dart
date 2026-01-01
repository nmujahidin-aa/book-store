import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/book.dart';
import '../../../domain/usecases/book/fetch_books.dart';
import '../auth/auth_viewmodel.dart';
import '../../../core/utils/currency.dart';
import 'book_query_state.dart';


class BookListState {
  final List<Book> all;
  final int currentPage;
  final int totalPages;
  final bool isLoadingMore;
  final bool hasMore;

  const BookListState({
    required this.all,
    required this.currentPage,
    required this.totalPages,
    required this.isLoadingMore,
    required this.hasMore,
  });

  factory BookListState.initial() => const BookListState(
        all: [],
        currentPage: 0,
        totalPages: 0,
        isLoadingMore: false,
        hasMore: true,
      );

  BookListState copyWith({
    List<Book>? all,
    int? currentPage,
    int? totalPages,
    bool? isLoadingMore,
    bool? hasMore,
  }) {
    return BookListState(
      all: all ?? this.all,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

final bookListViewModelProvider = AsyncNotifierProvider<BookListViewModel, BookListState>(BookListViewModel.new);

class BookListViewModel extends AsyncNotifier<BookListState> {
  late final FetchBooksUsecase _fetch =
      FetchBooksUsecase(ref.read(bookRepositoryProvider));

  static const int _limit = 20; // sesuai item/PerPage response dari si API

  @override
  Future<BookListState> build() async {
    final first = await _fetch(page: 1, limit: _limit);
    return BookListState(
      all: first.items,
      currentPage: first.currentPage,
      totalPages: first.totalPages,
      isLoadingMore: false,
      hasMore: first.hasNextPage,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final first = await _fetch(page: 1, limit: _limit);
      return BookListState(
        all: first.items,
        currentPage: first.currentPage,
        totalPages: first.totalPages,
        isLoadingMore: false,
        hasMore: first.hasNextPage,
      );
    });
  }

  Future<void> loadMore() async {
    final current = state.asData?.value;
    if (current == null) return;
    if (current.isLoadingMore || !current.hasMore) return;

    final nextPage = current.currentPage + 1;

    state = AsyncData(current.copyWith(isLoadingMore: true));
    try {
      final next = await _fetch(page: nextPage, limit: _limit);

      final merged = [...current.all, ...next.items];
      final map = {for (final b in merged) b.id: b};
      final unique = map.values.toList();

      state = AsyncData(
        current.copyWith(
          all: unique,
          currentPage: next.currentPage,
          totalPages: next.totalPages,
          hasMore: next.hasNextPage,
          isLoadingMore: false,
        ),
      );
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}


final visibleBooksProvider = Provider<List<Book>>((ref) {
  final query = ref.watch(bookQueryProvider);
  final booksState = ref.watch(bookListViewModelProvider).asData?.value;

  final all = booksState?.all ?? <Book>[];

  List<Book> filtered = List<Book>.from(all);

  if (query.keyword.trim().isNotEmpty) {
    final k = query.keyword.trim().toLowerCase();
    filtered = filtered.where((b) {
      return b.title.toLowerCase().contains(k) ||
          b.authorName.toLowerCase().contains(k) ||
          b.categoryName.toLowerCase().contains(k);
    }).toList();
  }

  if (query.genre != null && query.genre!.trim().isNotEmpty) {
    final g = query.genre!.trim().toLowerCase();
    filtered = filtered.where((b) => b.categoryName.toLowerCase().contains(g)).toList();
  }

  if (query.year != null && query.year!.trim().isNotEmpty) {
    final y = query.year!.trim();
    filtered = filtered.where((b) => b.publishedDate.contains(y)).toList();
  }

  int price(Book b) => CurrencyUtil.parseRupiahToInt(b.priceRaw);

  switch (query.sortKey) {
    case BookSortKey.newest:
      filtered.sort((a, b) => b.publishedDate.compareTo(a.publishedDate));
      break;
    case BookSortKey.oldest:
      filtered.sort((a, b) => a.publishedDate.compareTo(b.publishedDate));
      break;
    case BookSortKey.titleAZ:
      filtered.sort((a, b) => a.title.compareTo(b.title));
      break;
    case BookSortKey.titleZA:
      filtered.sort((a, b) => b.title.compareTo(a.title));
      break;
    case BookSortKey.priceLowHigh:
      filtered.sort((a, b) => price(a).compareTo(price(b)));
      break;
    case BookSortKey.priceHighLow:
      filtered.sort((a, b) => price(b).compareTo(price(a)));
      break;
  }

  return filtered;
});