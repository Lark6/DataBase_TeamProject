// pages/login_page.dart

import 'package:flutter/material.dart';
import 'package:twitter_clone/models/user.dart';

import '../models/database_Helper.dart';


class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: '아이디'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: '비밀번호'),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _handleLogin(context);
              },
              child: Text('로그인'),
            ),
            ElevatedButton(
              onPressed: () {
                _handleSignUp(context);
              },
              child: Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogin(BuildContext context) async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    DatabaseHelper dbHelper = DatabaseHelper.instance;
    User? user = await dbHelper.getUser(username, password);

    if (user != null) {
      // 로그인 성공
      // 여기에서 다음 화면으로 이동하거나 필요한 작업을 수행하세요.
      print('로그인 성공: ${user.username}');
    } else {
      // 로그인 실패
      print('로그인 실패');
    }
  }

  Future<void> _handleSignUp(BuildContext context) async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    User newUser = User(username: username, password: password, realName: '', profileMessage: '', gender: '', birthday: '', followers:0 , following:0 );
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    int userId = await dbHelper.insertUser(newUser);

    if (userId > 0) {
      // 회원가입 성공
      // 여기에서 다음 화면으로 이동하거나 필요한 작업을 수행하세요.
      print('회원가입 성공: $username');
    } else {
      // 회원가입 실패
      print('회원가입 실패');
    }
  }
}
