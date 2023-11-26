// main_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:twitter_clone/DB/database_Helper.dart';
import 'package:twitter_clone/DB/post.dart';
import 'package:twitter_clone/DB/user.dart';
import 'package:twitter_clone/models/authmodel.dart';
import 'package:twitter_clone/pages/login_page.dart';

//Mainpage
class MainPage extends StatelessWidget 
{
  final User? currentUser;
  MainPage({Key? key, this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthModel authModel = Provider.of<AuthModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          currentUser != null
          ? '(${currentUser?.username}) : username(로그인 아이디)': 'CLONE',
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () //logout
            {
              authModel.logout();
              Navigator.of(context).pushReplacement
              (
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Posting(), //게시글 작성 섹션
          Divider(),
          Expanded
          (
            child: TweetList(), //현재까지 작성된 게시글들
          ),
        ],
      ),
    );
  }
}

//게시글 작성
class Posting extends StatefulWidget 
{
  @override
  _PostingState createState() => _PostingState();
}

class _PostingState extends State<Posting> 
{
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) 
  {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField
          (
            controller: _textEditingController,
            decoration: InputDecoration(hintText: 'Write everything what you want', border: OutlineInputBorder(),),
          ),
          SizedBox(height: 8.0),
          ElevatedButton
          (
            onPressed: () 
            {
              _sendPost(context); //포스트 저장
            },
            child: Text('게시'),
          ),
        ],
      ),
    );
  }

  void _sendPost(BuildContext context) async //DB에 포스트 저장
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
            post_content: tweetContent,
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
        post_content: postMap['post_content'],
        post_time: postMap['post_time'],
      ));
    }

    return tweets;
  }
  Future<List<User>> fetchUser(int id) async {
  DatabaseHelper dbHelper = DatabaseHelper.instance;
  List<User> users =[];

  // TODO: 실제 데이터베이스에서 데이터 가져오기
  Database db = await dbHelper.database;
  List<Map<String, dynamic>> userMaps = await db.query(
    'User',
    columns: ['id', 'username'], // 가져올 필드 선택
    where: 'id = ?',
    whereArgs: [id],
  );

  for (var userMap in userMaps) {
    users.add(User(
      id: userMap['id'],
      username: userMap['username'],
    ));
  }
  return users;
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
            Post post = snapshot.data![index];
            return TweetItem(post: post, user: user);
          },
        );
      }
    },
  );
}

}
class TweetItem extends StatelessWidget {
  final Post post;
  final User user;

  TweetItem({required this.post, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        post.post_content,
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
              '작성자: ${user.username}', // user.author.realName 대신 user.realName을 사용
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          Text(
            '작성일: ${post.post_time}',
            style: TextStyle(color: Colors.grey),
          ),
          // 현재 좋아요 기능 미구현 

          // Text( 
          //   '좋아요: ${post.like_count}',
          //   style: TextStyle(color: Colors.green),
          // ),

          //현재 댓글 기능 미구현
          // Text(
          //   '댓글수: ${post.commentCount}',
          //   style: TextStyle(color: Colors.orange),
          // ),
        ],
      ),
      // 추가적인 트윗 정보 및 기능...
    );
  }
}
