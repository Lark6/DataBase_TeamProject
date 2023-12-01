// main.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:twitter_clone/models/authmodel.dart';
import 'pages/login_page.dart';
import 'pages/main_page.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';


Future<String> getDatabasePath() async {
  // 앱의 디렉터리 가져오기
  Directory appDirectory = await getApplicationDocumentsDirectory();

  // 데이터베이스 파일 경로 반환
  return join(appDirectory.path, 'your_database.db');
}
void main() {
  // Initialize sqflite FFI before using it
  sqfliteFfiInit();

  // If using sqflite_common_ffi, set the databaseFactory to databaseFactoryFfi
  databaseFactory = databaseFactoryFfi;

void main() async {
  // Get the application documents directory.
  String path = await getDatabasePath();

  print('SQLite Database Path: $path');
  print(path);
  // Use the 'path' variable when opening the database.
  // ...
}


  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthModel(),
      child: MaterialApp(
        title: 'Flutter Twitter Clone',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authModel = Provider.of<AuthModel>(context);

    if (authModel.isLoggedIn) {
      return MainPage();
    } else {
      return LoginPage();
    }
  }
}
