// main_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:twitter_clone/DB/database_Helper.dart';
import 'package:twitter_clone/DB/Post.dart';
import 'package:twitter_clone/DB/User.dart';
import 'package:twitter_clone/models/authmodel.dart';
import 'package:twitter_clone/pages/login_page.dart';
import 'package:twitter_clone/pages/profile_page.dart';

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
          ? '(${currentUser?.user_name},${currentUser?.user_id})': 'CLONE',
          style: TextStyle(fontSize: 20.0),
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
          Posting(currentUser: currentUser), //게시글 작성 섹션
          Divider(),
          Expanded
          (
            child: TweetList(currentUser: currentUser,), //현재까지 작성된 게시글들
          ),
        ],
      ),
    );
  }
}

//게시글 작성
class Posting extends StatefulWidget {
  final User? currentUser;

  Posting({Key? key, required this.currentUser}) : super(key: key);

  @override
  _PostingState createState() => _PostingState();
}
class _PostingState extends State<Posting> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                TextField(
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    hintText: 'Write everything',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 8.0),
                ElevatedButton(
                  onPressed: () {
                    _sendPost(context, widget.currentUser); // 포스트 저장
                  },
                  child: Text('게시'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendPost(BuildContext context, User? currentUser) async {
    String tweetContent = _textEditingController.text;
    
    if (tweetContent.isNotEmpty) {
      if (currentUser != null) {
        // 현재 로그인한 사용자의 ID와 트윗 내용을 사용하여 트윗을 저장
        await DatabaseHelper.instance.insertPost(
          Post(
            user_id: currentUser.user_id,
            post_content: tweetContent,
            author: currentUser.user_name,
            post_time: DateTime.now(), post_id: null, 
          ),
        );

        // 트윗을 저장한 후 텍스트 필드를 초기화
        _textEditingController.clear();

        // 저장 후 초기화가 성공적으로 이루어졌음을 사용자에게 알리기 위해 SnackBar를 표시
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('트윗이 성공적으로 저장되었습니다')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('현재 currentuser 없음')),
        );
      }
    } else {
      // 트윗 내용이 비어 있을 경우 경고 표시 또는 다른 처리를 할 수 있음
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('트윗 내용을 입력하세요')),
      );
    }
  }
}


//게시글 리스트 출력
class TweetList extends StatefulWidget {
  final User? currentUser; // 추가된 부분

  TweetList({Key? key, required this.currentUser}) : super(key: key);

  @override
  _TweetListState createState() => _TweetListState();
}

class _TweetListState extends State<TweetList> {
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


class TweetItem extends StatelessWidget {
  final Post post;
  final User? currentUser; // 새로 추가된 부분

  TweetItem({required this.post, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    return ListTile(
      title: Text(
        '포스트 내용: ${post.post_content}',
        style: TextStyle(fontWeight: FontWeight.normal),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              _ProfilePage(context, post.author ?? '', currentUser, post.user_id);
            },
            child: Text(
              '작성자: ${post.author ?? ''}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          Text(
            '작성일: ${formatter.format(post.post_time as DateTime)}',
            style: TextStyle(color: Colors.grey),
          ),
        ],
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