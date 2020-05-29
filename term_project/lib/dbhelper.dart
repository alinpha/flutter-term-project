import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

import 'package:term_project/model/fish.dart';

class DBHelper {

  static final _dbName = 'fish_db.db';
  static final _dbVersion = 1;
  static const TABLE_NAME = 'fish_table';
  static const ID = 'id';
  static const TITLE = 'title';
  static const STOCK = 'stock';
  static const DESCRIPTION = 'description';
  static const IMG = 'img';

  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  _initDatabase() async {
    Directory docDir = await getApplicationDocumentsDirectory();
    String path = join(docDir.path, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int ver) async {
    await db.execute('''
      create table $TABLE_NAME (
        $ID integer primary key,
        $TITLE text not null,
        $STOCK integer not null,
        $DESCRIPTION text not null,
        $IMG text not null
      )
    ''');
  }

  static Database _db;
  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await _initDatabase();
    return _db;
  }

  Future<int> insert(Fish fish) async {
    Database db = await instance.db;
    return await db.insert(
      TABLE_NAME, 
      {
        TITLE:fish.title, 
        STOCK:fish.stock, 
        DESCRIPTION:fish.description,
        IMG:fish.img
      });
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await instance.db;
    return await db.query(TABLE_NAME);
  }

  // Future<List<Map<String, dynamic>>> queryByTitle(title) async {
  //   Database db = await instance.db;
  //   return await db.query(TABLE_NAME, where: "$TITLE like '%$title%'");
  // }

  // Future<int> update(Fish fish) async {
  //   Database db = await instance.db;
  //   String id = '';
  //   return await db.update(TABLE_NAME, fish.toMap(), where: '$ID=${id}');
  // }

  // Future<int> delete(int id) async {
  //   Database db = await instance.db;
  //   return await db.delete(TABLE_NAME, where: '$ID=$id');    
  // }
}