import 'dart:async';

import 'package:gkrd/model/goods_models.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart' as sql;

String path = "goods.db";
int? version = 2;
String tableName = "goodsitem";
var logger = Logger();

class SQLHelperGoods {
  //creating database table
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE goodsitem (
id INTEGER PRIMARY KEY,
name TEXT,
price REAL,
quantity INTEGER,
icon TEXT
createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
)
""");
  }

  //create the database
  static Future<sql.Database> db() async {
    return sql.openDatabase("goods.db", version: 1,
        onCreate: (sql.Database database, int version) async {
      logger.d("...creating the goods.db......");
      await createTables(database);
    });
  }

  //insert task to the Databases
  Future<int> createTask(GoodsItem items) async {
    logger.d("createGoodsItems Methods calls");
    final db = await SQLHelperGoods.db();
    return await db.insert("goodsitem", items.toMap());
  }

  //
  Future<List<GoodsItem>> getItems() async {
    final db = await SQLHelperGoods.db();
    final List<Map<String, dynamic>> maps = await db.query('goodsitem');
    return List.generate(maps.length, (i) {
      return GoodsItem(
        name: maps[i]['name'],
        price: maps[i]['price'],
        quantity: maps[i]['quantity'],
        icon: maps[i]['icon'],
      );
    });
  }

  //search with query
  // Add a method to search for items
  Future<List<GoodsItem>> searchItems(String query) async {
    final db = await SQLHelperGoods.db();
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT * FROM goodsitem WHERE name LIKE ?',
      ['%$query%'],
    );

    return List.generate(maps.length, (i) {
      return GoodsItem(
        name: maps[i]['name'],
        price: maps[i]['price'],
        quantity: maps[i]['quantity'],
        icon: maps[i]['icon'],
      );
    });
  }
}
