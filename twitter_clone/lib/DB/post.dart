// DB/Post.dart


class Post {
  final int post_id;
  final int user_id;
  final String post_content;
  final String post_time;
  final String? author;
  final int like_count; // 좋아요 수 필드 추가

  Post({
    required this.post_id,
    required this.user_id,
    required this.post_content,
    required this.post_time,
    this.author,
    this.like_count = 0, // 기본값 0으로 설정
  });

  // Map에서 Post로 변환하는 메서드
  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      post_id: map['post_id'],
      user_id: map['user_id'],
      post_content: map['post_content'],
      post_time: map['post_time'],
      author: map['user_name'],
      like_count: map['like_count'], // 추가된 부분
    );
  }

  // Post에서 Map으로 변환하는 메서드
  Map<String, dynamic> toMap() {
    return {
      'post_id': post_id,
      'user_id': user_id,
      'post_content': post_content,
      'post_time': post_time,
      'like_count': like_count, // 추가된 부분
    };
  }


}
