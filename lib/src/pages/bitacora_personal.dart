import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class PagesBitacoraPersonal extends StatefulWidget {
  PagesBitacoraPersonal({Key key}) : super(key: key);

  @override
  _PagesBitacoraPersonalState createState() => _PagesBitacoraPersonalState();
}

class _PagesBitacoraPersonalState extends State<PagesBitacoraPersonal> {
  List<Asset> images = List<Asset>();
  String _error = null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('bitacora'),
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            child: Text("Pick images"),
            onPressed: loadAssets,
          ),
          Center(child: _error != null ? Text('Error: $_error') : Text('')),
          Expanded(
            child: buildGridView(),
          )
        ],
      ),
    );
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];

        print('gggggggggggg' + images[index].getByteData().toString());
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList;
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 3,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Imagenes",
          allViewTitle: "Todas las fotos",
          useDetailsView: true,
          selectCircleStrokeColor: "#000000",
          selectionLimitReachedText:
              "Puedes cargar maximo tres imagenes por registro.",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }
}
