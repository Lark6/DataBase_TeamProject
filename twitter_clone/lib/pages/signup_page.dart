// signup_page.dart

import 'package:flutter/material.dart';
import 'package:twitter_clone/models/user.dart';
import 'package:twitter_clone/models/database_helper.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _realNameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: _realNameController,
              decoration: InputDecoration(labelText: 'Real Name'),
            ),
            TextField(
              controller: _genderController,
              decoration: InputDecoration(labelText: 'Gender'),
            ),
            TextField(
              controller: _birthdayController,
              decoration: InputDecoration(labelText: 'Birthday'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _handleSignUp(context);
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }

  // signup_page.dart

Future<void> _handleSignUp(BuildContext context) async {
  String username = _usernameController.text.trim();
  String password = _passwordController.text.trim();
  String realName = _realNameController.text.trim();
  String gender = _genderController.text.trim();
  String birthday = _birthdayController.text.trim();

  User newUser = User(
    username: username,
    password: password,
    realName: realName,
    gender: gender,
    birthday: birthday,
    followers: 0,
    following: 0,
    profileMessage: '',
  );

  DatabaseHelper dbHelper = DatabaseHelper.instance;
  int result = await dbHelper.insertUser(newUser);

  if (result > 0) {
    // 회원가입 성공
    // 여기에서 다음 화면으로 이동하거나 필요한 작업을 수행하세요.
    Navigator.pop(context); // 현재 화면을 닫음
  } else if (result == -1) {
    // 중복된 아이디
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('중복된 아이디'),
          content: Text('이미 사용 중인 아이디입니다. 다른 아이디를 시도해주세요.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  } else {
    // 회원가입 실패
    print('회원가입 실패');
  }
}

}
