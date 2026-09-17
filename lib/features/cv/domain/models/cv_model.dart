import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_constants.dart';
import 'award.dart';
import 'certification.dart';
import 'custom_section.dart';
import 'cv_style.dart';
import 'education.dart';
import 'experience.dart';
import 'language_item.dart';
import 'personal_info.dart';
import 'project.dart';
import 'publication.dart';
import 'reference.dart';
import 'skill.dart';
import 'volunteering.dart';

class CvModel {
  final String id;
  final String title;
  final String language; // 'en', 'fr', 'ar'
  final PersonalInfo personalInfo;
  final List<Experience> experiences;
  final List<Education> educations;
  final List<Skill> skills;
  final List<LanguageItem> languages;
  final List<Project> projects;
  final List<Certification> certifications;
  final List<Publication> publications;
  final List<Award> awards;
  final List<Volunteering> volunteering;
  final List<Reference> references;
  final List<CustomSection> customSections;
  final CvStyle style;
  final DateTime createdAt;
  final DateTime updatedAt;

  CvModel({
    String? id,
    this.title = 'Untitled Resume',
    this.language = AppConstants.langEn,
    PersonalInfo? personalInfo,
    List<Experience>? experiences,
    List<Education>? educations,
    List<Skill>? skills,
    List<LanguageItem>? languages,
    List<Project>? projects,
    List<Certification>? certifications,
    List<Publication>? publications,
    List<Award>? awards,
    List<Volunteering>? volunteering,
    List<Reference>? references,
    List<CustomSection>? customSections,
    CvStyle? style,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? const Uuid().v4(),
        personalInfo = personalInfo ?? const PersonalInfo(),
        experiences = experiences ?? [],
        educations = educations ?? [],
        skills = skills ?? [],
        languages = languages ?? [],
        projects = projects ?? [],
        certifications = certifications ?? [],
        publications = publications ?? [],
        awards = awards ?? [],
        volunteering = volunteering ?? [],
        references = references ?? [],
        customSections = customSections ?? [],
        style = style ?? const CvStyle(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  bool get isRtl => language == AppConstants.langAr;

  CvModel copyWith({
    String? id,
    String? title,
    String? language,
    PersonalInfo? personalInfo,
    List<Experience>? experiences,
    List<Education>? educations,
    List<Skill>? skills,
    List<LanguageItem>? languages,
    List<Project>? projects,
    List<Certification>? certifications,
    List<Publication>? publications,
    List<Award>? awards,
    List<Volunteering>? volunteering,
    List<Reference>? references,
    List<CustomSection>? customSections,
    CvStyle? style,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CvModel(
      id: id ?? this.id,
      title: title ?? this.title,
      language: language ?? this.language,
      personalInfo: personalInfo ?? this.personalInfo,
      experiences: experiences ?? List.from(this.experiences),
      educations: educations ?? List.from(this.educations),
      skills: skills ?? List.from(this.skills),
      languages: languages ?? List.from(this.languages),
      projects: projects ?? List.from(this.projects),
      certifications: certifications ?? List.from(this.certifications),
      publications: publications ?? List.from(this.publications),
      awards: awards ?? List.from(this.awards),
      volunteering: volunteering ?? List.from(this.volunteering),
      references: references ?? List.from(this.references),
      customSections: customSections ?? List.from(this.customSections),
      style: style ?? this.style,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  CvModel duplicate({String suffix = ' (Copy)'}) {
    return CvModel(
      id: const Uuid().v4(),
      title: '$title$suffix',
      language: language,
      personalInfo: personalInfo.copyWith(),
      experiences: experiences.map((e) => e.copyWith(id: const Uuid().v4())).toList(),
      educations: educations.map((e) => e.copyWith(id: const Uuid().v4())).toList(),
      skills: skills.map((e) => e.copyWith(id: const Uuid().v4())).toList(),
      languages: languages.map((e) => e.copyWith(id: const Uuid().v4())).toList(),
      projects: projects.map((e) => e.copyWith(id: const Uuid().v4())).toList(),
      certifications: certifications.map((e) => e.copyWith(id: const Uuid().v4())).toList(),
      publications: publications.map((e) => e.copyWith(id: const Uuid().v4())).toList(),
      awards: awards.map((e) => e.copyWith(id: const Uuid().v4())).toList(),
      volunteering: volunteering.map((e) => e.copyWith(id: const Uuid().v4())).toList(),
      references: references.map((e) => e.copyWith(id: const Uuid().v4())).toList(),
      customSections: customSections
          .map((c) => c.copyWith(
                id: const Uuid().v4(),
                items: c.items.map((i) => i.copyWith(id: const Uuid().v4())).toList(),
              ))
          .toList(),
      style: style.copyWith(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'language': language,
      'personalInfo': personalInfo.toJson(),
      'experiences': experiences.map((e) => e.toJson()).toList(),
      'educations': educations.map((e) => e.toJson()).toList(),
      'skills': skills.map((e) => e.toJson()).toList(),
      'languages': languages.map((e) => e.toJson()).toList(),
      'projects': projects.map((e) => e.toJson()).toList(),
      'certifications': certifications.map((e) => e.toJson()).toList(),
      'publications': publications.map((e) => e.toJson()).toList(),
      'awards': awards.map((e) => e.toJson()).toList(),
      'volunteering': volunteering.map((e) => e.toJson()).toList(),
      'references': references.map((e) => e.toJson()).toList(),
      'customSections': customSections.map((e) => e.toJson()).toList(),
      'style': style.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory CvModel.fromJson(Map<String, dynamic> json) {
    return CvModel(
      id: json['id'] as String?,
      title: json['title'] as String? ?? 'Untitled Resume',
      language: json['language'] as String? ?? AppConstants.langEn,
      personalInfo: json['personalInfo'] != null
          ? PersonalInfo.fromJson(json['personalInfo'] as Map<String, dynamic>)
          : const PersonalInfo(),
      experiences: (json['experiences'] as List<dynamic>?)
              ?.map((e) => Experience.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      educations: (json['educations'] as List<dynamic>?)
              ?.map((e) => Education.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      skills: (json['skills'] as List<dynamic>?)
              ?.map((e) => Skill.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      languages: (json['languages'] as List<dynamic>?)
              ?.map((e) => LanguageItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      projects: (json['projects'] as List<dynamic>?)
              ?.map((e) => Project.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      certifications: (json['certifications'] as List<dynamic>?)
              ?.map((e) => Certification.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      publications: (json['publications'] as List<dynamic>?)
              ?.map((e) => Publication.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      awards: (json['awards'] as List<dynamic>?)
              ?.map((e) => Award.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      volunteering: (json['volunteering'] as List<dynamic>?)
              ?.map((e) => Volunteering.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      references: (json['references'] as List<dynamic>?)
              ?.map((e) => Reference.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      customSections: (json['customSections'] as List<dynamic>?)
              ?.map((e) => CustomSection.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      style: json['style'] != null
          ? CvStyle.fromJson(json['style'] as Map<String, dynamic>)
          : const CvStyle(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  factory CvModel.empty({String? title, String language = AppConstants.langEn}) {
    return CvModel(
      title: title ??
          (language == AppConstants.langAr
              ? 'سيرة ذاتية جديدة'
              : (language == AppConstants.langFr ? 'Nouveau CV' : 'New Resume')),
      language: language,
      style: CvStyle(
        fontFamily: language == AppConstants.langAr ? 'Cairo' : 'Roboto',
      ),
    );
  }
}
