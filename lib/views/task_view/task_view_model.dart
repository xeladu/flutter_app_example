import 'package:app_example/database/models/task.dart';
import 'package:app_example/navigation/navigation_service.dart';
import 'package:app_example/navigation/route_generator.dart';
import 'package:get/get.dart';

class TaskViewModel {
  final String taskId;

  TaskViewModel(this.taskId);

  Future goToTaskEditView(Task task) async {
    await Get.find<NavigationService>()
        .navigateTo(RouteGenerator.routeTaskEdit, task);
  }

  void goBack() {
    Get.find<NavigationService>().pop();
  }
}
