enum TaskStatus { newTask, processing, completed }

class Task {
  late int id;
  late String title;
  late String description;
  late TaskStatus taskStatus;

  Task({required this.title, required this.description,  required this.taskStatus}){
    id = 1;
  }

  Task.withId(this.id, this.title, this.description, this.taskStatus);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["title"] = title;
    map["description"] = description;
    map["taskStatus"] = taskStatus.index;
    if (id != null){
      map["id"] = id;
    }
    return map;
  }

  Task.fromObject(dynamic o){
    this.id = int.tryParse(o["id"].toString())!;
    this.title = o["title"];
    this.description = o["description"];
    this.taskStatus = TaskStatus.values[int.tryParse(o["taskStatus"].toString())!];
  }
}