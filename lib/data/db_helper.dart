//DATAbase funtioncs
/*import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'trip_item.dart';

class DatabaseHelper {
  static const _databaseName = "todo_database.db";
  static const _databaseVersion = 1;

  static const table = "todos";
// tutki static
  static const columnId = "id";
  static const columnTitle = "title";
  static const columnDescription = "description";
  static const columnDate = "date";


  DatabaseHelper._privateConstructor(); // !!!!!
  static final DatabaseHelper _instance = DatabaseHelper._privateConstructor();
  static DatabaseHelper get instance =>
      _instance; // tarkista, on vain yksi instance samaan aikaan??

  late Database _db;

  Future<void> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);

    //deleteDatabase(path);
    _db = await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate); // tarkista
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(// hipsut?
        """
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY,
        $columnTitle TEXT NOT NULL,
        $columnDescription TEXT,
        $columnDeadline INTEGER NOT NULL,
        $columnDone INTEGER NOT NULL)""");
  }

  Future<int> insert(TripItem item) async {
    return await _db.insert(table, item.toMap());
  }

  Future<int> delete(int id) async {
    return await _db.delete(table, where: "$columnId = ?", whereArgs: [id]);
  }

  Future<int> update(TripItem item) async {
    // tarkista
    return await _db.update(table, item.toMap(),
        where: "$columnId = ?", whereArgs: [item.id]);
  }

  Future<List<TripItem>> queryAllRows() async {
    final List<Map<String, dynamic>> maps = await _db.query(table);

    return List.generate(maps.length, (index) {
      return TripItem(
          id: maps[index]["id"],
          title: maps[index]["title"],
          description: maps[index]["description"],
          date: DateTime.fromMillisecondsSinceEpoch(maps[index]["deadline"]));
    });
  }
}*/
