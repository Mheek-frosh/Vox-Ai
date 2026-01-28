import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';

class AuthController extends GetxController {
  final _storage = const FlutterSecureStorage();
  final _userKey = 'user_session';
  final _isLoggedIn = false.obs;
  final _currentUser = Rxn<UserModel>();

  bool get isLoggedIn => _isLoggedIn.value;
  UserModel? get currentUser => _currentUser.value;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    try {
      final userJson = await _storage.read(key: _userKey);
      if (userJson != null) {
        _currentUser.value = UserModel.fromJson(jsonDecode(userJson));
        _isLoggedIn.value = true;
      }
    } catch (e) {
      print("Error reading secure storage: $e");
    }
  }

  Future<bool> login(String identifier, String password) async {
    await Future.delayed(const Duration(seconds: 2));

    // Simple mock logic
    if (password.length >= 6) {
      final user = UserModel(
        id: '1',
        fullName: 'John Doe',
        email: identifier.contains('@') ? identifier : 'john@example.com',
        phoneNumber: !identifier.contains('@') ? identifier : '+1234567890',
      );

      await _saveSession(user);
      return true;
    }
    return false;
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    final user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
    );

    await _saveSession(user);
    return true;
  }

  Future<void> _saveSession(UserModel user) async {
    await _storage.write(key: _userKey, value: jsonEncode(user.toJson()));
    _currentUser.value = user;
    _isLoggedIn.value = true;
  }

  Future<void> logout() async {
    await _storage.delete(key: _userKey);
    _currentUser.value = null;
    _isLoggedIn.value = false;
    Get.offAllNamed('/login');
  }

  void updateProfile(UserModel updatedUser) async {
    _currentUser.value = updatedUser;
    await _storage.write(
      key: _userKey,
      value: jsonEncode(updatedUser.toJson()),
    );
  }
}
