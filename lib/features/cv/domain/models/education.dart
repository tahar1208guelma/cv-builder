import 'package:uuid/uuid.dart';

class Education {
  final String id;
  final String degree;
  final String fieldOfStudy;
  final String institution;
  final String country;
  final String location;
  final String startDate;
  final String endDate;
  final bool currentlyStudying;
  final String grade;
  final String description;

  Education({
    String? id,
    this.degree = '',
    this.fieldOfStudy = '',
    this.institution = '',
    this.country = '',
    this.location = '',
    this.startDate = '',
    this.endDate = '',
    this.currentlyStudying = false,
    this.grade = '',
    this.description = '',
  }) : id = id ?? const Uuid().v4();

  Education copyWith({
    String? id,
    String? degree,
    String? fieldOfStudy,
    String? institution,
    String? country,
    String? location,
    String? startDate,
    String? endDate,
    bool? currentlyStudying,
    String? grade,
    String? description,
  }) {
    return Education(
      id: id ?? this.id,
      degree: degree ?? this.degree,
      fieldOfStudy: fieldOfStudy ?? this.fieldOfStudy,
      institution: institution ?? this.institution,
      country: country ?? this.country,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      currentlyStudying: currentlyStudying ?? this.currentlyStudying,
      grade: grade ?? this.grade,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'degree': degree,
      'fieldOfStudy': fieldOfStudy,
      'institution': institution,
      'country': country,
      'location': location,
      'startDate': startDate,
      'endDate': endDate,
      'currentlyStudying': currentlyStudying,
      'grade': grade,
      'description': description,
    };
  }

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      id: json['id'] as String?,
      degree: json['degree'] as String? ?? '',
      fieldOfStudy: json['fieldOfStudy'] as String? ?? '',
      institution: json['institution'] as String? ?? '',
      country: json['country'] as String? ?? '',
      location: json['location'] as String? ?? '',
      startDate: json['startDate'] as String? ?? '',
      endDate: json['endDate'] as String? ?? '',
      currentlyStudying: json['currentlyStudying'] as bool? ?? false,
      grade: json['grade'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }
}
