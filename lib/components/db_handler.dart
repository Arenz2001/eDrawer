//import 'dart:html';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import '../constants/model.dart';

class DBHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return null;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'edrawer.db');
    var db = await openDatabase(path, version: 1, onCreate: _createDatabase);
    return db;
  }

  _createDatabase(Database db, int version) async {
    await db.execute(
      "CREATE TABLE myfolder(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, folder_color STRING)",
    );
    await db.execute(
      "CREATE TABLE myfile(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, doc_path STRING, doc_color STRING, folder_id INTEGER)",
    );
  }

//Folder methods

  Future<DossierModel> insertFolder(DossierModel dossierModel) async {
    var dbClient = await db;
    await dbClient?.insert('myfolder', dossierModel.toMap());
    return dossierModel;
  }

  Future<List<DossierModel>> getDataListFolder() async {
    await db;
    final List<Map<String, Object?>> QueryResult = await _db!.rawQuery('SELECT * FROM myfolder');
    return QueryResult.map((e) => DossierModel.fromMap(e)).toList();
  }

  Future<int> deleteFolder(int id) async {
    var dbClient = await db;
    dbClient!.delete('myfile', where: 'folder_id = ?', whereArgs: [id]);
    return await dbClient.delete('myfolder', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateFolder(DossierModel dossierModel) async {
    var dbClient = await db;
    return await dbClient!.update('myfolder', dossierModel.toMap(), where: 'id = ?', whereArgs: [dossierModel.id]);
  }

  //File methods

  Future<DocModel> insertDoc(DocModel docModel) async {
    var dbClient = await db;
    await dbClient?.insert('myfile', docModel.toMap());
    return docModel;
  }

  Future<List<DocModel>> getDoc(int? file_id) async {
    await db;
    final List<Map<String, Object?>> QueryResult =
        await _db!.rawQuery("SELECT * FROM myfile WHERE ',' || doc_path || ',' LIKE '%,' || ? || ',%'", ["$file_id"]);
    return QueryResult.map((e) => DocModel.fromMap(e)).toList();
  }

  Future<List<DocModel>> getDataListDoc(int? folder_id) async {
    await db;
    //int folder_id = folder_id;
    final List<Map<String, Object?>> QueryResult = await _db!
        .rawQuery("SELECT * FROM myfile WHERE ',' || folder_id || ',' LIKE '%,' || ? || ',%' ORDER BY title COLLATE NOCASE ASC", ["$folder_id"]);
    return QueryResult.map((e) => DocModel.fromMap(e)).toList();
  }

  Future<List<DocModel>> getDataListDoc2() async {
    await db;
    //int folder_id = folder_id;
    final List<Map<String, Object?>> QueryResult = await _db!.rawQuery('SELECT * FROM myfile');
    return QueryResult.map((e) => DocModel.fromMap(e)).toList();
  }

  Future<int> deleteDoc(int id) async {
    var dbClient = await db;
    return await dbClient!.delete('myfile', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateDoc(DocModel docModel) async {
    var dbClient = await db;
    return await dbClient!.update('myfile', docModel.toMap(), where: 'id = ?', whereArgs: [docModel.id]);
  }
}
