// DB/Post.dart


class Post {
  int? post_id;
  final int user_id;
  final String post_content;
  final String post_time;
  final String? author;

  Post({
    this.post_id,
    required this.user_id,
    required this.post_content,
    required this.post_time,
    this.author,
  });

  // Map에서 Post로 변환하는 메서드
  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      post_id: map['post_id'],
      user_id: map['user_id'],
      post_content: map['post_content'],
      post_time: map['post_time'],
      author: map['user_name'],
    );
  }

  // Post에서 Map으로 변환하는 메서드
  Map<String, dynamic> toMap() {
    return {
      'post_id': post_id,
      'user_id': user_id,
      'post_content': post_content,
      'post_time': post_time,
    };
  }


}
