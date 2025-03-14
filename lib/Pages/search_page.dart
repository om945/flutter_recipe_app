import 'package:flutter/material.dart';
import 'package:flutter_recipe_app/Pages/drawer.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: const Color.fromRGBO(0, 0, 0, 25),
              spreadRadius: 0,
              blurRadius: 16.1,
              offset: Offset(0, 4))
        ]),
        child: BottomNavigationBar(
            onTap: (value) {
              if (value == 0) {
                Navigator.pop(context);
              } else if (value == 1) {
                return;
              } else if (value == 2) {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Drawer(
                      child: MyDrawer(),
                    );
                  },
                );
              }
            },
            selectedLabelStyle: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.018,
                fontFamily: 'Bold'),
            unselectedLabelStyle: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.016,
                fontFamily: 'medium'),
            unselectedItemColor: Color.fromRGBO(0, 0, 0, 10),
            selectedItemColor: Color.fromRGBO(76, 175, 80, 1),
            currentIndex: 1,
            elevation: 10,
            backgroundColor: Color.fromRGBO(211, 231, 192, 1),
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Search',
                  tooltip: 'Search for recipes')
            ]),
      ),
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(
          "Search",
          style: TextStyle(
              color: Color.fromRGBO(76, 175, 80, 1),
              fontFamily: 'Medium',
              fontSize: MediaQuery.of(context).size.height * 0.03),
        ),
      ),
    );
  }
}
