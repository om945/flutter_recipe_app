import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recipe_app/Pages/recipe_details.dart';
import 'package:flutter_recipe_app/modules/recipe_search.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Homepage_Recipe extends StatefulWidget {
  final String recipe;
  const Homepage_Recipe({super.key, required this.recipe});

  @override
  State<Homepage_Recipe> createState() => _Homepage_RecipeState();
}

class _Homepage_RecipeState extends State<Homepage_Recipe> {
  bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600;

  Set<String> favoriteMealIds = {}; // Store meal IDs of favorites
  Future<List<Meals>> recipeSearch() async {
    setState(() {
      _isLoading = true;
    });

    Uri url = Uri.parse(
        "https://www.themealdb.com/api/json/v1/1/search.php?s=${widget.recipe}");
    var response = await http.get(url);

    try {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['meals'] != null) {
          return (data['meals'] as List)
              .map((meal) => Meals.fromJson(meal))
              .toList();
        } else {
          return []; // Return empty list if no meals found
        }
      } else {
        if (kDebugMode) print("Failed to load data");
        return [];
      }
    } catch (e) {
      if (kDebugMode) print("Error: ${e.toString()}");
      return [];
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Meals> recipeModels = [];
  // Define favoriteRecipes
  bool _isLoading = true;
  myRecipes() {
    setState(() {
      _isLoading = true;
    });
    recipeSearch().then((value) {
      setState(() {
        recipeModels = value;
        _isLoading = false;
      });
    });
  }

  void _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteMealIds = prefs.getStringList('favoriteMeals')?.toSet() ?? {};
    });
  }

  void _toggleFavorite(Meals meal) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      if (favoriteMealIds.contains(meal.idMeal)) {
        favoriteMealIds.remove(meal.idMeal);
      } else {
        favoriteMealIds.add(meal.idMeal!);
      }
    });

    await prefs.setStringList('favoriteMeals', favoriteMealIds.toList());
  }

  @override
  void initState() {
    myRecipes();
    super.initState();
    _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
        // bottomNavigationBar: Container(
        //   decoration: BoxDecoration(boxShadow: [
        //     BoxShadow(
        //         color: const Color.fromRGBO(0, 0, 0, 25),
        //         spreadRadius: 0,
        //         blurRadius: 16.1,
        //         offset: Offset(0, 4))
        //   ]),
        //   child: BottomNavigationBar(
        //       onTap: (value) {
        //         if (value == 0) {
        //           Navigator.pushReplacementNamed(context, '/');
        //         } else if (value == 1) {
        //           Navigator.push(
        //             context,
        //             PageRouteBuilder(
        //               pageBuilder: (context, animation1, animation2) => Search(),
        //               transitionDuration: Duration(milliseconds: 200),
        //               reverseTransitionDuration: Duration(milliseconds: 200),
        //               transitionsBuilder:
        //                   (context, animation1, animation2, child) {
        //                 return SlideTransition(
        //                   position: Tween<Offset>(
        //                     begin: Offset(1, 0),
        //                     end: Offset(0, 0),
        //                   ).animate(animation1),
        //                   child: child,
        //                 );
        //               },
        //             ),
        //           );
        //         } else if (value == 2) {
        //           showModalBottomSheet(
        //             shape: RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.all(Radius.circular(20))),
        //             sheetAnimationStyle: AnimationStyle(
        //                 curve: Curves.bounceInOut,
        //                 duration: Duration(seconds: 1)),
        //             context: context,
        //             builder: (context) {
        //               return Container(
        //                 height: MediaQuery.of(context).size.height * 0.6,
        //                 width: MediaQuery.of(context).size.width * 0.8,
        //                 decoration: BoxDecoration(),
        //                 child: Drawer(
        //                   child: MyDrawer(),
        //                 ),
        //               );
        //             },
        //           );
        //         }
        //       },
        //       selectedLabelStyle: TextStyle(
        //           fontSize: MediaQuery.of(context).size.height * 0.018,
        //           fontFamily: 'Bold'),
        //       unselectedLabelStyle: TextStyle(
        //           fontSize: MediaQuery.of(context).size.height * 0.016,
        //           fontFamily: 'medium'),
        //       unselectedItemColor: Color.fromRGBO(0, 0, 0, 10),
        //       selectedItemColor: Color.fromRGBO(76, 175, 80, 1),
        //       currentIndex: 0,
        //       elevation: 10,
        //       backgroundColor: Color.fromRGBO(211, 231, 192, 1),
        //       items: [
        //         BottomNavigationBarItem(
        //             icon: Icon(Icons.home_rounded), label: 'Home'),
        //         BottomNavigationBarItem(
        //             icon: Icon(Icons.search),
        //             label: 'Search',
        //             tooltip: 'Search for recipes'),
        //         BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu')
        //       ]),
        // ),
        appBar: AppBar(
          clipBehavior: Clip.antiAlias,
          forceMaterialTransparency: true,
          title: Text(
            "Catagory of ${widget.recipe}",
            style: TextStyle(
                color: Color.fromRGBO(50, 48, 49, 1),
                fontFamily: 'Medium',
                fontSize: isDesktop(context)
                    ? screenwidth * 0.03
                    : screenwidth * 0.065),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(5.0),
          child: CustomScrollView(
            slivers: [
              if (_isLoading)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color.fromRGBO(76, 175, 80, 1),
                        ),
                      ),
                    ),
                  ),
                )
              else if (recipeModels.isEmpty)
                SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text("Nothing here! Try different category...",
                          style: TextStyle(
                              fontSize: screenwidth * 0.04,
                              fontFamily: 'Medium')),
                    ),
                  ),
                )
              else
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: isDesktop(context) ? 0.6 : 0.64,
                    crossAxisCount:
                        isDesktop(context) ? 4 : 2, // number of columns
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final recipe = recipeModels[index];
                      final isFavorite =
                          favoriteMealIds.contains(recipe.idMeal);
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      RecipeDetails(
                                recipe: recipeModels[index],
                              ),
                              transitionDuration: Duration(milliseconds: 200),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return FadeTransition(
                                    opacity: animation, child: child);
                              },
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            semanticContainer: false,
                            color: Color.fromRGBO(211, 231, 192, 1),
                            margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                            child: SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: _isLoading
                                        ? Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        //Image
                                        : Center(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Image.network(
                                                  recipeModels[index]
                                                          .strMealThumb ??
                                                      '',
                                                  // scale: 0.2,
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                  ),
                                  // SizedBox(
                                  //   height: screenheight * 0.01,
                                  // ),
                                  SizedBox(
                                    height: isDesktop(context)
                                        ? screenwidth * 0.085
                                        : screenwidth * 0.135,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                      child: Text(
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        recipeModels[index].strMeal ?? '',
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(50, 48, 49, 1),
                                            fontFamily: 'Bold',
                                            fontSize: isDesktop(context)
                                                ? screenwidth * 0.03
                                                : screenwidth * 0.05),
                                      ),
                                    ),
                                  ),
                                  // SizedBox(
                                  //   height: screenheight * 0.01,
                                  // ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          recipeModels[index].strArea ?? '',
                                          style: TextStyle(
                                              color:
                                                  Color.fromRGBO(79, 77, 78, 1),
                                              fontFamily: 'Medium',
                                              fontSize: isDesktop(context)
                                                  ? screenwidth * 0.015
                                                  : screenwidth * 0.035),
                                        ),
                                        IconButton(
                                            alignment: Alignment.bottomCenter,
                                            onPressed: () =>
                                                _toggleFavorite(recipe),
                                            icon: Icon(
                                              isFavorite
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: isFavorite
                                                  ? Colors.red
                                                  : Colors.black,
                                            ))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: recipeModels.length,
                  ),
                )
            ],
          ),
        ));
  }
}
