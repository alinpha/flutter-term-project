import 'dart:io';
import 'dart:ui';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:term_project/dbhelper.dart';
import './edit.dart';
import 'model/fish.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  home: MyApp(),
));

class MyApp extends StatefulWidget {
  _HomePage createState() => _HomePage();
  
}

class _HomePage extends State<MyApp> {

  final _pageController = PageController(initialPage: 0);
  final _currentPageNotifier = ValueNotifier<int>(0);


  @override
  Widget build(BuildContext context) {

    List<Fish> fishList = List<Fish>();

    void _loadFish() async {
      final List<Map<String, dynamic>> maps = await DBHelper.instance.queryAll();
      fishList.clear();
      maps.forEach((map) => fishList.add(Fish.fromMap(map)));
    }

    // fishList.add(
    //   Fish(
    //     id: 1, 
    //     title: 'goldfish', 
    //     stock: 5, 
    //     description: 'lorem iprum dolor',
    //     img: 'gold')
    // );

    // fishList.add(
    //   Fish(
    //     id: 2, 
    //     title: 'killifish', 
    //     stock: 2, 
    //     description: 'this is a description',
    //     img: 'loach')
    // );

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
      
      

      if (fish.img == "") {

        String _fishImage = "";

        switch (fish.title) {
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

        return Image.asset(
                _fishImage,
                width: 600,
                height: 240,
                fit: BoxFit.fill,
              );
      }

      return Image.file(File(fish.img));
      
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

    return Scaffold (
      
      appBar: AppBar(
          title: Text('Flutaquarium'),
        ),
        body: fishList.length > 0 ? mStack : _noFish,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => EditPage(mTitle: 'Add New Fish')))
            .then((value) {
              setState(() {
                _loadFish();
              });
            });
          },
          child: Icon(Icons.add),
        ),
      );
  }
}

