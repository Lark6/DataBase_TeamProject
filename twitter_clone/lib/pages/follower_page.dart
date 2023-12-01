// 파일: follower_list_page.dart
// import 'package:flutter/material.dart';
// import 'package:twitter_clone/DB/User.dart';
// import 'package:twitter_clone/DB/database_Helper.dart';

// class FollowerListPage extends StatelessWidget {
//   final int userId;

//   FollowerListPage({required this.userId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('팔로워 목록'),
//       ),
//       body: FutureBuilder<List<User>>(
//         future: getFollowers(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return CircularProgressIndicator();
//           } else if (snapshot.hasError) {
//             return Text('데이터를 불러오는 중 오류가 발생했습니다.');
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Text('팔로워가 없습니다.');
//           } else {
//             List<User> followers = snapshot.data!;

//             return ListView.builder(
//               itemCount: followers.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(followers[index].user_name),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }

//   Future<List<User>> getFollowers() async {
//     final List<Map<String, dynamic>> followersData = await DatabaseHelper.instance.getFollowers(userId);

//     return followersData.map((followerMap) => User.fromMap(followerMap)).toList();
//   }
// }
