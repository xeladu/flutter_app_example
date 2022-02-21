import 'package:app_example/database/models/task_reminder_configuration.dart';
import 'package:app_example/database/models/task_reminder.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Task extends Equatable {
  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.created,
    required this.configuration,
    required this.reminders,
  });

  final String id;
  final String title;
  final String description;
  final DateTime created;
  final TaskReminderConfiguration configuration;
  final List<TaskReminder> reminders;

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json.containsKey("id") ? json["id"] : "",
        title: json.containsKey("title") ? json["title"] : "",
        description: json.containsKey("description") ? json["description"] : "",
        created: json.containsKey("created")
            ? DateTime.parse(json["created"].toString())
            : DateTime.fromMicrosecondsSinceEpoch(1, isUtc: true),
        configuration: json.containsKey("configuration")
            ? TaskReminderConfiguration.fromJson(json["configuration"])
            : const TaskReminderConfiguration.empty(),
        reminders: json.containsKey("reminders")
            ? List<TaskReminder>.from(
                json["reminders"].map((x) => TaskReminder.fromJson(x)))
            : <TaskReminder>[],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "created": created.toIso8601String(),
        "configuration": configuration.toJson(),
        "reminders": List<dynamic>.from(reminders.map((x) => x.toJson())),
      };

  @override
  List<Object?> get props =>
      [id, title, description, created, configuration, reminders];
}
