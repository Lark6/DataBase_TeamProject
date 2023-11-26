// models/post.dart
class Post {
  int? postId;
  int? userId;
  String content;
  String? createdAt; // 이 부분을 추가
  int? like_count;

  Post({
    this.postId,
    this.userId,
    required this.content,
    this.createdAt,
    this.like_count, // 이 부분을 추가
    //추가 정보
    required String author,
    required timestamp, 
    required commentCount, 
  });

  get timestamp => null;
  get commentCount => null;
  get author => null;

  Map<String, dynamic> toMap() {
    return {
      'post_id': postId,
      'user_id': userId,
      'content': content,
      'created_at': createdAt, // 이 부분을 추가
      'like_count': like_count,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      postId: map['post_id'],
      userId: map['user_id'],
      content: map['content'],
      createdAt: map['created_at'], 
      author: map['realName'], 
      like_count: map['like_count'], 
      timestamp: map[''], 
      commentCount: null, // 이 부분을 추가
    );
  }
}
