import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:phoenix_club/about/views/about_screen.dart';
import 'package:phoenix_club/activities_list/views/activities_screen.dart';
import 'package:phoenix_club/login/views/login_screen.dart';
import 'package:phoenix_club/membership/views/membership_screen.dart';
import 'package:phoenix_club/news/views/news_screen.dart';
import 'package:phoenix_club/planning/views/planning_screen.dart';
import 'package:phoenix_club/pricing/views/membership_types_screen.dart';
import 'package:phoenix_club/reservations/views/reservations_screen.dart';
import 'package:phoenix_club/utils/attribs.dart';
import 'package:phoenix_club/utils/entities/user_entity.dart';
import 'package:phoenix_club/utils/page_transformer/data.dart';
import 'package:phoenix_club/utils/page_transformer/intro_page_item.dart';
import 'package:phoenix_club/utils/page_transformer/page_transformer.dart';
import 'package:phoenix_club/utils/res/strings.dart';
import 'package:phoenix_club/utils/webservice/webservice_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  static final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var sampleItems = [];
  String imageUrl = WebService.BASE_URL + "Server/file";
  bool isLoading = true;
  int _notifId = 0;
  bool currentRoute = false;

  //static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid =
  new AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettingsIOS = new IOSInitializationSettings();
  var initializationSettings;

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      if (payload.startsWith('N-'))
        Navigator.push(context, MaterialPageRoute(builder: (context) => NewsScreen(id: int.parse(payload.substring(2, payload.length)),)));
      else
        Navigator.push(context, MaterialPageRoute(builder: (context) => PlanningScreen()));
    }
  }

  void firebaseCloudMessaging_Listeners() {

    HomeScreen.firebaseMessaging.subscribeToTopic('actualite');

    HomeScreen.firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        showNotification(message['notification']['title'], message['notification']['body'], '${message['data']['Id']}', !message['notification']['title'].toString().contains("Reservation"));
      },
      onResume: (Map<String, dynamic> message) async {
        if (!message['notification']['title'].toString().contains("Reservation"))
          Navigator.push(context, MaterialPageRoute(builder: (context) => NewsScreen(id: int.parse(message['Id']),)));
        else
          Navigator.push(context, MaterialPageRoute(builder: (context) => PlanningScreen()));
      },
      onLaunch: (Map<String, dynamic> message) async {
        if (!message['notification']['title'].toString().contains("Reservation"))
          Navigator.push(context, MaterialPageRoute(builder: (context) => NewsScreen(id: int.parse(message['Id']),)));
        else
          Navigator.push(context, MaterialPageRoute(builder: (context) => PlanningScreen()));
      },
    );
  }

  showNotification (String title, String body, String payload, bool isNews) async{
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        '0', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, enableVibration: true, style: AndroidNotificationStyle.BigText, );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        _notifId, title, body, platformChannelSpecifics,
        payload: isNews ? 'N-'+payload : 'P-'+payload);
    _notifId++;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    currentRoute = false;
  }

  @override
  void initState() {
    super.initState();

    firebaseCloudMessaging_Listeners();

    initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getString("user") != null) {
        HomeScreen.firebaseMessaging.subscribeToTopic(
            UserEntity(data: jsonDecode(prefs.getString("user"))).id
                .toString());
      }
      setState(() {
        sampleItems.addAll([
          new IntroItem(
              title: Strings.RESERVATION_TITLE,
              category: Strings.RESERVATIONS,
              imageUrl: 'assets/reservation_background.jpg',
              page: prefs.getString("user") == null
                  ? LoginScreen()
                  : ReservationsScreen()),

          new IntroItem(
              title: Strings.COURSES_LIST_TITLE,
              category: Strings.ACTIVITIES_LIST,
              imageUrl: 'assets/courses_list_background.jpg',
              page: ActivitiesScreen()),

          new IntroItem(
              title: Strings.PLANNING_TITLE,
              category: Strings.PLANNING,
              imageUrl: 'assets/planning_background.jpg',
              page: PlanningScreen()),

          new IntroItem(
              title: Strings.NEWS_TITLE,
              category: Strings.NEWS,
              imageUrl: 'assets/news_background.jpg',
              page: NewsScreen()),

          new IntroItem(
              title: Strings.PRICING_TITLE,
              category: Strings.PRICING,
              imageUrl: 'assets/pricing_background.png',
              page: PricingScreen(),
          ),

          new IntroItem(
              title: Strings.MEMBERSHIP_TITLE,
              category: Strings.MEMBERSHIP,
              imageUrl: 'assets/members_background.png',
              page: prefs.getString("user") == null
                  ? LoginScreen()
                  : MembershipScreen(),
          ),

          new IntroItem(
              title: Strings.ABOUT_TITLE,
              category: Strings.ABOUT,
              imageUrl: 'assets/about_background.png',
              page: AboutScreen())
        ]);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Attributes.SCREEN_HEIGHT = MediaQuery.of(context).size.height;
    Attributes.SCREEN_WIDTH = MediaQuery.of(context).size.width;
    final _height = Attributes.SCREEN_HEIGHT;
    final _width = Attributes.SCREEN_WIDTH;

    return Scaffold(

      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/main_back.jpg"), fit: BoxFit.fill)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(top: _height * 0.05),
                child: Image.asset(
                  "assets/logo.png",
                  width: _width * 0.6,
                  fit: BoxFit.scaleDown,
                )
            ),
            SizedBox(
              height: _height*0.735,
              //size: const Size.fromHeight(500.0),
              child: PageTransformer(
                pageViewBuilder: (context, visibilityResolver) {
                  return PageView.builder(
                    controller: PageController(viewportFraction: 0.85),
                    itemCount: sampleItems.length,
                    itemBuilder: (context, index) {
                      final item = sampleItems[index];
                      final pageVisibility =
                          visibilityResolver.resolvePageVisibility(index);

                      return IntroPageItem(
                        item: item,
                        context: context,
                        page: item.page,
                        pageVisibility: pageVisibility,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}
