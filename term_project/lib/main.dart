import 'package:flutter/material.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import './edit.dart';
import 'model/fish.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutaquarium',
      theme: ThemeData(
        
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {

  final _pageController = PageController(initialPage: 0);
  final _currentPageNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {

    List<Fish> fishList = List<Fish>();

    fishList.add(
      Fish(
        id: 1, 
        title: 'goldfish', 
        stock: 5, 
        description: 'lorem iprum dolor',
        img: 'gold')
    );

    fishList.add(
      Fish(
        id: 2, 
        title: 'killifish', 
        stock: 2, 
        description: 'this is a description',
        img: 'loach')
    );

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

    Widget _image(String img) {
      return Image.asset(
                'images/$img.jpg',
                width: 600,
                height: 240,
                fit: BoxFit.fill,
              );
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
              _image(fish.img),
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

    return Scaffold (
      
      appBar: AppBar(
          title: Text('Flutaquarium'),
        ),
        body: mStack,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => EditPage(mTitle: 'Add New Fish',)));
          },
          child: Icon(Icons.add),
        ),
    );
  }
}

