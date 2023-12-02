
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:twitter_clone/DB/Post.dart';
import 'package:twitter_clone/DB/User.dart';
import 'package:twitter_clone/pages/post_page.dart';
import 'package:twitter_clone/pages/profile_page.dart';

class TweetItem extends StatelessWidget {
  final Post post;
  final User? currentUser;

  TweetItem({required this.post, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    return GestureDetector(
      onTap: () {
        _navigateToPost(context, post, currentUser);
      },
      child: Card(
        child: ListTile(
          title: Text(
            '포스트 내용: ${post.post_content}',
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '작성자: ${post.author ?? ''}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
              Text(
                '작성일: ${post.post_time}',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToPost(BuildContext context, Post post, User? currentUser) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostPage(post: post, currentUser: currentUser),
      ),
    );
  }

  void _ProfilePage(BuildContext context, String author, User? currentUser, int? user_id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(currentUser: currentUser, user_name: author, userId: user_id ?? 0),
      ),
    );
  }
}