import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:ui_flutter/src/pages/sedes.dart';

import 'package:ui_flutter/src/widgets/tab_bar/tab_evento.dart';
import 'package:ui_flutter/src/widgets/tab_bar/tab_inicio.dart';
import 'package:ui_flutter/src/widgets/tab_bar/tab_sede.dart';

import 'package:ui_flutter/src/widgets/nav_bar/nav_drawer.dart';

class InicioPage extends StatefulWidget {
  InicioPage({Key key}) : super(key: key);

  @override
  _InicioPageState createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage>
    with SingleTickerProviderStateMixin {
  int fabIndex = 0;
  final List<Tab> myTabs = <Tab>[
    new Tab(icon: new Icon(Icons.home), text: "Inicio"),
    new Tab(icon: new Icon(Icons.event), text: "Eventos"),
    new Tab(icon: new Icon(Icons.event), text: "Sedes"),
  ];
  TabController tabController;
  @override
  void initState() {
    tabController = new TabController(vsync: this, length: myTabs.length);
    tabController.addListener(() {
      setState(() {
        fabIndex = tabController.index;
        print(fabIndex);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
        length: 3,
        child: Scaffold(
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
        onPressed: null,
        backgroundColor: Colors.redAccent,
        child: Icon(
          Icons.edit,
          size: 20.0,
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
            context, MaterialPageRoute(builder: (context) => pageSedes())),
        backgroundColor: Colors.green,
      );
    }
  }
}
