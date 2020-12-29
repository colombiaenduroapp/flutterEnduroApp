import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui_flutter/src/pages/sedes.dart';

import 'package:ui_flutter/src/widgets/tab_bar/tab_evento.dart';
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
        length: 3,
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
              title: Text(
                'COLOMBIA ENDURO',
              ),
              bottom: new TabBar(controller: tabController, tabs: myTabs)),
          body: TabBarView(
            controller: tabController,
            children: [tab_inicio(), tab_evento(), tab_sede()],
          ),
          floatingActionButton: _bottomButtons(),
          drawer: Nav_drawer(),
        ));
  }

  Widget _bottomButtons() {
    if (fabIndex == 0) {
      return FloatingActionButton(
          shape: StadiumBorder(),
          onPressed: null,
          backgroundColor: Colors.redAccent,
          child: Icon(
            Icons.message,
            size: 20.0,
          ));
    } else if (tabController.index == 1) {
      return FloatingActionButton(
        shape: StadiumBorder(),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => pagesEventos(null, null, 'Registrar'))),
        backgroundColor: Colors.redAccent,
        child: Icon(
          Icons.add,
          size: 35.0,
        ),
      );
    } else if (tabController.index == 2) {
      return FloatingActionButton(
        child: Icon(
          Icons.add,
          size: 35.0,
        ),
        shape: StadiumBorder(),
        hoverColor: Colors.blue,
        focusColor: Colors.blue,
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => pageSedes('Registrar', null, null))),
        backgroundColor: Colors.green,
      );
    }
  }
}
