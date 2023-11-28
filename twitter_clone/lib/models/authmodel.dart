import 'package:flutter/material.dart';
import 'package:twitter_clone/DB/User.dart';
import 'package:twitter_clone/DB/database_Helper.dart';


class AuthModel extends ChangeNotifier {
  User? _currentUser;
  bool _isLoggedIn = false;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;

  // DatabaseHelper 인스턴스를 생성
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // 로그인 메서드
  void login() {
    // 로그인 로직을 여기에 추가
    // 예시로 사용자 정보를 임의로 생성
    _currentUser = User(
      user_id: 1,
      user_name: 'example_user',
      password: 'example_password',
      profile_message: 'Hello, I am example user!',
      gender: 'Male',
      birthday: '1990-01-01',
      followers_count: 100,
      following_count: 50,
    );
    _isLoggedIn = true;

    // 변경 사항을 듣고 있는 위젯들에게 알림
    notifyListeners();

    // 실제 사용자 정보를 가져오는 메서드 호출
    fetchUserData();
  }

  // 사용자 정보를 데이터베이스에서 가져오는 메서드
  void fetchUserData() async {
    try {
      // DatabaseHelper를 사용하여 사용자 정보를 가져옴
      User databaseUser = await _databaseHelper.getUserById(_currentUser!.user_id as int);
      _currentUser = databaseUser;
      notifyListeners(); // 상태가 변경되었음을 알림
    } catch (e) {
      // 오류 처리: 사용자 정보를 가져오지 못한 경우
      print('사용자 정보를 가져오는 중 오류 발생: $e');
    }
  }

  // 로그아웃 메서드
  void logout() {
    // TODO: 실제 로그아웃 작업을 수행 (예: 토큰 삭제 등)
    _currentUser = null; // 사용자 정보 초기화
    _isLoggedIn = false;

    // 변경 사항을 듣고 있는 위젯들에게 알림
    notifyListeners();
  }
}

