// models/post.dart

class Post {
  int? post_id;
  final int? user_id;
  String post_content;
  DateTime post_time;
  String? author; // 변경된 부분

  Post({
    this.post_id,
    this.user_id,
    required this.post_content,
    required this.post_time,
    this.author,
    
  });

  Map<String, dynamic> toMap() {
    return {
      'post_id': post_id,
      'user_id': user_id,
      'post_content': post_content,
      'post_time': post_time.toIso8601String(),
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      post_id: map['post_id'],
      user_id: map['user_id'],
      post_content: map['post_content'],
      post_time: DateTime.parse(map['post_time']),
    );
  }
}
