// user_model.dart

class User {
  int? id;
  late String username;
  late String password;
  late String realName;
  late String profileMessage;
  late String gender;
  late String birthday;
  late int followers;
  late int following;

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
