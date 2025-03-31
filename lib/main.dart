import 'package:flutter/material.dart';
import 'package:flutter_recipe_app/Pages/bottom_nav_bar.dart';
import 'package:flutter_recipe_app/connectivity/connectivity_injection.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  runApp(const MyApp());
  DependencyInjection.init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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
