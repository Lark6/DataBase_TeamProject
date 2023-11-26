// models/post.dart
class Post {
  int? postId;
  int? userId;
  String post_content;
  DateTime? post_time;

  Post({
    this.postId,
    this.userId,
    required this.post_content,
    this.post_time,
  });

  Map<String, dynamic> toMap() {
    return {
      'post_id': postId,
      'user_id': userId,
      'post_content': post_content,
      'post_time': post_time ?? DateTime.now(), 
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      postId: map['post_id'],
      userId: map['user_id'],
      post_content: map['post_content'],
      post_time: map['post_time'],
    );
  }
}
