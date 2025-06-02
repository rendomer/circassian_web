import 'package:flutter/material.dart';

void main() {
  runApp(const CherkessApp());
}

class CherkessApp extends StatelessWidget {
  const CherkessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cherkess Net',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Scaffold(
        body: Center(child: Text('Cherkess Net')),
      ),
    );
  }
}