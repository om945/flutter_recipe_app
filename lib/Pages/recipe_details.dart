import 'package:flutter/material.dart';
import 'package:flutter_recipe_app/modules/recipe_search.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipeDetails extends StatefulWidget {
  final Meals recipe;
  const RecipeDetails({super.key, required this.recipe});

  @override
  State<RecipeDetails> createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 650;

  Future<void> openYouTube(String videoId) async {
    final Uri url = Uri.parse(widget.recipe.strYoutube ?? '');

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text('Recipe Details',
            style: TextStyle(
              fontFamily: 'Medium',
              color: Color.fromRGBO(50, 48, 49, 1),
            )),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context)
                .requestFocus(FocusNode()); // dismiss keyboard
          },
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SizedBox(
                    height: screenwidth * 0.6,
                    width: screenwidth * 0.6,
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                            fit: BoxFit.cover,
                            widget.recipe.strMealThumb ?? ''),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Text(widget.recipe.strMeal ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: screenwidth * 0.06,
                        fontFamily: 'Bold',
                        color: Color.fromRGBO(50, 48, 49, 1),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.all(0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: screenwidth * 0.3,
                        width: screenwidth * 0.4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Area:',
                                style: TextStyle(
                                    fontSize: screenwidth * 0.04,
                                    fontFamily: 'Medium',
                                    color: Color.fromRGBO(79, 77, 78, 1))),
                            Text(widget.recipe.strArea ?? '',
                                style: TextStyle(
                                    fontSize: screenwidth * 0.055,
                                    fontFamily: 'Bold',
                                    color: Color.fromRGBO(79, 77, 78, 1))),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        width: 2,
                        height: screenheight * 0.08,
                        color: Color.fromRGBO(200, 199, 199, 1),
                      ),
                      SizedBox(
                        height: screenwidth * 0.2,
                        width: screenwidth * 0.4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Category:',
                                style: TextStyle(
                                    fontSize: screenwidth * 0.04,
                                    fontFamily: 'Medium',
                                    color: Color.fromRGBO(79, 77, 78, 1))),
                            Text(widget.recipe.strCategory ?? '',
                                style: TextStyle(
                                    fontSize: screenwidth * 0.055,
                                    fontFamily: 'Bold',
                                    color: Color.fromRGBO(79, 77, 78, 1))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(' Ingredients:',
                      style: TextStyle(
                          fontSize: screenwidth * 0.05,
                          fontFamily: 'Bold',
                          color: Color.fromRGBO(79, 77, 78, 1))),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    width: screenwidth,
                    height: screenheight * 0.0008,
                    color: Color.fromRGBO(200, 199, 199, 1),
                  ),
                ),
                ...[
                  for (int i = 1; i <= 20; i++)
                    if (widget.recipe.getIngredient(i) != "" &&
                        widget.recipe.getMeasure(i) != "")
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Row(
                          children: [
                            Text(
                                '•  ${widget.recipe.getIngredient(i)} -  ${widget.recipe.getMeasure(i)}',
                                style: TextStyle(
                                    color: Color.fromRGBO(79, 77, 78, 1),
                                    fontSize: screenwidth * 0.039,
                                    fontFamily: 'Medium')),
                          ],
                        ),
                      ),
                ],
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Instructions',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Color.fromRGBO(79, 77, 78, 1),
                                  fontSize: screenwidth * 0.05,
                                  fontFamily: 'Bold')),
                          SizedBox(
                            width: screenwidth * 0.46,
                          ),
                          IconButton(
                            alignment: Alignment.centerRight,
                            icon: Icon(
                              _isExpanded
                                  ? Icons.arrow_drop_up_rounded
                                  : Icons.arrow_drop_down_rounded,
                              size: screenwidth * 0.09,
                            ),
                            onPressed: () {
                              setState(() {
                                _isExpanded = !_isExpanded;
                              });
                            },
                          ),
                        ],
                      ),
                      AnimatedCrossFade(
                        firstChild: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Container(
                            width: screenwidth,
                            height: screenheight * 0.0008,
                            color: Color.fromRGBO(200, 199, 199, 1),
                          ),
                        ),
                        secondChild: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                  textAlign: TextAlign.left,
                                  widget.recipe.strInstructions ?? '',
                                  style: TextStyle(
                                      color: Color.fromRGBO(79, 77, 78, 1),
                                      fontSize: screenwidth * 0.04,
                                      fontFamily: 'Medium')),
                            ),
                          ],
                        ),
                        crossFadeState: _isExpanded
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: Duration(milliseconds: 300),
                      )
                    ],
                  ),
                ),
                Center(
                  heightFactor: 2,
                  child: Container(
                    height: screenwidth * 0.1,
                    width: screenwidth * 0.4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          screenheight * 4 * screenwidth * 3),
                      color: Color.fromRGBO(243, 195, 195, 1),
                    ),
                    child: TextButton(
                      onPressed: () {
                        openYouTube(widget.recipe.strYoutube ?? '');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Watch on ",
                              style: TextStyle(
                                  fontFamily: 'Medium',
                                  fontSize: screenwidth * 0.04,
                                  color: Colors.black)),
                          Image.asset(
                            'assets/images/YT.png',
                            width: screenwidth * 0.08,
                            height: screenwidth * 0.08,
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
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

  String getMeasure(int index) {
    switch (index) {
      case 1:
        return strMeasure1 ?? '';
      case 2:
        return strMeasure2 ?? '';
      case 3:
        return strMeasure3 ?? '';
      case 4:
        return strMeasure4 ?? '';
      case 5:
        return strMeasure5 ?? '';
      case 6:
        return strMeasure6 ?? '';
      case 7:
        return strMeasure7 ?? '';
      case 8:
        return strMeasure8 ?? '';
      case 9:
        return strMeasure9 ?? '';
      case 10:
        return strMeasure10 ?? '';
      case 11:
        return strMeasure11 ?? '';
      case 12:
        return strMeasure12 ?? '';
      case 13:
        return strMeasure13 ?? '';
      case 14:
        return strMeasure14 ?? '';
      case 15:
        return strMeasure15 ?? '';
      case 16:
        return strMeasure16 ?? '';
      case 17:
        return strMeasure17 ?? '';
      case 18:
        return strMeasure18 ?? '';
      case 19:
        return strMeasure19 ?? '';
      case 20:
        return strMeasure20 ?? '';
      default:
        return "";
    }
  }
}
