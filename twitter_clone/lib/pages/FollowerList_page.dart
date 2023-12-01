// FollowerListPage 클래스
import 'package:flutter/material.dart';
import 'package:twitter_clone/DB/database_Helper.dart';

import '../DB/User.dart';

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
          return Text('팔로워가 없습니다.');
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
      return dbHelper.getFollowerList(userId!); // 변경된 부분
    } else {
      // userId가 null이면 처리할 내용 추가
      return [];
    }
  }
}

// FollowingListPage 클래스
class FollowingListPage extends StatelessWidget {
  final int? userId;

  FollowingListPage({required this.userId});

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
          return Text('팔로잉한 사용자가 없습니다.');
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
      return dbHelper.getFollowingList(userId!); // 변경된 부분
    } else {
      // userId가 null이면 처리할 내용 추가
      return [];
    }
  }
}
