// post_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:twitter_clone/DB/Comment.dart';
import 'package:twitter_clone/DB/Post.dart';
import 'package:twitter_clone/DB/Reply.dart';
import 'package:twitter_clone/DB/User.dart';
import 'package:twitter_clone/DB/database_Helper.dart';
import 'package:twitter_clone/pages/profile_page.dart';
class PostPage extends StatefulWidget {
  final Post post;
  final User? currentUser;

  PostPage({required this.post, required this.currentUser});

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  int likeCount = 0;
  bool isLiked = false;
  final TextEditingController _commentEditingController = TextEditingController();
  final TextEditingController _replyEditingController = TextEditingController();
  int? selectedCommentId;
  bool isReplying = false;



  @override
  void initState() {
    super.initState();
    _fetchLikeCount();
  }

  void _fetchLikeCount() async {
    // 포스트의 초기 like 수를 가져옵니다.
    int count = await DatabaseHelper.instance.getLikeCount(widget.post.post_id??0);
    setState(() {
      likeCount = count;
    });

    // 현재 사용자가 이 포스트를 좋아했는지 확인합니다.
    bool liked = await DatabaseHelper.instance.isPostLiked(widget.currentUser?.user_id ?? 0, widget.post.post_id?? 0);
    setState(() {
      isLiked = liked;
    });
  }

  void _toggleLike() async {
    int userId = widget.currentUser?.user_id ?? 0;
    int? postId = widget.post.post_id;

    if (isLiked) {
      // 이미 좋아했다면 좋아요 취소
      await DatabaseHelper.instance.unlikePost(userId, postId!);
      setState(() {
        isLiked = false;
        likeCount--;
      });
    } else {
      // 좋아하지 않았다면 좋아요
      await DatabaseHelper.instance.likePost(userId, postId!);
      setState(() {
        isLiked = true;
        likeCount++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');

    return Scaffold(
      appBar: AppBar(
        title: Text('포스트 내용'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '포스트 내용: ${widget.post.post_content}',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            GestureDetector(
              onTap: () {
                _navigateToProfile(context, widget.post.author ?? '', widget.currentUser, widget.post.user_id);
              },
              child: Text(
                '작성자: ${widget.post.author ?? ''}',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            Text(
              '작성 시간: ${formatter.format(DateTime.parse(widget.post.post_time))}',
              style: TextStyle(fontSize: 14.0, color: Colors.grey),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _toggleLike,
                  child: Text(isLiked ? '좋아요 취소' : '좋아요'),
                ),
                SizedBox(width: 8.0),
                Text('좋아요 수: $likeCount'),
              ],
            ),
            // 댓글 작성 폼
            _buildCommentForm(),

            // 댓글 목록
            _buildCommentList(),
          ],
        ),
      ),
    );
  }

   Widget _buildCommentForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '댓글 작성',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        TextField(
          controller: _commentEditingController,
          decoration: InputDecoration(
            hintText: '댓글을 입력하세요',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 8.0),
        ElevatedButton(
          onPressed: () {
            _postComment();
          },
          child: Text('댓글 작성'),
        ),
      ],
    );
  }

  // 댓글 목록
  Widget _buildCommentList() {
    return FutureBuilder<List<Comment>>(
      future: DatabaseHelper.instance.getCommentsForPost(widget.post.post_id ?? 0),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('댓글이 없습니다.');
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '댓글 목록',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              for (Comment comment in snapshot.data!)
                _buildCommentItem(comment),
            ],
          );
        }
      },
    );
  }

  // 댓글 항목
   Widget _buildCommentItem(Comment comment) {
    String formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(comment.comment_time);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${comment.content} (${comment.comment_time})'),
        // 대댓글 목록
        _buildReplyList(comment.commentId ?? 0),
        // 대댓글 작성 폼
        _buildReplyForm(comment.commentId ?? 0),
      ],
    );
  }

  // 대댓글 목록
  Widget _buildReplyList(int commentId) {
    return FutureBuilder<List<Reply>>(
      future: DatabaseHelper.instance.getRepliesForComment(commentId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('대댓글이 없습니다.');
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (Reply reply in snapshot.data!)
                _buildReplyItem(reply),
            ],
          );
        }
      },
    );
  }

  // 대댓글 항목
  Widget _buildReplyItem(Reply reply) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text('- ${reply.content}'),
    );
  }

  Widget _buildReplyForm(int commentId) {
    if (isReplying && selectedCommentId == commentId) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _replyEditingController,
            decoration: InputDecoration(
              hintText: '대댓글을 입력하세요',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 8.0),
          ElevatedButton(
            onPressed: () {
              _postReply(commentId);
            },
            child: Text('대댓글 작성'),
          ),
        ],
      );
    } else {
      return ElevatedButton(
        onPressed: () {
          setState(() {
            selectedCommentId = commentId;
            isReplying = true;
          });
        },
        child: Text('대댓글 작성'),
      );
    }
  }

  void _postReply(int commentId) async {
  String replyContent = _replyEditingController.text;

  if (replyContent.isNotEmpty) {
    // 대댓글 저장
    await DatabaseHelper.instance.insertReply(
      Reply(
        commentId: commentId,
        content: replyContent,
      ),
    );

    // 대댓글 작성 후 입력 필드 초기화
    _replyEditingController.clear();

    // 대댓글 목록 다시 불러오기
    setState(() {});
  }
}

  // 댓글 작성 메소드
  void _postComment() async {
    String commentContent = _commentEditingController.text;
    int postId = widget.post.post_id ?? 0;

    if (commentContent.isNotEmpty) {
      int userId = widget.currentUser?.user_id ?? 0;

      // 댓글 저장
      await DatabaseHelper.instance.insertComment(
        Comment(
          postId: postId,
          content: commentContent,
          comment_time: DateTime.now(),
        ),
      );

      // 댓글 작성 후 입력 필드 초기화
      _commentEditingController.clear();

      // 댓글 목록 다시 불러오기
      setState(() {});
    }
  }

  void _navigateToProfile(BuildContext context, String author, User? currentUser, int? user_id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(currentUser: currentUser, user_name: author, userId: user_id ?? 0),
      ),
    );
  }







}
