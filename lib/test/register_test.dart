import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> registerUser() async {
  final url = Uri.parse('http://127.0.0.1:8000/api/users/register');

  final Map<String, dynamic> userData = {
    "first_name": "Тест",
    "last_name": "Пользователь",
    "email": "test@test.com",
    "phone": "1234567890",
    "password": "qwerty",
  };

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode(userData),
  );

  if (response.statusCode == 200) {
    print('Успешная регистрация: ${response.body}');
  } else {
    print('Ошибка регистрации: ${response.statusCode}');
    print('Ответ сервера: ${response.body}');
  }
}
 #void main() {
  registerUser(); // временный вызов
  runApp(MyApp());
}
#