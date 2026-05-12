import '../../domain/entity/place_entity.dart';

class PlaceModel {
  final String id;
  final String name;
  final String category;
  final String thumbnailUrl;
  final String description;
  final String address;
  final double? latitude;
  final double? longitude;

  const PlaceModel({
    required this.id,
    required this.name,
    required this.category,
    required this.thumbnailUrl,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory PlaceModel.fromJson(String id, Map<String, dynamic> json) {
    return PlaceModel(
      id: id,
      name: (json['name'] ?? '').toString(),
      category: (json['category'] ?? 'Uncategorized').toString(),
      thumbnailUrl: (json['thumbnail'] ?? '').toString(),
      description: (json['description'] ?? 'No description available').toString(),
      address: (json['address'] ?? 'No address available').toString(),
      latitude: _readDouble(json['latitude']),
      longitude: _readDouble(json['longitude']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'thumbnail': thumbnailUrl,
      'description': description,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory PlaceModel.fromEntity(PlaceEntity entity) {
    return PlaceModel(
      id: entity.id,
      name: entity.name,
      category: entity.category,
      thumbnailUrl: entity.thumbnailUrl,
      description: entity.description,
      address: entity.address,
      latitude: entity.latitude,
      longitude: entity.longitude,
    );
  }

  PlaceEntity toEntity() {
    return PlaceEntity(
      id: id,
      name: name,
      category: category,
      thumbnailUrl: thumbnailUrl,
      description: description,
      address: address,
      latitude: latitude,
      longitude: longitude,
    );
  }

  static double? _readDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
