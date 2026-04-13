class TaskModel {
  String id;
  String title;
  bool checked;
  String userId;

  TaskModel({
    required this.id,
    required this.title,
    required this.userId,
    this.checked = false
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'checked': checked,
      'userId': userId,
    };
  }

  factory TaskModel.fromMap(String id, Map<String, dynamic> map) {
    return TaskModel(
      id: id,
      title: map['title'] ?? '',
      checked: map['checked'] ?? false,
      userId: map['userId'] ?? '',
    );
  }

  void checkTask() => checked = true;
  void uncheckTask() => checked = false;
}