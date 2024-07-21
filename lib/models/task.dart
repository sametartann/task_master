enum TaskStatus { newTask, processing, completed }

class Task {
  late int id;
  late String title;
  late String description;
  late TaskStatus taskStatus;
  late DateTime creationDateTime;
  DateTime? processingStartDateTime;
  DateTime? completedDateTime;

  Task({
    required this.title,
    required this.description,
    required this.taskStatus,
    required this.creationDateTime,
    this.processingStartDateTime,
    this.completedDateTime,
  }) {
    id = 1;
  }

  Task.withId(
      this.id,
      this.title,
      this.description,
      this.taskStatus,
      this.creationDateTime,
      this.processingStartDateTime,
      this.completedDateTime);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["title"] = title;
    map["description"] = description;
    map["taskStatus"] = taskStatus.index;
    map["creationDateTime"] = creationDateTime.toIso8601String();
    if (processingStartDateTime != null) {
      map["processingStartDateTime"] = processingStartDateTime!.toIso8601String();
    }
    if (completedDateTime != null) {
      map["completedDateTime"] = completedDateTime!.toIso8601String();
    }
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  Task.fromObject(dynamic o) {
    id = int.tryParse(o["id"].toString())!;
    title = o["title"];
    description = o["description"];
    taskStatus = TaskStatus.values[int.tryParse(o["taskStatus"].toString())!];
    creationDateTime = DateTime.parse(o["creationDateTime"]);
    if (o["processingStartDateTime"] != null) {
      processingStartDateTime = DateTime.parse(o["processingStartDateTime"]);
    }
    if (o["completedDateTime"] != null) {
      completedDateTime = DateTime.parse(o["completedDateTime"]);
    }
  }
}
