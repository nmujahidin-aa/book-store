import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/rent.dart';

class RentModel {
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

  RentModel({
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

  Map<String, dynamic> toJson() => {
        'bookId': bookId,
        'title': title,
        'coverImage': coverImage,
        'authorName': authorName,
        'rentDays': rentDays,
        'pricePerDay': pricePerDay,
        'totalPrice': totalPrice,
        'rentedAt': Timestamp.fromDate(rentedAt),
        'expiredAt': Timestamp.fromDate(expiredAt),
      };

  factory RentModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    DateTime toDate(dynamic v) {
      if (v is Timestamp) return v.toDate();
      return DateTime.fromMillisecondsSinceEpoch(0);
    }

    return RentModel(
      id: doc.id,
      bookId: (data['bookId'] ?? '') as String,
      title: (data['title'] ?? '') as String,
      coverImage: (data['coverImage'] ?? '') as String,
      authorName: (data['authorName'] ?? '') as String,
      rentDays: (data['rentDays'] ?? 0) as int,
      pricePerDay: (data['pricePerDay'] ?? 0) as int,
      totalPrice: (data['totalPrice'] ?? 0) as int,
      rentedAt: toDate(data['rentedAt']),
      expiredAt: toDate(data['expiredAt']),
    );
  }

  Rent toEntity() => Rent(
        id: id,
        bookId: bookId,
        title: title,
        coverImage: coverImage,
        authorName: authorName,
        rentDays: rentDays,
        pricePerDay: pricePerDay,
        totalPrice: totalPrice,
        rentedAt: rentedAt,
        expiredAt: expiredAt,
      );
}