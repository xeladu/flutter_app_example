import 'package:app_example/database/models/task.dart';
import 'package:app_example/navigation/navigation_service.dart';
import 'package:app_example/navigation/route_generator.dart';
import 'package:app_example/notification/notification_service.dart';
import 'package:app_example/providers/reminder_update_provider.dart';
import 'package:app_example/providers/reminder_update_state_provider.dart';
import 'package:app_example/providers/task_list_provider.dart';
import 'package:app_example/views/home_view/home_view_model.dart';
import 'package:app_example/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class HomeView extends ConsumerStatefulWidget {
  final HomeViewModel viewModel;

  const HomeView(this.viewModel, {Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();

    // navigates to the task page with the given id
    NotificationService.notificationsList.stream.listen((event) {
      Get.find<NavigationService>()
          .navigateTo(RouteGenerator.routeTask, arguments: int.parse(event));
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(taskListProvider);

    return provider.when(
        loading: _buildLoadingContent,
        error: _buildErrorContent,
        data: (data) => _buildDataContent(data, ref));
  }

  Widget _buildLoadingContent() {
    return Scaffold(
        appBar: AppBar(title: const Text("HomeView")),
        body: const LoadingWidget());
  }

  Widget _buildErrorContent(Object? o, StackTrace? st) {
    return Scaffold(
        appBar: AppBar(title: const Text("HomeView")),
        body: ErrorWidget(o.toString()));
  }

  Widget _buildDataContent(List<Task> data, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(title: const Text("HomeView")),
        floatingActionButton: FloatingActionButton(
            heroTag: null,
            onPressed: () async {
              await widget.viewModel.addNewTask(ref);
              ref.refresh(taskListProvider);
            },
            child: const Icon(Icons.add)),
        body: data.isEmpty
            ? const Center(
                child: Text(
                    "No data found!\r\nCreate your first task right now!",
                    textAlign: TextAlign.center))
            : Stack(children: [
                ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final item = data[index];

                      return Card(
                          child: ListTile(
                        onLongPress: () async {
                          await widget.viewModel.deleteTask(item);
                          ref.refresh(taskListProvider);
                        },
                        onTap: () async {
                          await widget.viewModel.goToTaskView(item.id);
                        },
                        title: Text(item.title),
                        subtitle: Text(item.description),
                        isThreeLine: true,
                        leading: const Icon(Icons.notifications),
                      ));
                    }),
                _buildUpdateIndicator()
              ]));
  }

  Widget _buildUpdateIndicator() {
    final updateDone = ref.watch(reminderUpdateStateProvider);

    if (updateDone) return Container();

    final provider = ref.watch(reminderUpdateProvider);
    return provider.when(
        data: (data) => Container(),
        error: (o, s) => Container(),
        loading: () => Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.all(10),
                child: const Text("Updating reminders..."))));
  }
}
