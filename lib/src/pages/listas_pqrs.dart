import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ui_flutter/main.dart';
import 'package:ui_flutter/src/services/services_pqrs.dart';
import 'package:ui_flutter/src/widgets/widgets.dart';

class PagesListasPqrs extends StatefulWidget {
  PagesListasPqrs({Key key}) : super(key: key);

  @override
  _PagesListasPqrsState createState() => _PagesListasPqrsState();
}

class _PagesListasPqrsState extends State<PagesListasPqrs> {
  final TextEditingController _filter = new TextEditingController();
  Widget _appBarTitle = new Text('Quejas y Reclamos');
  Icon _searchIcon = Icon(Icons.search);
  List<dynamic> pqrs = Hive.box('pqrsdb').get('data');
  String _searchText;

  _PagesListasPqrsState() {
    _filter.addListener(() {
      setState(() {
        _searchText = (_filter.text.isEmpty) ? "" : _filter.text;
      });
    });
  }

  @override
  void initState() {
    _searchText = "";
    super.initState();
  }

  socket() async {
    App.conexion.on('pqrsres', (_) async {
      pqrs = await ServicioPQRS().getPQRS();
      if (mounted) {
        setState(() {
          print('cambiando');
          pqrs = pqrs;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _appBarTitle,
        actions: [
          IconButton(icon: _searchIcon, onPressed: _searchPressed),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: _jobListView(pqrs),
            )
          ],
        ),
      ),
    );
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          autofocus: true,
          style: TextStyle(color: Colors.white),
          decoration: new InputDecoration(
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(20),
            focusColor: Colors.white,
            hintText: "Buscar...",
            hintStyle: TextStyle(color: Colors.white54),
          ),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Quejas y Reclamos');
        _filter.clear();
      }
    });
  }

  Widget _jobListView(data) {
    if (data.length > 0) {
      List<dynamic> listaPqrs = (_searchText.isNotEmpty)
          ? pqrs
              .where((f) => f['pqrs_asunto']
                  .toLowerCase()
                  .contains(_searchText.toLowerCase()))
              .toList()
          : data;
      return SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: listaPqrs.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black45,
                        width: 0.5,
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.black38,
                            blurRadius: 5.0,
                            offset: Offset(1.0, 0.75))
                      ],
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom:
                                  BorderSide(color: Colors.black45, width: 0.5),
                            ),
                          ),
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(listaPqrs[index]['us_alias'],
                                  style: Theme.of(context).textTheme.headline6),
                              Text(listaPqrs[index]['sd_desc'],
                                  style: Theme.of(context).textTheme.bodyText1)
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(bottom: 5),
                                    width:
                                        MediaQuery.of(context).size.width - 50,
                                    child: Text(listaPqrs[index]['pqrs_asunto'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                        textAlign: TextAlign.start),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width -
                                        50, //cambiar a valor dinamico tamaño de pantalla
                                    child: Text(
                                      listaPqrs[index]['pqrs_desc'],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border(
                              top:
                                  BorderSide(color: Colors.black45, width: 0.5),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                child: Text(
                                  listaPqrs[index]['fecha'],
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                  // ListTile(
                  //   title: Text('${listaPqrs[index]['pqrs_asunto']}'),
                  // );
                }),
            SizedBox(
              height: 80,
            )
          ],
        ),
      );
    } else {
      return Center(child: WidgetsGenericos.containerEmptyData(context));
    }
  }
}
