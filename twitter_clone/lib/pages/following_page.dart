
// // 파일: following_list_page.dart
// import 'package:flutter/material.dart';
// import 'package:twitter_clone/DB/User.dart';
// import 'package:twitter_clone/DB/database_Helper.dart';

// class FollowingListPage extends StatelessWidget {
//   final int userId;

//   FollowingListPage({required this.userId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('팔로잉 목록'),
//       ),
//       body: FutureBuilder<List<User>>(
//         future: getFollowing(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return CircularProgressIndicator();
//           } else if (snapshot.hasError) {
//             return Text('데이터를 불러오는 중 오류가 발생했습니다.');
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Text('팔로잉이 없습니다.');
//           } else {
//             List<User> following = snapshot.data!;

//             return ListView.builder(
//               itemCount: following.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(following[index].user_name),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }

//   Future<List<User>> getFollowing() async {
//     final List<Map<String, dynamic>> followingData = await DatabaseHelper.instance.getFollowing(userId);

//     return followingData.map((followingMap) => User.fromMap(followingMap)).toList();
//   }
// }
