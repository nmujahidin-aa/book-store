import 'package:flutter/material.dart';
import '../viewmodels/home/book_query_state.dart';

class FilterSortSheet extends StatefulWidget {
  final BookQueryState initial;
  const FilterSortSheet({super.key, required this.initial});

  @override
  State<FilterSortSheet> createState() => _FilterSortSheetState();
}

class _FilterSortSheetState extends State<FilterSortSheet> {
  late final yearCtrl = TextEditingController(text: widget.initial.year ?? '');
  late final genreCtrl = TextEditingController(text: widget.initial.genre ?? '');
  late BookSortKey sortKey = widget.initial.sortKey;

  @override
  void dispose() {
    yearCtrl.dispose();
    genreCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: bottom + 16),
      child: Wrap(
        runSpacing: 12,
        children: [
          Text('Filter & Sort', style: Theme.of(context).textTheme.titleLarge),
          TextField(
            controller: yearCtrl,
            decoration: const InputDecoration(labelText: 'Filter Tahun (mis: 2020)'),
          ),
          TextField(
            controller: genreCtrl,
            decoration: const InputDecoration(labelText: 'Filter Genre/Kategori (mis: Novel)'),
          ),
          DropdownButtonFormField<BookSortKey>(
            value: sortKey,
            items: BookSortKey.values
                .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
                .toList(),
            onChanged: (v) => setState(() => sortKey = v ?? sortKey),
            decoration: const InputDecoration(labelText: 'Sort'),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context, BookQueryState.initial().copyWith(keyword: widget.initial.keyword)),
                  child: const Text('Reset'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                      widget.initial.copyWith(
                        year: yearCtrl.text.trim().isEmpty ? null : yearCtrl.text.trim(),
                        genre: genreCtrl.text.trim().isEmpty ? null : genreCtrl.text.trim(),
                        sortKey: sortKey,
                      ),
                    );
                  },
                  child: const Text('Apply'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}