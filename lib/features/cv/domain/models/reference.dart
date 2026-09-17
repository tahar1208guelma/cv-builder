import 'package:uuid/uuid.dart';

class Reference {
  final String id;
  final String name;
  final String position;
  final String organization;
  final String email;
  final String phone;

  Reference({
    String? id,
    this.name = '',
    this.position = '',
    this.organization = '',
    this.email = '',
    this.phone = '',
  }) : id = id ?? const Uuid().v4();

  Reference copyWith({
    String? id,
    String? name,
    String? position,
    String? organization,
    String? email,
    String? phone,
  }) {
    return Reference(
      id: id ?? this.id,
      name: name ?? this.name,
      position: position ?? this.position,
      organization: organization ?? this.organization,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'position': position,
      'organization': organization,
      'email': email,
      'phone': phone,
    };
  }

  factory Reference.fromJson(Map<String, dynamic> json) {
    return Reference(
      id: json['id'] as String?,
      name: json['name'] as String? ?? '',
      position: json['position'] as String? ?? '',
      organization: json['organization'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
    );
  }
}
