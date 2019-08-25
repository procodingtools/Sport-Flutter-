// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:phoenix_club/activities_list/activities_webservice.dart';
import 'package:phoenix_club/activities_list/entity/acivity_entity.dart';
import 'package:phoenix_club/utils/attribs.dart';
import 'package:phoenix_club/utils/dialogs/dialogs.dart';
import 'package:phoenix_club/utils/entities/user_entity.dart';
import 'package:phoenix_club/utils/res/strings.dart';
import 'package:phoenix_club/utils/webservice/webservice_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActivitiesScreen extends StatelessWidget {
  const ActivitiesScreen({Key key}) : super(key: key);

  static const String routeName = '/pesto';

  @override
  Widget build(BuildContext context) => PestoHome();
}

const double _kFabHalfSize =
    28.0; // TODO(mpcomplete): needs to adapt to screen size
const double _kRecipePageMaxWidth = 500.0;

final Set<Activity> _favoriteRecipes = Set<Activity>();

final ThemeData _kTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.teal,
  accentColor: Colors.redAccent,
);

bool _isLoggedin = false;

class PestoHome extends StatefulWidget {
  _PestoState createState() => _PestoState();
}

class _PestoState extends State<PestoHome>{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedPreferences.getInstance().then((prefs){
      if (prefs.getString("user") != null)
        _isLoggedin = true;
    });
  }
  @override
  Widget build(BuildContext context) {
    return const RecipeGridPage();
  }
}

class PestoFavorites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RecipeGridPage();
  }
}

class PestoStyle extends TextStyle {
  PestoStyle({
    double fontSize = 12.0,
    FontWeight fontWeight,
    Color color = Colors.white,
    double letterSpacing,
    double height,
  }) : super(
          inherit: false,
          color: color,
          fontFamily: 'Raleway',
          fontSize: fontSize,
          fontWeight: fontWeight,
          textBaseline: TextBaseline.alphabetic,
          letterSpacing: letterSpacing,
          height: height,
        );
}

// Displays a grid of recipe cards.
class RecipeGridPage extends StatefulWidget {
  const RecipeGridPage({Key key}) : super(key: key);

  @override
  _RecipeGridPageState createState() => _RecipeGridPageState();
}

//TODO: main view
class _RecipeGridPageState extends State<RecipeGridPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<Activity> recipes = List();
  bool _isFetching = true;
  final _width = Attributes.SCREEN_WIDTH;
  final _height = Attributes.SCREEN_HEIGHT;

  @override
  void initState() {
    ActivitiesWebService().fetch().then((_list) {
      if (_list == null) {
        Dialogs dialogs = Dialogs(context);
        dialogs.showErrorDialog(Strings.ERROR_CONNEXION);
      } else {
        for (ActivityEntity entity in _list) {
          recipes.add(Activity(
              ingredients: List<RecipeIngredient>(),
              steps: List<RecipeStep>(),
              author: '',
              name: entity.label,
              description: entity.description,
              id: entity.id,
              rating: entity.rating,
              idRating: entity.ratingId,
              raters: entity.raters,
              userRating: entity.userRating,
              imagePath: entity.photo,//entity.photo,
              ingredientsImagePath: 'assets/logo.png',
              imagePackage: 'assets',
              ingredientsImagePackage: 'assets'));
        }
      }
      setState(() {
        _isFetching = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Theme(
      data: _kTheme.copyWith(platform: Theme.of(context).platform),
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: Text(Strings.ACTIVITIES_LIST),
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/main_back.jpg"), fit: BoxFit.fill)),
          child: _isFetching
              ? Center(
                  child: SpinKitCubeGrid(
                  color: Colors.white70,
                  size: _width * 0.15,
                ))
              : CustomScrollView(
                  slivers: <Widget>[
                    _buildBody(context, statusBarHeight),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, double statusBarHeight) {
    final EdgeInsets mediaPadding = MediaQuery.of(context).padding;
    final EdgeInsets padding = EdgeInsets.only(
        top: 8.0,
        left: 8.0 + mediaPadding.left,
        right: 8.0 + mediaPadding.right,
        bottom: 8.0);
    return SliverPadding(
      padding: padding,
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: _kRecipePageMaxWidth,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            final Activity recipe = recipes[index];
            return RecipeCard(
              recipe: recipe,
              onTap: () {
                showRecipePage(context, recipe);
              },
            );
          },
          childCount: recipes.length,
        ),
      ),
    );
  }

  void showFavoritesPage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute<void>(
          settings: const RouteSettings(name: '/pesto/favorites'),
          builder: (BuildContext context) => PestoFavorites(),
        ));
  }

  void showRecipePage(BuildContext context, Activity recipe) {
    Navigator.push(
        context,
        MaterialPageRoute<void>(
          settings: const RouteSettings(name: '/pesto/recipe'),
          builder: (BuildContext context) {
            return Theme(
              data: _kTheme.copyWith(platform: Theme.of(context).platform),
              child: RecipePage(recipe: recipe),
            );
          },
        ));
  }
}

// A card with the recipe's image, author, and title.

//TODO: receipe card classes
class RecipeCard extends StatefulWidget{
  const RecipeCard({Key key, this.recipe, this.onTap}) : super(key: key);
  final Activity recipe;
  final VoidCallback onTap;

  _RecipeCard createState() => _RecipeCard(recipe: recipe, onTap: onTap);
}

class _RecipeCard extends State<RecipeCard> {

  _RecipeCard({Key key, this.recipe, this.onTap});

  final Activity recipe;
  final VoidCallback onTap;

  TextStyle get titleStyle => PestoStyle(
      fontSize: 24.0, fontWeight: FontWeight.w600, color: Colors.white);

  TextStyle get authorStyle =>
      PestoStyle(fontWeight: FontWeight.w500, color: Colors.black54);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.black54,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: '${recipe.id}',
              child: AspectRatio(
                aspectRatio: 4.0 / 3.0,
                child: CachedNetworkImage(
                  imageUrl: recipe.imagePath,
                  fit: BoxFit.cover,
                  placeholder: Image.asset('assets/logo.png', fit: BoxFit.cover,),
                ),
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Container(
                    width: Attributes.SCREEN_WIDTH * 0.05,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(recipe.name,
                            style: titleStyle,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis),
                        Text(recipe.author, style: authorStyle),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Displays one recipe. Includes the recipe sheet with a background image.
class RecipePage extends StatefulWidget {
  const RecipePage({Key key, this.recipe}) : super(key: key);

  final Activity recipe;

  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextStyle menuItemStyle =
      PestoStyle(fontSize: 15.0, color: Colors.black54, height: 24.0 / 15.0);

  double _getAppBarHeight(BuildContext context) =>
      MediaQuery.of(context).size.height * 0.3;

  @override
  Widget build(BuildContext context) {
    // The full page content with the recipe's image behind it. This
    // adjusts based on the size of the screen. If the recipe sheet touches
    // the edge of the screen, use a slightly different layout.
    final double appBarHeight = _getAppBarHeight(context);
    final Size screenSize = MediaQuery.of(context).size;
    final bool fullWidth = screenSize.width < _kRecipePageMaxWidth;
    final bool isFavorite = _favoriteRecipes.contains(widget.recipe);
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/main_back.jpg"), fit: BoxFit.fill)),
        child: Container(
          color: Colors.black38,
          child: Column(
            children: <Widget>[
              Container(
                height: appBarHeight + _kFabHalfSize,
                child: Hero(
                  tag: '${widget.recipe.id}',
                  child: CachedNetworkImage(
                    imageUrl: widget.recipe.imagePath,
                    fit: BoxFit.cover,
                    placeholder: Image.asset('assets/logo.png', fit: BoxFit.cover,),
                  ),
                ),
              ),

              /*SliverAppBar(
                expandedHeight: appBarHeight - _kFabHalfSize,
                backgroundColor: Colors.transparent,
                */ /*actions: <Widget>[
                      PopupMenuButton<String>(
                        onSelected: (String item) {},
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuItem<String>>[
                              _buildMenuItem(Icons.share, 'Tweet recipe'),
                              _buildMenuItem(Icons.email, 'Email recipe'),
                              _buildMenuItem(Icons.message, 'Message recipe'),
                              _buildMenuItem(Icons.people, 'Share on Facebook'),
                            ],
                      ),
                    ],*/ /*
                flexibleSpace: const FlexibleSpaceBar(
                  background: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.0, -1.0),
                        end: Alignment(0.0, -0.2),
                        colors: <Color>[
                          Color(0x60000000),
                          Color(0x00000000)
                        ],
                      ),
                    ),
                  ),
                ),
              ),*/

              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.only(top: _kFabHalfSize),
                    width: fullWidth ? null : _kRecipePageMaxWidth,
                    child: RecipeSheet(recipe: widget.recipe),
                  ),
                ),
              )

              /*CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                      child: Stack(
                    children: <Widget>[

                    ],
                  )),
                ],
              ),*/
            ],
          ),
        ),
      ),
    );
  }

}

/// Displays the recipe's name and instructions.
class RecipeSheet extends StatefulWidget {
  RecipeSheet({Key key, this.recipe}) : super(key: key);
  final Activity recipe;

  _RecipeState createState() => _RecipeState(recipe: recipe);
}

class _RecipeState extends State<RecipeSheet> {
  _RecipeState({this.recipe});

  final TextStyle titleStyle = PestoStyle(fontSize: 34.0);
  final TextStyle descriptionStyle =
      PestoStyle(fontSize: 18.0, color: Colors.white70, height: 24.0 / 15.0);
  final TextStyle itemStyle = PestoStyle(fontSize: 15.0, height: 24.0 / 15.0);
  final TextStyle itemAmountStyle = PestoStyle(
      fontSize: 15.0, color: _kTheme.primaryColor, height: 24.0 / 15.0);
  final TextStyle headingStyle = PestoStyle(
      fontSize: 16.0, fontWeight: FontWeight.bold, height: 24.0 / 15.0);

  final Activity recipe;

  bool _isRating = false;

  final _width = Attributes.SCREEN_WIDTH;
  final _height = Attributes.SCREEN_HEIGHT;

  Color _ratingColor = Colors.yellowAccent;
  double _rating;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _rating = recipe.rating;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
        child: Table(columnWidths: const <int, TableColumnWidth>{
          0: FixedColumnWidth(64.0)
        }, children: <TableRow>[
          TableRow(children: <Widget>[
            /* TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Image.asset(recipe.ingredientsImagePath,
                    //package: recipe.ingredientsImagePackage,
                    width: 32.0,
                    height: 32.0,
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown)),*/
            Container(
              height: 32.0,
            ),
            TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Text(recipe.name, style: titleStyle)),
          ]),
          TableRow(children: <Widget>[
            Container(),
            _isRating
                ? CupertinoActivityIndicator(
                    animating: true,
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          StarRating(
                            onRatingChanged: (rating) {
                              sendRate(recipe.id, rating, recipe, ratingId: recipe.idRating,);
                            },
                            starCount: 5,
                            color: recipe.userRating != null
                                ? Colors.blue
                                : Colors.yellowAccent,
                            size: _width * 0.07,
                            rating: recipe.rating??0,
                          ),
                        ],
                      ),
                      Text(
                        "${recipe.raters} ${Strings.USERS_RATED}",
                        style: TextStyle(
                            color: Colors.white70, fontSize: _width * 0.025),
                      )
                    ],
                  ),
          ]),
          TableRow(children: <Widget>[
            const SizedBox(),
            Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                child: Text(recipe.description, style: descriptionStyle)),
          ]),

        ]
        ),
      ),
    );
  }


  void sendRate(int id, double rating, Activity act, {int ratingId}) {

    if (_isLoggedin){
      setState(() {
        _isRating = true;
      });
      if (ratingId == null)
        ActivitiesWebService().rate(id, rating.toInt()).then((b) {
          if (b != null) {
            if (b > 0) {
              setState(() {
                recipe.rating = rating;
                recipe.idRating = b;
                recipe.raters++;
              });
            } else
              Dialogs(context).showErrorDialog(Strings.ERROR);
          } else
            Dialogs(context).showErrorDialog(Strings.ERROR_CONNEXION);

          setState(() {
            _isRating = false;
          });
        });
      else
        ActivitiesWebService().updateRating(ratingId, rating.toInt()).then((b) {
          if (b != null) {
            if (b) {
              setState(() {
                recipe.rating = rating;
              });
            } else
              Dialogs(context).showErrorDialog(Strings.ERROR);
          } else
            Dialogs(context).showErrorDialog(Strings.ERROR_CONNEXION);

          setState(() {
            _isRating = false;
          });
        });
    }

  }
}

class Activity {
  Activity(
      {this.name,
      this.id,
      this.author,
      this.description,
      this.imagePath,
      this.imagePackage,
      this.ingredientsImagePath,
      this.ingredientsImagePackage,
      this.ingredients,
      this.rating,
      this.idRating,
      this.raters,
      this.userRating,
      this.steps});

  int raters;
  final String name;
  final String author;
  final String description;
  final String imagePath;
  final String imagePackage;
  final String ingredientsImagePath;
  final String ingredientsImagePackage;
  final List<RecipeIngredient> ingredients;
  final List<RecipeStep> steps;
  final int id;
  double rating;
  double userRating;
  int idRating;
}

class RecipeIngredient {
  const RecipeIngredient({this.amount, this.description});

  final String amount;
  final String description;
}

class RecipeStep {
  const RecipeStep({this.duration, this.description});

  final String duration;
  final String description;
}
