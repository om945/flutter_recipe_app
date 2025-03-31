import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_recipe_app/Pages/recipe_details.dart';
import 'package:flutter_recipe_app/modules/recipe_search.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FavRecipe extends StatefulWidget {
  @override
  _FavRecipeState createState() => _FavRecipeState();
}

class _FavRecipeState extends State<FavRecipe> {
  bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 650;

  Set<String> favoriteMealIds = {};
  bool _isLoading = false;

  void _toggleFavorite(Meals meal) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (mounted) {
      setState(() {
        if (favoriteMealIds.contains(meal.idMeal)) {
          favoriteMealIds.remove(meal.idMeal!);
          favoriteRecipes.removeWhere((recipe) => recipe.idMeal == meal.idMeal);
        } else {
          favoriteMealIds.add(meal.idMeal!);
          // Add the meal to favoriteRecipes if it's not already there
          if (!favoriteRecipes.contains(meal)) {
            favoriteRecipes.add(meal);
          }
        }
      });
    }

    await prefs.setStringList('favoriteMeals', favoriteMealIds.toList());
  }

  List<Meals> favoriteRecipes = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() async {
    setState(() {
      _isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriteIds = prefs.getStringList('favoriteMeals');

    if (favoriteIds != null) {
      // Fetch recipe details for each favorite ID
      for (var id in favoriteIds) {
        Uri url = Uri.parse(
            "https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id");
        var response = await http.get(url);

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          if (data['meals'] != null && data['meals'].length > 0) {
            var meal = Meals.fromJson(data['meals'][0]);
            if (mounted) {
              setState(() {
                if (favoriteMealIds.contains(meal.idMeal)) {
                  favoriteMealIds.remove(meal.idMeal!);
                  favoriteRecipes
                      .removeWhere((recipe) => recipe.idMeal == meal.idMeal);
                } else {
                  favoriteMealIds.add(meal.idMeal!);
                  // Add the meal to favoriteRecipes if it's not already there
                  if (!favoriteRecipes.contains(meal)) {
                    favoriteRecipes.add(meal);
                  }
                }
              });
            }
          }
        }
      }
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
            title: Text(
          "Favorite Recipes",
          style: TextStyle(
            color: Color.fromRGBO(76, 175, 80, 1),
            fontFamily: 'Medium',
          ),
        )),
        body: _isLoading
            ? Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color.fromRGBO(76, 175, 80, 1),
                    ),
                  ),
                ),
              )
            : favoriteRecipes.isEmpty
                ? Center(
                    child: Text(
                    "No favorite recipes yet!",
                    style: TextStyle(
                      fontFamily: 'Medium',
                      fontSize: isDesktop(context)
                          ? screenwidth * 0.03
                          : screenwidth * 0.05,
                    ),
                  ))
                : Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Center(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: isDesktop(context) ? 0.6 : 0.64,
                          crossAxisCount:
                              isDesktop(context) ? 4 : 2, // number of columns,
                        ),
                        itemCount: favoriteRecipes.length,
                        itemBuilder: (BuildContext context, int index) {
                          final recipe = favoriteRecipes[index];
                          final isFavorite =
                              favoriteMealIds.contains(recipe.idMeal);
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      RecipeDetails(
                                    recipe: favoriteRecipes[index],
                                  ),
                                  transitionDuration:
                                      Duration(milliseconds: 300),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // SizedBox(
                                      //   height: MediaQuery.of(context).size.height *
                                      //       0.023,
                                      // ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: _isLoading
                                            ? Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            //Image
                                            : Center(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: Image.network(
                                                      recipe.strMealThumb ?? '',
                                                      // scale: 0.2,
                                                      fit: BoxFit.cover),
                                                ),
                                              ),
                                      ),
                                      SizedBox(
                                        height: isDesktop(context)
                                            ? screenwidth * 0.085
                                            : screenwidth * 0.14,
                                        child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(8, 0, 8, 0),
                                          child: Text(
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            recipe.strMeal ?? '',
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    50, 48, 49, 1),
                                                fontFamily: 'Bold',
                                                fontSize: isDesktop(context)
                                                    ? screenwidth * 0.03
                                                    : screenwidth * 0.05),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 0, 8, 0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              recipe.strArea ?? '',
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      79, 77, 78, 1),
                                                  fontFamily: 'Medium',
                                                  fontSize: isDesktop(context)
                                                      ? screenwidth * 0.015
                                                      : screenwidth * 0.035),
                                            ),
                                            IconButton(
                                                onPressed: () =>
                                                    _toggleFavorite(recipe),
                                                icon: Icon(
                                                    isFavorite
                                                        ? Icons.favorite
                                                        : Icons.favorite_border,
                                                    color: isFavorite
                                                        ? Colors.red
                                                        : Colors.black))
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
                      ),
                    ),
                  ));
  }
}
