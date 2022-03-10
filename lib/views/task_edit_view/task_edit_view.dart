import 'package:app_example/views/task_edit_view/task_edit_view_model.dart';
import 'package:flutter/material.dart';

class TaskEditView extends StatefulWidget {
  final TaskEditViewModel viewModel;

  const TaskEditView(this.viewModel, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<TaskEditView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _firstReminderController =
      TextEditingController();
  final TextEditingController _nextRemindersController =
      TextEditingController();

  String? _firstReminderErrorText;
  String? _nextReminderErrorText;

  @override
  Widget build(BuildContext context) {
    _titleController.text = widget.viewModel.title;
    _descriptionController.text = widget.viewModel.description;

    return Scaffold(
        appBar:
            AppBar(title: Text("Task Edit View - ${widget.viewModel.title}")),
        body: ListView(padding: const EdgeInsets.all(10), children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(label: Text("Title")),
            onChanged: (value) {
              widget.viewModel.title = value;
            },
          ),
          Container(height: 10),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(label: Text("Description")),
            onChanged: (value) {
              widget.viewModel.description = value;
            },
          ),
          Container(height: 20),
          const Text("Reminders",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Container(height: 10),
          TextField(
            controller: _firstReminderController,
            decoration: InputDecoration(
                errorText: _firstReminderErrorText,
                hintText: "yyyy/MM/dd HH:mm",
                label: const Text("First reminder on")),
            onChanged: (value) {
              var dt = DateTime.tryParse(value);
              if (dt == null) {
                _firstReminderErrorText = "Wrong format!";
              } else {
                _firstReminderErrorText = null;
                widget.viewModel.firstReminder = dt;
              }
              _refreshUi();
            },
          ),
          Container(height: 10),
          TextField(
            controller: _nextRemindersController,
            decoration: InputDecoration(
                errorText: _nextReminderErrorText,
                hintText: "number in seconds (86400 = 1 day)",
                label: const Text("Next reminders interval")),
            onChanged: (value) {
              var dur = int.tryParse(value);
              if (dur == null) {
                _nextReminderErrorText = "Enter interval in seconds!";
              } else {
                _nextReminderErrorText = null;
                widget.viewModel.reminderInterval = Duration(seconds: dur);
              }
              _refreshUi();
            },
          ),
          Container(height: 20),
          const Text("Select days to be skipped",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Container(height: 10),
          SwitchListTile(
              visualDensity: VisualDensity.compact,
              dense: true,
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text("Mondays"),
              contentPadding: EdgeInsets.zero,
              value: widget.viewModel.skipMondays,
              onChanged: (value) {
                widget.viewModel.skipMondays = value;
                _refreshUi();
              }),
          SwitchListTile(
              visualDensity: VisualDensity.compact,
              dense: true,
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text("Tuesdays"),
              contentPadding: EdgeInsets.zero,
              value: widget.viewModel.skipTuesdays,
              onChanged: (value) {
                widget.viewModel.skipTuesdays = value;
                _refreshUi();
              }),
          SwitchListTile(
              visualDensity: VisualDensity.compact,
              dense: true,
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text("Wednesdays"),
              contentPadding: EdgeInsets.zero,
              value: widget.viewModel.skipWednesdays,
              onChanged: (value) {
                widget.viewModel.skipWednesdays = value;
                _refreshUi();
              }),
          SwitchListTile(
              visualDensity: VisualDensity.compact,
              dense: true,
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text("Thursdays"),
              contentPadding: EdgeInsets.zero,
              value: widget.viewModel.skipThursdays,
              onChanged: (value) {
                widget.viewModel.skipThursdays = value;
                _refreshUi();
              }),
          SwitchListTile(
              visualDensity: VisualDensity.compact,
              dense: true,
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text("Fridays"),
              contentPadding: EdgeInsets.zero,
              value: widget.viewModel.skipFridays,
              onChanged: (value) {
                widget.viewModel.skipFridays = value;
                _refreshUi();
              }),
          SwitchListTile(
              visualDensity: VisualDensity.compact,
              dense: true,
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text("Saturdays"),
              contentPadding: EdgeInsets.zero,
              value: widget.viewModel.skipSaturdays,
              onChanged: (value) {
                widget.viewModel.skipSaturdays = value;
                _refreshUi();
              }),
          SwitchListTile(
              visualDensity: VisualDensity.compact,
              dense: true,
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text("Sundays"),
              contentPadding: EdgeInsets.zero,
              value: widget.viewModel.skipSundays,
              onChanged: (value) {
                widget.viewModel.skipSundays = value;
                _refreshUi();
              }),
          CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text("Task enabled?"),
              subtitle: const Text("Click to enable or disable this task"),
              value: widget.viewModel.enabled,
              onChanged: (value) {
                widget.viewModel.enabled =
                    value != null && value ? true : false;
                _refreshUi();
              }),
          Container(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Row(children: [
                  const Icon(Icons.arrow_back),
                  Container(width: 10),
                  const Text("Go back")
                ])),
            ElevatedButton(
                onPressed: () async {
                  await widget.viewModel.save();
                  Navigator.pop(context);
                },
                child: Row(children: [
                  const Icon(Icons.check),
                  Container(width: 10),
                  const Text("Save")
                ]))
          ]),
        ]));
  }

  void _refreshUi() {
    setState(() {});
  }
}
