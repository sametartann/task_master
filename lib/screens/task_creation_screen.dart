import 'package:flutter/material.dart';
import 'package:task_master/data/db_helper.dart';
import 'package:task_master/models/task.dart';
import 'package:task_master/screens/home_screen.dart';

class TaskCreationScreen extends StatefulWidget {
  @override
  _TaskCreationScreenState createState() => _TaskCreationScreenState();
}

class _TaskCreationScreenState extends State<TaskCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  var dbHelper = DbHelper();
  late int maxId;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    await dbHelper.initializeDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
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
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) {
                  _description = value!;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    await _getNextId();
                    await _saveTask().then((value) {
                      Navigator.pop(context);
                    });
                  }
                },
                child: Text('Save Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fetch max id from the database and increment it by 1
  Future<void> _getNextId() async {
    var tasks = await dbHelper.fetchTasks();
    if (tasks.isEmpty) {
      maxId = 1;
      return;
    }
    var maxId2 = (tasks.map((e) => e.id).reduce((value, element) => value > element ? value : element)) ?? 0;
    maxId = maxId2 + 1;
  }


  Future<void> _saveTask() async {

    await dbHelper.insert(Task.withId(
        maxId, _title, _description, 0
    ));
  }
}
