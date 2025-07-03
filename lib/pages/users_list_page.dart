import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class UsersListPage extends StatefulWidget {
  @override
  _UsersListPageState createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {
  late Future<List<User>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final storage = getServiceImpl();
    final myId = await storage.getUserId();
    if (myId == null) return;

    setState(() {
      _usersFuture = ApiService.listUsers(myId);
    });
  }

  Future<void> _confirmUser(String userId) async {
    final storage = getServiceImpl();
    final myId = await storage.getUserId();

    if (myId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: не найден мой ID!')),
      );
      return;
    }

    final success = await ApiService.confirmUser(userId, myId);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Пользователь подтверждён!')),
      );
      _loadUsers();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка подтверждения')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
      future: _usersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: Text('Список черкесов')),
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text('Список черкесов')),
            body: Center(child: Text('Ошибка: ${snapshot.error}')),
          );
        }

        final users = snapshot.data ?? [];
        final confirmedCount = users.where((u) => u.iHaveConfirmed).length;

        return Scaffold(
          appBar: AppBar(
            title: Text('Список черкесов'),
            actions: [
              IconButton(
                icon: Icon(Icons.home),
                tooltip: 'На главную',
                onPressed: () => Navigator.pop(context),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(24),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'Подтверждённых: $confirmedCount из ${users.length}',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ),
          ),
          body: users.isEmpty
              ? Center(child: Text('Нет пользователей'))
              : ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      title: Text('${user.firstName} ${user.lastName}'),
                      subtitle: Text(
                        'ID: ${user.id}\n'
                        'Детей: ${user.childrenCount ?? 0}\n'
                        'Подтверждений: ${user.confirmationsCount ?? 0}',
                      ),
                      trailing: user.iHaveConfirmed
                          ? Icon(Icons.check, color: Colors.green)
                          : (user.id != null
                              ? TextButton(
                                  onPressed: () => _confirmUser(user.id!),
                                  child: Text('Подтвердить'),
                                )
                              : Text('Нет ID', style: TextStyle(color: Colors.red))),
                    );
                  },
                ),
        );
      },
    );
  }
}
