// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'navigation_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NavigationHistoryModel _$NavigationHistoryModelFromJson(
  Map<String, dynamic> json,
) => NavigationHistoryModel(
  id: json['id'] as String,
  userId: json['userId'] as String,
  destinationId: json['destinationId'] as String,
  destinationName: json['destinationName'] as String,
  roomNumber: json['roomNumber'] as String,
  timestamp: DateTime.parse(json['timestamp'] as String),
  completed: json['completed'] as bool? ?? false,
);

Map<String, dynamic> _$NavigationHistoryModelToJson(
  NavigationHistoryModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'destinationId': instance.destinationId,
  'destinationName': instance.destinationName,
  'roomNumber': instance.roomNumber,
  'timestamp': instance.timestamp.toIso8601String(),
  'completed': instance.completed,
};
