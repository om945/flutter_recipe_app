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
  bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 650;

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
        // toolbarHeight: screenwidth * 0.1,
        forceMaterialTransparency: true,
        title: Text(
          "Search",
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
            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                      color: Color.fromRGBO(50, 48, 49, 1),
                      fontFamily: 'Medium',
                    ),
                    hintText: "Search for Recipes..",
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
                        child: Text("Search",
                            style: TextStyle(color: Colors.white)),
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
                      Color.fromRGBO(7, 175, 80, 1),
                    ),
                  )),
                ),
              )
            else if (_textController.text.isEmpty)
              SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text("Search for a recipe",
                        style: TextStyle(
                            fontSize: screenwidth * 0.04,
                            fontFamily: 'Medium',
                            color: Color.fromRGBO(79, 77, 78, 1))),
                  ),
                ),
              )
            else if (recipeModels.isEmpty)
              SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Image.asset(
                      height: screenheight * 0.3,
                      width: screenwidth * 0.7,
                      'assets/images/errorImg.png',
                      fit: BoxFit.cover,
                    ),
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
                    final isFavorite = favoriteMealIds.contains(recipe.idMeal);
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
                                // SizedBox(
                                //   height: MediaQuery.of(context).size.height *
                                //       0.023,
                                // ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
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
                                SizedBox(
                                  height: isDesktop(context)
                                      ? screenwidth * 0.085
                                      : screenwidth * 0.135,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                    child: Text(
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      recipeModels[index].strMeal ?? '',
                                      style: TextStyle(
                                          color: Color.fromRGBO(50, 48, 49, 1),
                                          fontFamily: 'Bold',
                                          fontSize: isDesktop(context)
                                              ? screenwidth * 0.03
                                              : screenwidth * 0.05),
                                    ),
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
                                            color:
                                                Color.fromRGBO(50, 48, 49, 1),
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
          ],
        ),
      ),
    );
  }
}
