class Rent {
  final String id;
  final String bookId;
  final String title;
  final String coverImage;
  final String authorName;
  final int rentDays;
  final int pricePerDay;
  final int totalPrice;
  final DateTime rentedAt;
  final DateTime expiredAt;

  const Rent({
    required this.id,
    required this.bookId,
    required this.title,
    required this.coverImage,
    required this.authorName,
    required this.rentDays,
    required this.pricePerDay,
    required this.totalPrice,
    required this.rentedAt,
    required this.expiredAt,
  });
}