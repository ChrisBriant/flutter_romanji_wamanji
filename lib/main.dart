import 'dart:io';

import 'package:flutter/material.dart';
import 'package:romanji_wamanji/screens/add_verb_screen.dart';
import 'package:romanji_wamanji/screens/home_screen.dart';
import 'package:romanji_wamanji/screens/verb_display_screen.dart';
import 'package:romanji_wamanji/screens/verb_example_screen.dart';
import 'package:romanji_wamanji/screens/verb_examples_screen.dart';
import './screens/splash_screen.dart';
import 'package:loggy/loggy.dart';
import './services/http_overrides.dart';
import 'package:provider/provider.dart';
import './providers/data_provider.dart';

void main() {
  Loggy.initLoggy();
  HttpOverrides.global = MyHttpOverrides();
  runApp(const RomajiWamaji());
}

class RomajiWamaji extends StatelessWidget {
  const RomajiWamaji({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DataProvider(),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          brightness: Brightness.dark,
          colorScheme: .fromSeed(seedColor: Colors.black, brightness: Brightness.dark),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // Button background
                foregroundColor: Colors.black, // Text/Icon color
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold, // Makes it bold
                  fontSize: 16,
                ),
              ),
            ),
        ),
        home: const SplashScreen(),
        routes: {
          HomeScreen.routeName : (context) => HomeScreen(),
          VerbDisplayScreen.routeName : (context) => VerbDisplayScreen(),
          AddVerbScreen.routeName : (context) => AddVerbScreen(),
          VerbExampleScreen.routeName : (content) => VerbExampleScreen(),
          VerbExamplesScreen.routeName : (context) => const VerbExamplesScreen(),

        },
      ),
    );
  }
}
