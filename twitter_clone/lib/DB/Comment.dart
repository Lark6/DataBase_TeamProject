class Comment 
{
  int? commentId; //댓글 식별자
  int? postId; // 작성글 아이디
  String content; // 댓글 내용
  DateTime comment_time; //작성시간

  Comment
  ({
    this.commentId,
    this.postId,
    required this.content,
    required this.comment_time,
    required timestamp,
    required String author,
  });

  get timestamp => null;
  get author=>null;

  Map<String, dynamic> toMap()
  {
    return
    {
      'comment_id': commentId,
      'post_id': postId,
      'content' : content,
      'comment_time': comment_time.toIso8601String(),
    };
  }

  factory Comment.fromMap(Map<String,dynamic> map)
  {
    return Comment
    (
      commentId: map['comment_id'],
      postId: map['post_id'],
      content: map['content'],
      comment_time: DateTime.parse(map['comment_time']),
      author: map['realName'], 
      timestamp: map[''], 
      );
  }

  


}
