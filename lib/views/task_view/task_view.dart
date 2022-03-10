import 'package:app_example/database/models/task.dart';
import 'package:app_example/database/models/task_reminder.dart';
import 'package:app_example/providers/single_task_provider.dart';
import 'package:app_example/providers/task_list_provider.dart';
import 'package:app_example/views/task_view/task_view_model.dart';
import 'package:app_example/wigets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class TaskView extends ConsumerWidget {
  final TaskViewModel viewModel;
  const TaskView(this.viewModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final task = ref.watch(singleTaskProvider(viewModel.taskId));

    return task.when(
        data: (data) => _buildTaskDetails(data, ref),
        error: (Object o, StackTrace? st) => Scaffold(
            appBar: AppBar(title: const Text("Task View")),
            body: ErrorWidget(o.toString())),
        loading: () => Scaffold(
            appBar: AppBar(title: const Text("Task View")),
            body: const LoadingWidget()));
  }

  Widget _buildTaskDetails(Task? task, WidgetRef ref) {
    return task == null
        ? Scaffold(
            appBar: AppBar(title: const Text("Task View")),
            body: ErrorWidget("Error"))
        : Scaffold(
            appBar: AppBar(title: Text("Task View - ${task.title}")),
            floatingActionButton: FloatingActionButton(
                heroTag: null,
                child: const Icon(Icons.edit),
                onPressed: () async {
                  await viewModel.goToTaskEditView(task);
                  ref.refresh(taskListProvider);
                }),
            body: ListView(padding: const EdgeInsets.all(10), children: [
              Text(
                  "Task created on ${DateFormat("dd.MM.yyyy HH:mm").format(task.created)}"),
              Container(height: 10),
              Text(
                  "Task active since ${DateFormat("dd.MM.yyyy HH:mm").format(task.configuration.initialDate ?? DateTime.now())}"),
              Container(height: 10),
              const Text("Past reminders",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Container(height: 10),
              ..._buildPastReminders(task),
              const Text("Upcoming reminders",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Container(height: 10),
              ..._buildUpcomingReminders(task),
              ElevatedButton(
                  onPressed: () => viewModel.goBack(),
                  child: const Text("Go back")),
            ]));
  }

  List<Widget> _buildPastReminders(Task task) {
    var widgets = <Widget>[];
    for (var reminder in task.reminders
        .where((element) => element.state != TaskReminderActionState.none)) {
      widgets.add(Text(
          "Task on ${DateFormat("dd.MM.yyyy HH:mm").format(reminder.scheduledOn)} was ${(reminder.state == TaskReminderActionState.skipped) ? "skipped" : "confirmed"}"));
      widgets.add(Container(height: 10));
    }

    return widgets;
  }

  List<Widget> _buildUpcomingReminders(Task task) {
    var widgets = <Widget>[];
    for (var reminder in task.reminders
        .where((element) => element.state == TaskReminderActionState.none)) {
      widgets.add(Text(
          "Task due on ${DateFormat("dd.MM.yyyy HH:mm").format(reminder.scheduledOn)}"));
      widgets.add(Container(height: 10));
    }

    return widgets;
  }
}
