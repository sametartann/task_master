import 'package:flutter/material.dart';
import 'package:task_master/data/db_helper.dart';
import 'package:task_master/models/task.dart';
import 'package:task_master/screens/task_edit_screen.dart';

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
        title: Text('Task Details',style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueGrey[900],
        actions: [
          IconButton(
            icon: Icon(Icons.edit , color: Colors.white,),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskEditScreen(task: _task!), // Pass the task to the edit screen
                ),
              ).then((_) {
                _initDatabase(); // Refresh task details after editing
              });
            },
          ),
        ],
      ),
      body: _task != null
          ? SingleChildScrollView(
            child:
              Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _task!.title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  _task!.description,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 64),
                Text('Creation: ${_task!.creationDateTime.toString().substring(0, 19)}', style: const TextStyle(fontSize: 15, )),
                if (_task!.processingStartDateTime != null)
                  Text('Processing: ${_task!.processingStartDateTime.toString().substring(0, 19)}'),
                if (_task!.completedDateTime != null)
                  Text('Completed: ${_task!.completedDateTime.toString().substring(0, 19)}'),
                SizedBox(height: 32),
                Row(
                  children: [
                    Text('Status: '),
                    DropdownButton<TaskStatus>(
                      value: _task!.taskStatus,
                      onChanged: (TaskStatus? newValue) {
                        setState(() {
                          _task!.taskStatus = newValue!;
                          if (newValue == TaskStatus.processing) {
                            _task!.processingStartDateTime = DateTime.now();
                          } else if (newValue == TaskStatus.completed) {
                            _task!.completedDateTime = DateTime.now();
                          }
                        });
                        _updateTask();
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
              ],
                      ),
                    ),

          )
          : Center(child: CircularProgressIndicator()),
    );
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



  Future<void> _updateTask() async {
    await dbHelper.update(_task!);
  }
}
