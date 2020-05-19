import 'package:term_project/dbhelper.dart';

class Fish {

  int id;
  String title;
  int stock;
  String description;
  String img;

  Fish({this.id, this.title, this.stock, this.description, this.img});

  Fish.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    stock = map['stock'];
    description = map['description'];
    img = map['img'];
  }

  Map<String, dynamic> toMap() {
    return {
      DBHelper.ID:id,
      DBHelper.TITLE:title,
      DBHelper.STOCK:stock,
      DBHelper.DESCRIPTION:description,
      DBHelper.IMG:img
    };
  }
}