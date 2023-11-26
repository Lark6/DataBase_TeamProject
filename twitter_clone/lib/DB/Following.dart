class Following {
  final int followId;
  final int userId;
  final int followingId;

  Following({
    required this.followId,
    required this.userId,
    required this.followingId,
  });
  Map<String, dynamic> toMap() {
    return {
      'followId': followId,
      'userId': userId,
      'followingId': followingId,
    };
  }

  Following.fromMap(Map<String, dynamic> map)
      : followId = map['followId'],
        userId = map['userId'],
        followingId = map['followingId'];
}
