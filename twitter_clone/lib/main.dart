// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_clone/models/authmodel.dart';
import 'pages/login_page.dart';
import 'pages/main_page.dart';

void main() {
  
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
