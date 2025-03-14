import 'dart:convert';

import 'package:flutter_recipe_app/modules/recipe_models.dart';
import 'package:http/http.dart' as http;

recipeItems() async{
  Uri url =Uri.parse("https://www.themealdb.com/api/json/v1/1/categories.php");
  var response = await http.get(url);

  try{
if(response.statusCode == 200){
  var data =  recipeModels.fromJson(jsonDecode(response.body));
  return data.categories;
} else{
  print("Failed to load data");
}
  }catch(e){
    print(e.toString());
  }

}