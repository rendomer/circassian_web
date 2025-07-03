import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class TestStoragePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final storage = getServiceImpl();

    return Scaffold(
      appBar: AppBar(title: Text('Тест StorageService')),
      body: Center(
        child: FutureBuilder<String>(
          future: _testStorage(storage),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            return Text(snapshot.data ?? 'Ничего не вернуло');
          },
        ),
      ),
    );
  }

  Future<String> _testStorage(StorageService storage) async {
    await storage.saveUserId('123456');
    final userId = await storage.getUserId();
    return 'Тип: ${storage.runtimeType}\nСохранили ID: $userId';
  }
}
