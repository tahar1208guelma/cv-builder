import 'package:uuid/uuid.dart';

enum LanguageProficiency {
  native,
  fluent,
  intermediate,
  basic,
}

class LanguageItem {
  final String id;
  final String name;
  final LanguageProficiency proficiency;

  LanguageItem({
    String? id,
    this.name = '',
    this.proficiency = LanguageProficiency.fluent,
  }) : id = id ?? const Uuid().v4();

  LanguageItem copyWith({
    String? id,
    String? name,
    LanguageProficiency? proficiency,
  }) {
    return LanguageItem(
      id: id ?? this.id,
      name: name ?? this.name,
      proficiency: proficiency ?? this.proficiency,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'proficiency': proficiency.name,
    };
  }

  factory LanguageItem.fromJson(Map<String, dynamic> json) {
    return LanguageItem(
      id: json['id'] as String?,
      name: json['name'] as String? ?? '',
      proficiency: LanguageProficiency.values.firstWhere(
        (e) => e.name == json['proficiency'],
        orElse: () => LanguageProficiency.fluent,
      ),
    );
  }
}
