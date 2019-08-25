import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:phoenix_club/activities_list/activities_webservice.dart';
import 'package:phoenix_club/activities_list/entity/acivity_entity.dart';
import 'package:phoenix_club/news/news_entity.dart';
import 'package:phoenix_club/news/news_webservice.dart';
import 'package:phoenix_club/utils/attribs.dart';
import 'package:phoenix_club/utils/dialogs/dialogs.dart';
import 'package:phoenix_club/utils/res/strings.dart';

class NewsScreen extends StatefulWidget{
  final int id;

  const NewsScreen({Key key, this.id}) : super(key: key);
  _NewsState createState() => _NewsState(id);
}

const double _kFabHalfSize =
28.0; // TODO(mpcomplete): needs to adapt to screen size
const double _kRecipePageMaxWidth = 500.0;

final Set<News> _favoriteRecipes = Set<News>();

final ThemeData _kTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.teal,
  accentColor: Colors.redAccent,
);

class _NewsState extends State<NewsScreen>{

  final int id;

  _NewsState(this.id);

  @override
  Widget build(BuildContext context) {
    return RecipeGridPage(id: id,);
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
  const RecipeGridPage({Key key, this.id}) : super(key: key);
  final int id;

  @override
  _RecipeGridPageState createState() => _RecipeGridPageState(id);
}

//TODO: main view
class _RecipeGridPageState extends State<RecipeGridPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final _width = Attributes.SCREEN_WIDTH;
  final _height = Attributes.SCREEN_HEIGHT;
  final int id;

  List<News> _news = List();
  final _newsWebService = NewsWebService();
  bool _isLoading = true;

  _RecipeGridPageState(this.id);


  @override
  void initState() {
    _newsWebService.getNews().then((_list) {
      if (_list == null) {
        Dialogs dialogs = Dialogs(context);
        dialogs.showErrorDialog(Strings.ERROR_CONNEXION);
      } else {
        for (NewsEntity entity in _list) {
          if (_news.length < 2)
            _news.add(News(
                ingredients: List<RecipeIngredient>(),
                steps: List<RecipeStep>(),
                author: '',
                name: entity.title,
                description: entity.description,
                id: entity.id,
                imagePath: entity.photo,
                ingredientsImagePath: 'assets/logo.png',
                imagePackage: 'assets',
                ingredientsImagePackage: 'assets'));
        }
        if (id != null)
          for (News n in _news){
            if (n.id == id){
              showRecipePage(context, n);
              break;
            }}

      }
      _isLoading = false;
      setState(() {});
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
          child: _isLoading
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
            final News recipe = _news[index];
            return RecipeCard(
              recipe: recipe,
              onTap: () {
                showRecipePage(context, recipe);
              },
            );
          },
          childCount: _news.length,
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

  void showRecipePage(BuildContext context, News recipe) {
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

/*class PestoLogo extends StatefulWidget {
  const PestoLogo({this.height, this.t});

  final double height;
  final double t;

  @override
  _PestoLogoState createState() => _PestoLogoState();
}*/

/*class _PestoLogoState extends State<PestoLogo> {
  // Native sizes for logo and its image/text components.
  static const double kLogoHeight = 162.0;
  static const double kLogoWidth = 220.0;
  static const double kImageHeight = 108.0;
  static const double kTextHeight = 48.0;
  final TextStyle titleStyle = const PestoStyle(fontSize: kTextHeight, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 3.0);
  final RectTween _textRectTween = RectTween(
      begin: Rect.fromLTWH(0.0, kLogoHeight, kLogoWidth, kTextHeight),
      end: Rect.fromLTWH(0.0, kImageHeight, kLogoWidth, kTextHeight)
  );
  final Curve _textOpacity = const Interval(0.4, 1.0, curve: Curves.easeInOut);
  final RectTween _imageRectTween = RectTween(
    begin: Rect.fromLTWH(0.0, 0.0, kLogoWidth, kLogoHeight),
    end: Rect.fromLTWH(0.0, 0.0, kLogoWidth, kImageHeight),
  );

  @override
  Widget build(BuildContext context) {
    return Semantics(
      namesRoute: true,
      child: Transform(
        transform: Matrix4.identity()..scale(widget.height / kLogoHeight),
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: kLogoWidth,
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Positioned.fromRect(
                rect: _imageRectTween.lerp(widget.t),
                child: Image.asset(
                  _kSmallLogoImage,
                  package: _kGalleryAssetsPackage,
                  fit: BoxFit.contain,
                ),
              ),
              Positioned.fromRect(
                rect: _textRectTween.lerp(widget.t),
                child: Opacity(
                  opacity: _textOpacity.transform(widget.t),
                  child: Text('PESTO', style: titleStyle, textAlign: TextAlign.center),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/

// A card with the recipe's image, author, and title.


//TODO: receipe card classes
class RecipeCard extends StatefulWidget{
  const RecipeCard({Key key, this.recipe, this.onTap}) : super(key: key);
  final News recipe;
  final VoidCallback onTap;

  _RecipeCard createState() => _RecipeCard(recipe: recipe, onTap: onTap);
}

class _RecipeCard extends State<RecipeCard> {

  _RecipeCard({Key key, this.recipe, this.onTap});

  final News recipe;
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
              tag: '${recipe.imagePath}',
              child: AspectRatio(
                  aspectRatio: 4.0 / 3.0,
                  child: CachedNetworkImage(
                  imageUrl: recipe.imagePath,
                  //package: recipe.imagePackage,
                  fit: BoxFit.cover,
                  placeholder: Image.asset('assets/logo.png', fit: BoxFit.cover,),
                  //semanticLabel: recipe.name,
                ),
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  /*Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset(
                      recipe.ingredientsImagePath,
                      //package: recipe.ingredientsImagePackage,
                      width: 48.0,
                      height: 48.0,
                    ),
                  ),*/
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

  final News recipe;

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
                    tag: '${widget.recipe.imagePath}',
                    child: CachedNetworkImage(
                    imageUrl: widget.recipe.imagePath,
                    //package: recipe.imagePackage,
                    fit: BoxFit.cover,
                    placeholder: Image.asset('assets/logo.png', fit: BoxFit.cover,),
                    //semanticLabel: recipe.name,
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

  PopupMenuItem<String> _buildMenuItem(IconData icon, String label) {
    return PopupMenuItem<String>(
      child: Row(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 24.0),
              child: Icon(icon, color: Colors.black54)),
          Text(label, style: menuItemStyle),
        ],
      ),
    );
  }

  void _toggleFavorite() {
    setState(() {
      if (_favoriteRecipes.contains(widget.recipe))
        _favoriteRecipes.remove(widget.recipe);
      else
        _favoriteRecipes.add(widget.recipe);
    });
  }
}

/// Displays the recipe's name and instructions.
class RecipeSheet extends StatefulWidget {
  RecipeSheet({Key key, this.recipe}) : super(key: key);
  final News recipe;

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

  final News recipe;

  bool _isRating = false;

  final _width = Attributes.SCREEN_WIDTH;
  final _height = Attributes.SCREEN_HEIGHT;



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
             TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Image.asset(recipe.ingredientsImagePath,
                    //package: recipe.ingredientsImagePackage,
                    width: 32.0,
                    height: 32.0,
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown)),
            /*Container(
              height: 32.0,
            ),*/
            TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Text(recipe.name, style: titleStyle)),
          ]),

          TableRow(children: <Widget>[
            const SizedBox(),
            Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                child: Text(recipe.description, style: descriptionStyle)),
          ]),
          /*TableRow(
                children: <Widget>[
                  const SizedBox(),
                  Padding(
                      padding: const EdgeInsets.only(top: 24.0, bottom: 4.0),
                      child: Text('Ingredients', style: headingStyle)
                  ),
                ]
            ),*/
        ]
          /*..addAll(recipe.ingredients.map<TableRow>(
                    (RecipeIngredient ingredient) {
                  return _buildItemRow(
                      ingredient.amount, ingredient.description);
                }
            ))*/
          /*..add(
                TableRow(
                    children: <Widget>[
                      const SizedBox(),
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 24.0, bottom: 4.0),
                          child: Text('Steps', style: headingStyle)
                      ),
                    ]
                )
            )*/
          /*..addAll(recipe.steps.map<TableRow>(
                    (RecipeStep step) {
                  return _buildItemRow(step.duration ?? '', step.description);
                }
            )),*/
        ),
      ),
    );
  }

  TableRow _buildItemRow(String left, String right) {
    return TableRow(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(left, style: itemAmountStyle),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(right, style: itemStyle),
        ),
      ],
    );
  }

}

class News {
  News(
      {this.name,
        this.id,
        this.author,
        this.description,
        this.imagePath,
        this.imagePackage,
        this.ingredientsImagePath,
        this.ingredientsImagePackage,
        this.ingredients,
        this.steps});

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
