import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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
                  return ListTile(
                    title: Text('${listaPqrs[index]['pqrs_asunto']}'),
                  );
                }),
            SizedBox(
              height: 80,
            )
          ],
        ),
      );
    } else
      return Center(child: WidgetsGenericos.containerEmptyData(context));
  }
}
