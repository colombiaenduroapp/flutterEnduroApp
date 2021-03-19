import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui_flutter/main.dart';

import 'package:ui_flutter/src/widgets/tab_bar/tab_evento.dart';
import 'package:ui_flutter/src/widgets/tab_bar/tab_gestionar.dart';
import 'package:ui_flutter/src/widgets/tab_bar/tab_inicio.dart';
import 'package:ui_flutter/src/widgets/nav_bar/nav_drawer.dart';

class InicioPage extends StatefulWidget {
  InicioPage({Key key}) : super(key: key);

  @override
  _InicioPageState createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage>
    with SingleTickerProviderStateMixin {
  int us_per;
  int us_perfil = App.localStorage.getInt('us_perfil');
  int fabIndex;
  List<Tab> myTabs;

  TabController tabController;

  @override
  void initState() {
    String s = App.localStorage.getString('us_alias');
    print(s);
    us_per = us_perfil;
    myTabs = <Tab>[
      if (us_per > 1) new Tab(text: "Gestionar"),
      new Tab(text: "Inicio"),
      new Tab(text: "Eventos"),
    ];
    tabController = new TabController(vsync: this, length: myTabs.length);
    tabController.index = us_per > 1 ? 1 : 0;
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
        length: us_per > 1 ? 3 : 2,
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
              if (us_per > 1) tab_gestionar(),
              tab_inicio(),
              tab_evento(),
              // tab_sede(),
            ],
          ),
          bottomNavigationBar: Container(
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
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
              unselectedLabelColor: Theme.of(context).textSelectionColor,
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
