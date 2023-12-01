
import 'package:flutter/material.dart';
import 'package:twitter_clone/DB/User.dart';
import 'package:twitter_clone/DB/database_Helper.dart';

class EditProfilePage extends StatefulWidget {
  final User? currentUser;

  EditProfilePage({Key? key, required this.currentUser}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _userNameController;
  late TextEditingController _profileMessageController;
  late TextEditingController _genderController;
  late TextEditingController _birthdayController;
  late TextEditingController _passwordController; // 추가

  @override
  void initState() {
    super.initState();
    // 현재 사용자 정보로 초기화
    _userNameController = TextEditingController(text: widget.currentUser?.user_name ?? '');
    _profileMessageController = TextEditingController(text: widget.currentUser?.profile_message ?? ''); // 수정된 부분
    _genderController = TextEditingController(text: widget.currentUser?.gender ?? '');
    _birthdayController = TextEditingController(text: widget.currentUser?.birthday ?? '');
    _passwordController = TextEditingController(); // 초기화
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원 정보 수정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _userNameController,
              decoration: InputDecoration(labelText: '사용자 이름'),
            ),
            TextField(
              controller: _profileMessageController,
              decoration: InputDecoration(labelText: '프로필 메시지'),
            ),
            TextField(
              controller: _genderController,
              decoration: InputDecoration(labelText: '성별'),
            ),
            TextField(
              controller: _birthdayController,
              decoration: InputDecoration(labelText: '생년월일'),
            ),
            TextField(
              controller: _passwordController, // 새로 추가된 비밀번호 컨트롤러
              obscureText: true,
              decoration: InputDecoration(labelText: '비밀번호 (비워두면 기존 비밀번호 유지)'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _updateUserProfile();
              },
              child: Text('저장'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateUserProfile() async {
    String newPassword = _passwordController.text.isNotEmpty ? _passwordController.text : widget.currentUser?.password ?? '';

    // 수정된 정보로 사용자 객체 업데이트
    User updatedUser = User(
      user_id: widget.currentUser?.user_id,
      user_name: _userNameController.text,
      password: newPassword,
      profile_message: _profileMessageController.text,
      gender: _genderController.text,
      birthday: _birthdayController.text,
      followers_count: widget.currentUser?.followers_count,
      following_count: widget.currentUser?.following_count,
    );

    // 디비에 업데이트
    await DatabaseHelper.instance.updateUser(updatedUser);

    // 업데이트 완료 후 이전 화면으로 이동
    Navigator.pop(context, updatedUser);
  }
}