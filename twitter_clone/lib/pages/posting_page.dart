import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:twitter_clone/DB/Post.dart';
import 'package:twitter_clone/DB/User.dart';
import 'package:twitter_clone/DB/database_Helper.dart';
import 'package:twitter_clone/pages/main_page.dart';

class Posting extends StatelessWidget {
  final User? currentUser;
  final TextEditingController _textEditingController = TextEditingController();

  Posting({Key? key, required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('게시글 작성'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
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
                _sendPost(context, currentUser); // 포스트 저장
              },
              child: Text('게시'),
            ),
          ],
        ),
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
            user_id: currentUser.user_id ?? 0,
            post_content: tweetContent,
            author: currentUser.user_name,
            post_time: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
          ),
        );

        // 트윗을 저장한 후 텍스트 필드를 초기화
        _textEditingController.clear();

        // 게시글 작성 페이지를 닫고 이전 페이지로 이동
        Navigator.pop(context);

        // 저장 후 초기화가 성공적으로 이루어졌음을 사용자에게 알리기 위해 SnackBar를 표시
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('트윗이 성공적으로 저장되었습니다')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('현재 로그인이 되어있지 않음')),
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
