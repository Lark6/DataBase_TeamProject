import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_clone/DB/Post.dart';
import 'package:twitter_clone/DB/User.dart';
import 'package:twitter_clone/DB/database_Helper.dart';
import 'package:twitter_clone/models/authmodel.dart';
import 'package:twitter_clone/pages/login_page.dart';
import 'package:twitter_clone/pages/posting_page.dart';
import 'package:twitter_clone/pages/profile_page.dart';
import 'package:twitter_clone/pages/tweetItem_page.dart';
import 'package:twitter_clone/pages/tweetList_page.dart';

class MainPage extends StatelessWidget {
  final User? currentUser;
  MainPage({Key? key,  this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthModel authModel = Provider.of<AuthModel>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            currentUser != null
                ? '(${currentUser?.user_name},${currentUser?.user_id})'
                : 'CLONE',
            style: TextStyle(fontSize: 20.0),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                authModel.logout();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(
                      currentUser: currentUser,
                      user_name: currentUser?.user_name ?? '',
                      userId: currentUser?.user_id ?? 0,
                    ),
                  ),
                );
              },
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: '전체 트윗'),
              Tab(text: '팔로잉 트윗'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // 전체 트윗 탭
            TweetList(currentUser: currentUser),
            // 팔로우한 사용자의 게시물을 표시하기 위한 메소드 추가
            _buildFollowingPosts(context),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Posting(currentUser: currentUser),
              ),
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

 Widget _buildFollowingPosts(BuildContext context) {
  return FollowingPostsWidget(currentUser: currentUser);
}

}

// 팔로잉한 사용자의 트윗을 표시하는 위젯
class FollowingPostsWidget extends StatelessWidget {
  final User? currentUser;

  FollowingPostsWidget({Key? key, this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Post>>(
      // 팔로잉한 사용자의 트윗을 가져오는 비동기 작업
      future: DatabaseHelper.instance.getFollowingPosts(currentUser?.user_id ?? 0),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // 로딩 중이면 로딩 표시
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // 에러가 발생하면 에러 메시지 표시
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // 데이터가 없으면 메시지 표시
          return Text('No posts from following users');
        } else {
          // 데이터가 있으면 트윗 목록 표시
          List<Post> followingPosts = snapshot.data!;
          return ListView.builder(
            itemCount: followingPosts.length,
            itemBuilder: (context, index) {
              return TweetItem(post: followingPosts[index], currentUser: currentUser);
            },
          );
        }
      },
    );
  }
}
