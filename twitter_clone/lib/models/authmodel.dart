import 'package:flutter/material.dart';

class AuthModel extends ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void login() {
    // 로그인 로직을 여기에 추가
    _isLoggedIn = true;
    notifyListeners(); // 상태가 변경되었음을 알림
  }

  // 로그아웃 메서드
  void logout() {
    // TODO: 실제 로그아웃 작업을 수행 (예: 토큰 삭제 등)
    _isLoggedIn = false;

    // 변경 사항을 듣고 있는 위젯들에게 알림
    notifyListeners();
  }
}