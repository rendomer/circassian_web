import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/survey_model.dart';

class SurveyService {
  final String baseUrl = 'http://127.0.0.1:8000/api/surveys';

  // Получить активный опрос
  Future<Survey> fetchActiveSurvey() async {
    final response = await http.get(Uri.parse('$baseUrl/active'));
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return Survey.fromJson(data);
    } else {
      throw Exception('Ошибка загрузки активного опроса');
    }
  }

  // Отправить голос пользователя
  Future<void> vote(String surveyId, String userId, Map<String, String> answers) async {
    final body = jsonEncode({
      'user_id': userId,
      'answers': answers,
    });

    final response = await http.post(
      Uri.parse('$baseUrl/$surveyId/vote'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception('Ошибка при голосовании');
    }
  }

  // Получить результаты опроса
  Future<PollResults> fetchSurveyResults(String surveyId) async {
    final response = await http.get(Uri.parse('$baseUrl/$surveyId/results'));
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return PollResults.fromJson(data);
    } else {
      throw Exception('Ошибка загрузки результатов опроса');
    }
  }
}