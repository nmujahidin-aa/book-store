import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/datetime_ext.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../domain/entities/book.dart';
import '../../viewmodels/rent/rent_list_viewmodel.dart';
import 'package:go_router/go_router.dart';

class RentListPage extends ConsumerWidget {
  const RentListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rentsAsync = ref.watch(rentListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Sewa')),
      body: rentsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => EmptyState(title: 'Gagal memuat sewa', subtitle: e.toString()),
        data: (rents) {
          if (rents.isEmpty) {
            return const EmptyState(title: 'Belum ada data sewa', subtitle: 'Sewa buku dari halaman detail.');
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: rents.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final r = rents[i];
              final expired = r.expiredAt.isExpired;

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          r.coverImage,
                          width: 56,
                          height: 72,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const SizedBox(width: 56, height: 72),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 4),
                            Text(r.authorName),
                            const SizedBox(height: 4),
                            Text(
                              expired
                                  ? 'Expired: ${r.expiredAt}'
                                  : 'Aktif sampai: ${r.expiredAt}',
                              style: TextStyle(
                                color: expired ? Colors.red : Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (expired)
                        OutlinedButton(
                          onPressed: () {
                            final book = Book(
                              id: r.bookId,
                              title: r.title,
                              coverImage: r.coverImage,
                              authorName: r.authorName,
                              categoryName: '',
                              summary: '',
                              publisher: '',
                              isbn: '',
                              priceRaw: '',
                              totalPages: '',
                              size: '',
                              publishedDate: '',
                              format: '',
                              tags: const [],
                              buyLinks: const [],
                            );
                            context.push('/rent/order', extra: book);
                          },
                          child: const Text('Rent Again'),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}