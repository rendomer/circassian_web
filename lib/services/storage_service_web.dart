import 'dart:html' as html;
import 'storage_service_base.dart';
//import 'package:cherkess_net/services/storage_service.dart';

class StorageServiceWeb implements StorageService {
  @override
  Future<void> saveEmail(String email) async {
    html.window.localStorage['user_email'] = email;
  }

  @override
  Future<String?> getEmail() async {
    return html.window.localStorage['user_email'];
  }

  @override
  Future<void> saveUserId(String userId) async {
    html.window.localStorage['user_id'] = userId;
  }

  @override
  Future<String?> getUserId() async {
    return html.window.localStorage['user_id'];
  }

  @override
  Future<void> savePassword(String password) async {
    html.window.localStorage['user_password'] = password;
  }

  @override
  Future<String?> getPassword() async {
    return html.window.localStorage['user_password'];
  }

  @override
  Future<void> clear() async {
    html.window.localStorage.remove('user_email');
    html.window.localStorage.remove('user_id');
    html.window.localStorage.remove('user_password');
  }
}

// Вот это:
StorageService getServiceImpl() => StorageServiceWeb();
