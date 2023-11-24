// models/user.dart

class User {
  int? id; // 사용자 식별자
  String username; // 사용자 아이디
  String password; // 사용자 비밀번호
  String realName; // 사용자 실명
  String profileMessage; // 사용자 프로필 메시지
  String gender; // 사용자 성별
  String birthday; // 사용자 생년월일
  int followers; // 팔로워 수
  int following; // 팔로잉 수

  User({
    this.id,
    required this.username,
    required this.password,
    required this.realName,
    required this.profileMessage,
    required this.gender,
    required this.birthday,
    required this.followers,
    required this.following,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'realName': realName,
      'profileMessage': profileMessage,
      'gender': gender,
      'birthday': birthday,
      'followers': followers,
      'following': following,
    };
  }
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      realName: map['realName'],
      profileMessage: map['profileMessage'],
      gender: map['gender'],
      birthday: map['birthday'],
      followers: map['followers'],
      following: map['following'],
    );
  }
}
