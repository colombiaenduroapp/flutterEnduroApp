import 'package:flutter/material.dart';
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
    new Tab(text: "Sedes"),
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
    return new DefaultTabController(
        length: 4,
        child: Scaffold(
          // resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text(
              'COLOMBIA ENDURO',
            ),
            // bottom: new TabBar(controller: tabController, tabs: myTabs),
          ),
          body: TabBarView(
            controller: tabController,
            children: [tab_gestionar(), tab_inicio(), tab_evento(), tab_sede()],
          ),
          bottomNavigationBar: Container(
            height: 50,
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
                  fontSize: 18.0,
                  fontFamily: 'Family Name',
                  fontWeight: FontWeight.w800),
              unselectedLabelStyle:
                  TextStyle(fontSize: 15.0, fontFamily: 'Family Name'),
              unselectedLabelColor: Colors.black38,
              labelColor: Theme.of(context).accentColor,
              indicatorWeight: 3,
              indicatorColor: Theme.of(context).accentColor,
              tabs: myTabs,
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
          floatingActionButton: _bottomButtons(),
          drawer: Nav_drawer(),
        ));
  }

  Widget _bottomButtons() {
    if (tabController.index == 2) {
      return FloatingActionButton(
        shape: StadiumBorder(),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => pagesEventos(null, null, 'Registrar'))),
        child: Icon(Icons.add, size: 35.0, color: Colors.white),
      );
    } else if (tabController.index == 3) {
      return FloatingActionButton(
        child: Icon(Icons.add, size: 35.0, color: Colors.white),
        shape: StadiumBorder(),
        hoverColor: Colors.blue,
        focusColor: Colors.blue,
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => pageSedes('Registrar', null, null))),
      );
    }
  }
}
