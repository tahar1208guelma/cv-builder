import 'package:uuid/uuid.dart';

class Experience {
  final String id;
  final String position; // Job title
  final String company;
  final String location;
  final String startDate;
  final String endDate;
  final bool isCurrent; // Currently working
  final String description;
  final List<String> highlights; // Achievements

  Experience({
    String? id,
    String? jobTitle,
    String position = '',
    this.company = '',
    this.location = '',
    this.startDate = '',
    this.endDate = '',
    bool? currentlyWorking,
    bool isCurrent = false,
    this.description = '',
    List<String>? achievements,
    List<String>? highlights,
  })  : id = id ?? const Uuid().v4(),
        position = jobTitle ?? position,
        isCurrent = currentlyWorking ?? isCurrent,
        highlights = achievements ?? highlights ?? [];

  String get jobTitle => position;
  bool get currentlyWorking => isCurrent;
  List<String> get achievements => highlights;

  Experience copyWith({
    String? id,
    String? position,
    String? jobTitle,
    String? company,
    String? location,
    String? startDate,
    String? endDate,
    bool? isCurrent,
    bool? currentlyWorking,
    String? description,
    List<String>? highlights,
    List<String>? achievements,
  }) {
    return Experience(
      id: id ?? this.id,
      position: jobTitle ?? position ?? this.position,
      company: company ?? this.company,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isCurrent: currentlyWorking ?? isCurrent ?? this.isCurrent,
      description: description ?? this.description,
      highlights: achievements ?? highlights ?? List.from(this.highlights),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'position': position,
      'jobTitle': jobTitle,
      'company': company,
      'location': location,
      'startDate': startDate,
      'endDate': endDate,
      'isCurrent': isCurrent,
      'currentlyWorking': currentlyWorking,
      'description': description,
      'highlights': highlights,
      'achievements': achievements,
    };
  }

  factory Experience.fromJson(Map<String, dynamic> json) {
    final pos = (json['jobTitle'] as String?) ?? (json['position'] as String?) ?? '';
    final curr = (json['currentlyWorking'] as bool?) ?? (json['isCurrent'] as bool?) ?? false;
    final achList = (json['achievements'] as List<dynamic>?) ?? (json['highlights'] as List<dynamic>?);

    return Experience(
      id: json['id'] as String?,
      position: pos,
      company: json['company'] as String? ?? '',
      location: json['location'] as String? ?? '',
      startDate: json['startDate'] as String? ?? '',
      endDate: json['endDate'] as String? ?? '',
      isCurrent: curr,
      description: json['description'] as String? ?? '',
      highlights: achList?.map((e) => e.toString()).toList() ?? [],
    );
  }
}
