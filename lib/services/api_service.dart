import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

import '../models/user_model.dart';
import '../models/survey_model.dart';
import '../services/storage_service.dart';

class AppConfig {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://127.0.0.1:8000';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000';
    } else {
      return 'http://192.168.1.100:8000';
    }
  }
}

class ApiService {
  static final String _usersBaseUrl = '${AppConfig.baseUrl}/api/users';
  static final String _statsBaseUrl = '${AppConfig.baseUrl}/api/stats';
  static final String _generalStatsUrl = '${AppConfig.baseUrl}/api/statistics';

  /// ✅ Логин
  static Future<User?> login(String credential, String password) async {
    final url = Uri.parse('$_usersBaseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email_or_phone': credential,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final user = User.fromJson(data);
      final storage = getServiceImpl();
      await storage.saveEmail(user.email ?? '');
      await storage.saveUserId(user.id ?? '');
      return user;
    } else {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      throw Exception(data['message'] ?? 'Ошибка логина');
    }
  }

  /// ✅ Регистрация
  static Future<bool> register(User user, String password) async {
    final url = Uri.parse('$_usersBaseUrl/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'first_name': user.firstName,
        'last_name': user.lastName,
        'email': user.email,
        'phone': user.phone,
        'password': password,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      throw Exception(data['message'] ?? 'Ошибка регистрации');
    }
  }

  /// ✅ Список пользователей (исправлено!)
  static Future<List<User>> listUsers(String myId) async {
    final url = Uri.parse('$_usersBaseUrl/list?confirmed_by=$myId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Не удалось получить список пользователей');
    }
  }

  /// ✅ Подтверждение пользователя
static Future<bool> confirmUser(String userId, String confirmedBy) async {
  final url = Uri.parse('$_usersBaseUrl/confirm/$userId');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'confirmed_by': confirmedBy}),
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    print('Error confirming user: ${response.statusCode}');
    return false;
  }
}

  /// ✅ Статистика: число зарегистрированных пользователей
  static Future<Map<String, dynamic>> getStats() async {
    final url = Uri.parse('$_statsBaseUrl/registered_users_count');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Не удалось получить статистику');
    }
  }

  /// ✅ Общая статистика
  static Future<Map<String, dynamic>> fetchStatistics() async {
    final url = Uri.parse('$_generalStatsUrl/');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Не удалось получить общую статистику');
    }
  }

  /// ✅ Проверка соединения
  static Future<String> fetchPing() async {
    final url = Uri.parse('${AppConfig.baseUrl}/ping');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return data['message']?.toString() ?? 'OK';
    } else {
      return 'Ошибка сервера: ${response.statusCode}';
    }
  }
}

/// ✅ Сервис опросов
class SurveyApiService {
  static final String _baseUrl = '${AppConfig.baseUrl}/api/surveys';

  /// Активный опрос
  static Future<Survey?> getActiveSurvey() async {
    final url = Uri.parse('$_baseUrl/active');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return Survey.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Ошибка сервера при получении опроса');
    }
  }

  /// Проголосовать
  static Future<bool> voteInSurvey(String surveyId, String userId, Map<String, dynamic> answers) async {
    final url = Uri.parse('$_baseUrl/$surveyId/vote');
    final payload = jsonEncode({
      'user_id': userId,
      'answers': answers.map((key, value) => MapEntry(key, value.toString())),
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: payload,
    );
    return response.statusCode == 200;
  }

  /// Результаты опроса
  static Future<SurveyResults> getSurveyResults(String surveyId) async {
    final url = Uri.parse('$_baseUrl/$surveyId/results');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return SurveyResults.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Ошибка при получении результатов опроса');
    }
  }

  /// Архив опросов
  static Future<List<Survey>> fetchSurveyArchive() async {
    final url = Uri.parse('$_baseUrl/archive');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((e) => Survey.fromJson(e)).toList();
    } else {
      throw Exception('Ошибка при получении архива опросов');
    }
  }
}
