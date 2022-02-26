import 'package:app_example/database/database_service.dart';
import 'package:app_example/database/models/task.dart';
import 'package:app_example/database/models/task_reminder.dart';
import 'package:app_example/database/models/task_reminder_configuration.dart';
import 'package:app_example/navigation/route_generator.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<HomeView> {
  final DatabaseService _dbService = DatabaseService();
  List<Task> _taskList = <Task>[];

  @override
  void initState() {
    super.initState();

    _dbService.getAllTasks().then((value) {
      setState(() {
        _taskList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Home View")),
        body: Center(
            child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
                onPressed: () async => await Navigator.pushNamed(
                    context, RouteGenerator.routeTask),
                child: const Text("Go to Task View")),
            Container(height: 10),
            ElevatedButton(
                onPressed: () async => await Navigator.pushNamed(
                    context, RouteGenerator.routeTaskEdit),
                child: const Text("Go to Task Edit View")),
            Container(height: 10),
            ElevatedButton(
                onPressed: () async => await Navigator.pushNamed(
                    context, RouteGenerator.routeError),
                child: const Text("Go to Error View")),
            Container(height: 30),
            ElevatedButton(
                onPressed: () async => await addRandomTask(),
                child: const Text("Add random task")),
            Container(height: 10),
            ElevatedButton(
                onPressed: () async => await deleteLatestTask(),
                child: const Text("Remove latest task")),
            Container(height: 30),
            Text("There are ${_taskList.length} tasks in the database")
          ]),
        )));
  }

  Future addRandomTask() async {
    await _dbService.addTask(Task(
        id: UniqueKey().toString(),
        title: "test",
        description: "description",
        created: DateTime.now(),
        configuration: const TaskReminderConfiguration.empty(),
        reminders: const <TaskReminder>[]));

    var res = await _dbService.getAllTasks();

    setState(() {
      _taskList = res;
    });
  }

  Future deleteLatestTask() async {
    if (_taskList.isEmpty) return;

    await _dbService.removeTask(_taskList.last);
    var res = await _dbService.getAllTasks();

    setState(() {
      _taskList = res;
    });
  }
}
