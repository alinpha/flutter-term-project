import 'package:flutter/material.dart';

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
  
  Widget _stackImage() {

    double _btnImgSize = 35.0;

    return Stack(
      children: <Widget>[
        Image(
          image: AssetImage('images/fish_template.jpg'),
        ),
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
                Navigator.pop(scaffoldKey.currentContext);
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
  
}