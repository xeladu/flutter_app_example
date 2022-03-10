import 'package:app_example/database/models/task.dart';
import 'package:app_example/navigation/navigation_service.dart';
import 'package:app_example/navigation/route_generator.dart';
import 'package:get/get.dart';

class HomeViewModel {
  Future goToTaskView(Task task) async {
    await Get.find<NavigationService>()
        .navigateTo(RouteGenerator.routeTask, task.id);
  }

  Future addNewTask() async {
    await Get.find<NavigationService>()
        .navigateTo(RouteGenerator.routeTaskEdit, null);
  }
}
