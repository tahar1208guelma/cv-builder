class PersonalInfo {
  final String firstName;
  final String lastName;
  final String _legacyFullName;
  final String jobTitle;
  final String email;
  final String phone;
  final String address;
  final String dateOfBirth;
  final String nationality;
  final String website;
  final String linkedin;
  final String github;
  final String summary;
  final String? photoBase64;
  final bool showPhoto;

  const PersonalInfo({
    this.firstName = '',
    this.lastName = '',
    String fullName = '',
    this.jobTitle = '',
    this.email = '',
    this.phone = '',
    this.address = '',
    this.dateOfBirth = '',
    this.nationality = '',
    this.website = '',
    this.linkedin = '',
    this.github = '',
    this.summary = '',
    this.photoBase64,
    this.showPhoto = true,
  }) : _legacyFullName = fullName;

  String get fullName {
    final combined = '$firstName $lastName'.trim();
    if (combined.isNotEmpty) return combined;
    return _legacyFullName;
  }

  bool get hasPhoto => showPhoto && photoBase64 != null && photoBase64!.isNotEmpty;

  PersonalInfo copyWith({
    String? firstName,
    String? lastName,
    String? fullName,
    String? jobTitle,
    String? email,
    String? phone,
    String? address,
    String? dateOfBirth,
    String? nationality,
    String? website,
    String? linkedin,
    String? github,
    String? summary,
    String? photoBase64,
    bool? showPhoto,
    bool clearPhoto = false,
  }) {
    return PersonalInfo(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      fullName: fullName ?? (firstName != null || lastName != null ? '$firstName $lastName'.trim() : _legacyFullName),
      jobTitle: jobTitle ?? this.jobTitle,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      nationality: nationality ?? this.nationality,
      website: website ?? this.website,
      linkedin: linkedin ?? this.linkedin,
      github: github ?? this.github,
      summary: summary ?? this.summary,
      photoBase64: clearPhoto ? null : (photoBase64 ?? this.photoBase64),
      showPhoto: showPhoto ?? this.showPhoto,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'fullName': fullName,
      'jobTitle': jobTitle,
      'email': email,
      'phone': phone,
      'address': address,
      'dateOfBirth': dateOfBirth,
      'nationality': nationality,
      'website': website,
      'linkedin': linkedin,
      'github': github,
      'summary': summary,
      'photoBase64': photoBase64,
      'showPhoto': showPhoto,
    };
  }

  factory PersonalInfo.fromJson(Map<String, dynamic> json) {
    final fn = json['firstName'] as String? ?? '';
    final ln = json['lastName'] as String? ?? '';
    final full = json['fullName'] as String? ?? '';

    // If first/last name were not separated originally, split full name if possible
    String derivedFirst = fn;
    String derivedLast = ln;
    if (derivedFirst.isEmpty && derivedLast.isEmpty && full.isNotEmpty) {
      final parts = full.trim().split(' ');
      if (parts.length > 1) {
        derivedFirst = parts.first;
        derivedLast = parts.sublist(1).join(' ');
      } else {
        derivedFirst = full;
      }
    }

    return PersonalInfo(
      firstName: derivedFirst,
      lastName: derivedLast,
      fullName: full,
      jobTitle: json['jobTitle'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      address: json['address'] as String? ?? '',
      dateOfBirth: json['dateOfBirth'] as String? ?? '',
      nationality: json['nationality'] as String? ?? '',
      website: json['website'] as String? ?? '',
      linkedin: json['linkedin'] as String? ?? '',
      github: json['github'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      photoBase64: json['photoBase64'] as String?,
      showPhoto: json['showPhoto'] as bool? ?? true,
    );
  }

  factory PersonalInfo.empty() => const PersonalInfo();
}
