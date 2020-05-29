import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:term_project/dbhelper.dart';

import 'model/fish.dart';

class EditPage extends StatefulWidget {

  final Fish mFish;

  EditPage({@required this.mFish});

  @override
  _EditPageState createState() => _EditPageState(mFish);
  
}

class _EditPageState extends State<EditPage> {

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  
  String _selectedFish;
  double _stockValue = 1;
  File _imageFile;
  TextEditingController _descTextController = TextEditingController();

  _EditPageState(Fish mFish) {
    _stockValue = mFish == null ? 1 : mFish.stock.toDouble();
    if (mFish != null) {
      _selectedFish = mFish.title;
      if (!mFish.img.contains('images/')) {
        _imageFile = File(mFish.img);
      }
    }
  }

  Future _getImage(ImageSource src) async {

    var image = await ImagePicker.pickImage(source: src);

    setState(() {
      _imageFile = image;
    });
  }
  
  String _fishImgFileName(String selectedFish) {
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

    return _fishImage;
  }

  Image _getImageWidget() {

    double screenWidth = MediaQuery.of(context).size.width;

    String _fishImage = _fishImgFileName(_selectedFish);

      return _imageFile == null ?
            Image(
              image: AssetImage(_fishImage),
              fit: BoxFit.fitWidth,
              width: screenWidth,
              height: 250,
            ) :
            Image.file(_imageFile, fit: BoxFit.fitWidth, width: screenWidth, height: 250);
  }

  Widget _stackImage() {

    double _btnImgSize = 35.0;

    return Stack(
      
      children: <Widget>[
        
        _getImageWidget(),
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

    List<String> _fishList = [
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
      controller: _descTextController,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Description',
      ),
    );
  }


  List<Widget> _appBarAction() {
    if (widget.mFish == null) {
      return <Widget>[
          
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(Icons.done),
              onPressed: () {
                if (_selectedFish == null) {
                  _showSnacBar1("Please choose fish type");
                } else {
                  _insertToDatabase();
                }
              },
            ),
          ),
        ];
    } else {
      return <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
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
            padding: EdgeInsets.only(right: 15.0),
            child: GestureDetector(
              onTap: () {
                _updateDatabase();
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

  void _showSnacBar1(String mssg) {
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
    } else {
      imgPath = _fishImgFileName(_selectedFish);
    }
    Fish fish = Fish(title: _selectedFish, stock: _stockValue.toInt(), description: _descTextController.text, img: imgPath);
    
    int rows = await DBHelper.instance.insert(fish);

    Navigator.pop(context, fish);
    
  }

  Future<void> _deleteFromDatabase() async {
    String imgPath = "";
    if (_imageFile != null) {
      imgPath = _imageFile.path;
    } else {
      imgPath = _fishImgFileName(_selectedFish);
    }
    Fish fish = Fish(title: _selectedFish, stock: _stockValue.toInt(), description: _descTextController.text, img: imgPath);
    
    int rows = await DBHelper.instance.insert(fish);

    Navigator.pop(context, fish);
    
  }

  Future<void> _updateDatabase() async {

    String imgPath = "";
    if (_imageFile != null) {
      imgPath = _imageFile.path;
    } else {
      imgPath = _fishImgFileName(_selectedFish);
    }

    widget.mFish.title = _selectedFish;
    widget.mFish.stock = _stockValue.toInt();
    widget.mFish.description = _descTextController.text;
    widget.mFish.img = imgPath;

    //Fish fish = Fish(title: _selectedFish, stock: _stockValue.toInt(), description: _descTextController.text, img: imgPath);
    
    //int rows = await DBHelper.instance.update(widget.mFish);

    //_showSnacBar(rows != 0 ? "Fish inserted" : "Fish could not be inserted");

    Navigator.pop(context, widget.mFish);
    
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(widget.mFish == null ? 'Add Fish' : 'Edit Fish'),
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
    _descTextController.dispose();
    super.dispose();
  }
}