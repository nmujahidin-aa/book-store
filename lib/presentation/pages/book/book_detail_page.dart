import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/utils/currency.dart';
import '../../../domain/entities/book.dart';

class BookDetailPage extends StatelessWidget {
  final Book book;
  const BookDetailPage({super.key, required this.book});

  Future<void> _openBuyLink(BuildContext context) async {
    final link = book.buyLinks.isNotEmpty ? book.buyLinks.first : null;
    if (link == null || link.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Link beli tidak tersedia')));
      return;
    }
    final uri = Uri.tryParse(link);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final priceInt = CurrencyUtil.parseRupiahToInt(book.priceRaw);

    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: Image.network(book.coverImage, fit: BoxFit.cover, errorBuilder: (_, __, ___) {
                return const ColoredBox(color: Colors.black12, child: Center(child: Icon(Icons.image_not_supported)));
              }),
            ),
          ),
          const SizedBox(height: 16),
          Text(book.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(book.authorName),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(label: Text(book.categoryName)),
              if (book.publisher.isNotEmpty) Chip(label: Text(book.publisher)),
              if (book.format.isNotEmpty) Chip(label: Text(book.format)),
            ],
          ),
          const SizedBox(height: 12),
          Text(book.summary.isEmpty ? '-' : book.summary),
          const SizedBox(height: 16),
          Text('Detail', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          _kv('ISBN', book.isbn),
          _kv('Harga', priceInt > 0 ? CurrencyUtil.formatRupiah(priceInt) : book.priceRaw),
          _kv('Total Pages', book.totalPages),
          _kv('Size', book.size),
          _kv('Published Date', book.publishedDate),
          _kv('Format', book.format),
          const SizedBox(height: 16),
          if (book.tags.isNotEmpty) ...[
            Text('Tags', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: book.tags.map((t) => Chip(label: Text(t))).toList(),
            ),
          ],
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _openBuyLink(context),
                  child: const Text('Buy'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () => context.push('/rent/order', extra: book),
                  child: const Text('Rent'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(k, style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text(v.isEmpty ? '-' : v)),
        ],
      ),
    );
  }
}