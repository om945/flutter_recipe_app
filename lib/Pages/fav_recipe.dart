import 'package:flutter/material.dart';
import 'package:flutter_recipe_app/modules/recipe_search.dart';

class FavRecipe extends StatefulWidget {
  @override
  _FavRecipeState createState() => _FavRecipeState();
}

class _FavRecipeState extends State<FavRecipe> {
  List<Meals> favoriteRecipes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Recipes'),
      ),
      body: ListView.builder(
        itemCount: favoriteRecipes.length,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              children: [
                Image.network(favoriteRecipes[index].strMealThumb ?? ''),
                Text(favoriteRecipes[index].strMeal ?? ''),
                Text(favoriteRecipes[index].strArea ?? ''),
              ],
            ),
          );
        },
      ),
    );
  }
}
