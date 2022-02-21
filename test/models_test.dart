import 'dart:convert';

import 'package:app_example/database/models/skip_configuration.dart';
import 'package:app_example/database/models/task.dart';
import 'package:app_example/database/models/task_reminder.dart';
import 'package:app_example/database/models/task_reminder_configuration.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String json1 = """
    { 
        "id": "taskId1",
        "title": "test title 1",
        "description": "test description 1",
        "created": "20220220T200000+0100",
        "configuration": {
            "initialDate": "20220220T200000+0100",
            "recurringInterval": 86400,
            "enabled": true,
            "skipOn": {
                "monday": false,
                "tuesday": false,
                "wednesday": false,
                "thursday": false,
                "friday": false,
                "saturday": true,
                "sunday": true
            }
        },
        "reminders": [
            {
                "id": "taskReminderId1",
                "scheduledOn": "20220220T200000+0100",
                "state": 1
            },
            {
                "id": "taskReminderId2",
                "scheduledOn": "20220221T200000+0100",
                "state": 2
            },
            {
                "id": "taskReminderId3",
                "scheduledOn": "20220222T200000+0100",
                "state": 0
            },
            {
                "id": "taskReminderId4",
                "scheduledOn": "20220223T200000+0100",
                "state": 0
            }
        ]
    }
    """;

  const String json2 = """
    {
        "id": "taskId2",
        "title": "test title 2",
        "description": "test description 2",
        "created": "20220220T200000+0100",
        "configuration": {
            "initialDate": null,
            "recurringInterval": null,
            "enabled": false,
            "skipOn": {}
        },
        "reminders": []
    }
    """;

  test("Verify object deserialization 1", () {
    var task = Task.fromJson(jsonDecode(json1));

    expect("taskId1", task.id);
    expect("test title 1", task.title);
    expect("test description 1", task.description);
    expect(DateTime.utc(2022, 02, 20, 19, 0, 0), task.created);
    expect(
        DateTime.utc(2022, 02, 20, 19, 0, 0), task.configuration.initialDate);
    expect(86400, task.configuration.recurringInterval!.inSeconds);
    expect(true, task.configuration.enabled);
    expect(false, task.configuration.skipOn.monday);
    expect(false, task.configuration.skipOn.tuesday);
    expect(false, task.configuration.skipOn.wednesday);
    expect(false, task.configuration.skipOn.thursday);
    expect(false, task.configuration.skipOn.friday);
    expect(true, task.configuration.skipOn.saturday);
    expect(true, task.configuration.skipOn.sunday);
    expect(
        2,
        task.reminders
            .where((x) => x.state == TaskReminderActionState.none)
            .length);
    expect(
        1,
        task.reminders
            .where((x) => x.state == TaskReminderActionState.done)
            .length);
    expect(
        1,
        task.reminders
            .where((x) => x.state == TaskReminderActionState.skipped)
            .length);
  });

  test("Verify object deserialization 2", () {
    var task = Task.fromJson(jsonDecode(json2));

    expect("taskId2", task.id);
    expect("test title 2", task.title);
    expect("test description 2", task.description);
    expect(DateTime.utc(2022, 02, 20, 19, 0, 0), task.created);
    expect(null, task.configuration.initialDate);
    expect(null, task.configuration.recurringInterval);
    expect(false, task.configuration.enabled);
    expect(false, task.configuration.skipOn.monday);
    expect(false, task.configuration.skipOn.tuesday);
    expect(false, task.configuration.skipOn.wednesday);
    expect(false, task.configuration.skipOn.thursday);
    expect(false, task.configuration.skipOn.friday);
    expect(false, task.configuration.skipOn.saturday);
    expect(false, task.configuration.skipOn.sunday);
    expect(0, task.reminders.length);
  });

  test("Verify serialization and deserialization", () {
    var expected = Task(
        created: DateTime.now(),
        id: "1",
        title: "title",
        description: "description",
        configuration: TaskReminderConfiguration(
            enabled: true,
            initialDate: DateTime.now(),
            recurringInterval: const Duration(days: 1),
            skipOn: const SkipConfiguration.empty()),
        reminders: <TaskReminder>[
          TaskReminder(
              id: "11",
              scheduledOn: DateTime.now(),
              state: TaskReminderActionState.none),
          TaskReminder(
              id: "22",
              scheduledOn: DateTime.now(),
              state: TaskReminderActionState.done),
          TaskReminder(
              id: "33",
              scheduledOn: DateTime.now(),
              state: TaskReminderActionState.skipped)
        ]);

    var actual = Task.fromJson(jsonDecode(jsonEncode(expected.toJson())));

    expect(actual, expected);
  });
}
