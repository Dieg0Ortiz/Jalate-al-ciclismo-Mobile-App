import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearCache();
  Future<bool> isLoggedIn();
}

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<void> cacheUser(UserModel user) async {
    //await _prefs.setString(AppConstants.keyUserId, user.id);
    //await _prefs.setString(AppConstants.keyUserName, user.name);
    await _prefs.setString(AppConstants.keyUserEmail, user.email);
    await _prefs.setBool(AppConstants.keyIsLoggedIn, true);
    if (user.photoUrl != null) {
      await _prefs.setString('user_photo_url', user.photoUrl!);
    }
    if (user.location != null) {
      await _prefs.setString('user_location', user.location!);
    }
    if (user.birthDate != null) {
      await _prefs.setString('user_birth_date', user.birthDate!);
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final isLoggedIn = _prefs.getBool(AppConstants.keyIsLoggedIn) ?? false;
    if (!isLoggedIn) return null;

    final id = _prefs.getString(AppConstants.keyUserId);
    final name = _prefs.getString(AppConstants.keyUserName);
    final email = _prefs.getString(AppConstants.keyUserEmail);

    if (id == null || name == null || email == null) return null;

    return UserModel(
      id: id,
      name: name,
      email: email,
      photoUrl: _prefs.getString('user_photo_url'),
      location: _prefs.getString('user_location'),
      birthDate: _prefs.getString('user_birth_date'),
    );
  }

  @override
  Future<void> clearCache() async {
    await _prefs.remove(AppConstants.keyUserId);
    await _prefs.remove(AppConstants.keyUserName);
    await _prefs.remove(AppConstants.keyUserEmail);
    await _prefs.remove(AppConstants.keyIsLoggedIn);
    await _prefs.remove('user_photo_url');
    await _prefs.remove('user_location');
    await _prefs.remove('user_birth_date');
  }

  @override
  Future<bool> isLoggedIn() async {
    return _prefs.getBool(AppConstants.keyIsLoggedIn) ?? false;
  }
}
