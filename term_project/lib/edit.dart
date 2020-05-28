import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:term_project/dbhelper.dart';

import 'model/fish.dart';

class EditPage extends StatefulWidget {

  final String mTitle;

  EditPage({@required this.mTitle});

  @override
  _EditPageState createState() => _EditPageState();
  
}

class _EditPageState extends State<EditPage> {

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  
  String _selectedFish;
  double _stockValue = 1;

  File _imageFile;

  final descTextController = TextEditingController();

  Future _getImage(ImageSource src) async {

    var image = await ImagePicker.pickImage(source: src);

    setState(() {
      _imageFile = image;
    });
  }
  
  Widget _stackImage() {

    double _btnImgSize = 35.0;

    double screenWidth = MediaQuery.of(context).size.width;

    String _fishImage = "images/";

    switch(_selectedFish) {
      case "Catfish":
      _fishImage += "catfish";
      break;
      case "Characin":
      _fishImage += "characin";
      break;
      case "Cichlid":
      _fishImage += "cichlid";
      break;
      case "Goldfish":
      _fishImage += "gold";
      break;
      case "Golden Loach":
      _fishImage += "loach";
      break;
      case "Bluefin Killifish":
      _fishImage += "killi";
      break;
      case "Paradise Fish":
      _fishImage += "paradise";
      break;
      case "Orangeback Rainbowfish":
      _fishImage += "rainbow";
      break;
      case "Koifish":
      _fishImage += "koi";
      break;
      default:
      _fishImage += "fish_template";
      break;
    }

    _fishImage += ".jpg";

    return Stack(
      
      children: <Widget>[
        
        _imageFile == null ?
            Image(
              image: AssetImage(_fishImage),
              fit: BoxFit.fitWidth,
              width: screenWidth,
              height: 250,
            ) :
            Image.file(_imageFile, fit: BoxFit.fitWidth, width: screenWidth, height: 250),
        Positioned(
          right: 0,
          bottom: 0,
          child: Row(
            children: <Widget>[
              RawMaterialButton(
            constraints: BoxConstraints(
              maxHeight: _btnImgSize,
              minHeight: _btnImgSize,
              maxWidth: _btnImgSize,
              minWidth: _btnImgSize,
            ),
            child: Icon(Icons.file_upload, color: Colors.white, size: 18,),
            elevation: 2.0,
            padding: EdgeInsets.all(0),
            shape: CircleBorder(),
            fillColor: Colors.blue,
            onPressed: () {
              _getImage(ImageSource.gallery);
            },
          ),
          RawMaterialButton(
            constraints: BoxConstraints(
              maxHeight: _btnImgSize,
              minHeight: _btnImgSize,
              maxWidth: _btnImgSize,
              minWidth: _btnImgSize,
            ),
            child: Icon(Icons.camera_alt, color: Colors.white, size: 18,),
            elevation: 2.0,
            padding: EdgeInsets.all(0),
            shape: CircleBorder(),
            fillColor: Colors.blue,
            onPressed: () {
              _getImage(ImageSource.camera);
            },
          ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _dropDownFishType() {

      
    List _fishList = [
          'Catfish',
          'Characin',
          'Cichlid',
          'Goldfish',
          'Golden Loach',
          'Bluefin Killifish',
          'Paradise Fish',
          'Orangeback Rainbowfish',
          'Koifish',
          'Other',
      ];
      return Container(
        
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: DropdownButton(
                elevation: 2,
                underline: SizedBox(),
                isExpanded: true,
                hint: Text('Select Fish Type'),
                value: _selectedFish,
                items: _fishList
                  .map((fish) => 
                    DropdownMenuItem(value: fish, child: Text(fish)))
                  .toList(),
                onChanged: (str) {
                  setState(() {
                    _selectedFish = str;
                  });
                },
        ),
      );
      
      
    }

  Widget _sliderStock() {

    return Slider(
              
              min: 1,
              max: 50,
              value: _stockValue,
              onChanged: (val) {
                setState(() {
                  _stockValue = val;
                });
              },
            );
  }

  Widget _rowStock() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        
        children: <Widget>[
          
          Text('In Stock:'),
          Text(_stockValue.toInt().toString()),
       ],
      ),
    );
  }

  Widget _txtDescription() {
    return TextField(
      controller: descTextController,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Description',
      ),
    );
  }


  List<Widget> _appBarAction() {
    if (widget.mTitle.contains('Add')) {
      return <Widget>[
          
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(Icons.done),
              onPressed: () {
                if (_selectedFish == null) {
                  _showSnacBar("Please choose fish type");
                } else {
                  _insertToDatabase();
                }
                //Navigator.pop(scaffoldKey.currentContext);
              },
            ),
          ),
        ];
    } else {
      return <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: () {

              },
              child: Icon(
                Icons.delete,
                size: 26.0,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: () {

              },
              child: Icon(
                Icons.save,
                size: 26.0,
              ),
            ),
          ),
        ];
    }
  }

  void _showSnacBar(String mssg) {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(mssg),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _insertToDatabase() async {
    String imgPath = "";
    if (_imageFile != null) {
      imgPath = _imageFile.path;
    }
    Fish fish = Fish(title: _selectedFish, stock: _stockValue.toInt(), description: descTextController.text, img: imgPath);
    
    int rows = await DBHelper.instance.insert(fish);

    _showSnacBar(rows != 0 ? "Fish inserted" : "Fish could not be inserted");

    Navigator.pop(context);
    
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(widget.mTitle),
        actions: _appBarAction(),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
            child: Column(
            children: <Widget>[
              _stackImage(),
              SizedBox(height: 10),
              _dropDownFishType(),
              SizedBox(height: 30),
              _rowStock(),
              _sliderStock(),
              SizedBox(height: 30),
              _txtDescription(),
              
            ],
          ),
          ),
      ),
    );
  }
  
  @override
  void dispose() {
    descTextController.dispose();
    super.dispose();
  }
}