import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class TaskReminder extends Equatable {
  const TaskReminder({
    required this.id,
    required this.scheduledOn,
    required this.state,
  });

  final String id;
  final DateTime scheduledOn;
  final TaskReminderActionState state;

  factory TaskReminder.fromJson(Map<String, dynamic> json) => TaskReminder(
        id: json.containsKey("id") ? json["id"] : "",
        scheduledOn: json.containsKey("scheduledOn")
            ? DateTime.parse(json["scheduledOn"].toString())
            : DateTime.fromMicrosecondsSinceEpoch(1, isUtc: true),
        state: json.containsKey("state")
            ? TaskReminderActionState.values[json["state"]]
            : TaskReminderActionState.none,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "scheduledOn": scheduledOn.toIso8601String(),
        "state": state.index,
      };

  @override
  List<Object?> get props => [id, scheduledOn, state];
}

enum TaskReminderActionState { none, skipped, done }
