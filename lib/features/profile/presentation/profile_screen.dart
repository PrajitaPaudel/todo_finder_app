import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/entity/profile_entity.dart';
import 'bloc/profile_bloc.dart';
import 'bloc/profile_event.dart';
import 'bloc/profile_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();

  String _initials(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'G';
    return trimmed.substring(0, 1).toUpperCase();
  }

  void _showEditDialog(String currentName) {
    _nameController.text = currentName;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: TextField(
            controller: _nameController,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Display name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<ProfileBloc>().add(
                  ProfileDisplayNameSubmitted(_nameController.text.trim()),
                );
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }

        if (state is ProfileLogoutSuccess) {
          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        }
      },
      builder: (context, state) {
        final profile = _profileFromState(state);

        if (state is ProfileLoading && profile == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Profile')),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (profile == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Profile'),
              actions: [
                IconButton(
                  onPressed: () {
                    context.read<ProfileBloc>().add(ProfileLogoutRequested());
                  },
                  icon: const Icon(Icons.logout),
                ),
              ],
            ),
            body: const Center(child: Text('No profile data available.')),
          );
        }

        final displayName = profile.displayName.trim().isNotEmpty
            ? profile.displayName
            : 'Guest User';
        final email = profile.email.trim().isNotEmpty
            ? profile.email
            : 'No email available';

        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            actions: [
              IconButton(
                onPressed: () {
                  context.read<ProfileBloc>().add(ProfileLogoutRequested());
                },
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey.shade300,
                          child: Text(
                            _initials(displayName),
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                displayName,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                email,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Display name'),
                      subtitle: Text(displayName),
                    ),
                    const SizedBox(height: 8),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Email'),
                      subtitle: Text(email),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: state is ProfileSaving
                          ? null
                          : () => _showEditDialog(displayName),
                      icon: state is ProfileSaving
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.edit),
                      label: const Text('Update display name'),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () {
                        context.read<ProfileBloc>().add(ProfileLogoutRequested());
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  ProfileEntity? _profileFromState(ProfileState state) {
    if (state is ProfileLoaded) {
      return state.profile;
    }

    if (state is ProfileSaving) {
      return state.profile;
    }

    if (state is ProfileFailure && state.profile != null) {
      return state.profile;
    }

    return null;
  }
}
