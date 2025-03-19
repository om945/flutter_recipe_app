import 'package:flutter/material.dart';
import 'package:flutter_recipe_app/modules/recipe_search.dart';

class RecipeDetails extends StatelessWidget {
  final Meals recipe;
  const RecipeDetails({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.strMeal ?? 'Recipe Details'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.height * 0.3,
                      recipe.strMealThumb ?? ''),
                ),
              ),
              Text(recipe.strMeal ?? '', style: TextStyle(fontSize: 24)),
              Text(recipe.strArea ?? '', style: TextStyle(fontSize: 18)),
              ...[
                for (int i = 1; i <= 20; i++)
                  if (recipe.getIngredient(i) != "")
                    Text(recipe.getIngredient(i)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// Add this extension method to your Meals class
extension MealsExtension on Meals {
  String getIngredient(int index) {
    switch (index) {
      case 1:
        return strIngredient1 ?? '';
      case 2:
        return strIngredient2 ?? '';
      case 3:
        return strIngredient3 ?? '';
      case 4:
        return strIngredient4 ?? '';
      case 5:
        return strIngredient5 ?? '';
      case 6:
        return strIngredient6 ?? '';
      case 7:
        return strIngredient7 ?? '';
      case 8:
        return strIngredient8 ?? '';
      case 9:
        return strIngredient9 ?? '';
      case 10:
        return strIngredient10 ?? '';
      case 11:
        return strIngredient11 ?? '';
      case 12:
        return strIngredient12 ?? '';
      case 13:
        return strIngredient13 ?? '';
      case 14:
        return strIngredient14 ?? '';
      case 15:
        return strIngredient15 ?? '';
      case 16:
        return strIngredient16 ?? '';
      case 17:
        return strIngredient17 ?? '';
      case 18:
        return strIngredient18 ?? '';
      case 19:
        return strIngredient19 ?? '';
      case 20:
        return strIngredient20 ?? '';
      default:
        return "";
    }
  }
}
