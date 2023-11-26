// main_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:twitter_clone/DB/database_Helper.dart';
import 'package:twitter_clone/DB/Post.dart';
import 'package:twitter_clone/DB/User.dart';
import 'package:twitter_clone/models/authmodel.dart';
import 'package:twitter_clone/pages/login_page.dart';

//Mainpage
class MainPage extends StatelessWidget {
  final User? currentUser;

  MainPage({Key? key, this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthModel authModel = Provider.of<AuthModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          currentUser != null
              ? '${currentUser?.realName}: realName(실명) (${currentUser?.username}) : username(로그인 아이디)'
              : '트위터 클론',
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // 로그아웃 기능을 구현하세요
              authModel.logout();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          TweetInput(),
          Divider(),
          Expanded(
            child: TweetList(),
          ),
        ],
      ),
    );
  }
}



//게시글 작성
class TweetInput extends StatefulWidget 
{
  @override
  _TweetInputState createState() => _TweetInputState();
}

class _TweetInputState extends State<TweetInput> 
{
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [
        Expanded(
          child: TextField(
            controller: _textEditingController,
            decoration: InputDecoration(hintText: '지금 무슨 일이 일어나고 있나요?', border: OutlineInputBorder(),),
          ),
          SizedBox(height: 8.0),
          ElevatedButton
          (
            onPressed: () 
            {
              _sendTweet(context);
            },
            child: Text('트윗 전송'),
          ),
        ],
      ),
    );
  }

  void _sendTweet(BuildContext context) async 
  {
    String tweetContent = _textEditingController.text;
    if (tweetContent.isNotEmpty) 
    {
      AuthModel authModel = Provider.of<AuthModel>(context, listen: false);
      User? currentUser = authModel.currentUser;

      if (currentUser != null) 
      {
        // 현재 로그인한 사용자의 ID와 트윗 내용을 사용하여 트윗을 저장
        await DatabaseHelper.instance.insertPost
        (
          Post(
            userId: currentUser.id,
            content: tweetContent,
            author: currentUser.realName, // 현재 사용자를 작성자로 설정
            timestamp: DateTime.now().toString(), 
            commentCount: null, // 현재 시간으로 설정
          ),
        );
        // 트윗을 저장한 후 텍스트 필드를 초기화
        _textEditingController.clear();
      }
    } 
    else 
    {
      // 트윗 내용이 비어 있을 경우 경고 표시 또는 다른 처리를 할 수 있음
      ScaffoldMessenger.of(context).showSnackBar
      (
        SnackBar(content: Text('트윗 내용을 입력하세요')),
      );
    }
  }
}


//게시글 리스트 출력
class TweetList extends StatelessWidget {
  Future<List<Post>> fetchPosts() async {
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    List<Post> tweets = [];

    // TODO: 실제 데이터베이스에서 데이터 가져오기
    Database db = await dbHelper.database;
    List<Map<String, dynamic>> postMaps = await db.query('posts', orderBy: 'created_at DESC');

    for (var postMap in postMaps) {
      tweets.add(Post(
        postId: postMap['post_id'],
        content: postMap['content'],
        author: postMap['author'],
        timestamp: postMap['created_at'], 
        commentCount: postMap['like_count'],
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
              return TweetItem(post: snapshot.data![index]);
            },
          );
        }
      },
    );
  }
}

class TweetItem extends StatelessWidget {
  final Post post;

  TweetItem({required this.post});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        post.content,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              // TODO: 작성자의 프로필 페이지로 이동하는 코드 작성
              // Navigator.of(context).push(MaterialPageRoute(
              //   builder: (context) => ProfilePage(userId: post.author.id),
              // ));
            },
            child: Text(
              '작성자: ${post.author.realName}',
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          Text(
            '작성일: ${post.timestamp}',
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            '좋아요: ${post.like_count}',
            style: TextStyle(color: Colors.green),
          ),
          Text(
            '댓글수: ${post.commentCount}',
            style: TextStyle(color: Colors.orange),
          ),
        ],
      ),
      // 추가적인 트윗 정보 및 기능...
    );
  }
}
