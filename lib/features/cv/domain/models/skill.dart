import 'package:uuid/uuid.dart';

class Skill {
  final String id;
  final String name;
  final int level; // 1 to 5
  final String category;

  Skill({
    String? id,
    this.name = '',
    this.level = 4,
    this.category = '',
  }) : id = id ?? const Uuid().v4();

  Skill copyWith({
    String? id,
    String? name,
    int? level,
    String? category,
  }) {
    return Skill(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'level': level,
      'category': category,
    };
  }

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'] as String?,
      name: json['name'] as String? ?? '',
      level: json['level'] as int? ?? 4,
      category: json['category'] as String? ?? '',
    );
  }
}
