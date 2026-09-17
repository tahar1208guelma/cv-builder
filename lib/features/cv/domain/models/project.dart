import 'package:uuid/uuid.dart';

class Project {
  final String id;
  final String title; // Project name
  final String role; // Role in project
  final String date; // Project Date
  final String url; // Project URL
  final String technologies;
  final String description;

  Project({
    String? id,
    this.title = '',
    this.role = '',
    this.date = '',
    this.url = '',
    this.technologies = '',
    this.description = '',
  }) : id = id ?? const Uuid().v4();

  Project copyWith({
    String? id,
    String? title,
    String? role,
    String? date,
    String? url,
    String? technologies,
    String? description,
  }) {
    return Project(
      id: id ?? this.id,
      title: title ?? this.title,
      role: role ?? this.role,
      date: date ?? this.date,
      url: url ?? this.url,
      technologies: technologies ?? this.technologies,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'role': role,
      'date': date,
      'url': url,
      'technologies': technologies,
      'description': description,
    };
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as String?,
      title: json['title'] as String? ?? '',
      role: json['role'] as String? ?? '',
      date: json['date'] as String? ?? '',
      url: json['url'] as String? ?? '',
      technologies: json['technologies'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }
}
