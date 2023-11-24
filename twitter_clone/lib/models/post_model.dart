// post_model.dart

class Post {
  int? id;
  late int userId;
  late String content;
  late DateTime timestamp;
  late int likes;

  Post({
    this.id,
    required this.userId,
    required this.content,
    required this.timestamp,
    required this.likes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'likes': likes,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      userId: map['userId'],
      content: map['content'],
      timestamp: DateTime.parse(map['timestamp']),
      likes: map['likes'],
    );
  }
}
