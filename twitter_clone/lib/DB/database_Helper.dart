// models/database_Helper.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:twitter_clone/DB/Follow.dart';
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
    String path = join(await getDatabasesPath(), 'test12.db'); //Use local DB file
    return await openDatabase
    (
      path,
      version: 1,
      onCreate: _createTable,
    );
  }

  Future<void> _createTable(Database db, int version) async //create table
  {
    await db.execute
    ('''
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

    await db.execute
    ('''
      CREATE TABLE Post (
        post_id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        post_content TEXT,
        post_time TEXT,
        FOREIGN KEY (user_id) REFERENCES users(user_id)
      )
    ''');

    await db.execute
    ('''
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

    await db.execute
    ('''
      CREATE TABLE Reply (
        reply_id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TNTEGER, 
        comment_id INTEGER,
        reply_content TEXT,
        FOREIGN KEY (comment_id) REFERENCES comments(comment_id),
        FOREIGN KEY (user_id) REFERENCES users(user_id)
      );
    ''');

    await db.execute
    ('''
      CREATE TABLE Follow (
        follower_id INTEGER,
        following_id INTEGER,
        PRIMARY KEY (follower_id, following_id),
        FOREIGN KEY (follower_id) REFERENCES users(id),
        FOREIGN KEY (following_id) REFERENCES users(id)
      );
    ''');

    await db.execute
    ('''
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

  Future<int> insertUser(User user) async //Sign in User
  {
    Database db = await instance.database;
    return await db.insert('User', user.toMap());
  }

  Future<User?> getLoginFactor(String user_name, String password) async //Get password, Id
  {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query
    (
      'User',
      where: 'user_name = ? AND password = ?',
      whereArgs: [user_name, password],
    );

    if (maps.isNotEmpty) //find user at DB
    {
      return User.fromMap(maps.first);
    } 
    else //fail to find
    {
      return null;
    }
  }

  Future<bool> isUserExists(String username) async //find who are existed
  {
    final Database db = await database;
    final List<Map<String, dynamic>> result = await db.query
    (
      'User',
      where: 'user_name = ?',
      whereArgs: [username],
    );

    return result.isNotEmpty;
  }

  Future<int> insertPost(Post post) async //insert post
  {
  Database db = await instance.database;
  return await db.insert('Post', post.toMap());
  }

  Future<User> getUserById(int userId) async //get User Id
  {
    final Database db = await database;
    List<Map<String, dynamic>> maps = await db.query
    (
      'User',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    if (maps.isNotEmpty) 
    {
      return User.fromMap(maps.first);
    } 
    else 
    {
      throw Exception('Can not find user who use this Id');
    }
  }

  Future<List<Map<String, dynamic>>> getPosts() async //get post with author using Join
  {
  Database db = await instance.database;

  // Join the Post and User tables to get the author's username together
  return await db.rawQuery
  ('''
    SELECT Post.*, User.user_name
    FROM Post
    JOIN User ON Post.user_id = User.user_id
    ORDER BY post_time DESC
  ''');
  }

  Future<List<Post>> fetchPosts() async 
  {
  List<Map<String, dynamic>> postMaps = await getPosts();

  List<Post> tweets = postMaps.map((postMap) 
  {
    return Post
    (
      post_id: postMap['post_id'],
      post_content: postMap['post_content'],
      post_time: DateTime.parse(postMap['post_time']),
      author: postMap['user_name'] ?? 'Unknown User', // 작성자의 유저네임 추가, null일 경우 'Unknown User'로 설정
    );
  }).toList();

  return tweets;
  }

  Future<List<User>> getFollowerList(int userId) async 
  {
  final Database db = await database;
  List<Map<String, dynamic>> maps = await db.rawQuery
  (
    '''
    SELECT User.*
    FROM User
    JOIN Follow ON Follow.follower_id = User.user_id
    WHERE Follow.following_id = ?
    ''',
    [userId],
  );

  return maps.map((map) => User.fromMap(map)).toList();
}

  Future<List<User>> getFollowingList(int userId) async 
  {
  final Database db = await database;
  List<Map<String, dynamic>> maps = await db.rawQuery
  (
    '''
    SELECT User.*
    FROM User
    JOIN Follow ON Follow.following_id = User.user_id
    WHERE Follow.follower_id = ?
    ''',
    [userId],
  );

  return maps.map((map) => User.fromMap(map)).toList();
}

  Future<User?> getAllUser(String user_name) async //get user all info data
  {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query
    (
      'User',
      where: 'user_name = ?',
      whereArgs: [user_name],
    );

    if (maps.isNotEmpty) 
    {
      return User.fromMap(maps.first);
    }
    else 
    {
      return null;
    }
  }

  // method for follow

  // Follow 추가
  Future<void> insertFollow(Follow follow) async {
    Database db = await instance.database;
    await db.insert('Follow', follow.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Follow 삭제
  Future<void> deleteFollow(int followerId, int followingId) async {
    Database db = await instance.database;
    await db.delete('Follow',
        where: 'follower_id = ? AND following_id = ?',
        whereArgs: [followerId, followingId]);
  }

  // 팔로우 여부 확인
  Future<bool> isFollowing(int followerId, int followingId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query('Follow',
        where: 'follower_id = ? AND following_id = ?',
        whereArgs: [followerId, followingId]);

    return result.isNotEmpty;
  }

  // 팔로워 수 가져오기
  Future<int> getFollowerCount(int userId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query('Follow',
        where: 'following_id = ?', whereArgs: [userId]);

    return result.length;
  }

  // 팔로잉 수 가져오기
  Future<int> getFollowingCount(int userId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query('Follow',
        where: 'follower_id = ?', whereArgs: [userId]);

    return result.length;
  }

  Future<void> updateUser(User user) async {
    Database db = await instance.database;

    await db.update(
      'User',
      user.toMap(),
      where: 'user_id = ?',
      whereArgs: [user.user_id],
    );
  }




  // add other methods
}
