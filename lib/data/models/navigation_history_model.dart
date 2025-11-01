import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'navigation_history_model.g.dart';

@JsonSerializable()
class NavigationHistoryModel extends Equatable {
  final String id;
  final String userId;
  final String destinationId;
  final String destinationName;
  final String roomNumber;
  final DateTime timestamp;
  final bool completed;

  const NavigationHistoryModel({
    required this.id,
    required this.userId,
    required this.destinationId,
    required this.destinationName,
    required this.roomNumber,
    required this.timestamp,
    this.completed = false,
  });

  factory NavigationHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$NavigationHistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$NavigationHistoryModelToJson(this);

  @override
  List<Object?> get props => [
        id,
        userId,
        destinationId,
        destinationName,
        roomNumber,
        timestamp,
        completed,
      ];

  NavigationHistoryModel copyWith({
    String? id,
    String? userId,
    String? destinationId,
    String? destinationName,
    String? roomNumber,
    DateTime? timestamp,
    bool? completed,
  }) {
    return NavigationHistoryModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      destinationId: destinationId ?? this.destinationId,
      destinationName: destinationName ?? this.destinationName,
      roomNumber: roomNumber ?? this.roomNumber,
      timestamp: timestamp ?? this.timestamp,
      completed: completed ?? this.completed,
    );
  }
}

