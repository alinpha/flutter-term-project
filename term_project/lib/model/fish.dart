class Fish {

  String title;
  int stock;
  String description;

  Fish({this.title, this.stock, this.description});

  Fish.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    stock = json['stock'];
    description = json['description'];
  }
}