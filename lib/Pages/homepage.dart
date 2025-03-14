import 'package:flutter/material.dart';
import 'package:flutter_recipe_app/Pages/drawer.dart';
import 'package:flutter_recipe_app/modules/recipe_models.dart';
import 'package:flutter_recipe_app/modules/service.dart';
import 'dart:ui';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Categories> recipeModels = [];
  myRecipes() {
    recipeItems().then((value) {
      setState(() {
        recipeModels = value;
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
      endDrawer: MyDrawer(),
      appBar: AppBar(
        title: Text(
          "Fork & Fire",
          style: TextStyle(
              color: Color.fromRGBO(76, 175, 80, 1), fontFamily: 'Bold'),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // Image and details section
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Image.asset(
                      'assets/images/intro.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.126,
                    child: Stack(
                      children: [
                        Positioned(
                          child: Row(
                            children: [
                              Text("Discover",
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.045,
                                      fontFamily: 'Bold')),
                              Text(" Delicious",
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.045,
                                      fontFamily: 'Bold',
                                      color: Color.fromRGBO(255, 152, 0, 1)))
                            ],
                          ),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).size.height * 0.126 / 2.5,
                          child: Row(
                            children: [
                              Text("Recipes",
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.045,
                                      fontFamily: 'Bold',
                                      color: Color.fromRGBO(76, 175, 80, 1))),
                              Text(" Instantly!",
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.045,
                                    fontFamily: 'Bold',
                                  ))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Column(
                      children: [
                        Text(
                          'Find the perfect dish with easy step-by-step guides, smart recommendations, and ingredient-based searches. Cook, save, and share your favorites!',
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.02,
                              fontFamily: 'Bold'),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                //   child: Row(
                //     children: [
                //       Text("Discover", style: TextStyle(fontSize: 40, fontFamily: 'Bold')),
                //       Text(" Delicious", style: TextStyle(fontSize: 40, fontFamily: 'Bold',
                //       color: Color.fromRGBO(255, 152, 0, 1)
                //       ))
                //     ],
                //   ),
                // ),
                //  Padding(
                //   padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                //   child: Row(
                //     children: [
                //       Text("Recipes", style: TextStyle(fontSize: 40, fontFamily: 'Bold',
                //       color: Color.fromRGBO(76, 175, 80, 1)
                //       )),
                //       Text(" Instantly!", style: TextStyle(fontSize: 40, fontFamily: 'Bold',
                //       ))
                //     ],
                //   ),
                // )
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Popular Recipes",
                        style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.height * 0.025,
                            fontFamily: 'Bold'),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          // Grid view section
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 0.85,
              crossAxisCount: 2, // number of columns
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Card(
                  semanticContainer: false,
                  color: Color.fromRGBO(211, 231, 192, 1),
                  margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.023,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Image.network(
                                fit: BoxFit.cover,
                                recipeModels[index].strCategoryThumb ?? ''),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            recipeModels[index].strCategory ?? '',
                            style: TextStyle(
                                fontFamily: 'Bold',
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.025),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: Text(
                            recipeModels[index].idCategory ?? '',
                            style: TextStyle(
                                fontFamily: 'Bold',
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.012),
                          ),
                        ),
                      ],
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
//  SliverGrid(
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//           ),
//           delegate: SliverChildBuilderDelegate(
//             (context, index) {
//               return Card(
//                 child: Container(
//                   child: Column(
//                     children: [
//                       Image.network(recipeModels[index].strCategoryThumb ?? ''), // replace with your image
//                       Text(recipeModels[index].strCategory ?? 'Unknown Category'),
//                     ],
//                   ),
//                 ),
//               );
//             },
//             childCount: recipeModels.length,
//           ),
//         ),
