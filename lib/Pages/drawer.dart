import 'package:flutter/material.dart';
import 'package:flutter_recipe_app/Pages/fav_recipe.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color.fromRGBO(211, 231, 192, 1),
      child: SingleChildScrollView(
        child: Column(
          children: [
            DrawerHeader(
                child: Icon(
              Icons.food_bank_rounded,
              size: 100,
            )),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListTile(
                title: Text(
                  "Home",
                  style: TextStyle(fontSize: 20, fontFamily: 'Medium'),
                ),
                leading: Icon(Icons.home),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListTile(
                title: Text(
                  "Favorites",
                  style: TextStyle(fontSize: 20, fontFamily: 'Medium'),
                ),
                leading: Icon(Icons.favorite),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => FavRecipe()));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListTile(
                title: Text(
                  "About",
                  style: TextStyle(fontSize: 20, fontFamily: 'Medium'),
                ),
                leading: Icon(Icons.info),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
