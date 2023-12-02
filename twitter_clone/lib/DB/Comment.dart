class Comment {
  int? commentId;
  int? postId;
  String content;
  DateTime comment_time;

  Comment({
    this.commentId,
    this.postId,
    required this.content,
    required this.comment_time,
  });

  Map<String, dynamic> toMap() {
    return {
      'comment_id': commentId,
      'post_id': postId,
      'comment_content': content,
      'comment_time': comment_time.toIso8601String(),
    };
  }
}