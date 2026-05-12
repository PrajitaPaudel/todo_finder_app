import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:place_finder_app/core/utils/capitalize_word.dart';


import '../domain/entity/place_entity.dart';
import 'bloc/home_bloc.dart';
import 'bloc/home_state.dart';
import 'place_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _initials(String? name) {
    if (name == null || name.trim().isEmpty) return 'G';
    return name.trim().substring(0, 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        PreferredSizeWidget buildAppBar() {
          return AppBar(
            titleSpacing: 16,
            backgroundColor: Colors.blue.withAlpha(40),
            title: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: currentUser == null
                  ? null
                  : FirebaseFirestore.instance
                      .collection('users')
                      .doc(currentUser.uid)
                      .snapshots(),
              builder: (context, snapshot) {
                final data = snapshot.data?.data();
                final firestoreName = data?['displayName'] as String?;
                final fallbackName = currentUser?.email;
                final displayName = firestoreName?.trim().isNotEmpty == true
                    ? firestoreName!.trim()
                    : (fallbackName?.contains('@') == true
                        ? fallbackName!.split('@').first
                        : 'Guest');

                return Text(
                  'Hello, ${displayName.toCapitalize()}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),
            actions: [
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: currentUser == null
                    ? null
                    : FirebaseFirestore.instance
                        .collection('users')
                        .doc(currentUser.uid)
                        .snapshots(),
                builder: (context, snapshot) {
                  final data = snapshot.data?.data();
                  final firestoreName = data?['displayName'] as String?;
                  final fallbackName = currentUser?.email;
                  final displayName = firestoreName?.trim().isNotEmpty == true
                      ? firestoreName!.trim()
                      : (fallbackName?.contains('@') == true
                          ? fallbackName!.split('@').first
                          : null);

                  return Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () => Navigator.pushNamed(context, '/profile'),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey.shade200,
                        child: Text(
                          _initials(displayName),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        }

        if (state is HomeLoading || state is HomeInitial) {
          return Scaffold(
            appBar: buildAppBar(),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is HomeFailure) {
          return Scaffold(
            appBar: buildAppBar(),
            body: Center(
              child: Text(
                state.message,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (state is HomeEmpty) {
          return Scaffold(
            appBar: buildAppBar(),
            body: const Center(
              child: Text('No places found yet.'),
            ),
          );
        }

        final places = state is HomeLoaded ? state.places : <PlaceEntity>[];

        return Scaffold(
          appBar: buildAppBar(),
          body: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: places.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final place = places[index];
              return _PlaceCard(
                place: place,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PlaceDetailsScreen(place: place),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _PlaceCard extends StatelessWidget {
  final PlaceEntity place;
  final VoidCallback onTap;

  const _PlaceCard({
    required this.place,
    required this.onTap,
  });

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

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: SizedBox(
                  width: 88,
                  height: 88,
                  child: place.thumbnailUrl.isNotEmpty
                      ? networkImage(place.thumbnailUrl)
                      : _placeholder(),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      place.category,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      place.address,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: Colors.grey.shade300,
      alignment: Alignment.center,
      child: const Icon(Icons.image, color: Colors.black54),
    );
  }
}
