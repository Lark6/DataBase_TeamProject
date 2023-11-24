// main_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:twitter_clone/DB/database_Helper.dart';
import 'package:twitter_clone/DB/post.dart';
import 'package:twitter_clone/models/authmodel.dart';
import 'package:twitter_clone/pages/login_page.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('트위터 클론'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // 로그아웃 기능을 구현하세요
              Provider.of<AuthModel>(context, listen: false).logout();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => LoginPage(),
              ));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          TweetInput(),
          Divider(), // 각 트윗을 구분하기 위한 Divider
          Expanded(
            child: TweetList(),
          ),
        ],
      ),
    );
  }
}

class TweetInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: '지금 무슨 일이 일어나고 있나요?',
          border: OutlineInputBorder(),
        ),
        // TODO: 텍스트 입력 및 트윗 전송 로직을 추가하세요
      ),
    );
  }
}
class TweetList extends StatelessWidget {
  Future<List<Post>> fetchPosts() async {
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    List<Post> tweets = [];

    // TODO: 실제 데이터베이스에서 데이터 가져오기
    Database db = await dbHelper.database;
    List<Map<String, dynamic>> postMaps = await db.query('posts', orderBy: 'created_at DESC');

    for (var postMap in postMaps) {
      tweets.add(Post(
        content: postMap['content'],
        author: '사용자', // 사용자 정보도 가져와야 함
        likes: postMap['like_count'], 
        timestamp: null,
      ));
    }

    return tweets;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Post>>(
      future: fetchPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('데이터를 불러오는 중 오류가 발생했습니다.');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('포스트가 없습니다.');
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return TweetItem(tweet: snapshot.data![index], post: null,);
            },
          );
        }
      },
    );
  }
}

class TweetItem extends StatelessWidget {
  final Post post;

  TweetItem({required this.post, required Post tweet});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(post.content),
      subtitle: Text('작성자: 사용자 | 작성일: ${post.createdAt} | 좋아요: ${post.likeCount}'),
      // 추가적인 트윗 정보 및 기능...
    );
  }
}

