import 'dart:io';
import 'dart:ui';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:term_project/dbhelper.dart';
import './edit.dart';
import 'model/fish.dart';

// void main() => runApp(MaterialApp(
//   debugShowCheckedModeBanner: false,
//   home: MyApp(),
// ));

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  _HomePage createState() => _HomePage();
  
}

class _HomePage extends State<MyApp> {

    final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  final _pageController = PageController(initialPage: 0);
  final _currentPageNotifier = ValueNotifier<int>(0);

  List<Fish> fishList = List<Fish>();

    Future<void> _loadFish() async {
      print('load fish');
      final List<Map<String, dynamic>> maps = await DBHelper.instance.queryAll();
      fishList.clear();
     maps.forEach((map) => fishList.add(Fish.fromMap(map)));
      //print(fishList[0].img);
      setState(() {});
    }

    


  @override
  Widget build(BuildContext context) {

    _loadFish();

    Widget _title(String title) {
      return Container(
      padding: const EdgeInsets.all(20),
      child: Text(
        title,
        maxLines: 1,
        style: TextStyle(
          color: Colors.blue[900],
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),
      ),
    );
    }

    Widget _stock(int stock) {
      return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Text('In stock: $stock'),
    );
    }

    Widget _description(String description) {
      return Container(
        padding: const EdgeInsets.all(20),
       child: Text(description),
      );
    }

    Widget _image(Fish fish) {

      //print(fish.img);
      
      if (fish.img.contains('images/')) {

        return Image.asset(
                fish.img,
                width: MediaQuery.of(context).size.width,
                height: 250,
                fit: BoxFit.fitWidth,
              );
      }

      return Image.file(File(fish.img), width: MediaQuery.of(context).size.width, height: 250, fit: BoxFit.fitWidth,);
      
    }

    Widget _fishContainer(Fish fish) {
      return Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.white],
          ),
        ),
          child: Column(
            children: <Widget>[
              _image(fish),
              _title(fish.title),
              _stock(fish.stock),
              _description(fish.description),
            ],
          ),
        );
    }

    PageView mPageView = PageView.builder(
      itemCount: fishList.length,
      scrollDirection: Axis.horizontal,
      reverse: false,
      controller: _pageController,
      itemBuilder: (BuildContext ctx, int index) {
        return _fishContainer(fishList[index]);
      },
      onPageChanged: (int index) {
        _currentPageNotifier.value = index;
      },
    );

    Positioned indicators = Positioned(
      left: 0,
      right: 0,
      bottom: 10,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: CirclePageIndicator(
          itemCount: fishList.length,
          currentPageNotifier: _currentPageNotifier,
          size: 8.0,
          selectedSize: 8.0,
          selectedDotColor: Colors.blue,
          dotColor: Colors.blue[100],
        ),
      ),
    );

    Stack mStack = Stack(
      children: <Widget>[         
        mPageView,
        indicators,
      ],
    );

    Widget _noFish = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue, Colors.white],
        ),
      ),
      child: Center(
        child: Text('Tap + to add fish'),
      ),
    );

    List<Widget> _appBarActions() {
      if (fishList.length > 0) {
        return <Widget>[
            Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                _awaitReturnFromEditPage(context, fishList[_pageController.page.toInt()]);
              },
            ),
          )
        ];
      } else {
        return [];
      }
    }

    Scaffold _scaffold() {
    return Scaffold (
      key: scaffoldKey,
      appBar: AppBar(
          title: Text('Flutaquarium'),
          actions: _appBarActions(),
        ),
        body: fishList.length > 0 ? mStack : _noFish,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _awaitReturnFromEditPage(context, null);
          },
          child: Icon(Icons.add),
        ),
      );
  }


    return _scaffold();
  }

  void _showSnacBar(String mssg) {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(mssg),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  

  void _awaitReturnFromEditPage(BuildContext ctx, Fish fish) async {
    final result = await Navigator.push(context, MaterialPageRoute(
              builder: (context) => EditPage(mFish: fish),
            ));
    if (result != null) {

      if (result == "update") {//update made

        setState(() {
          _showSnacBar('Fish updated');
        });

      } else if (result == "insert") {//new fish added
        setState(() {
          
          _showSnacBar('Fish added');
        });
      } else {
        setState(() {
          
          _showSnacBar('Fish deleted');
        });
      }

    }
  }
}

