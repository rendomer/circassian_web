import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/survey_model.dart';
import '../services/storage_service.dart';

class SurveyPage extends StatefulWidget {
  const SurveyPage({Key? key}) : super(key: key);

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  Survey? _survey;
  bool _loading = true;
  String? _error;
  Map<String, String> _selectedAnswers = {}; // questionId -> answerId
  bool _submitted = false;
  SurveyResults? _results;

  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserId().then((_) {
      if (_userId != null) {
        _fetchSurvey();
      }
    });
  }

  Future<void> _loadUserId() async {
    final storage = getServiceImpl();
    final id = await storage.getUserId();
    final password = await storage.getPassword();
    print('📦 Loaded userId from storage: $id');

    if (id == null || password == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/');
      });
    } else {
      setState(() {
        _userId = id;
      });
    }
  }

  Future<void> _fetchSurvey() async {
    try {
      final survey = await SurveyApiService.getActiveSurvey();
      setState(() {
        _survey = survey;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _submitVote() async {
    print('📨 Submit vote triggered');

    if (_userId == null || _survey == null) {
      print('❌ No userId or survey');
      setState(() {
        _error = 'Пользователь не авторизован или опрос не загружен';
      });
      return;
    }
    if (_selectedAnswers.length != (_survey?.questions.length ?? 0)) {
      setState(() {
        _error = 'Пожалуйста, ответьте на все вопросы';
      });
      return;
    }

    print('➡️ Отправляем: user_id=$_userId, survey_id=${_survey!.id}, answers=${_selectedAnswers}');

    setState(() {
      _error = null;
      _loading = true;
    });

    try {
      bool success = await SurveyApiService.voteInSurvey(
        _survey!.id,
        _userId!,
        _selectedAnswers
      );
      if (success) {
        final results = await SurveyApiService.getSurveyResults(_survey!.id);
        setState(() {
          _submitted = true;
          _results = results;
          _loading = false;
        });
      } else {
        setState(() {
          _error = 'Ошибка при отправке голосов';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
          appBar: AppBar(title: const Text('Опрос')),
          body: const Center(child: CircularProgressIndicator()));
    }
    if (_error != null) {
      return Scaffold(
          appBar: AppBar(title: const Text('Опрос')),
          body: Center(child: Text('Ошибка: $_error')));
    }
    if (_survey == null) {
      return Scaffold(
          appBar: AppBar(title: const Text('Опрос')),
          body: const Center(child: Text('Опрос не найден')));
    }

    return Scaffold(
      appBar: AppBar(title: Text(_survey!.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _submitted ? _buildResults() : _buildSurveyForm(),
      ),
      floatingActionButton: _submitted
          ? null
          : FloatingActionButton.extended(
              onPressed: _submitVote,
              label: const Text('Отправить голос'),
              icon: const Icon(Icons.send),
            ),
    );
  }

  Widget _buildSurveyForm() {
    return ListView(
      children: [
        if (_survey!.description.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(_survey!.description,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ),
        ..._survey!.questions.map((q) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(q.questionText,
                  style:
                      const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ...q.answers.map((a) {
                return RadioListTile<String>(
                  title: Text(a.answerText),
                  value: a.id,
                  groupValue: _selectedAnswers[q.id],
                  onChanged: (val) {
                    setState(() {
                      _selectedAnswers[q.id] = val!;
                    });
                  },
                );
              }).toList(),
              const SizedBox(height: 12),
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget _buildResults() {
    return ListView(
      children: [
        const Text(
          'Результаты опроса:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...?_results?.results.map((questionEntry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                questionEntry.question,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              ...questionEntry.answers.map((answer) {
                return Text('${answer.answer}: ${answer.count} голосов');
              }).toList(),
              const SizedBox(height: 12),
            ],
          );
        }).toList(),
      ],
    );
  }
}
