class Reply {
  final int? replyId;
  final int commentId;
  final String content;

  Reply({
    this.replyId,
    required this.commentId,
    required this.content,
  });

  Map<String, dynamic> toMap() {
    return {
      'reply_id': replyId,
      'comment_id': commentId,
      'reply_content': content,
    };
  }
}
