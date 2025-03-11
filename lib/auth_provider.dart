import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:mawy_dashboard/hive/hive_objects.dart';
import 'package:mawy_dashboard/objects/datas.dart';
import 'package:mawy_dashboard/request/get_data.dart';

// Simple auth state model.
class AuthState {
  final bool isLoggedIn;
  final dynamic
  user; // Replace 'dynamic' with your actual user model if available.
  const AuthState({required this.isLoggedIn, this.user});
  AuthState copyWith({bool? isLoggedIn, dynamic user}) => AuthState(
    isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    user: user ?? this.user,
  );
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._authBox) : super(const AuthState(isLoggedIn: false)) {
    // Load persisted auth info from Hive, if any.
    if (_authBox.containsKey('login')) {
      final storedUser = _authBox.get('login');
      state = AuthState(isLoggedIn: true, user: storedUser);
      connectDB(); // Optionally perform additional data loading.
    }
  }
  final Box _authBox;

  Future<void> login(String email, String password) async {
    // Call your API or auth service here.
    // Example:
    final user = await Future.delayed(
      const Duration(seconds: 1),
      () => 'dummyUser',
    );
    _authBox.put('login', user);
    state = AuthState(isLoggedIn: true, user: user);
  }

  Future<void> logout() async {
    _authBox.delete('login');
    state = const AuthState(isLoggedIn: false);
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((
  ref,
) {
  final authBox = Hive.box("test4box");
  return AuthNotifier(authBox);
});

Future<void> connectDB() async {
  // Assume that the Hive boxes and global variables (logins, passwords, keyCodes) are set up.
  final authBox = Hive.box("test4box");
  // Retrieve necessary credentials
  final logins = authBox.get("login")?.logins;
  final passwords = authBox.get("login")?.passwords;
  final keyCodes = authBox.get("login")?.keys;

  String connect = await getDatas(logins, passwords, keyCodes);
  final initData = datasFromJson(connect);

  final keyBox = Hive.box("test1box");
  await keyBox.put("key", AllKeys(keys: initData));
}
