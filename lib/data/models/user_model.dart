import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  final String uid;
  final String email;
  final String name;
  final String? photoUrl;
  final String userType;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isGuest;

  const UserModel({
    required this.uid,
    required this.email,
    required this.name,
    this.photoUrl,
    required this.userType,
    required this.createdAt,
    this.updatedAt,
    this.isGuest = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  // Create a guest user
  factory UserModel.guest() {
    return UserModel(
      uid: 'guest_${DateTime.now().millisecondsSinceEpoch}',
      email: 'guest@waylio.app',
      name: 'Guest User',
      userType: 'Visitor',
      createdAt: DateTime.now(),
      isGuest: true,
    );
  }

  @override
  List<Object?> get props => [
        uid,
        email,
        name,
        photoUrl,
        userType,
        createdAt,
        updatedAt,
        isGuest,
      ];

  UserModel copyWith({
    String? uid,
    String? email,
    String? name,
    String? photoUrl,
    String? userType,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isGuest,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      userType: userType ?? this.userType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isGuest: isGuest ?? this.isGuest,
    );
  }
}

