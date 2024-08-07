import 'package:flutter/material.dart';
import 'package:task_master/data/db_helper.dart';
import 'package:task_master/models/task.dart';

class TaskEditScreen extends StatefulWidget {
  final Task task;

  TaskEditScreen({required this.task});

  @override
  _TaskEditScreenState createState() => _TaskEditScreenState();
}

class _TaskEditScreenState extends State<TaskEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late TaskStatus _taskStatus;
  late DateTime _creationDateTime;
  DateTime? _processingStartDateTime;
  DateTime? _completedDateTime;
  var dbHelper = DbHelper();

  @override
  void initState() {
    super.initState();
    _title = widget.task.title;
    _description = widget.task.description;
    _taskStatus = widget.task.taskStatus;
    _creationDateTime = widget.task.creationDateTime;
    _processingStartDateTime = widget.task.processingStartDateTime;
    _completedDateTime = widget.task.completedDateTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task',style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (value) {
                  _description = value!;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Status: '),
                  DropdownButton<TaskStatus>(
                    value: _taskStatus,
                    onChanged: (TaskStatus? newValue) {
                      setState(() {
                        _taskStatus = newValue!;
                        if (newValue == TaskStatus.processing) {
                          _processingStartDateTime = DateTime.now();
                        } else if (newValue == TaskStatus.completed) {
                          _completedDateTime = DateTime.now();
                        }
                      });
                    },
                    items: TaskStatus.values.map<DropdownMenuItem<TaskStatus>>((TaskStatus value) {
                      return DropdownMenuItem<TaskStatus>(
                        value: value,
                        child: Text(_getTaskStatusString(value)),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    await _updateTask();
                    Navigator.pop(context);
                  }
                },
                child: const Text('Update Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateTask() async {
    var updatedTask = Task.withId(
      widget.task.id,
      _title,
      _description,
      _taskStatus,
      _creationDateTime,
      _processingStartDateTime,
      _completedDateTime,
    );
    await dbHelper.update(updatedTask);
  }

  String _getTaskStatusString(TaskStatus status) {
    switch (status) {
      case TaskStatus.newTask:
        return 'New Task';
      case TaskStatus.processing:
        return 'Processing';
      case TaskStatus.completed:
        return 'Completed';
      default:
        return '';
    }
  }
}
