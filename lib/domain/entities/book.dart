class Book {
  final String id;
  final String title;
  final String coverImage;
  final String authorName;
  final String categoryName;
  final String summary;
  final String publisher;

  final String isbn;
  final String priceRaw;
  final String totalPages;
  final String size;
  final String publishedDate;
  final String format;

  final List<String> tags;
  final List<String> buyLinks;

  const Book({
    required this.id,
    required this.title,
    required this.coverImage,
    required this.authorName,
    required this.categoryName,
    required this.summary,
    required this.publisher,
    required this.isbn,
    required this.priceRaw,
    required this.totalPages,
    required this.size,
    required this.publishedDate,
    required this.format,
    required this.tags,
    required this.buyLinks,
  });
}