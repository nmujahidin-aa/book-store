import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/currency.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/loader_overlay.dart';
import '../../../domain/entities/book.dart';
import '../../viewmodels/rent/rent_form_viewmodel.dart';

class OrderRentPage extends ConsumerWidget {
  final Book book;
  const OrderRentPage({super.key, required this.book});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(rentFormViewModelProvider);

    return LoaderOverlay(
      isLoading: state.isLoading,
      child: Scaffold(
        appBar: AppBar(title: const Text('Order Rent')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  book.coverImage,
                  width: 56,
                  height: 72,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox(width: 56, height: 72),
                ),
              ),
              title: Text(book.title, maxLines: 2, overflow: TextOverflow.ellipsis),
              subtitle: Text(book.authorName),
            ),
            const SizedBox(height: 16),
            Text('Durasi sewa (1–7 hari)', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  onPressed: () => ref.read(rentFormViewModelProvider.notifier).setDays(state.days - 1),
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text('${state.days} hari', style: Theme.of(context).textTheme.titleLarge),
                IconButton(
                  onPressed: () => ref.read(rentFormViewModelProvider.notifier).setDays(state.days + 1),
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _priceRow('Harga per hari', CurrencyUtil.formatRupiah(state.pricePerDay)),
            _priceRow('Total', CurrencyUtil.formatRupiah(state.totalPrice)),
            const SizedBox(height: 24),
            SizedBox(
              height: 48,
              child: FilledButton(
                onPressed: () async {
                  try {
                    await ref.read(rentFormViewModelProvider.notifier).submit(book);
                    if (context.mounted) {
                      AppToast.show(context, 'Sewa berhasil disimpan', ToastType.success);
                      Navigator.of(context).pop();
                    }
                  } catch (e) {
                    AppToast.show(context, e.toString(), ToastType.error);
                  }
                },
                child: const Text('Submit Rent'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _priceRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}