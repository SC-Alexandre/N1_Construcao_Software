class Task {
  final String title;
  final String description;
  final DateTime? date;
  final int? priority;
  final String? category;
  bool isCompleted;

  Task({
    required this.title,
    required this.description,
    this.date,
    this.priority,
    this.category,
    this.isCompleted = false,
  });
}