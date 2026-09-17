import 'package:uuid/uuid.dart';

class Certification {
  final String id;
  final String name; // Certificate name
  final String issuer; // Issuing organization
  final String issueDate; // Date
  final String url; // Credential URL
  final String description;

  Certification({
    String? id,
    this.name = '',
    this.issuer = '',
    this.issueDate = '',
    this.url = '',
    this.description = '',
  }) : id = id ?? const Uuid().v4();

  Certification copyWith({
    String? id,
    String? name,
    String? issuer,
    String? issueDate,
    String? url,
    String? description,
  }) {
    return Certification(
      id: id ?? this.id,
      name: name ?? this.name,
      issuer: issuer ?? this.issuer,
      issueDate: issueDate ?? this.issueDate,
      url: url ?? this.url,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'issuer': issuer,
      'issueDate': issueDate,
      'url': url,
      'description': description,
    };
  }

  factory Certification.fromJson(Map<String, dynamic> json) {
    return Certification(
      id: json['id'] as String?,
      name: json['name'] as String? ?? '',
      issuer: json['issuer'] as String? ?? '',
      issueDate: json['issueDate'] as String? ?? '',
      url: json['url'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }
}
