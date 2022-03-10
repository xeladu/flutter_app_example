import 'package:app_example/database/models/task.dart';
import 'package:app_example/providers/task_list_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// returns a Task object with the given id
final singleTaskProvider =
    FutureProvider.family<Task?, String>((ref, id) async {
  final tasks = ref.watch(taskListProvider);

  return (tasks.asData == null)
      ? null
      : tasks.asData!.value.firstWhere((element) => element.id == id);
});
