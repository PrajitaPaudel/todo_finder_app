import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/place/presentation/bloc/place_bloc.dart';
import 'features/place/presentation/screen/place_finder_screen.dart';
import 'injection_container.dart';




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

        BlocProvider<PlaceBloc>(
          create: (context) => sl<PlaceBloc>(),
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
        initialRoute: '/home',
        routes: {
          '/home': (_) => const PlaceFinderScreen(),

        },
      ),
    );
  }
}
