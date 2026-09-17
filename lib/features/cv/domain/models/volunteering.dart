import 'package:uuid/uuid.dart';

class Volunteering {
  final String id;
  final String organization;
  final String role;
  final String startDate;
  final String endDate;
  final bool isCurrent;
  final String description;

  Volunteering({
    String? id,
    this.organization = '',
    this.role = '',
    this.startDate = '',
    this.endDate = '',
    this.isCurrent = false,
    this.description = '',
  }) : id = id ?? const Uuid().v4();

  Volunteering copyWith({
    String? id,
    String? organization,
    String? role,
    String? startDate,
    String? endDate,
    bool? isCurrent,
    String? description,
  }) {
    return Volunteering(
      id: id ?? this.id,
      organization: organization ?? this.organization,
      role: role ?? this.role,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isCurrent: isCurrent ?? this.isCurrent,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organization': organization,
      'role': role,
      'startDate': startDate,
      'endDate': endDate,
      'isCurrent': isCurrent,
      'description': description,
    };
  }

  factory Volunteering.fromJson(Map<String, dynamic> json) {
    return Volunteering(
      id: json['id'] as String?,
      organization: json['organization'] as String? ?? '',
      role: json['role'] as String? ?? '',
      startDate: json['startDate'] as String? ?? '',
      endDate: json['endDate'] as String? ?? '',
      isCurrent: json['isCurrent'] as bool? ?? false,
      description: json['description'] as String? ?? '',
    );
  }
}
