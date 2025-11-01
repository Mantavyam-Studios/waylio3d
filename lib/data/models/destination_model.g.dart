// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'destination_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DestinationModel _$DestinationModelFromJson(Map<String, dynamic> json) =>
    DestinationModel(
      id: json['id'] as String,
      name: json['name'] as String,
      roomNumber: json['roomNumber'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      coordinates: json['coordinates'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$DestinationModelToJson(DestinationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'roomNumber': instance.roomNumber,
      'category': instance.category,
      'description': instance.description,
      'coordinates': instance.coordinates,
    };

DestinationsData _$DestinationsDataFromJson(Map<String, dynamic> json) =>
    DestinationsData(
      building: json['building'] as String,
      floor: json['floor'] as String,
      destinations: (json['destinations'] as List<dynamic>)
          .map((e) => DestinationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DestinationsDataToJson(DestinationsData instance) =>
    <String, dynamic>{
      'building': instance.building,
      'floor': instance.floor,
      'destinations': instance.destinations,
    };
