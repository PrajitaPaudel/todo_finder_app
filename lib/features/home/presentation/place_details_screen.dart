import 'package:flutter/material.dart';

import '../domain/entity/place_entity.dart';
import 'place_route_map.dart';

class PlaceDetailsScreen extends StatefulWidget {
  final PlaceEntity place;

  const PlaceDetailsScreen({
    super.key,
    required this.place,
  });

  @override
  State<PlaceDetailsScreen> createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    Widget networkImage(String url) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.place.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PlaceRouteMap(place: widget.place),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 20),
                  Text(
                    widget.place.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Chip(label: Text(widget.place.category)),
                  const SizedBox(height: 20),
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.place.description,
                    style: const TextStyle(fontSize: 15, height: 1.5),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Address',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(widget.place.address),
                  const SizedBox(height: 20),
                  const Text(
                    'Coordinate Preview',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      'Latitude: ${widget.place.latitude?.toStringAsFixed(6) ?? 'Unknown'}\nLongitude: ${widget.place.longitude?.toStringAsFixed(6) ?? 'Unknown'}',
                    ),
                  ),
                  SizedBox(height: 20,),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: widget.place.thumbnailUrl.isNotEmpty
                          ? networkImage(widget.place.thumbnailUrl)
                          : _placeholder(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: Colors.grey.shade300,
      alignment: Alignment.center,
      child: const Icon(Icons.place, size: 54, color: Colors.black54),
    );
  }
}
