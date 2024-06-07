import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper
      .internal(); // DatabaseHelper sınıfını tek bir örnekle sınırla

  factory DatabaseHelper() => _instance; // Singleton deseniyle örnek al

  static Database? _db; // SQLite veritabanı nesnesini sakla
  static int? loggedInUserId;
  Future<Database?> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal(); // Özel bir kurucu fonksiyon kullanarak sınıfın dışarıdan oluşturulmasını engelle

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'expense_tracker.db');
    var db = await openDatabase(path, version: 2, onCreate: _onCreate);
    return db;
  }

// Veritabanı oluşturma fonksiyonu

  void _onCreate(Database db, int newVersion) async {
    //User tablosu oluşturuldu
    await db.execute(
        'CREATE TABLE User(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT UNIQUE, password TEXT)');
    //Expence tablosu oluşturuldu
    await db.execute(
        '''CREATE TABLE Expense(id INTEGER PRIMARY KEY AUTOINCREMENT, userId INTEGER, 
        category TEXT, description TEXT, amount REAL, type TEXT, date TEXT,
        FOREIGN KEY (userId) REFERENCES User(id) ON DELETE CASCADE)''');
  }

  Future<bool> authenticate(Map<String, dynamic> row) async {
    Database? dbClient = await db;
    var res = await dbClient?.rawQuery(
        "SELECT * FROM User WHERE email = '${row['email']}' AND password = '${row['password']}'");
    if (res!.isNotEmpty) {
      loggedInUserId = res.first['id'] as int?;
      return true;
    } else {
      return false;
    }
  }

  Future<bool> createUser(Map<String, dynamic> row, String email) async {
    Database? dbClient = await db;
    var res =
        await dbClient?.rawQuery("SELECT * FROM User WHERE email = '$email'");
    if (res!.isNotEmpty) {
      return false;
    } else {
      await dbClient!.insert('User', row);
      loggedInUserId = res.first['id'] as int?;
      return true;
    }
  }

  static void logout() {
    loggedInUserId = null; // loggedInUserId değişkeninin değerini sıfırla
  }

  Future<String?> getLoggedinUserName() async {
    // Eğer bir kullanıcı oturum açmışsa
    if (loggedInUserId != null) {
      Database? dbClient = await db;
      var res = await dbClient
          ?.rawQuery("SELECT name FROM User WHERE id = $loggedInUserId");
      if (res != null && res.isNotEmpty) {
        return res.first['name'] as String?;
      } else {
        return null; // Kullanıcı bulunamadıysa null döndür
      }
    } else {
      return null; // Eğer oturum açan kullanıcı yoksa null döndür
    }
  }

  Future<String?> getLoggedinEmail() async {
    // Eğer bir kullanıcı oturum açmışsa
    if (loggedInUserId != null) {
      Database? dbClient = await db;
      var res = await dbClient
          ?.rawQuery("SELECT email FROM User WHERE id = $loggedInUserId");
      if (res != null && res.isNotEmpty) {
        return res.first['email'] as String?;
      } else {
        return null; // Kullanıcı bulunamadıysa null döndür
      }
    } else {
      return null; // Eğer oturum açan kullanıcı yoksa null döndür
    }
  }

  Future<bool> insertExpence(Map<String, dynamic> row) async {
    Database? dbClient = await db;

    if (dbClient != null) {
      await dbClient.insert('Expense', row);
      return true;
    }
    return false;
  }

  Future<List<Map<String, dynamic>>> getUserExpenses(int userId) async {
    Database? dbClient = await db;
    if (dbClient != null) {
      List<Map<String, dynamic>> result = await dbClient.query(
        'Expense',
        where: 'userId = ?',
        whereArgs: [userId],
      );
      return result;
    } else {
      // Handle the error appropriately
      //print("Error: Database connection failed.");
      return [];
    }
  }

  Future<double?> income() async {
    Database? dbClient = await db;

    if (dbClient != null) {
      final List<Map<String, dynamic>> result = await dbClient.rawQuery(
          "SELECT SUM(amount) AS totalIncome FROM Expense WHERE type = 'Income' AND userId = '$loggedInUserId' ;");
      final double totalIncome =
          result.isNotEmpty ? result.first['totalIncome'] : 0.0;
      return totalIncome;
    }
    return 0.0;
  }

  Future<double?> expand() async {
    Database? dbClient = await db;

    if (dbClient != null) {
      final List<Map<String, dynamic>> result = await dbClient.rawQuery(
          "SELECT SUM(amount) AS totalIncome FROM Expense WHERE type = 'Expand' AND userId = '$loggedInUserId' ;");
      final double totalIncome =
          result.isNotEmpty ? result.first['totalIncome'] : 0.0;
      return totalIncome;
    }
    return 0.0;
  }
}
