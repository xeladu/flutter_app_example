import 'package:app_example/database/models/task.dart';
import 'package:app_example/providers/task_list_provider.dart';
import 'package:app_example/views/home_view/home_view_model.dart';
import 'package:app_example/wigets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeView extends ConsumerWidget {
  final HomeViewModel viewModel;

  const HomeView(this.viewModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              await viewModel.addNewTask();
              ref.refresh(taskListProvider);
            },
            child: const Icon(Icons.add)),
        body: data.isEmpty
            ? const Center(child: Text("No data found!"))
            : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final item = data[index];

                  return Card(
                      child: ListTile(
                    onTap: () async {
                      await viewModel.goToTaskView(item);
                      ref.refresh(taskListProvider);
                    },
                    title: Text(item.title),
                    subtitle: Text(item.description),
                    isThreeLine: true,
                    leading: const Icon(Icons.notifications),
                  ));
                }));
  }
}
