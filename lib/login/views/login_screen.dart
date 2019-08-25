import 'dart:async';

import 'package:flutter/material.dart';
import 'package:phoenix_club/login/webservice/login_webservice.dart';
import 'package:phoenix_club/utils/attribs.dart';
import 'package:phoenix_club/utils/color_parse.dart';
import 'package:phoenix_club/utils/dialogs/dialogs.dart';
import 'package:phoenix_club/utils/res/strings.dart';

class LoginScreen extends StatefulWidget {
  String page = null;

  LoginScreen({this.page});

  _LoginState createState() => _LoginState(page: page);
}

class _LoginState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  _LoginState({this.page});

  bool _toSignUp = false;
  bool _accountCreated = false;
  String page;
  final _width = Attributes.SCREEN_WIDTH;
  final _height = Attributes.SCREEN_HEIGHT;
  bool _isLoggingIn = false;
  AnimationController _controller;
  Animation<double> _transition;
  Animation _anim;
  Tween<double> _toFullScreen;
  double containerSize;
  bool _isGoingToFull = false;
  LoginWebService _webService;
  String _birthDateText = Strings.BIRTH_DATE;
  String _userName;
  String _passwd;
  String _sex = "Genre";
  final _loginFormKey = GlobalKey<FormState>();
  final _signUpFormKey = GlobalKey<FormState>();

  //Login text gradienr shader
  final Shader linearGradient = LinearGradient(
    colors: <Color>[
      Colors.black,
      Color(ColorParse.getColorHexFromStr("9E9E9E"))
    ],
  ).createShader(Rect.fromLTRB(50.0, 50.0, 700.0, 100.0));

  @override
  void initState() {
    _webService = LoginWebService();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _transition =
        Tween(begin: _width * 0.6, end: _width * 0.2).animate(_controller)
          ..addListener(() {
            setState(() {});
          });

    _toFullScreen = Tween(begin: _width * 0.2, end: _height * 1.25);
  }

  @override
  Widget build(BuildContext context) {
    containerSize = !_isGoingToFull ? _transition.value : _anim.value;
    return WillPopScope(
      onWillPop: () {
        if (!_isLoggingIn || !_isGoingToFull) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            if (MediaQuery.of(context).viewInsets.bottom != 0.0)
              FocusScope.of(context).requestFocus(new FocusNode());
            else if (!_isLoggingIn || !_isGoingToFull) {
              Navigator.pop(context);
            }
          },
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/main_back.jpg"),
                    fit: BoxFit.fill)),
            child: Stack(
              //TODO: main stack
              fit: StackFit.passthrough,
              children: <Widget>[
                Positioned(
                  left: 0.0,
                  top: 0.0,
                  child: Container(
                    margin: EdgeInsets.only(top: _height * 0.05),
                    child: InkWell(
                      highlightColor: Colors.black,
                      onTap: () => Navigator.pop(context),
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  //TODO: LOGO
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(top: _height * 0.09),
                  child: Image.asset(
                    "assets/logo.png",
                    width: _width * 0.6,
                    fit: BoxFit.scaleDown,
                  ),
                ),
                Center(
                  child: Container(
                    //TODO: all centered children
                    margin: !_isGoingToFull
                        ? EdgeInsets.only(top: _height * 0.17)
                        : null,
                    width: _isGoingToFull ? containerSize : _width * 0.75,
                    height: _isGoingToFull
                        ? containerSize
                        : _toSignUp ? _height * 0.61 : _height * 0.5,
                    child: Stack(
                      //TODO: Centred Stack
                      children: <Widget>[
                        Container(
                          //TODO: The white card parent (Container)
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          width:
                              !_isGoingToFull ? _width * 0.75 : containerSize,
                          height: _toSignUp ? _height * 0.56 : _height * 0.45,
                          //white card size
                          child: InkWell(
                            onTap: () => FocusScope.of(context)
                                .requestFocus(new FocusNode()),
                            child: Card(
                              //TODO: The white Card containing Login word and form
                              color: Colors.white.withOpacity(0.7),
                              elevation: 5.0,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: Stack(
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: Container(
                                          margin: EdgeInsets.only(top: 30.0),
                                          child: Text(
                                            //TODO: Login/Create account word
                                            _toSignUp
                                                ? "" + Strings.CREATE_ACCOUNT
                                                : "" + Strings.LOGIN,
                                            style: TextStyle(
                                                fontSize: _toSignUp
                                                    ? _width * 0.07
                                                    : _width * 0.095,
                                                fontWeight: FontWeight.bold,
                                                foreground: Paint()
                                                  ..shader = linearGradient),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Container(
                                          //TODO: forms Container
                                          margin: EdgeInsets.only(
                                              top: _toSignUp
                                                  ? _height * 0.07
                                                  : _height * 0.05),
                                          child: _toSignUp
                                              ? _signUpForm()
                                              : _loginForm(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          //TODO: Connect btn
                          alignment: Alignment.bottomCenter,
                          child: Material(
                              elevation: 3.0,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              type: MaterialType.transparency,
                              child: Container(
                                  width: containerSize,
                                  height: _isGoingToFull
                                      ? containerSize
                                      : _height * 0.11,
                                  decoration: BoxDecoration(
                                      borderRadius: containerSize < 500
                                          ? BorderRadius.all(
                                              Radius.circular(50.0))
                                          : null,
                                      gradient: LinearGradient(
                                          colors: [
                                            Colors.black,
                                            Color(ColorParse.getColorHexFromStr(
                                                "424242"))
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight)),
                                  child: !_isLoggingIn
                                      ? InkWell(
                                          onTap: () {
                                            FocusScope.of(context)
                                                .requestFocus(new FocusNode());
                                            _signUpOrLogin(_toSignUp);
                                          },
                                          splashColor: Colors.grey,
                                          highlightColor: Colors.white70,
                                          child: Center(
                                            child: Text(
                                              _toSignUp
                                                  ? "" + Strings.DEMAND
                                                  : "" + Strings.CONNECT,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20.0),
                                            ),
                                          ))
                                      : !_isGoingToFull
                                          ? Theme(
                                              data: Theme.of(context).copyWith(
                                                  accentColor: Colors.white),
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            )
                                          : Center(
                                              child: InkWell(
                                                onTap: () {
                                                  if (_accountCreated)
                                                    Navigator.pop(context);
                                                },
                                                child: Text(
                                                  _toSignUp
                                                      ? "" +
                                                          Strings.DEMAND_SUCCESS
                                                      : "" + Strings.WELCOME,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w100,
                                                      fontSize: _width * 0.13),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ))),
                        )
                      ],
                    ),
                  ),
                )
              ].where((c) => c != null).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginForm() {
    return Material(
      type: MaterialType.transparency,
      child: Form(
        key: _loginFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              validator: (txt) =>
                  txt.trim().isEmpty
                      ? Strings.IS_EMPTY//Strings.WRONG_MAIL
                      : null,
              autocorrect: false,
              autofocus: false,
              textCapitalization: TextCapitalization.none,
              keyboardType: TextInputType.emailAddress,
              maxLines: 1,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.grey,
                ),
                hintText: Strings.USER_NAME,
              ),
              onSaved: (val) => _userName = val,
            ),
            TextFormField(
              validator: (val) => val.trim().isEmpty
                  ? Strings.IS_EMPTY//Strings.SHORT_PASSWD
                  : null,
              autocorrect: false,
              autofocus: false,
              textCapitalization: TextCapitalization.none,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.grey,
                ),
                hintText: Strings.PASSWD,
              ),
              obscureText: true,
              keyboardType: TextInputType.text,
              maxLines: 1,
              onSaved: (val) => _passwd = val,
            ),
            FlatButton(
                onPressed: () {
                  setState(() {
                    _toSignUp = !_toSignUp;
                  });
                },
                child: Text(
                  '${Strings.CREATE_ACCOUNT}',
                  style: TextStyle(
                      color: Color(ColorParse.getColorHexFromStr("424242")),
                      fontSize: 13.0),
                ))
          ],
        ),
      ),
    );
  }

  Widget _signUpForm() {
    return SingleChildScrollView(
      child: Form(
        key: _signUpFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              validator: (val) => val.length < 4 || !val.contains(" ")
                  ? Strings.CHK_NAME_LSTNAME
                  : null,
              autocorrect: false,
              autofocus: false,
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.text,
              maxLines: 1,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.grey,
                ),
                hintText: Strings.NAME_LAST_NAME,
              ),
              onSaved: (val) => _userName = val,
            ),
            TextFormField(
              validator: (val) => val.length < 8 || val.length > 13
                  ? Strings.SHORT_PHONE
                  : null,
              autocorrect: false,
              autofocus: false,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.phone_android,
                  color: Colors.grey,
                ),
                hintText: Strings.PHONE_NB,
              ),
              keyboardType: TextInputType.phone,
              maxLines: 1,
              onSaved: (val) => _passwd = val,
            ),
            GestureDetector(
              onTap: () {
                showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now())
                    .then((_date) {
                  _birthDateText = "${_date.day}/${_date.month}/${_date.year}";
                  setState(() {});
                });
              },
              child: Padding(
                padding: EdgeInsets.only(top: _height * 0.01),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.calendar_today,
                            color: Colors.grey,
                          ),
                          Container(
                            width: _width * 0.05,
                          ),
                          Text(
                            _birthDateText,
                            style: TextStyle(
                                color: _birthDateText.contains('/')
                                    ? Colors.black
                                    : Colors.black54,
                                fontSize: 15.0),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 5.0,
                      color: Colors.black54,
                    )
                  ],
                ),
              ),
            ),
            DropdownButton<String>(
              items: <String>['Homme', 'Femme'].map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              onChanged: (sex) {
                _sex = sex;
                setState(() {});
              },
              hint: Text(_sex),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                  onPressed: () {
                    setState(() {
                      _toSignUp = !_toSignUp;
                      _birthDateText = Strings.BIRTH_DATE;
                    });
                  },
                  child: Text(
                    '${Strings.OR_LOGIN}',
                    style: TextStyle(
                        color: Color(ColorParse.getColorHexFromStr("424242")),
                        fontSize: 13.0),
                  )),
            )
          ],
        ),
      ),
    );
  }

  void _signUpOrLogin(bool toSignUp) {
    if (!toSignUp) {
      if (_loginFormKey.currentState.validate()) {
        _isLoggingIn = true;
        _controller.forward();
        setState(() {});
        _loginFormKey.currentState.save();
        _webService.login(_userName, _passwd).then((status) {
          if (status != null) {
            if (!status) {
              _controller.reverse();
              _isLoggingIn = false;
              Dialogs(context).showErrorDialog(Strings.VERIF_LOGIN);
              setState(() {});
            } else {
              _isGoingToFull = true;
              _controller.reset();
              _controller.duration = Duration(milliseconds: 500);
              _anim = _toFullScreen.animate(_controller)
                ..addListener(() {
                  setState(() {});
                });
              _anim.addStatusListener((status) {
                if (status == AnimationStatus.completed)
                  Future.delayed(Duration(seconds: 2)).then((_) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/', (Route<dynamic> route) => false);
                  });
              });
              _controller.forward();
              setState(() {});
            }
          } else {
            _controller.reverse();
            _isLoggingIn = false;
            Dialogs(context).showErrorDialog(Strings.ERROR_CONNEXION);
            setState(() {});
          }
        });
      }
    } else if (_signUpFormKey.currentState.validate()) {
      bool b = true;
      if (!_birthDateText.contains('/')) {
        b = false;
        Dialogs(context).showErrorDialog(Strings.PUT_BD);
      }
      if (_sex == "Genre") {
        b = false;
        Dialogs(context).showErrorDialog(Strings.CHOOSE_SEX);
      }
      if (b) {
        _isLoggingIn = true;
        _controller.forward();
        setState(() {});
        _signUpFormKey.currentState.save();
        _webService
            .createAccount(_userName, _passwd, _userName, _sex)
            .then((status) {
          if (status != null) {
            if (!status) {
              Dialogs(context).showErrorDialog(Strings.ST_WENT_WRONG);
              _controller.reverse();
              _isLoggingIn = false;
              setState(() {});
            } else {
              _isGoingToFull = true;
              _controller.reset();
              _controller.duration = Duration(milliseconds: 500);
              _anim = _toFullScreen.animate(_controller)
                ..addListener(() {
                  setState(() {});
                });
              _accountCreated = true;
              _controller.forward();
              setState(() {});
            }
          } else {
            Dialogs(context).showErrorDialog(Strings.ERROR_CONNEXION);
            _controller.reverse();
            _isLoggingIn = false;
            setState(() {});
          }
        });
      }
    }
  }
}
