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
  Set<String> favoriteMealIds = {};
  bool _isLoading = false;

  void _toggleFavorite(Meals meal) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

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

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(title: Text("Favorite Recipes")),
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
                ? Center(child: Text("No favorite recipes yet!"))
                : Center(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.64,
                        crossAxisCount: 2,
                      ),
                      itemCount: favoriteRecipes.length,
                      itemBuilder: (BuildContext context, int index) {
                        final recipe = favoriteRecipes[index];
                        final isFavorite =
                            favoriteMealIds.contains(recipe.idMeal);
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => RecipeDetails(
                                      recipe: favoriteRecipes[index],
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
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            //Image
                                            : Image.network(
                                                recipe.strMealThumb ?? '',
                                                scale: 0.2,
                                                fit: BoxFit.cover),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                      child: Text(
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        recipe.strMeal ?? '',
                                        style: TextStyle(
                                            fontFamily: 'Bold',
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.021),
                                      ),
                                    ),
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
                                            recipe.strArea ?? '',
                                            style: TextStyle(
                                                fontFamily: 'Medium',
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.018),
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
                  ));
  }
}
