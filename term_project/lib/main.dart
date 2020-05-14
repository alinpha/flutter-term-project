import 'package:flutter/material.dart';
import './edit.dart';

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

  @override
  Widget build(BuildContext context) {


    Widget title = Container(
      padding: const EdgeInsets.all(20),
      child: Text(
        'Fish type title',
        maxLines: 1,
        style: TextStyle(
          color: Colors.blue[900],
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),
      ),
    );

    Widget stock = Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Text('In stock: 7'),
    );

    Widget description = Container(
      padding: const EdgeInsets.all(20),
      child: Text('Fish are gill-bearing aquatic craniate animals that lack limbs with digits. They form a sister group to the tunicates, together forming the olfactores.'),
    );

    return Scaffold (
      
      appBar: AppBar(
          title: Text('Flutaquarium'),
        ),
        body: Container(
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
              Image.asset(
                'images/fish_template.jpg',
                width: 600,
                height: 240,
                fit: BoxFit.fill,
              ),
              title,
              stock,
              description,
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => EditPage(mTitle: 'Add New Fish',)));
          },
          child: Icon(Icons.add),
        ),
    );
  }
}