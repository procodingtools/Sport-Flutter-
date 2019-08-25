import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phoenix_club/utils/attribs.dart';
import 'package:phoenix_club/utils/res/colors.dart';
import 'package:phoenix_club/utils/res/strings.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  double _width;
  double _height;

  @override
  Widget build(BuildContext context) {
    _width = Attributes.SCREEN_WIDTH;
    _height = Attributes.SCREEN_HEIGHT;
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/main_back.jpg"), fit: BoxFit.fill)),
      //decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/main_back.png"), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.white12,
          title: Text("À propos"),
        ),
        body: Column(
          children: <Widget>[
            Container(
              width: _width * 0.7,
              child: Image.asset('assets/logo.png', width: _width * 0.85),
              margin: EdgeInsets.only(top: 10.0),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Text(
                            '' + Strings.DESCRIPTION,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          margin: EdgeInsets.only(
                              top: _height * 0.08, bottom: _height * 0.04),
                        ),
                        _coordinatesItem(
                            icon: Icons.phone,
                            text: Strings.PHONE,
                            onClick: () => launch("tel:123456789")),
                        Divider(
                          color: Colors.white54,
                        ),
                        _coordinatesItem(
                            icon: Icons.email,
                            text: Strings.EMAIL,
                            onClick: () => launch("mailto:test@test.com")),
                        Divider(
                          color: Colors.white54,
                        ),
                        _coordinatesItem(
                            icon: Icons.location_on,
                            text: Strings.LOCATION,
                            onClick: () => launch(
                                "http://maps.google.com/maps?q=loc:${Strings.LAT},${Strings.LNG}")),
                        Divider(
                          color: Colors.white54,
                        ),
                        _coordinatesItem(
                            icon: FontAwesomeIcons.facebook,
                            text: Strings.FACEBOOK,
                            onClick: () =>
                                launch("https://fb.me/Phenixclubsfax")),
                        Divider(
                          color: Colors.white54,
                        ),
                        _coordinatesItem(
                            icon: FontAwesomeIcons.instagram,
                            text: Strings.INSTAGRAM,
                            onClick: () =>
                                launch("https://instagram.com/phenix.club/")),
                        Divider(
                          color: Colors.white54,
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _coordinatesItem({IconData icon, String text, void onClick()}) {
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: InkWell(
        splashColor: MyColors.primaryColor,
        onTap: () => onClick(),
        child: Container(
          margin: EdgeInsets.only(top: _height * 0.05, bottom: _height * 0.02),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Icon(
                icon,
                color: Colors.white54,
              ),
              Flexible(
                child: Container(
                  margin: EdgeInsets.only(left: _width * 0.03),
                  child: Text('$text', style: TextStyle(color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
