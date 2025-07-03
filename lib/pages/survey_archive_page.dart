import 'package:flutter/material.dart';
import '../models/survey_model.dart';
import '../services/api_service.dart';
import 'survey_page.dart';
import 'package:cherkess_net/pages/survey_results_page.dart';

class SurveyArchivePage extends StatefulWidget {
  @override
  _SurveyArchivePageState createState() => _SurveyArchivePageState();
}

class _SurveyArchivePageState extends State<SurveyArchivePage> {
  late Future<List<Survey>> surveysFuture;

  @override
  void initState() {
    super.initState();
    surveysFuture = SurveyApiService.fetchSurveyArchive();
  }

  void _openSurvey(Survey survey) {
    if (survey.isActive) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => SurveyPage()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SurveyResultsPage(surveyId: survey.id),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Архив опросов')),
      body: FutureBuilder<List<Survey>>(
        future: surveysFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Нет архивных опросов'));
          }

          final surveys = snapshot.data!;
          return ListView.builder(
            itemCount: surveys.length,
            itemBuilder: (context, index) {
              final survey = surveys[index];
              return ListTile(
                title: Text(survey.title),
                subtitle: Text(survey.description),
                onTap: () => _openSurvey(survey),
              );
            },
          );
        },
      ),
    );
  }
}