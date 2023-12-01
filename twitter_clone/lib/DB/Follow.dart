class Follow {
  final int followId;
  final int follower_id; // 변경된 부분
  final int following_id;

  Follow({
    required this.followId,
    required this.follower_id,
    required this.following_id,
  });

  Map<String, dynamic> toMap() {
    return {
      'follower_id': follower_id,
      'following_id': following_id,
    };
  }

  Follow.fromMap(Map<String, dynamic> map)
      : followId = map['followId'],
        follower_id = map['follower_id'],
        following_id = map['following_id'];
}
