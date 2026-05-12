class PlaceEntity {
  final String id;
  final String name;
  final String category;
  final String thumbnailUrl;
  final String description;
  final String address;
  final double? latitude;
  final double? longitude;

  const PlaceEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.thumbnailUrl,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
  });
}
