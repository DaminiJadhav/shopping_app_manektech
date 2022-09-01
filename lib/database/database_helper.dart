import 'package:shopping_app_manektech/model/my_card.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "carddb.db";
  static final _databaseVersion = 1;

  static final table = 'card_table';
  static final columnId = 'id';
  static final columnName = 'productName';
  static final columnImage = 'productImage';
  static final columnPrice = 'price';
  static final columnQuatity = 'quatity';


  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
   Database ?_database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnName TEXT NOT NULL,
            $columnImage TEXT NOT NULL,
            $columnPrice INTEGER,
            $columnQuatity INTEGER
          )
          ''');
  }


  Future<int> insert(MyCard myCard) async {
    Database? db = await instance.database;
    return await db!.insert(table, {'productName': myCard.productName, 'productImage': myCard.productImage,'price': myCard.price,'quatity': myCard.quatity});
  }


  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database? db = await instance.database;
    return await db!.query(table);
  }

  Future<List<Map<String, dynamic>>> queryRows(name) async {
    Database? db = await instance.database;
    return await db!.query(table, where: "$columnName LIKE '%$name%'");
  }

  Future<int?> queryRowCount() async {
    Database? db = await instance.database;
    return Sqflite.firstIntValue(await db!.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<int> update(MyCard myCard) async {
    Database ?db = await instance.database;
    int id = myCard.toMap()['id'];
    return await db!.update(table, myCard.toMap(), where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database? db = await instance.database;
    return await db!.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }


}