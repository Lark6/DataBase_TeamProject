class Followers {
  final int followId;
  final int userId;
  final int followerId;

  Followers({
    required this.followId,
    required this.userId,
    required this.followerId,
  });
  
   Map<String, dynamic> toMap() {
    return {
      'followId': followId,
      'userId': userId,
      'followerId': followerId,
    };
  }

  Followers.fromMap(Map<String, dynamic> map)
      : followId = map['followId'],
        userId = map['userId'],
        followerId = map['followerId'];
}
