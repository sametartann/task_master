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
  late List<Task> _tasks;
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
        title: Text('TaskMaster', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: ListView.builder(
        itemCount: taskCount,
        itemBuilder: (context, int index) {
          final task = _tasks[index];
          return ListTile(
            title: Text(task.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            subtitle: Text('${task.description}\nStatus: ${task.taskStatus.toString().split('.').last}'), // Display task status
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
          );
        },
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
        child: Icon(Icons.add),
      ),
    );
  }


  Future<void> _updateTask(Task task) async {
    await dbHelper.update(task);
    dbHelper.fetchTasks();
  }
}
