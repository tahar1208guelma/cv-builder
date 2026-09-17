import 'package:uuid/uuid.dart';

class Award {
  final String id;
  final String title; // Award name
  final String issuer; // Organization
  final String date;
  final String description;

  Award({
    String? id,
    this.title = '',
    this.issuer = '',
    this.date = '',
    this.description = '',
  }) : id = id ?? const Uuid().v4();

  Award copyWith({
    String? id,
    String? title,
    String? issuer,
    String? date,
    String? description,
  }) {
    return Award(
      id: id ?? this.id,
      title: title ?? this.title,
      issuer: issuer ?? this.issuer,
      date: date ?? this.date,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'issuer': issuer,
      'date': date,
      'description': description,
    };
  }

  factory Award.fromJson(Map<String, dynamic> json) {
    return Award(
      id: json['id'] as String?,
      title: json['title'] as String? ?? '',
      issuer: json['issuer'] as String? ?? '',
      date: json['date'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }
}
