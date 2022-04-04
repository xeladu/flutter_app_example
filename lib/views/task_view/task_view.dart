import 'package:app_example/database/models/task.dart';
import 'package:app_example/database/models/task_reminder.dart';
import 'package:app_example/providers/single_task_provider.dart';
import 'package:app_example/views/task_view/task_view_model.dart';
import 'package:app_example/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class TaskView extends ConsumerWidget {
  final TaskViewModel viewModel;
  const TaskView(this.viewModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(singleTaskProvider(viewModel.taskId));

    return provider.when(
        data: (data) => _buildTaskDetails(data, ref),
        error: _buildErrorContent,
        loading: _buildLoadingContent);
  }

  Widget _buildLoadingContent() {
    return Scaffold(
        appBar: AppBar(title: const Text("TaskView")),
        body: const LoadingWidget());
  }

  Widget _buildErrorContent(Object? o, StackTrace? st) {
    return Scaffold(
        appBar: AppBar(title: const Text("TaskView")),
        body: ErrorWidget(o.toString()));
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
                  await viewModel.goToTaskEditView(ref);
                }),
            body: ListView.separated(
                padding: const EdgeInsets.all(10),
                separatorBuilder: (context, index) => Container(height: 10),
                itemCount: task.reminders.length,
                itemBuilder: ((context, index) => _buildReminderWidget(
                    task.reminders[task.reminders.length - index - 1], ref))));
  }

  Widget _buildReminderWidget(TaskReminder reminder, WidgetRef ref) {
    Color? color;
    switch (reminder.state) {
      case TaskReminderActionState.none:
        color = Colors.grey.shade300;
        return _buildUnmarkedReminder(reminder, color, ref);
      case TaskReminderActionState.done:
        color = Colors.green.shade200;
        return _buildMarkedReminder(reminder, color, true);
      case TaskReminderActionState.skipped:
        color = Colors.red.shade200;
        return _buildMarkedReminder(reminder, color, false);
      default:
        color = Colors.grey.shade300;
        return _buildUnmarkedReminder(reminder, color, ref);
    }
  }

  Widget _buildMarkedReminder(
      TaskReminder reminder, Color bgColor, bool isDone) {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text("Reminder #${reminder.id}"),
                Text(
                    DateFormat("dd.MM.yyyy HH:mm").format(reminder.scheduledOn))
              ])),
          Icon(isDone ? Icons.thumb_up_off_alt : Icons.thumb_down_off_alt)
        ]));
  }

  Widget _buildUnmarkedReminder(
      TaskReminder reminder, Color bgColor, WidgetRef ref) {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Reminder #${reminder.id}"),
          Text(DateFormat("dd.MM.yyyy HH:mm").format(reminder.scheduledOn)),
          Container(height: 30),
          _buildMarkButtons(reminder, ref),
        ]));
  }

  Widget _buildMarkButtons(TaskReminder reminder, WidgetRef ref) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ActionChip(
              backgroundColor: Colors.green.shade300,
              shadowColor: Colors.black,
              elevation: 3,
              avatar: const Icon(Icons.thumb_up_off_alt, color: Colors.white),
              label: const Text("Yes, I did it!",
                  style: TextStyle(color: Colors.white)),
              onPressed: () {
                viewModel.setReminderAsDone(reminder.id, ref);
              }),
          ActionChip(
              backgroundColor: Colors.red.shade300,
              shadowColor: Colors.black,
              elevation: 3,
              avatar: const Icon(Icons.thumb_down_off_alt, color: Colors.white),
              label: const Text("I Skipped it",
                  style: TextStyle(color: Colors.white)),
              onPressed: () {
                viewModel.setReminderAsSkipped(reminder.id, ref);
              }),
        ]);
  }
}
