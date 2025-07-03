import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();

  String _message = '';
  bool _isRequesting = false;
  bool _isConfirming = false;
  bool _resetRequested = false;

  Future<void> _requestReset() async {
    setState(() {
      _isRequesting = true;
      _message = '';
    });

    try {
      final url = Uri.parse('http://127.0.0.1:8000/request-reset');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': _emailController.text.trim()}),
      );

      final data = jsonDecode(utf8.decode(response.bodyBytes));
      if (response.statusCode == 200) {
        setState(() {
          _resetRequested = true;
          _message = data['message'] ?? 'Код отправлен на email';
        });
      } else {
        setState(() {
          _message = data['detail'] ?? 'Ошибка запроса';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Ошибка: $e';
      });
    } finally {
      setState(() {
        _isRequesting = false;
      });
    }
  }

  Future<void> _confirmReset() async {
    setState(() {
      _isConfirming = true;
      _message = '';
    });

    try {
      final url = Uri.parse('http://127.0.0.1:8000/reset');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _emailController.text.trim(),
          'code': _codeController.text.trim(),
          'new_password': _newPasswordController.text.trim(),
        }),
      );

     final data = jsonDecode(utf8.decode(response.bodyBytes));
      if (response.statusCode == 200) {
        setState(() {
          _message = data['message'] ?? 'Пароль успешно изменён!';
        });
        await Future.delayed(const Duration(seconds: 1));
        Navigator.pushReplacementNamed(context, '/');
      } else {
        setState(() {
          _message = data['detail'] ?? 'Ошибка подтверждения';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Ошибка: $e';
      });
    } finally {
      setState(() {
        _isConfirming = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Восстановление пароля')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              if (_resetRequested) ...[
                const SizedBox(height: 16),
                TextField(
                  controller: _codeController,
                  decoration: const InputDecoration(labelText: 'Код из email'),
                ),
                TextField(
                  controller: _newPasswordController,
                  decoration: const InputDecoration(labelText: 'Новый пароль'),
                  obscureText: true,
                ),
              ],
              const SizedBox(height: 16),
              if (_message.isNotEmpty)
                Text(
                  _message,
                  style: TextStyle(
                    color: _message.contains('успешно') ? Colors.green : Colors.red,
                  ),
                ),
              const SizedBox(height: 16),
              if (!_resetRequested)
                _isRequesting
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _requestReset,
                        child: const Text('Отправить код'),
                      ),
              if (_resetRequested)
                _isConfirming
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _confirmReset,
                        child: const Text('Сбросить пароль'),
                      ),
            ],
          ),
        ),
      ),
    );
  }
}
