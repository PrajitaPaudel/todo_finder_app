import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../core/utils/local_storage.dart';

class CheckerScreen extends StatefulWidget {
  const CheckerScreen({super.key});

  @override
  State<CheckerScreen> createState() => _CheckerScreenState();
}

class _CheckerScreenState extends State<CheckerScreen> {
  late final Future<String> _nextRouteFuture;
  bool _redirected = false;

  @override
  void initState() {
    super.initState();
    _nextRouteFuture = _nextRoute();
  }

  Future<String> _nextRoute() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await LocalStorage.setBool('is_logged_in', true);
      await LocalStorage.setBool('is_registered', true);
      return '/home';
    }

    final isRegistered = await LocalStorage.getBool('is_registered') ?? false;
    final isLoggedIn = await LocalStorage.getBool('is_logged_in') ?? false;

    if (isLoggedIn) {
      return '/home';
    }

    if (isRegistered) {
      return '/login';
    }

    return '/register';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String>(
        future: _nextRouteFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final route = snapshot.data ?? '/register';

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && !_redirected) {
              _redirected = true;
              Navigator.pushReplacementNamed(context, route);
            }
          });

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
