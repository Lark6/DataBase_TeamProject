// 파일: following_list_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_clone/DB/User.dart';
import 'package:twitter_clone/DB/database_Helper.dart';
import 'package:twitter_clone/models/authmodel.dart';
import 'package:twitter_clone/pages/profile_page.dart'; // 해당 파일의 경로에 맞게 수정

class FollowingListPage extends StatelessWidget {
  final int? userId;
  final User? currentUser; // currentUser 파라미터 추가

  FollowingListPage({required this.userId, this.currentUser});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
      future: getFollowingList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('데이터를 불러오는 중 오류가 발생했습니다.');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: Text('팔로잉 목록'),
            ),
            body: Center(
              child: Text('팔로잉한 사용자가 없습니다.'),
            ),
          );
        } else {
          List<User> followingList = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Text('팔로잉 목록'),
            ),
            body: ListView.builder(
              itemCount: followingList.length,
              itemBuilder: (context, index) {
                User followingUser = followingList[index];
                return ListTile(
                  title: Text(followingUser.user_name),
                  onTap: () {
                    navigateToProfile(
                      context,
                      followingUser.user_name,
                      followingUser.user_id,
                      currentUser: currentUser, // currentUser를 navigateToProfile에 전달
                    );
                  },
                );
              },
            ),
          );
        }
      },
    );
  }

  Future<List<User>> getFollowingList() async {
    if (userId != null) {
      DatabaseHelper dbHelper = DatabaseHelper.instance;
      return dbHelper.getFollowingList(userId!);
    } else {
      // userId가 null이면 처리할 내용 추가
      return [];
    }
  }

  void navigateToProfile(BuildContext context, String userName, int? userId, {User? currentUser}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ProfilePage(
        currentUser: currentUser,
        user_name: userName,
        userId: userId ?? 0,
      ),
    ),
  );
}

}
