class Task {
  late int id;
  late String title;
  late String description;
  late int completed;

  Task({required this.title, required this.description,  required this.completed}){
    id = 1;
  }

  Task.withId(this.id, this.title, this.description, this.completed);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["title"] = title;
    map["description"] = description;
    map["completed"] = completed;
    if (id != null){
      map["id"] = id;
    }
    return map;
  }

  Task.fromObject(dynamic o){
    this.id = int.tryParse(o["id"].toString())!;
    this.title = o["title"];
    this.description = o["description"];
    this.completed = int.tryParse(o["completed"].toString())!;
  }
}