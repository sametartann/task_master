import 'package:flutter/material.dart';
import 'package:task_master/data/db_helper.dart';
import 'package:task_master/models/task.dart';
import 'task_detail_screen.dart';
import 'task_creation_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var dbHelper = DbHelper();
  late List<Task> _tasks = [];
  int taskCount = 0;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    await dbHelper.initializeDb().then((value) {
      _fetchTasks();
    });
  }

  Future<void> _fetchTasks() async {
    await dbHelper.fetchTasks().then((value) {
      setState(() {
        _tasks = value;
        taskCount = value.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TaskMaster',
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: taskCount > 0
          ? ListView.builder(
        itemCount: taskCount,
        itemBuilder: (context, int index) {
          final task = _tasks[index];
          return Column(
            children: [
              Dismissible(
                key: Key(task.id.toString()),
                background: Container(
                  color: Colors.red,
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Delete Task"),
                        content: const Text("Are you sure you want to delete this task?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: const Text("Delete"),
                          ),
                        ],
                      );
                    },
                  );
                },
                onDismissed: (direction) async {
                  await dbHelper.deleteTask(task.id);
                  setState(() {
                    _tasks.removeAt(index);
                    taskCount--;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("${task.title} deleted!"),
                      duration: const Duration(seconds: 3),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
                child: Container(
                  color: _getTaskBackgroundColor(task.taskStatus),
                  child: ListTile(
                    title: Text(
                      task.title,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${task.description}\nStatus: ${_getTaskStatusString(task.taskStatus)}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskDetailScreen(taskId: task.id),
                        ),
                      ).then((_) {
                        _fetchTasks();
                      });
                    },
                  ),
                ),
              ),
              Divider(),
            ],
          );
        },
      )
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'No tasks available',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TaskCreationScreen()),
                ).then((_) {
                  _fetchTasks();
                });
              },
              child: const Text('Create First Task'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TaskCreationScreen()),
          ).then((_) {
            _fetchTasks();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Color _getTaskBackgroundColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.newTask:
        return Colors.grey[50]!;
      case TaskStatus.processing:
        return Colors.blue[100]!;
      case TaskStatus.completed:
        return Colors.green[100]!;
      default:
        return Colors.white;
    }
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
