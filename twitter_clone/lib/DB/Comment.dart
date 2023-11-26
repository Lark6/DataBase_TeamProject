class Comment {
  int? commentId; //댓글 식별자
  int? postId; // 작성글 아이디
  String content; // 댓글 내용
  String? createdAt; //작성시간

  Comment({
    this.commentId,
    this.postId,
    required this.content,
    this.createdAt,
    required timestamp,
    required String author,
  });

  get timestamp => null;
  get author=>null;

  Map<String, dynamic> toMap(){
    return{
      'comment_id': commentId,
      'post_id': postId,
      'content' : content,
      'created_at': createdAt,
    };
  }

  factory Comment.fromMap(Map<String,dynamic> map){
    return Comment(
      commentId: map['comment_id'],
      postId: map['post_id'],
      content: map['content'],
      createdAt: map['created_at'],
      author: map['realName'], 
      timestamp: map[''], 
      );
  }

  


}
