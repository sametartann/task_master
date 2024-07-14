import 'package:flutter/material.dart';
import 'package:task_master/data/db_helper.dart';
import 'package:task_master/models/task.dart';

class TaskDetailScreen extends StatefulWidget {
  final int taskId;

  TaskDetailScreen({ required this.taskId}) ;

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  var dbHelper = DbHelper();
  Task? _task;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    await dbHelper.initializeDb().then((value) async {
      await dbHelper.fetchTask(widget.taskId).then((value) {
        setState(() {
          _task = value;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
      ),
      body: _task != null
          ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _task!.title ?? '',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              _task!.description ?? '',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text('Completed: '),
                Checkbox(
                  value: _task!.completed == 1,
                  onChanged: (value) {
                    setState(() {
                      _task!.completed = value! ? 1 : 0;
                    });
                    _updateTask();
                  },
                ),
              ],
            ),
          ],
        ),
      )
          : Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> _updateTask() async {
    await dbHelper.update(_task!);
  }
}
