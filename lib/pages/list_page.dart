import 'package:flutter/material.dart';
import 'poll_model.dart';
import 'poll_service.dart';

class PollListPage extends StatefulWidget {
  @override
  _PollListPageState createState() => _PollListPageState();
}

class _PollListPageState extends State<PollListPage> {
  final PollService pollService = PollService();
  late Future<List<Poll>> pollsFuture;

  @override
  void initState() {
    super.initState();
    pollsFuture = pollService.fetchPolls();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Опросы')),
      body: FutureBuilder<List<Poll>>(
        future: pollsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (snapshot.hasError)
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          if (!snapshot.hasData || snapshot.data!.isEmpty)
            return Center(child: Text('Опросов пока нет'));

          final polls = snapshot.data!;
          return ListView.builder(
            itemCount: polls.length,
            itemBuilder: (context, index) {
              final poll = polls[index];
              return ListTile(
                title: Text(poll.title),
                subtitle: Text(poll.question),
                onTap: () {
                  // сюда можно добавить переход на экран голосования или результатов
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // открыть страницу создания опроса
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
