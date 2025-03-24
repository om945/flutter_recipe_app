import 'package:flutter/material.dart';
import 'package:flutter_recipe_app/modules/recipe_search.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavRecipe extends StatefulWidget {
  @override
  _FavRecipeState createState() => _FavRecipeState();
}

class _FavRecipeState extends State<FavRecipe> {
  List<Meals> favoriteRecipes = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriteIds = prefs.getStringList('favoriteMeals');

    if (favoriteIds != null) {
      // Fetch recipe details for each favorite ID (if needed)
      // Assuming you have a method to get recipes by ID
      setState(() {
        favoriteRecipes = favoriteIds.map((id) => Meals(idMeal: id)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Favorite Recipes")),
      body: favoriteRecipes.isEmpty
          ? Center(child: Text("No favorite recipes yet!"))
          : Center(
              child: ListView.builder(
                itemCount: favoriteRecipes.length,
                itemBuilder: (context, index) {
                  final recipe = favoriteRecipes[index];
                  return ListTile(
                    iconColor: Colors.black,
                    title: Text(recipe.idMeal ?? '',
                        style: TextStyle(
                            fontFamily: 'Medium', color: Colors.black)),
                    leading: Icon(Icons.add_ic_call_outlined),
                  );
                },
              ),
            ),
    );
  }
}
