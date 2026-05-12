import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/presentation/bloc/login_bloc.dart';
import 'features/auth/presentation/bloc/registration_bloc.dart';
import 'features/auth/presentation/login_screen.dart';
import 'injection_container.dart';
import 'features/auth/presentation/regestration_screen.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/home/presentation/bloc/home_event.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';
import 'features/profile/presentation/bloc/profile_event.dart';
import 'features/profile/presentation/profile_screen.dart';
import 'features/home/presentation/home_screen.dart';
import 'features/checker.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await initializeDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RegisterBloc>(
          create: (context) => sl<RegisterBloc>(),
        ),
        BlocProvider<LoginBloc>(
          create: (context) => sl<LoginBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
          ),
        ),
        initialRoute: '/checker',
        routes: {
          '/checker': (_) => const CheckerScreen(),
          '/register': (_) => const RegistrationScreen(),
          '/login': (_) => const LoginScreen(),
          '/home': (_) => BlocProvider(
                create: (_) => sl<HomeBloc>()..add(HomeStarted()),
                child: const HomeScreen(),
              ),
          '/profile': (_) => BlocProvider(
                create: (_) => sl<ProfileBloc>()..add(ProfileStarted()),
                child: const ProfileScreen(),
              ),
        },
      ),
    );
  }
}
