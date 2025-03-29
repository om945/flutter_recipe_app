import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recipe_app/Pages/recipe_details.dart';
import 'package:flutter_recipe_app/modules/recipe_search.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<Meals> recipeModels = [];
  bool _isLoading = false;
  final TextEditingController _textController = TextEditingController();
  Set<String> favoriteMealIds = {}; // Store meal IDs of favorites

  Future<List<Meals>> recipeSearch(String recipe) async {
    setState(() {
      _isLoading = true;
    });

    Uri url = Uri.parse(
        "https://www.themealdb.com/api/json/v1/1/search.php?s=$recipe");
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

  void _onSearch() async {
    String searchText = _textController.text.trim();
    if (searchText.isNotEmpty) {
      var results = await recipeSearch(searchText);
      setState(() {
        recipeModels = results;
      });
    } else {
      Text("Enter a recipe");
    }
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
    super.initState();
    _loadFavorites(); // Load favorites when screen initializes
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(
          "Search",
          style: TextStyle(
            color: Color.fromRGBO(76, 175, 80, 1),
            fontFamily: 'Medium',
            fontSize: MediaQuery.of(context).size.height * 0.035,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: "Search for Recipes",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  suffixIcon: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(19),
                      color: Colors.green,
                    ),
                    child: TextButton(
                      onPressed: _onSearch,
                      child:
                          Text("Search", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Show Loading Indicator
          if (_isLoading)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(
                    child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromRGBO(76, 175, 80, 1),
                  ),
                )),
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
            SliverPadding(
              padding: const EdgeInsets.all(10.0),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.64,
                  crossAxisCount: 2, // number of columns
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final recipe = recipeModels[index];
                    final isFavorite = favoriteMealIds.contains(recipe.idMeal);
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
                                  padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
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
              ),
            ),
        ],
      ),
    );
  }
}
