import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'destination_model.g.dart';

@JsonSerializable()
class DestinationModel extends Equatable {
  final String id;
  final String name;
  final String roomNumber;
  final String category;
  final String description;
  final Map<String, dynamic>? coordinates;

  const DestinationModel({
    required this.id,
    required this.name,
    required this.roomNumber,
    required this.category,
    required this.description,
    this.coordinates,
  });

  factory DestinationModel.fromJson(Map<String, dynamic> json) =>
      _$DestinationModelFromJson(json);

  Map<String, dynamic> toJson() => _$DestinationModelToJson(this);

  @override
  List<Object?> get props => [id, name, roomNumber, category, description, coordinates];

  DestinationModel copyWith({
    String? id,
    String? name,
    String? roomNumber,
    String? category,
    String? description,
    Map<String, dynamic>? coordinates,
  }) {
    return DestinationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      roomNumber: roomNumber ?? this.roomNumber,
      category: category ?? this.category,
      description: description ?? this.description,
      coordinates: coordinates ?? this.coordinates,
    );
  }
}

@JsonSerializable()
class DestinationsData extends Equatable {
  final String building;
  final String floor;
  final List<DestinationModel> destinations;

  const DestinationsData({
    required this.building,
    required this.floor,
    required this.destinations,
  });

  factory DestinationsData.fromJson(Map<String, dynamic> json) =>
      _$DestinationsDataFromJson(json);

  Map<String, dynamic> toJson() => _$DestinationsDataToJson(this);

  @override
  List<Object?> get props => [building, floor, destinations];
}

