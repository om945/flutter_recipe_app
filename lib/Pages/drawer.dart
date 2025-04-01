import 'package:flutter/material.dart';
import 'package:flutter_recipe_app/Pages/fav_recipe.dart';
import 'package:url_launcher/url_launcher.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return Drawer(
      backgroundColor: Color.fromRGBO(211, 231, 192, 1),
      child: Column(
        children: [
          DrawerHeader(
              child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset('assets/images/applogo.png'),
          )),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListTile(
              title: Text(
                "Home",
                style: TextStyle(
                    color: Color.fromRGBO(79, 77, 78, 1),
                    fontSize: 20,
                    fontFamily: 'Medium'),
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
                style: TextStyle(
                    color: Color.fromRGBO(79, 77, 78, 1),
                    fontSize: 20,
                    fontFamily: 'Medium'),
              ),
              leading: Icon(Icons.favorite),
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        FavRecipe(),
                    transitionDuration: Duration(milliseconds: 200),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return SlideTransition(
                        position: animation.drive(
                          Tween<Offset>(
                            begin: Offset(1.0, 0.0),
                            end: Offset.zero,
                          ),
                        ),
                        child: child,
                      );
                    },
                  ),
                );
              },
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(15.0),
          //   child: ListTile(
          //     title: Text(
          //       "About",
          //       style: TextStyle(fontSize: 20, fontFamily: 'Medium'),
          //     ),
          //     leading: Icon(Icons.info),
          //     onTap: () {
          //       Navigator.of(context).push(
          //         PageRouteBuilder(
          //           pageBuilder: (context, animation, secondaryAnimation) =>
          //               AboutPage(),
          //           transitionDuration: Duration(milliseconds: 200),
          //           transitionsBuilder:
          //               (context, animation, secondaryAnimation, child) {
          //             return SlideTransition(
          //               position: animation.drive(
          //                 Tween<Offset>(
          //                   begin: Offset(1.0, 0.0),
          //                   end: Offset.zero,
          //                 ),
          //               ),
          //               child: child,
          //             );
          //           },
          //         ),
          //       );
          //     },
          //   ),
          // )
          Expanded(
            child: Container(),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Container(
              width: screenwidth,
              height: screenheight * 0.0008,
              color: Color.fromRGBO(200, 199, 199, 1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () {
                      launchUrl(Uri.parse('https://github.com/om945'));
                    },
                    child: Image.asset(
                      "assets/images/github.png",
                      height: screenwidth * 0.06,
                      width: screenwidth * 0.06,
                    )),
                SizedBox(
                  width: 15,
                ),
                GestureDetector(
                    onTap: () {
                      launchUrl(Uri.parse(
                          'https://www.linkedin.com/in/om-belekar-aab424326?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app'));
                    },
                    child: Image.asset(
                      "assets/images/linkedin.png",
                      height: screenwidth * 0.06,
                      width: screenwidth * 0.06,
                    )),
                SizedBox(
                  width: 15,
                ),
                GestureDetector(
                    onTap: () {
                      launchUrl(Uri.parse('https://x.com/om_belekar123'));
                    },
                    child: Image.asset(
                      "assets/images/twitter.png",
                      height: screenwidth * 0.06,
                      width: screenwidth * 0.06,
                    )),
                SizedBox(
                  width: 15,
                ),
                GestureDetector(
                    onTap: () {
                      launchUrl(Uri.parse(
                          'https://www.instagram.com/om_belekar_?igsh=MXh1Zzdxc2MyNHlscQ=='));
                    },
                    child: Image.asset(
                      "assets/images/instagram.png",
                      height: screenwidth * 0.06,
                      width: screenwidth * 0.06,
                    ))
              ],
            ),
          ),
          GestureDetector(
              onTap: () {
                launchUrl(Uri.parse(
                    'https://www.instagram.com/om_belekar_?igsh=MXh1Zzdxc2MyNHlscQ=='));
              },
              child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromRGBO(211, 231, 192, 1)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Color.fromRGBO(79, 77, 78, 1)),
                      ),
                    ),
                  ),
                  onPressed: () {
                    launchUrl(Uri.parse(
                        'https://food-recipe-app-ratnesh-chipres-projects.vercel.app/'));
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Visit our Website',
                        style: TextStyle(
                          color: Color.fromRGBO(79, 77, 78, 1),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Image.asset(
                        "assets/images/arrows.png",
                        height: screenwidth * 0.05,
                        width: screenwidth * 0.05,
                      ),
                    ],
                  ))),
          Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Copyright @2025. All rights reserved | Made by ',
                      style: TextStyle(
                          fontFamily: 'Medium',
                          color: Color.fromRGBO(79, 77, 78, 1)),
                    ),
                    TextSpan(
                        text: 'Om Belekar',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Bold',
                          color: Color.fromRGBO(50, 48, 49, 1),
                        )),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
