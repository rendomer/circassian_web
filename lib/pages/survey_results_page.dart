import 'package:flutter/material.dart';
import '../models/survey_model.dart';
import '../services/api_service.dart';

class SurveyResultsPage extends StatefulWidget {
  final String surveyId;

  const SurveyResultsPage({required this.surveyId, Key? key}) : super(key: key);

  @override
  State<SurveyResultsPage> createState() => _SurveyResultsPageState();
}

class _SurveyResultsPageState extends State<SurveyResultsPage> {
  SurveyResults? _results;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchResults();
  }

  Future<void> _fetchResults() async {
    try {
      final results = await SurveyApiService.getSurveyResults(widget.surveyId);
      setState(() {
        _results = results;
        _loading = false;
      });
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
        appBar: AppBar(title: const Text('Результаты опроса')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Результаты опроса')),
        body: Center(child: Text('Ошибка: $_error')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Результаты опроса')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildResults(),
      ),
    );
  }

  Widget _buildResults() {
    return ListView(
      children: [
        const Text(
          'Результаты:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...?_results?.results.map((q) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                q.question,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              ...q.answers.map((a) {
                return Text('${a.answer}: ${a.count} голосов');
              }).toList(),
              const SizedBox(height: 12),
            ],
          );
        }).toList(),
      ],
    );
  }
}
