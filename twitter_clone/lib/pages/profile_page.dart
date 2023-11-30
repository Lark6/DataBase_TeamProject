
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String user_name;

  ProfilePage({required this.user_name});

  @override
  Widget build(BuildContext context) {
    // 사용자의 세부 정보를 사용자 이름을 통해 가져와 이 페이지에 표시할 수 있습니다.
    return Scaffold(
      appBar: AppBar(
        title: Text('프로필: $user_name'),
      ),
      body: Center(
        child: Text('$user_name 님의 프로필 세부 정보'),
      ),
    );
  }
}