// models/database_Helper.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:twitter_clone/DB/Post.dart';
import 'package:twitter_clone/DB/User.dart';

class DatabaseHelper 
{
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async 
  {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async 
  {
    String path = join(await getDatabasesPath(), 'your_database_name.db'); //로컬 데이터 베이스 파일 이용
    return await openDatabase
    (
      path,
      version: 1,
      onCreate: _createTable,
    );
  }

  Future<void> _createTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE User (
        user_id INTEGER PRIMARY KEY AUTOINCREMENT,
        password TEXT NOT NULL,
        user_name TEXT NOT NULL,
        profile_message TEXT,
        gender TEXT,
        birthday TEXT,
        followers_count INTEGER,
        following_count INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE Post (
        post_id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        post_content TEXT,
        post_time TEXT,
        FOREIGN KEY (user_id) REFERENCES users(user_id)
      )
    ''');

    await db.execute('''
      CREATE TABLE Comment (
        comment_id INTEGER PRIMARY KEY AUTOINCREMENT,
        post_id INTEGER,
        user_id INTEGER,
        comment_content TEXT,
        comment_time TEXT,
        FOREIGN KEY (post_id) REFERENCES posts(post_id),
        FOREIGN KEY (user_id) REFERENCES users(user_id)
      );
    ''');

    await db.execute('''
      CREATE TABLE Reply (
        reply_id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TNTEGER, 
        comment_id INTEGER,
        reply_content TEXT,
        FOREIGN KEY (comment_id) REFERENCES comments(comment_id),
        FOREIGN KEY (user_id) REFERENCES users(user_id)
      );
    ''');

    await db.execute('''
      CREATE TABLE Follow (
        follower_id INTEGER,
        following_id INTEGER,
        PRIMARY KEY (follower_id, following_id),
        FOREIGN KEY (follower_id) REFERENCES users(id),
        FOREIGN KEY (following_id) REFERENCES users(id)
);

    ''');

    await db.execute('''
      CREATE TABLE Like (
        post_id INTEGER,
        user_id INTEGER,
        like_count INTEGER,
        PRIMARY KEY (post_id, user_id),
        FOREIGN KEY (post_id) REFERENCES posts(post_id),
        FOREIGN KEY (user_id) REFERENCES users(id)
      );
    ''');

  }

  Future<int> insertUser(User user) async {
    Database db = await instance.database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> getUser(String username, String password) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (maps.isNotEmpty) {
      // 데이터베이스에서 사용자를 찾은 경우
      return User.fromMap(maps.first);
    } else {
      // 사용자를 찾지 못한 경우
      return null;
    }
  }

  Future<bool> isUserExists(String username) async {
    final Database db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );

    return result.isNotEmpty;
  }


  Future<int> insertPost(Post post) async {
  Database db = await instance.database;
  post.createdAt = DateTime.now().toUtc().toIso8601String(); // 현재 타임스탬프 설정
  return await db.insert('posts', post.toMap());
  }


  // getUserById 메소드 추가
  Future<User> getUserById(int userId) async {
  final Database db = await database;
  List<Map<String, dynamic>> maps = await db.query(
    'users',
    where: 'id = ?',
    whereArgs: [userId],
  );

  if (maps.isNotEmpty) {
    return User.fromMap(maps.first);
  } else {
    // 사용자를 찾지 못한 경우에 대한 처리
    throw Exception('해당 ID의 사용자를 찾을 수 없습니다.');
  }
}
  // ... (다른 메소드들)
}
