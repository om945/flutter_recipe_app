import 'package:flutter/material.dart';
import 'package:flutter_recipe_app/Pages/bottom_nav_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF5F5DC),
        ),
        scaffoldBackgroundColor: Color(0xFFF5F5DC),
        primarySwatch: Colors.green,
      ),
      home: BottomNavBar(),
    );
  }
}
