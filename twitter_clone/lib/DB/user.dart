// models/user.dart

class User 
{
  int? user_id; // 사용자 식별자
  String user_name; // 사용자 아이디
  String password; // 사용자 비밀번호
  String profile_message; // 사용자 프로필 메시지
  String gender; // 사용자 성별
  String birthday; // 사용자 생년월일
  int? followers_count; // 팔로워 수
  int? following_count; // 팔로잉 수
  List<int> followingList = [];

  // 팔로우 목록에 사용자 추가
  void addFollowing(int userId) {
    followingList.add(userId);
  }

  // 팔로우 목록에서 사용자 제거
  void removeFollowing(int userId) {
    followingList.remove(userId);
  }

  User
  ({
    this.user_id,
    required this.user_name,
    required this.password,
    required this.profile_message,
    required this.gender,
    required this.birthday,
    required this.followers_count,
    required this.following_count,
  });
  Map<String, dynamic> toMap() 
  {
    return 
    {
      'user_id': user_id,
      'user_name': user_name,
      'password': password,
      'profile_message': profile_message,
      'gender': gender,
      'birthday': birthday,
      'followers_count': followers_count,
      'following_count': following_count,
    };
  }
  factory User.fromMap(Map<String, dynamic> map) 
  {
    return User
    (
      user_id: map['user_id'],
      user_name: map['user_name'],
      password: map['password'],
      profile_message: map['profile_message'],
      gender: map['gender'],
      birthday: map['birthday'],
      followers_count: map['followers_count'],
      following_count: map['following_count'],
    );
  }
}
