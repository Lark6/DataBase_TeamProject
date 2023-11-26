import 'package:flutter/material.dart';
import 'package:twitter_clone/DB/database_Helper.dart';
import 'package:twitter_clone/DB/user.dart';
import 'login_page.dart'; // 로그인 페이지를 import

class SignupPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _realNameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _birthController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원 가입'),
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
            TextField(
              controller: _realNameController,
              decoration: InputDecoration(labelText: '실명'),
            ),
            TextField(
              controller: _genderController,
              decoration: InputDecoration(labelText: '성별'),
            ),
            TextField(
              controller: _birthController,
              decoration: InputDecoration(labelText: '생년월일(XXXX.XX.XX'),
            ),
            SizedBox(height: 16.0),
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

  Future<void> _handleSignUp(BuildContext context) async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();
    String realName = _realNameController.text.trim();
    String gender = _genderController.text.trim();
    String birthday = _birthController.text.trim();

    if (username.isNotEmpty && password.isNotEmpty) {
      DatabaseHelper dbHelper = DatabaseHelper.instance;

      // 동일한 아이디로 가입이 불가능한 경우 체크
      bool isUserExist = await dbHelper.isUserExists(username);
      if (isUserExist) {
        // 동일한 아이디로 가입이 불가능한 경우
        _showAlertDialog(context, '회원 가입 실패', '이미 존재하는 아이디입니다. 다른 아이디를 사용해주세요.');
        return;
      }

      User newUser = User(
        username: username,
        password: password,
        profileMessage: '',
        gender: gender,
        birthday: '',
        followers: 0,
        following: 0,
      );

      int userId = await dbHelper.insertUser(newUser);

      if (userId > 0) {
        // 회원가입 성공
        // 여기에서 다음 화면으로 이동하거나 필요한 작업을 수행하세요.
        print('회원가입 성공: $username');
        _showAlertDialog(context, '회원 가입 성공', '회원 가입이 성공적으로 완료되었습니다.');

        // 회원가입 성공 후 초기 로그인 페이지로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        // 회원가입 실패
        _showAlertDialog(context, '회원 가입 실패', '회원 가입 중 오류가 발생했습니다.');
        print('회원가입 실패');
      }
    } else {
      // 아이디 또는 비밀번호가 비어있는 경우
      _showAlertDialog(context, '입력 오류', '아이디와 비밀번호를 모두 입력하세요.');
      print('아이디와 비밀번호를 모두 입력하세요.');
    }
  }

  void _showAlertDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }
}
