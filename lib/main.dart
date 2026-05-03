import 'dart:io';

import 'package:flutter/material.dart';
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
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          colorScheme: .fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
