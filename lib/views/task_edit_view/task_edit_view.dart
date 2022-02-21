import 'package:flutter/material.dart';

class TaskEditView extends StatelessWidget {
  const TaskEditView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Task Edit View")),
        body: Center(
            child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Go back")),
          ]),
        )));
  }
}
