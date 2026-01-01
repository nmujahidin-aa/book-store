import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/datetime_ext.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loader_overlay.dart';
import '../../viewmodels/auth/auth_viewmodel.dart';
import '../../viewmodels/home/book_list_viewmodel.dart';
import '../../viewmodels/home/book_query_state.dart';
import '../../widgets/book_grid_item.dart';
import '../../widgets/filter_sort_sheet.dart';
import '../../widgets/search_bar.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();

    _controller.addListener(() {
      final pos = _controller.position;

      if (pos.pixels >= pos.maxScrollExtent - 400) {
        ref.read(bookListViewModelProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider).asData?.value;
    final bookState = ref.watch(bookListViewModelProvider);
    final books = ref.watch(visibleBooksProvider);

    final isBusy = bookState.isLoading;
    final greeting = DateTime.now().indoGreeting;

    return LoaderOverlay(
      isLoading: isBusy,
      child: Scaffold(
        appBar: AppBar(
          title: Text('$greeting, ${profile?.name ?? 'User'}'),
          actions: [
            IconButton(
              onPressed: () => context.push('/rent/list'),
              icon: const Icon(Icons.receipt_long),
              tooltip: 'Daftar Sewa',
            ),
            IconButton(
              onPressed: () =>
                  ref.read(authViewModelProvider.notifier).logout(),
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () =>
              ref.read(bookListViewModelProvider.notifier).refresh(),
          child: CustomScrollView(
            controller: _controller,
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Column(
                    children: [
                      AppSearchBar(
                        onChanged: (v) {
                          final prev = ref.read(bookQueryProvider);
                          ref.read(bookQueryProvider.notifier).state =
                              prev.copyWith(keyword: v);
                        },
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                final result =
                                    await showModalBottomSheet<BookQueryState>(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (_) => FilterSortSheet(
                                    initial: ref.read(bookQueryProvider),
                                  ),
                                );
                                if (result != null) {
                                  ref.read(bookQueryProvider.notifier).state =
                                      result;
                                }
                              },
                              icon: const Icon(Icons.tune),
                              label: const Text('Filter & Sort'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              if (bookState.hasError)
                SliverFillRemaining(
                  child: EmptyState(
                    title: 'Gagal memuat data',
                    subtitle: bookState.error.toString(),
                  ),
                )

              else if (!bookState.isLoading && books.isEmpty)
                const SliverFillRemaining(
                  child: EmptyState(
                    title: 'Data buku kosong',
                    subtitle: 'Coba ubah filter atau kata kunci.',
                  ),
                )

              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        final b = books[i];
                        return BookGridItem(
                          book: b,
                          onTap: () => context.push('/book', extra: b),
                        );
                      },
                      childCount: books.length,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.55,
                    ),
                  ),
                ),

              SliverToBoxAdapter(
                child: Center(
                  child: (bookState.asData?.value.isLoadingMore ?? false)
                      ? const Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(),
                        )
                      : const SizedBox(height: 24),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
