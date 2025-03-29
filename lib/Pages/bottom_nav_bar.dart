import 'package:flutter/material.dart';
import 'package:flutter_recipe_app/Pages/drawer.dart';
import 'package:flutter_recipe_app/Pages/homepage.dart';
import 'package:flutter_recipe_app/Pages/search_page.dart';

void main() {
  runApp(const BottomNavBar());
}

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int myCurrentIndex = 0;
  List pages = const [
    Homepage(),
    Search(),
  ]; // removed MyDrawer from the list

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: const Color.fromARGB(255, 116, 116, 116),
              spreadRadius: 0,
              blurRadius: 16.5,
              offset: Offset(0, 4))
        ]),
        child: Builder(builder: (context) {
          return BottomNavigationBar(
            onTap: (index) {
              if (index == 2) {
                Scaffold.of(context).openEndDrawer();
              } else {
                setState(() {
                  myCurrentIndex = index;
                });
              }
            },
            currentIndex: myCurrentIndex,
            selectedLabelStyle: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.018,
                fontFamily: 'Bold'),
            unselectedLabelStyle: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.016,
                fontFamily: 'medium'),
            unselectedItemColor: Color.fromRGBO(0, 0, 0, 10),
            selectedItemColor: Color.fromRGBO(76, 175, 80, 1),
            elevation: 10,
            backgroundColor: Color.fromRGBO(211, 231, 192, 1),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search), label: 'Search'),
              BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
            ],
          );
        }),
      ),
      body: pages[myCurrentIndex],
      endDrawer: MyDrawer(),
    );
  }
}
