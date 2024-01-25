import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final String? id;
  final String? email;
  final bool isEmailVerified;
  const AuthUser({
    required this.id,
    required this.email,
    required this.isEmailVerified,
  });

  factory AuthUser.fromFirebase(User user) =>
      AuthUser(
          id: user.uid,
          email : user.email!, // 우리는 facebook이나 구글 로그인 같은거 안쓸거고 firebase 로그인만 쓴다 가정 할 거기 때문에 email은 무조건 있다고 생각 해도 된다.
          isEmailVerified :  user.emailVerified,
      );
}