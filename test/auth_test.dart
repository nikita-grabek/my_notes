import 'dart:math';

import 'package:success_planner/services/auth/auth_exceptions.dart';
import 'package:success_planner/services/auth/auth_provider.dart';
import 'package:success_planner/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group("Mock Authentification", () {
    final provider = MockAuthProvider();
    test("Should not be initialized to begin with", () {
      expect(provider._isInitialised, false);
    });
    test("Connot log out if not initialized", () {
      expect(provider.logOut(),
          throwsA(const TypeMatcher<NotInitializedException>()));
    });

    test("Should be able to be initialized", () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test("User should be null after initialization", () {
      expect(provider.currentUser, null);
    });

    test(
      "Should be able to initialze in less than 2 seconds",
      () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );
    test("Create User should delegate to logIn function", () async {
      final badEmailUser = provider.createUser(
        email: "foo@bar.com",
        password: "sdfasf",
      );
      expect(badEmailUser,
          throwsA(const TypeMatcher<UserNotFoundAuthException>()));
      final badPasswordUser =
          provider.createUser(email: "someone@bar.com", password: "foobar");

      expect(badPasswordUser,
          throwsA(const TypeMatcher<UserNotFoundAuthException>()));

      final user = await provider.createUser(email: "foo", password: "bar");
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    // test("LogIn user should be able to get verifed", () {
    //   final user = provider.sendEmailVerification;
    //   expect(user, isNotNull);
    //   expect(user.isEmailVerified, true);
    // });

    test("Should be able to logOut and logIn again", () async {
      await provider.logOut();
      await provider.logIn(email: "email", password: "password");
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialised = false;
  bool get isInitialized => _isInitialised;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!_isInitialised) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialised = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    if (!_isInitialised) throw NotInitializedException();
    if (email == "foo@bar.com") throw UserNotFoundAuthException();
    if (password == "foobar") throw WrongPasswordAuthException();
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!_isInitialised) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!_isInitialised) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }
}
