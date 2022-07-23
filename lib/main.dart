import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spot_the_bird/bloc/location_cubit.dart';
import 'package:spot_the_bird/screens/map_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(

      create: (BuildContext context) => LocationCubit()..getLocation(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(

          primaryColor: const Color(0xFF495C83),
          colorScheme: const ColorScheme.light().copyWith(
            primary: const Color(0xFF7A86B6),
            secondary: const Color(0xFFC8B6E2)
          )
        ),
        home: MapScreen(),
      ),
    );
  }
}

