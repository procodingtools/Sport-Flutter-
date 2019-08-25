import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:phoenix_club/membership/entity/membership_entity.dart';
import 'package:phoenix_club/membership/membership_webservice.dart';
import 'package:phoenix_club/utils/attribs.dart';
import 'package:phoenix_club/utils/dialogs/dialogs.dart';
import 'package:phoenix_club/utils/res/strings.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MembershipScreen extends StatefulWidget {
  _MembershipState createState() => _MembershipState();
}

class _MembershipState extends State<MembershipScreen> {
  final _width = Attributes.SCREEN_WIDTH;
  final _height = Attributes.SCREEN_HEIGHT;
  final _webservice = MembershipWebservice();
  bool _isLoading = true;
  List<MembershipEntity> _data;
  RefreshController _controller = RefreshController();

  @override
  void initState() {
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("${Strings.MEMBERSHIP}"),
          backgroundColor: Colors.black87,
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/main_back.jpg"), fit: BoxFit.fill)),
          child: _isLoading
              ? _loadingWidget()
              : SmartRefresher(
                enablePullUp: false,
                enablePullDown: true,
                enableOverScroll: true,
                controller: _controller,
                onRefresh: (b) {
                  _getData().then((status) {
                    _controller.sendBack(
                        true,
                        status == null
                            ? RefreshStatus.failed
                            : status
                            ? RefreshStatus.completed
                            : RefreshStatus.failed);
                  });
                },
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return _listItem(index);
                  },
                  itemCount: _data.length,
                ),
              ),
        ));
  }

  Widget _loadingWidget() {
    return Center(
        child: SpinKitCubeGrid(
      color: Colors.white70,
      size: _width * 0.15,
    ));
  }

  Widget _listItem(int index) {
    MembershipEntity _entity = _data[index];
    return Container(
      margin: EdgeInsets.only(bottom: _height * 0.02),
      child: Stack(
        children: <Widget>[
          Container(
            height: _height * 0.35,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/membership.item.background.png"),
                    fit: BoxFit.cover)),
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(left: _width * 0.2),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildDescRow(
                          "Date début: ",
                          DateFormat("dd/MM/yyyy").format(_entity.beginDate),
                          0.1),
                      Container(
                        height: _height * 0.01,
                        width: 0.0,
                      ),
                      _buildDescRow(
                          "Date fin: ",
                          DateFormat("dd/MM/yyyy").format(_entity.endDate),
                          0.08),
                      Container(
                        height: _height * 0.01,
                        width: 0.0,
                      ),
                      _buildDescRow("Prix: ", _entity.price.toString(), 0.06),
                      Container(
                        height: _height * 0.01,
                        width: 0.0,
                      ),
                      _buildDescRow(
                          "Somme payée: ", _entity.paid.toString(), 0.04),
                      Container(
                        height: _height * 0.01,
                        width: 0.0,
                      ),
                      _buildDescRow("Reste: ",
                          (_entity.price - _entity.paid).toString(), 0.02),
                    ]),
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.only(left: _width * 0.43, top: _height * 0.02),
              width: _width * 0.7,
              child: AutoSizeText(
                "${_entity.label}",
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontSize: _width * 0.07,
                    fontFamily: 'SportsNight'),
              )),
        ],
      ),
    );
  }

  Widget _buildDescRow(String title, String value, double marginLeft) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: _width * marginLeft,
        ),
        Text(
          title,
          style: TextStyle(color: Colors.red),
        ),
        Text(
          value,
          style: TextStyle(color: Colors.white),
        )
      ],
    );
  }

  Future<bool> _getData() async {
    final _list = await _webservice.get();
    if (_list == null) {
      Dialogs(context).showErrorDialog(Strings.ERROR_CONNEXION);
      setState(() {
        _isLoading = false;
      });
      return false;
    } else {
      if (_list.isEmpty) {
        Dialogs(context).showErrorDialog(Strings.NO_MEMBERSHIPS);
        setState(() {
          _data = _list;
          _isLoading = false;
        });
        return false;
      }
    }
    setState(() {
      _data = _list;
      _isLoading = false;
    });
    return true;
  }
}
