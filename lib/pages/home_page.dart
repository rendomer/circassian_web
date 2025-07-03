import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../widgets/flag_logo.dart';
import 'edit_profile_page.dart';
import '../services/api_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _userEmail;
  int _registeredCount = 0;

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
    _loadStatistics();
  }

  Future<void> _loadUserEmail() async {
    final storage = getServiceImpl();
    final email = await storage.getEmail();
    setState(() {
      _userEmail = email;
    });
  }

  Future<void> _loadStatistics() async {
    final stats = await ApiService.fetchStatistics();
    setState(() {
      _registeredCount = stats['active_users'] ?? 0;
    });
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Выход'),
        content: Text('Вы действительно хотите выйти?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Отмена'),
          ),
          TextButton(
            onPressed: () async {
              final storage = getServiceImpl();
              await storage.clear();
              Navigator.pop(ctx);
              Navigator.pushReplacementNamed(context, '/');
            },
            child: Text('Выйти'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: FlagLogo(),
        title: Text('Главная'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            tooltip: 'Редактировать профиль',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfilePage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Выйти',
            onPressed: _confirmLogout,
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                _userEmail != null
                    ? 'Добро пожаловать, $_userEmail!'
                    : 'Добро пожаловать в CherkessNet!',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),

              // 👇 Счётчик Черкесов — интерактивный!
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/statistics');
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Зарегистрированных черкесов:',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        '$_registeredCount',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                        ),
                      ),
                      Text(
                        'Посмотреть подробнее',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton.icon(
                icon: Icon(Icons.people),
                label: Text('Список пользователей'),
                onPressed: () {
                  Navigator.pushNamed(context, '/users-list');
                },
              ),

              const SizedBox(height: 20),

              ElevatedButton.icon(
                icon: Icon(Icons.poll),
                label: Text('Пройти опрос'),
                onPressed: () {
                  Navigator.pushNamed(context, '/survey');
                },
              ),

              const SizedBox(height: 20),

              ElevatedButton.icon(
                icon: Icon(Icons.archive),
                label: Text('Архив опросов'),
                onPressed: () {
                  Navigator.pushNamed(context, '/survey-archive');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
