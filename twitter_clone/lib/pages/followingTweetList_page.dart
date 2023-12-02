
//게시글 리스트 출력
import 'package:flutter/material.dart';
import 'package:twitter_clone/DB/Post.dart';
import 'package:twitter_clone/DB/User.dart';
import 'package:twitter_clone/DB/database_Helper.dart';
import 'package:twitter_clone/pages/tweetItem_page.dart';

class FollowingTweetList extends StatefulWidget {
  final User? currentUser; // 추가된 부분

  FollowingTweetList({Key? key, required this.currentUser}) : super(key: key);

  @override
  _FollowingTweetListState createState() => _FollowingTweetListState();
}

class _FollowingTweetListState extends State<FollowingTweetList> {
  Future<List<Post>>? _posts;
  

  @override
  void initState() {
    super.initState();
    _posts = _fetchPosts();
  }

  Future<void> _refresh() async {
    setState(() {
      _posts = _fetchPosts();
    });
  }

  Future<List<Post>> _fetchPosts() async {
    List<Post> posts = await DatabaseHelper.instance.fetchPosts();
    return posts;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Post>>(
      future: _fetchPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('데이터를 불러오는 중 오류가 발생했습니다.');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('포스트가 없습니다.');
        } else {
          List<Post> posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              Post post = posts[index];
              return TweetItem(post: post, currentUser: widget.currentUser); // 변경된 부분
            },
          );
        }
      },
    );
  }
}

