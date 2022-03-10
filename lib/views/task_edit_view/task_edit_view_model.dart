import 'package:app_example/database/database_service.dart';
import 'package:app_example/database/models/skip_configuration.dart';
import 'package:app_example/database/models/task.dart';
import 'package:app_example/database/models/task_reminder.dart';
import 'package:app_example/database/models/task_reminder_configuration.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class TaskEditViewModel {
  final Task? task;
  late String title;
  late String description;
  late DateTime? firstReminder;
  late Duration? reminderInterval;
  late bool skipMondays;
  late bool skipTuesdays;
  late bool skipWednesdays;
  late bool skipThursdays;
  late bool skipFridays;
  late bool skipSaturdays;
  late bool skipSundays;
  late bool enabled;

  TaskEditViewModel(this.task) {
    title = task?.title ?? "";
    description = task?.description ?? "";
    firstReminder = task?.configuration.initialDate;
    reminderInterval = task?.configuration.recurringInterval;
    skipMondays = task?.configuration.skipOn.monday ?? false;
    skipTuesdays = task?.configuration.skipOn.tuesday ?? false;
    skipWednesdays = task?.configuration.skipOn.wednesday ?? false;
    skipThursdays = task?.configuration.skipOn.thursday ?? false;
    skipFridays = task?.configuration.skipOn.friday ?? false;
    skipSaturdays = task?.configuration.skipOn.saturday ?? false;
    skipSundays = task?.configuration.skipOn.sunday ?? false;
    enabled = task?.configuration.enabled ?? false;
  }

  Future save() async {
    var newTask = Task(
        id: task?.id ?? UniqueKey().toString(),
        title: title,
        description: description,
        created: task?.created ?? DateTime.now(),
        configuration: TaskReminderConfiguration(
            enabled: enabled,
            initialDate: firstReminder,
            recurringInterval: reminderInterval,
            skipOn: SkipConfiguration(
                monday: skipMondays,
                tuesday: skipTuesdays,
                wednesday: skipWednesdays,
                thursday: skipThursdays,
                friday: skipFridays,
                saturday: skipSaturdays,
                sunday: skipSundays)),
        reminders: task?.reminders ?? <TaskReminder>[]);

    var dbService = Get.find<DatabaseService>();

    if (task == null) {
      await dbService.addTask(newTask);
    } else {
      await dbService.replaceTask(task!, newTask);
    }
  }
}
