import '../../domain/entities/book.dart';

class BookModel {
  final String id;
  final String title;
  final String coverImage;
  final AuthorModel author;
  final CategoryModel category;
  final String summary;
  final DetailsModel details;
  final List<TagModel> tags;
  final List<dynamic> buyLinks;
  final String publisher;

  BookModel({
    required this.id,
    required this.title,
    required this.coverImage,
    required this.author,
    required this.category,
    required this.summary,
    required this.details,
    required this.tags,
    required this.buyLinks,
    required this.publisher,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: (json['_id'] ?? '') as String,
      title: (json['title'] ?? '') as String,
      coverImage: (json['cover_image'] ?? '') as String,
      author: AuthorModel.fromJson((json['author'] ?? {}) as Map<String, dynamic>),
      category: CategoryModel.fromJson((json['category'] ?? {}) as Map<String, dynamic>),
      summary: (json['summary'] ?? '') as String,
      details: DetailsModel.fromJson((json['details'] ?? {}) as Map<String, dynamic>),
      tags: (json['tags'] as List? ?? []).map((e) => TagModel.fromJson(e as Map<String, dynamic>)).toList(),
      buyLinks: (json['buy_links'] as List?) ?? const [],
      publisher: (json['publisher'] ?? '') as String,
    );
  }

  Book toEntity() {
    return Book(
      id: id,
      title: title,
      coverImage: coverImage,
      authorName: author.name,
      categoryName: category.name,
      summary: summary,
      publisher: publisher,
      isbn: details.isbn,
      priceRaw: details.price,
      totalPages: details.totalPages,
      size: details.size,
      publishedDate: details.publishedDate,
      format: details.format,
      tags: tags.map((e) => e.toString()).toList(),
      buyLinks: buyLinks.map((e) => e.toString()).toList(),
    );
  }
}

class AuthorModel {
  final String name;
  final String url;
  AuthorModel({required this.name, required this.url});

  factory AuthorModel.fromJson(Map<String, dynamic> json) => AuthorModel(
        name: (json['name'] ?? '') as String,
        url: (json['url'] ?? '') as String,
      );
}

class CategoryModel {
  final String name;
  final String url;
  CategoryModel({required this.name, required this.url});

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        name: (json['name'] ?? '') as String,
        url: (json['url'] ?? '') as String,
      );
}

class DetailsModel {
  final String isbn;
  final String price;
  final String totalPages;
  final String size;
  final String publishedDate;
  final String format;

  DetailsModel({
    required this.isbn,
    required this.price,
    required this.totalPages,
    required this.size,
    required this.publishedDate,
    required this.format,
  });

  factory DetailsModel.fromJson(Map<String, dynamic> json) => DetailsModel(
        isbn: (json['isbn'] ?? '') as String,
        price: (json['price'] ?? '') as String,
        totalPages: (json['total_pages'] ?? '') as String,
        size: (json['size'] ?? '') as String,
        publishedDate: (json['published_date'] ?? '') as String,
        format: (json['format'] ?? '') as String,
      );
}

class TagModel {
  final String name;
  final String url;

  TagModel({required this.name, required this.url});

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      name: json['name'] ?? '',
      url: json['url'] ?? '',
    );
  }

  @override
  String toString() => name;
}