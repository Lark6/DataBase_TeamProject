import 'package:flutter/material.dart';
import 'package:twitter_clone/DB/Follow.dart';
import 'package:twitter_clone/DB/User.dart';
import 'package:twitter_clone/DB/database_Helper.dart';
import 'package:twitter_clone/pages/EditProflle_page.dart';
import 'package:twitter_clone/pages/follower_page.dart';
import 'package:twitter_clone/pages/following_page.dart';



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
                  title: FutureBuilder<int>(
                    // 팔로워 수 가져오기
                    future: getFollowerCount(user.user_id ?? 0),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('에러 발생: ${snapshot.error}');
                      } else {
                        int followerCount = snapshot.data ?? 0;
                        return Text('팔로워 수: $followerCount');
                      }
                    },
                  ),
                  onTap: () {
                    navigateToFollowerList(context, user.user_id ?? 0);
                  },
                ),
                ListTile(
                  title: FutureBuilder<int>(
                    // 팔로잉 수 가져오기
                    future: getFollowingCount(user.user_id ?? 0),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('에러 발생: ${snapshot.error}');
                      } else {
                        int followingCount = snapshot.data ?? 0;
                        return Text('팔로잉 수: $followingCount');
                      }
                    },
                  ),
                  onTap: () {
                    navigateToFollowingList(context, user.user_id ?? 0);
                  },
                ),
                ListTile(
                  title: Text('성별: ${user.gender}'),
                ),
                ListTile(
                  title: Text('생년월일: ${user.birthday}'),
                ),
                if (!isCurrentUserProfile) // 현재 사용자와 프로필 사용자가 다를 때만 버튼 표시
                  FutureBuilder<bool>(
                    // 팔로우 여부 확인
                    future: checkFollowingStatus(currentUser?.user_id ?? 0, user.user_id ?? 0),
                    builder: (context, followingSnapshot) {
                      if (followingSnapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (followingSnapshot.hasError) {
                        return Text('팔로우 정보를 확인하는 중 오류가 발생했습니다.');
                      } else {
                        bool isFollowing = followingSnapshot.data ?? false;
                        return ElevatedButton(
                          onPressed: () async {
                            if (isFollowing) {
                              // 언팔로우
                              await unfollow(currentUser!.user_id ?? 0, user.user_id ?? 0);
                            } else {
                              // 팔로우
                              await follow(currentUser!.user_id ?? 0, user.user_id ?? 0);
                            }
                            // 팔로우 여부 갱신
                            await refreshProfile();
                            // 업데이트된 프로필 페이지 열기
                            _navigateToProfile(context, user.user_name);
                          },
                          child: Text(isFollowing ? '언팔로우' : '팔로우'),
                        );
                      }
                    },
                  ),
                if (isCurrentUserProfile)
                  ElevatedButton(
                    onPressed: () {
                      if (isCurrentUserProfile) {
                        // 현재 사용자와 프로필의 사용자가 동일한 경우 회원 정보 수정 창으로 이동
                        _navigateToEditProfile(context);
                      }
                    },
                    child: Text('회원 정보 수정'),
                  ),
              ],
            ),
          );
        }
      },
    );
  }
// 프로필 정보를 불러오거나 수정하는데 필요한 메소드들 


  Future<void> refreshProfile() async {
    notifyListeners();
  }

  bool isCurrentUserLogic(User? currentUser, User profileUser) {
    print(currentUser?.user_id);
    return currentUser != null && currentUser.user_id == profileUser.user_id;
  }

  Future<User?> getUserData() async {
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    User? updatedUser = await dbHelper.getAllUser(user_name);
    return updatedUser;
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

  void _navigateToEditProfile(BuildContext context) async {
    // 업데이트된 사용자 정보를 받아오기
    User? updatedUser = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(currentUser: currentUser),
      ),
    );

    // 사용자 정보가 업데이트되었으면 최신화된 프로필 페이지 열기
    if (updatedUser != null) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(
            currentUser: updatedUser,
            user_name: updatedUser.user_name,
            userId: updatedUser.user_id ?? 0,
          ),
        ),
      );
    }
  }

  // ProfilePage 클래스에 팔로잉 및 팔로워 수를 가져오는 메서드 추가
  Future<int> getFollowerCount(int userId) async {
    return await DatabaseHelper.instance.getFollowerCount(userId);
  }

  Future<int> getFollowingCount(int userId) async {
    return await DatabaseHelper.instance.getFollowingCount(userId);
  }

  void _navigateToProfile(BuildContext context, String userName) async {
    User? updatedUser = await getUserData();
    if (updatedUser != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(
            currentUser: currentUser,
            user_name: userName,
            userId: updatedUser.user_id ?? 0,
          ),
        ),
      );
    }
  }






// 팔로우 기능 구현을 위한 메소드들 
  // 팔로우 여부 확인
  Future<bool> checkFollowingStatus(int followerId, int followingId) async {
    return await DatabaseHelper.instance.isFollowing(followerId, followingId);
  }

  // 팔로우
  Future<void> follow(int followerId, int followingId) async {
    Follow follow = Follow(followId: 0, follower_id: followerId, following_id: followingId);
    await DatabaseHelper.instance.insertFollow(follow);
  }

  // 언팔로우
  Future<void> unfollow(int followerId, int followingId) async {
    await DatabaseHelper.instance.deleteFollow(followerId, followingId);
  }










}

