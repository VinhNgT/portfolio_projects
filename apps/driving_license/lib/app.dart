import 'package:driving_license/features/home_page.dart';
import 'package:driving_license/theme/theme.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Driving License App',
      theme: const MaterialTheme().light(),
      darkTheme: const MaterialTheme().dark(),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}