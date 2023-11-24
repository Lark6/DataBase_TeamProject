// models/post.dart
class Post {
  int? postId;
  int? userId;
  String content;
  String? createdAt; // 이 부분을 추가

  Post({
    this.postId,
    this.userId,
    required this.content,
    this.createdAt, required String author, required likes, required timestamp, // 이 부분을 추가
  });

  Map<String, dynamic> toMap() {
    return {
      'post_id': postId,
      'user_id': userId,
      'content': content,
      'created_at': createdAt, // 이 부분을 추가
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      postId: map['post_id'],
      userId: map['user_id'],
      content: map['content'],
      createdAt: map['created_at'], // 이 부분을 추가
    );
  }
}
