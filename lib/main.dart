import 'package:flutter/material.dart';
import 'services/storage_service.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/home_page.dart';
import 'pages/edit_profile_page.dart';
import 'pages/survey_page.dart';
import 'pages/survey_archive_page.dart';
import 'pages/users_list_page.dart';
import 'pages/statistics_page.dart';
import 'pages/survey_results_page.dart';
import 'pages/forgot_password_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = getServiceImpl();
  final email = await storage.getEmail();

  runApp(MyApp(isLoggedIn: email != null));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CherkessNet',
      initialRoute: isLoggedIn ? '/home' : '/',
      routes: {
        '/': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => HomePage(),
        '/survey': (context) => SurveyPage(),
        '/survey-archive': (context) => SurveyArchivePage(),
        '/users-list': (context) => UsersListPage(),
        '/statistics': (context) => StatisticsPage(),
        '/survey-results': (context) => SurveyResultsPage(
              surveyId: ModalRoute.of(context)!.settings.arguments as String,
            ),
        '/edit-profile': (context) => EditProfilePage(),
        '/forgot-password': (context) => ForgotPasswordPage(),
      },
    );
  }
}
