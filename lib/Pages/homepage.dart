// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_recipe_app/Pages/homepage_recipe.dart';
import 'package:flutter_recipe_app/modules/recipe_models.dart';
import 'package:flutter_recipe_app/modules/service.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 650;
  List<Categories> recipeModels = [];

  bool _isLoading = true;
  myRecipes() {
    setState(() {
      _isLoading = true;
    });
    recipeItems().then((value) {
      setState(() {
        recipeModels = value;
        _isLoading = false;
      });
    });
  }

  int height = 338;

  @override
  void initState() {
    myRecipes();
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
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
        toolbarHeight: screenwidth * 0.1,
        clipBehavior: Clip.antiAlias,
        forceMaterialTransparency: true,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Fork & Fire",
            style: TextStyle(
                color: Color.fromRGBO(76, 175, 80, 1),
                fontFamily: 'Bold',
                fontSize: screenwidth * 0.08),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: CustomScrollView(
          slivers: [
            // Image and details section
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: SizedBox(
                      height: isDesktop(context)
                          ? screenheight * 0.5
                          : screenheight * 0.4,
                      width: isDesktop(context)
                          ? screenwidth * 0.7
                          : screenwidth * 1,
                      child: FadeTransition(
                        opacity: CurvedAnimation(
                          parent: _animationController,
                          curve: Curves.slowMiddle,
                        ),
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(1, 0),
                            end: Offset(0, 0),
                          ).animate(_animationController),
                          child: Image.asset(
                            height: screenheight * 0.3,
                            width: screenwidth * 0.7,
                            'assets/images/landingImg.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 8, 0),
                    child: SizedBox(
                      height: screenwidth * 0.28,
                      child: Stack(
                        children: [
                          Positioned(
                            child: FadeTransition(
                              opacity: CurvedAnimation(
                                parent: _animationController,
                                curve: Curves.slowMiddle,
                              ),
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: Offset(-1, 0),
                                  end: Offset(0, 0),
                                ).animate(_animationController),
                                child: Row(
                                  children: [
                                    Text("Discover",
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(50, 48, 49, 1),
                                            fontSize: screenwidth * 0.09,
                                            fontFamily: 'Bold')),
                                    Text(" Delicious",
                                        style: TextStyle(
                                            fontSize: screenwidth * 0.09,
                                            fontFamily: 'Bold',
                                            color:
                                                Color.fromRGBO(255, 152, 0, 1)))
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: screenwidth * 0.1,
                            child: FadeTransition(
                              opacity: CurvedAnimation(
                                parent: _animationController,
                                curve: Curves.slowMiddle,
                              ),
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: Offset(1, 0),
                                  end: Offset(0, 0),
                                ).animate(_animationController),
                                child: Row(
                                  children: [
                                    Text("Recipes",
                                        style: TextStyle(
                                            fontSize: screenwidth * 0.09,
                                            fontFamily: 'Bold',
                                            color: Color.fromRGBO(
                                                76, 175, 80, 1))),
                                    Text(" Instantly!",
                                        style: TextStyle(
                                          color: Color.fromRGBO(50, 48, 49, 1),
                                          fontSize: screenwidth * 0.09,
                                          fontFamily: 'Bold',
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 8, 10),
                    child: SizedBox(
                      width: screenwidth * 0.8,
                      child: Column(
                        children: [
                          FadeTransition(
                            opacity: _animationController,
                            child: Text(
                              'Find the perfect dish with easy step-by-step guides, smart recommendations, and ingredient-based searches. Cook, save, and share your favorites!',
                              style: TextStyle(
                                  color: Color.fromRGBO(50, 48, 49, 1),
                                  fontSize: screenwidth * 0.04,
                                  fontFamily: 'Bold'),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: FadeTransition(
                          opacity: _animationController,
                          child: Text(
                            "Popular Categories",
                            style: TextStyle(
                                color: Color.fromRGBO(50, 48, 49, 1),
                                fontSize: screenwidth * 0.05,
                                fontFamily: 'Bold'),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            // Grid view section
            _isLoading
                ? SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 50, bottom: 20),
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color.fromRGBO(76, 175, 80, 1),
                          ),
                        ),
                      ),
                    ),
                  )
                : SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 0,
                      childAspectRatio: 0.7,
                      crossAxisCount:
                          isDesktop(context) ? 4 : 2, // number of columns
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: screenheight * 0.01,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      Homepage_Recipe(
                                          recipe:
                                              recipeModels[index].strCategory ??
                                                  ''),
                                  transitionDuration:
                                      Duration(milliseconds: 200),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    return FadeTransition(
                                        opacity: animation, child: child);
                                  },
                                ),
                              );
                            },
                            child: Card(
                              clipBehavior: Clip.antiAlias,
                              semanticContainer: false,
                              color: Color.fromRGBO(211, 231, 192, 1),
                              margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: SizedBox(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: screenheight * 0.023,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: _isLoading
                                          ? Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            )
                                          : Center(
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: Image.network(
                                                    // scale: 0.2,
                                                    fit: BoxFit.cover,
                                                    recipeModels[index]
                                                            .strCategoryThumb ??
                                                        ''),
                                              ),
                                            ),
                                    ),
                                    SizedBox(
                                      height: screenheight * 0.01,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        recipeModels[index].strCategory ?? '',
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(50, 48, 49, 1),
                                            fontFamily: 'Bold',
                                            fontSize: isDesktop(context)
                                                ? screenwidth * 0.03
                                                : screenwidth * 0.05),
                                      ),
                                    ),
                                    SizedBox(
                                      height: screenheight * 0.01,
                                    ),
                                    Padding(
                                      //padding l and r = 8
                                      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                      child: Text(
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        recipeModels[index]
                                                .strCategoryDescription ??
                                            '',
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(79, 77, 78, 1),
                                            fontFamily: 'Medium',
                                            fontSize: isDesktop(context)
                                                ? screenwidth * 0.015
                                                : screenwidth * 0.035),
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
