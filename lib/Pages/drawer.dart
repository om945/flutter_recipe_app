import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

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
                  "H o m e",
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
                  "F a v o r i t e s",
                  style: TextStyle(fontSize: 20, fontFamily: 'Medium'),
                ),
                leading: Icon(Icons.favorite),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListTile(
                title: Text(
                  "A b o u t",
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
