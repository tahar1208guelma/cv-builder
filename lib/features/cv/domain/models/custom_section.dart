import 'package:uuid/uuid.dart';

class CustomSectionItem {
  final String id;
  final String title;
  final String subtitle;
  final String date;
  final String description;

  CustomSectionItem({
    String? id,
    this.title = '',
    this.subtitle = '',
    this.date = '',
    this.description = '',
  }) : id = id ?? const Uuid().v4();

  CustomSectionItem copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? date,
    String? description,
  }) {
    return CustomSectionItem(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      date: date ?? this.date,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'date': date,
      'description': description,
    };
  }

  factory CustomSectionItem.fromJson(Map<String, dynamic> json) {
    return CustomSectionItem(
      id: json['id'] as String?,
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      date: json['date'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }
}

class CustomSection {
  final String id;
  final String title;
  final List<CustomSectionItem> items;

  CustomSection({
    String? id,
    this.title = '',
    List<CustomSectionItem>? items,
  })  : id = id ?? const Uuid().v4(),
        items = items ?? [];

  CustomSection copyWith({
    String? id,
    String? title,
    List<CustomSectionItem>? items,
  }) {
    return CustomSection(
      id: id ?? this.id,
      title: title ?? this.title,
      items: items ?? List.from(this.items),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }

  factory CustomSection.fromJson(Map<String, dynamic> json) {
    return CustomSection(
      id: json['id'] as String?,
      title: json['title'] as String? ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => CustomSectionItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
