import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_clone/DB/Follow.dart';
import 'package:twitter_clone/DB/Post.dart';
import 'package:twitter_clone/DB/User.dart';
import 'package:twitter_clone/DB/database_Helper.dart';
import 'package:twitter_clone/models/authmodel.dart';
import 'package:twitter_clone/pages/EditProflle_page.dart';
import 'package:twitter_clone/pages/follower_page.dart';
import 'package:twitter_clone/pages/following_page.dart';
import 'package:twitter_clone/pages/post_page.dart';



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
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('데이터를 불러오는 중 오류가 발생했습니다.'));
      } else if (!snapshot.hasData) {
        return Center(child: Text('사용자 데이터를 찾을 수 없습니다.'));
      } else {
        User user = snapshot.data!;
        bool isCurrentUserProfile = isCurrentUserLogic(currentUser, user);
        bool isFollowing = false;

        return Scaffold(
          appBar: AppBar(
            title: Text('프로필: ${user.user_name}'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                    title: Text('유저 정보: ${user.user_name}'),
                  ),
                  ListTile(
                    title: Text('프로필 메시지: ${user.profile_message ?? '없음'}'),
                  ),
                  ListTile(
                    title: Text('성별: ${user.gender}'),
                  ),
                  ListTile(
                    title: Text('생년월일: ${user.birthday}'),
                  ),
                  // 팔로워 수를 비동기로 가져와 표시
                  FutureBuilder<int>(
                    future: getFollowerCount(user.user_id ?? 0),
                    builder: (context, followerSnapshot) {
                      if (followerSnapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (followerSnapshot.hasError) {
                        return Center(child: Text('에러 발생: ${followerSnapshot.error}'));
                      } else {
                        int followerCount = followerSnapshot.data ?? 0;
                        return ListTile(
                          title: Text('팔로워 수: $followerCount'),
                          onTap: () {
                            _navigateToFollowerList(context, user.user_id ?? 0, currentUser);
                          },
                        );
                      }
                    },
                  ),

                  // 팔로잉 수를 비동기로 가져와 표시
                  FutureBuilder<int>(
                    future: getFollowingCount(user.user_id ?? 0),
                    builder: (context, followingSnapshot) {
                      if (followingSnapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (followingSnapshot.hasError) {
                        return Center(child: Text('에러 발생: ${followingSnapshot.error}'));
                      } else {
                        int followingCount = followingSnapshot.data ?? 0;
                        return ListTile(
                          title: Text('팔로잉 수: $followingCount'),
                          onTap: () {
                            _navigateToFollowingList(context, user.user_id ?? 0, currentUser);
                          },
                        );
                      }
                    },
                  ),

                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (!isCurrentUserProfile)
                        ElevatedButton(
                          onPressed: () async {
                            isFollowing = await checkFollowingStatus(currentUser?.user_id ?? 0, user.user_id ?? 0);
                            await _handleFollowButton(context, isCurrentUserProfile, user);
                          },
                          child: Text(isFollowing ? '언팔로우' : '팔로우/언팔로우'),
                        ),
                      if (isCurrentUserProfile)
                        ElevatedButton(
                          onPressed: () {
                            _navigateToEditProfile(context);
                          },
                          child: Text('회원 정보 수정'),
                        ),
                    ],
                  ),
                  Text(
                    '작성한 포스트',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                  child: FutureBuilder<List<Post>>(
                    future: DatabaseHelper.instance.fetchUserPosts(user.user_id ?? 0),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('포스트를 불러오는 중 오류가 발생했습니다.'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('작성한 포스트가 없습니다.'));
                      } else {
                        List<Post> userPosts = snapshot.data!;
                        return ListView.builder(
                          itemCount: userPosts.length,
                          itemBuilder: (context, index) {
                            Post post = userPosts[index];
                            return ListTile(
                              title: Text(post.post_content),
                              onTap: () {
                                // 해당 포스트 페이지로 이동
                                _navigateToPost(context, post, currentUser);
                              },
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }
    },
  );
}
void _navigateToPost(BuildContext context, Post post, User? currentUser) {
  print(post.user_id);
  print(currentUser?.user_id);
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PostPage(post: post, currentUser: currentUser),
    ),
  );
}



  Future<void> _handleFollowButton(BuildContext context, bool isCurrentUserProfile, User user) async {
    bool isFollowing = await checkFollowingStatus(currentUser?.user_id ?? 0, user.user_id ?? 0);
    if (isFollowing) {
      await unfollow(currentUser!.user_id ?? 0, user.user_id ?? 0);
    } else {
      await follow(currentUser!.user_id ?? 0, user.user_id ?? 0);
    }
    await refreshProfile();
    isFollowing = await checkFollowingStatus(currentUser?.user_id ?? 0, user.user_id ?? 0);
    _navigateToProfile(context, user.user_name);
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





// 예시 코드
void _navigateToFollowingList(BuildContext context, int userId, User? currentUser) {
  navigateToFollowingList(context, userId, currentUser);
}
void navigateToFollowingList(BuildContext context, int userId, User? currentUser) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => FollowingListPage(userId: userId, currentUser: currentUser),
    ),
  );
}

void _navigateToFollowerList(BuildContext context, int userId, User? currentUser) {
  navigateToFollowerList(context, userId, currentUser);
}

  void navigateToFollowerList(BuildContext context, int userId, User? currentUser) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => FollowerListPage(userId: userId, currentUser: currentUser),
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
      // ignore: use_build_context_synchronously
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
