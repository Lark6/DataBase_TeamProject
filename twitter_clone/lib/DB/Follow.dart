class Follow {
  final int followId;
  final int followerId;
  final int followingId;

  Follow({
    required this.followId,
    required this.followerId,
    required this.followingId,
  });

  Map<String, dynamic> toMap() {
    return {
      'followId': followId,
      'followerId': followerId,
      'followingId': followingId,
    };
  }

  Follow.fromMap(Map<String, dynamic> map)
      : followId = map['followId'],
        followerId = map['followerId'],
        followingId = map['followingId'];
}
