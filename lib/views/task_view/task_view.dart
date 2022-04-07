import 'package:app_example/database/models/task.dart';
import 'package:app_example/database/models/task_reminder.dart';
import 'package:app_example/providers/single_task_provider.dart';
import 'package:app_example/style/text_styles.dart';
import 'package:app_example/views/task_view/task_view_model.dart';
import 'package:app_example/views/task_view/widgets/mark_button_widget.dart';
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
    return Card(
        color: bgColor,
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text("Reminder #${reminder.id}",
                            style: TextStyles.heading),
                        Text(
                          DateFormat("dd.MM.yyyy HH:mm")
                              .format(reminder.scheduledOn),
                          style: TextStyles.subHeading,
                        )
                      ])),
                  Icon(isDone
                      ? Icons.thumb_up_off_alt
                      : Icons.thumb_down_off_alt)
                ])));
  }

  Widget _buildUnmarkedReminder(
      TaskReminder reminder, Color bgColor, WidgetRef ref) {
    return Dismissible(
        direction: DismissDirection.horizontal,
        onDismissed: (direction) =>
            _handleDismissed(direction, reminder.id, ref),
        background:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.thumb_up_off_alt,
                        size: 72, color: Colors.green.shade300),
                    Text("Done!", style: TextStyles.reminderDone)
                  ])),
          Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.thumb_down_off_alt,
                        size: 72, color: Colors.red.shade300),
                    Text("Skipped!", style: TextStyles.reminderSkipped)
                  ]))
        ]),
        key: Key(reminder.id.toString()),
        child: Card(
            color: bgColor,
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Reminder #${reminder.id}",
                          style: TextStyles.heading),
                      Text(
                          DateFormat("dd.MM.yyyy HH:mm")
                              .format(reminder.scheduledOn),
                          style: TextStyles.subHeading),
                      Container(height: 30),
                      _buildMarkButtons(reminder, ref),
                    ]))));
  }

  Widget _buildMarkButtons(TaskReminder reminder, WidgetRef ref) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MarkButtonWidget(
              backgroundColor: Colors.green.shade300,
              label: "Yes, I did it!",
              onPressed: () => viewModel.setReminderAsDone(reminder.id, ref),
              avatar: const Icon(Icons.thumb_up_off_alt, color: Colors.white)),
          MarkButtonWidget(
              backgroundColor: Colors.red.shade300,
              label: "I Skipped it",
              onPressed: () => viewModel.setReminderAsSkipped(reminder.id, ref),
              avatar: const Icon(Icons.thumb_down_off_alt, color: Colors.white))
        ]);
  }

  void _handleDismissed(
      DismissDirection direction, int reminderId, WidgetRef ref) {
    switch (direction) {
      case DismissDirection.vertical:
        break;
      case DismissDirection.horizontal:
        break;
      case DismissDirection.endToStart:
        viewModel.setReminderAsSkipped(reminderId, ref);
        break;
      case DismissDirection.startToEnd:
        viewModel.setReminderAsDone(reminderId, ref);
        break;
      case DismissDirection.up:
        break;
      case DismissDirection.down:
        break;
      case DismissDirection.none:
        break;
    }
  }
}
