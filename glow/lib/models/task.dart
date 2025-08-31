// Simple Task model - no code generation needed
class Task {
  final String id;
  final String title;
  final String? description;
  final bool completed;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.completed,
    this.tags = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  // Simple way to create Task from JSON (from API)
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      completed: json['completed'] as bool,
      tags: List<String>.from(json['tags'] ?? []),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  // Simple way to convert Task to JSON (for API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'completed': completed,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
