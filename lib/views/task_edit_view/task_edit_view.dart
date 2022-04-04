import 'package:app_example/views/task_edit_view/task_edit_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

class TaskEditView extends StatefulWidget {
  final TaskEditViewModel viewModel;

  const TaskEditView(this.viewModel, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<TaskEditView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.viewModel.title;
    _descriptionController.text = widget.viewModel.description;
    _dateController.text =
        DateFormat("yyyy-MM-dd HH:mm").format(widget.viewModel.firstExecution);
  }

  @override
  Widget build(BuildContext context) {
    final pageName = widget.viewModel.task == null
        ? "Create new task"
        : "Edit task ${widget.viewModel.title}";
    return Scaffold(
        appBar: AppBar(title: Text(pageName)),
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
          const Text("First reminder on",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Row(children: [
            Expanded(
                child: Text(DateFormat("yyyy-MM-dd HH:mm")
                    .format(widget.viewModel.firstExecution))),
            IconButton(
                onPressed: () async {
                  var date = await showDatePicker(
                      context: context,
                      initialDate: widget.viewModel.firstExecution,
                      firstDate:
                          DateTime.now().subtract(const Duration(days: 1)),
                      lastDate: DateTime.now().add(const Duration(days: 365)));

                  if (date != null) {
                    var time = await showTimePicker(
                        context: context, initialTime: TimeOfDay.now());

                    if (time != null) {
                      widget.viewModel.firstExecution = tz.TZDateTime(
                          tz.local,
                          date.year,
                          date.month,
                          date.day,
                          time.hour,
                          time.minute);
                      setState(() {});
                    }
                  }
                },
                icon: const Icon(Icons.calendar_today),
                color: Colors.blue)
          ]),
          const Text("Reminders will be scheduled daily",
              style: TextStyle(fontSize: 14)),
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
