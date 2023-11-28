// pages/login_page.dart

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:twitter_clone/DB/database_Helper.dart';
import 'package:twitter_clone/DB/User.dart';
import 'signup_page.dart';
import 'main_page.dart'; // 메인페이지 import

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
    print('로그인 성공: ${user.user_name}');
    WidgetsFlutterBinding.ensureInitialized();
    final directory = await getApplicationDocumentsDirectory();
    print(directory.path);

    // 메인페이지로 이동하면서 사용자 정보 전달
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MainPage(currentUser: user),
      ),
    );
  }else {
      // 로그인 실패
      // 경고창 표시
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('로그인 실패'),
            content: Text('아이디 또는 비밀번호가 올바르지 않습니다.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 경고창 닫기
                },
                child: Text('확인'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _handleSignUp(BuildContext context) async {
    
    // 회원 가입 버튼을 누를 때, 회원 가입 페이지로 이동
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignupPage()),
    );
    
  }
}
