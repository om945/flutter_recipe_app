import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recipe_app/Pages/recipe_details.dart';
import 'package:flutter_recipe_app/modules/recipe_search.dart';
import 'package:http/http.dart' as http;

class Homepage_Recipe extends StatefulWidget {
  final String recipe;
  const Homepage_Recipe({super.key, required this.recipe});

  @override
  State<Homepage_Recipe> createState() => _Homepage_RecipeState();
}

class _Homepage_RecipeState extends State<Homepage_Recipe> {
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
  List<Meals> favoriteRecipes = []; // Define favoriteRecipes
  bool _isLoading = true;
  myRecipes() {
    setState(() {
      _isLoading = true;
    });
    recipeSearch().then((value) {
      setState(() {
        recipeModels = value;
        favoriteRecipes =
            recipeModels.where((recipe) => recipe.isFavorite).toList();
        _isLoading = false;
      });
    });
  }

  int height = 338;

  @override
  void initState() {
    myRecipes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        forceMaterialTransparency: true,
        title: Text(
          "Fork & Fire",
          style: TextStyle(
              color: Color.fromRGBO(76, 175, 80, 1),
              fontFamily: 'Bold',
              fontSize: MediaQuery.of(context).size.height * 0.035),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // Image and details section

          // Grid view section
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
                  padding: const EdgeInsets.all(20.0),
                  child: Text("No recipes found. Try searching!",
                      style: TextStyle(fontSize: 18)),
                ),
              ),
            )
          else
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 0.64,
                crossAxisCount: 2, // number of columns
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RecipeDetails(
                                recipe: recipeModels[index],
                              )));
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
                              // SizedBox(
                              //   height: MediaQuery.of(context).size.height *
                              //       0.023,
                              // ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: _isLoading
                                      ? Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      //Image
                                      : Image.network(
                                          recipeModels[index].strMealThumb ??
                                              '',
                                          scale: 0.2,
                                          fit: BoxFit.cover),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                child: Text(
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  recipeModels[index].strMeal ?? '',
                                  style: TextStyle(
                                      fontFamily: 'Bold',
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.021),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      recipeModels[index].strArea ?? '',
                                      style: TextStyle(
                                          fontFamily: 'Medium',
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.018),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          // Toggle favorite status
                                          recipeModels[index].isFavorite =
                                              !recipeModels[index].isFavorite;
                                          // Store favorite recipe
                                          if (recipeModels[index].isFavorite) {
                                            favoriteRecipes
                                                .add(recipeModels[index]);
                                          } else {
                                            favoriteRecipes
                                                .remove(recipeModels[index]);
                                          }
                                        },
                                        icon: Icon(
                                          recipeModels[index].isFavorite
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: recipeModels[index].isFavorite
                                              ? Colors.red
                                              : Colors.grey,
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
            ),
        ],
      ),
    );
  }
}
