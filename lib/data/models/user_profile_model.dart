import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_profile.dart';

class UserProfileModel {
  final String uid;
  final String name;
  final String email;
  final DateTime createdAt;

  UserProfileModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  static UserProfileModel fromDoc(String uid, Map<String, dynamic> data) {
    final ts = data['createdAt'];
    return UserProfileModel(
      uid: uid,
      name: (data['name'] ?? '') as String,
      email: (data['email'] ?? '') as String,
      createdAt: ts is Timestamp ? ts.toDate() : DateTime.now(),
    );
  }

  UserProfile toEntity() => UserProfile(uid: uid, name: name, email: email);
}