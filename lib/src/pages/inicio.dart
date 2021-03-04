import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui_flutter/src/pages/sedes.dart';

import 'package:ui_flutter/src/widgets/tab_bar/tab_evento.dart';
import 'package:ui_flutter/src/widgets/tab_bar/tab_gestionar.dart';
import 'package:ui_flutter/src/widgets/tab_bar/tab_inicio.dart';
import 'package:ui_flutter/src/widgets/tab_bar/tab_sede.dart';

import 'package:ui_flutter/src/widgets/nav_bar/nav_drawer.dart';

import 'eventos.dart';

class InicioPage extends StatefulWidget {
  int tab_index;
  InicioPage(this.tab_index, {Key key}) : super(key: key);

  @override
  _InicioPageState createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage>
    with SingleTickerProviderStateMixin {
  int fabIndex;
  final List<Tab> myTabs = <Tab>[
    new Tab(text: "Gestionar"),
    new Tab(text: "Inicio"),
    new Tab(text: "Eventos"),
  ];
  TabController tabController;
  addStringToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('us_cdgo', 1);
    prefs.setString('us_nombres', "Yuri Marcela");
    prefs.setInt('us_sede_sd_cdgo', 110);
  }

  @override
  void initState() {
    addStringToSF();
    tabController = new TabController(vsync: this, length: myTabs.length);
    tabController.index = widget.tab_index;
    tabController.addListener(() {
      setState(() {
        fabIndex = tabController.index;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.blueGrey[800]),
    );
    return new DefaultTabController(
        length: 3,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text(
              'COLOMBIA ENDURO',
            ),
          ),
          body: TabBarView(
            controller: tabController,
            children: [
              tab_gestionar(),
              tab_inicio(),
              tab_evento(),
              // tab_sede(),
            ],
          ),
          bottomNavigationBar: Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  //                    <--- top side
                  color: Theme.of(context).primaryColor,
                  width: 1.0,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: TabBar(
              controller: tabController,
              labelStyle: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'Family Name',
                  fontWeight: FontWeight.w800),
              unselectedLabelStyle:
                  TextStyle(fontSize: 13.0, fontFamily: 'Family Name'),
              unselectedLabelColor: Colors.black38,
              labelColor: Theme.of(context).accentColor,
              indicatorWeight: 3,
              indicatorColor: Theme.of(context).accentColor,
              tabs: myTabs,
            ),
          ),
          drawer: Nav_drawer(),
        ));
  }
}
