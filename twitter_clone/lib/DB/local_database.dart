// local_database.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';


class LocalDatabase {
  static Future<Database> initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'my_local_database.db'),
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT,
            password TEXT
          )
        ''');
      },
    );
  }
  static Future<void> likePost(int postId) async {
    final Database db = await initDatabase();

    await db.rawUpdate('''
      UPDATE posts
      SET likes = likes + 1
      WHERE id = ?
    ''', [postId]);
  }

  static Future<void> unlikePost(int postId) async {
    final Database db = await initDatabase();

    await db.rawUpdate('''
      UPDATE posts
      SET likes = likes - 1
      WHERE id = ?
    ''', [postId]);
  }

  static Future<void> saveUserData(User user) async {
    final Database db = await initDatabase();
    await db.insert('users', user.toMap());
  }

  static Future<User?> getUserData(String username, String password) async {
    final Database db = await initDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    } else {
      return null;
    }
  }
}
