// 파일: follower_list_page.dart
import 'package:flutter/material.dart';
import 'package:twitter_clone/DB/User.dart';
import 'package:twitter_clone/DB/database_Helper.dart';
import 'package:twitter_clone/pages/Profile_page.dart'; // 해당 파일의 경로에 맞게 수정

class FollowerListPage extends StatelessWidget {
  final int? userId;

  FollowerListPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
      future: getFollowerList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('데이터를 불러오는 중 오류가 발생했습니다.');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: Text('팔로워 목록'),
            ),
            body: Center(
              child: Text('팔로워가 없습니다.'),
            ),
          );
        } else {
          List<User> followerList = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Text('팔로워 목록'),
            ),
            body: ListView.builder(
              itemCount: followerList.length,
              itemBuilder: (context, index) {
                User follower = followerList[index];
                return ListTile(
                  title: Text(follower.user_name),
                  onTap: () {
                    navigateToProfile(context, follower.user_name, follower.user_id);
                  },
                );
              },
            ),
          );
        }
      },
    );
  }

  Future<List<User>> getFollowerList() async {
    if (userId != null) {
      DatabaseHelper dbHelper = DatabaseHelper.instance;
      return dbHelper.getFollowerList(userId!);
    } else {
      // userId가 null이면 처리할 내용 추가
      return [];
    }
  }

  void navigateToProfile(BuildContext context, String userName, int? userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(
          currentUser: null, // 여기에 현재 사용자 정보를 전달하도록 수정
          user_name: userName,
          userId: userId ?? 0,
        ),
      ),
    );
  }
}
