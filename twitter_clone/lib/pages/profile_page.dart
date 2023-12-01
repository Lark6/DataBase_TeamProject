import 'package:flutter/material.dart';
import 'package:twitter_clone/DB/Follow.dart';
import 'package:twitter_clone/DB/User.dart';
import 'package:twitter_clone/DB/database_Helper.dart';
import 'package:twitter_clone/models/authmodel.dart';
import 'package:twitter_clone/pages/EditProflle_page.dart';
import 'package:twitter_clone/pages/FollowerList_page.dart';

class ProfilePage extends StatelessWidget with ChangeNotifier {
  final String user_name;
  final User? currentUser;
  final int userId; // userId 매개변수 추가

  ProfilePage({required this.currentUser, required this.user_name, required this.userId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('데이터를 불러오는 중 오류가 발생했습니다.');
        } else if (!snapshot.hasData) {
          return Text('사용자 데이터를 찾을 수 없습니다.');
        } else {
          User user = snapshot.data!;
          bool isCurrentUserProfile = isCurrentUserLogic(currentUser, user);

          return Scaffold(
            appBar: AppBar(
              title: Text('프로필: ${user.user_name}'),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text('유저 정보: ${user.user_name}'),
                ),
                ListTile(
                  title: Text('프로필 메시지: ${user.profile_message ?? '없음'}'),
                ),
                ListTile(
                  title: Text('팔로워 수: ${user.followers_count ?? 0}'),
                  onTap: () {
                    //navigateToFollowerList(context, user.user_id);
                  },
                ),
                ListTile(
                  title: Text('팔로잉 수: ${user.following_count ?? 0}'),
                  onTap: () {
                    //navigateToFollowingList(context, user.user_id);
                  },
                ),
                ListTile(
                  title: Text('성별: ${user.gender}'),
                ),
                ListTile(
                  title: Text('생년월일: ${user.birthday}'),
                ),
                if (isCurrentUserProfile)
                  ElevatedButton(
                    onPressed: () {
                      if (isCurrentUserProfile) {
                        // 현재 사용자와 프로필의 사용자가 동일한 경우 회원 정보 수정 창으로 이동
                        _navigateToEditProfile(context);
                        refreshProfile();
                      } else {
                        // 다른 사용자의 프로필인 경우 팔로우 또는 언팔로우 로직 수행
                        followUnfollowLogic(currentUser, user);
                      }
                    },
                    child: Text(isCurrentUserProfile ? '회원 정보 수정' : (isFollowing ? '언팔로우' : '팔로우')),
                  ),
              ],
            ),
          );
        }
      },
    );
  }

  void refreshProfile() {
    notifyListeners();
  }

  bool get isFollowing {
    return currentUser?.followingList.contains(currentUser?.user_id) ?? false;
  }

  bool isCurrentUserLogic(User? currentUser, User profileUser) {
    print(currentUser?.user_id);
    return currentUser != null && currentUser.user_id == profileUser.user_id;
  }

  void followUnfollowLogic(User? currentUser, User profileUser) {
    if (isFollowing) {
      unfollowUser(currentUser!, profileUser);
    } else {
      followUser(currentUser!, profileUser);
    }
  }

  Future<void> followUser(User currentUser, User profileUser) async {
    Follow follow = Follow(
      followId: 0,
      followerId: currentUser.user_id!,
      followingId: profileUser.user_id!,
    );

    await DatabaseHelper.instance.insertFollow(follow);

    currentUser.following_count = (currentUser.following_count ?? 0) + 1;
    DatabaseHelper.instance.updateUser(currentUser);

    notifyListeners();
  }

  Future<void> unfollowUser(User currentUser, User profileUser) async {
    await DatabaseHelper.instance.deleteFollow(
      currentUser.user_id!,
      profileUser.user_id!,
    );

    currentUser.following_count = (currentUser.following_count ?? 0) - 1;
    DatabaseHelper.instance.updateUser(currentUser);

    notifyListeners();
  }

  Future<User?> getUserData() async {
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    return dbHelper.getAllUser(user_name);
  }

  void navigateToFollowerList(BuildContext context, int userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FollowerListPage(userId: userId),
      ),
    );
  }

  void navigateToFollowingList(BuildContext context, int userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FollowingListPage(userId: userId),
      ),
    );
  }

  void _navigateToEditProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(currentUser: currentUser),
      ),
    );
  }


}


