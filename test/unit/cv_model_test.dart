import 'package:flutter_test/flutter_test.dart';
import 'package:cv_builder/core/constants/app_constants.dart';
import 'package:cv_builder/features/cv/domain/models/cv_model.dart';
import 'package:cv_builder/features/cv/domain/models/cv_style.dart';
import 'package:cv_builder/features/cv/domain/models/experience.dart';
import 'package:cv_builder/features/cv/domain/models/education.dart';
import 'package:cv_builder/features/cv/domain/models/skill.dart';
import 'package:cv_builder/features/cv/domain/models/language_item.dart';
import 'package:cv_builder/features/cv/domain/models/personal_info.dart';
import 'package:cv_builder/features/cv/domain/models/publication.dart';
import 'package:cv_builder/features/cv/domain/models/award.dart';
import 'package:cv_builder/features/cv/domain/models/volunteering.dart';
import 'package:cv_builder/features/cv/domain/models/reference.dart';

void main() {
  group('CvModel Tests', () {
    test('CvModel empty constructor defaults', () {
      final cv = CvModel.empty(title: 'Test Resume', language: AppConstants.langEn);
      expect(cv.title, 'Test Resume');
      expect(cv.language, AppConstants.langEn);
      expect(cv.isRtl, false);
      expect(cv.experiences, isEmpty);
      expect(cv.educations, isEmpty);
      expect(cv.skills, isEmpty);
      expect(cv.style.templateId, AppConstants.templateModern);
    });

    test('CvModel Arabic isRtl is true', () {
      final cv = CvModel.empty(language: AppConstants.langAr);
      expect(cv.language, 'ar');
      expect(cv.isRtl, true);
      expect(cv.style.fontFamily, 'Cairo');
    });

    test('CvModel serialization roundtrip', () {
      final cv = CvModel(
        title: 'Full Stack Engineer',
        language: AppConstants.langFr,
        personalInfo: const PersonalInfo(
          fullName: 'Jean Dupont',
          jobTitle: 'Ingénieur Logiciel',
          email: 'jean@example.com',
          phone: '+33 6 00 00 00 00',
          photoBase64: 'fake_base64_data',
          showPhoto: true,
        ),
        experiences: [
          Experience(
            position: 'Lead Developer',
            company: 'Tech SA',
            startDate: '2020',
            endDate: '2023',
            highlights: ['Delivered project on time', 'Scaled cluster'],
          ),
        ],
        educations: [
          Education(
            degree: 'Master Informatique',
            institution: 'Université de Paris',
            endDate: '2019',
          ),
        ],
        skills: [
          Skill(name: 'Dart', level: 5, category: 'Tech'),
        ],
        languages: [
          LanguageItem(name: 'Français', proficiency: LanguageProficiency.native),
        ],
        style: const CvStyle(
          templateId: AppConstants.templateClassic,
          primaryColorHex: '#0F766E',
        ),
      );

      final json = cv.toJson();
      final restored = CvModel.fromJson(json);

      expect(restored.id, cv.id);
      expect(restored.title, cv.title);
      expect(restored.language, AppConstants.langFr);
      expect(restored.personalInfo.fullName, 'Jean Dupont');
      expect(restored.personalInfo.hasPhoto, true);
      expect(restored.experiences.length, 1);
      expect(restored.experiences.first.highlights.length, 2);
      expect(restored.educations.length, 1);
      expect(restored.skills.length, 1);
      expect(restored.skills.first.level, 5);
      expect(restored.languages.first.proficiency, LanguageProficiency.native);
      expect(restored.style.templateId, AppConstants.templateClassic);
    });

    test('CvModel duplication creates unique ID and deep copies nested entities', () {
      final original = CvModel(
        title: 'Original Resume',
        experiences: [Experience(company: 'Google', position: 'SRE')],
        skills: [Skill(name: 'Kubernetes')],
      );

      final duplicate = original.duplicate();

      expect(duplicate.id, isNot(original.id));
      expect(duplicate.title, 'Original Resume (Copy)');
      expect(duplicate.experiences.length, 1);
      expect(duplicate.experiences.first.id, isNot(original.experiences.first.id));
      expect(duplicate.experiences.first.company, 'Google');
      expect(duplicate.skills.first.id, isNot(original.skills.first.id));
      expect(duplicate.skills.first.name, 'Kubernetes');
    });

    test('CvModel serialization roundtrip with new sections and fields', () {
      final cv = CvModel(
        title: 'Lead Architect',
        language: AppConstants.langEn,
        personalInfo: const PersonalInfo(
          firstName: 'Alexander',
          lastName: 'Wright',
          dateOfBirth: '1990-05-14',
          nationality: 'British',
          jobTitle: 'Senior Software Architect',
          email: 'alex@example.com',
        ),
        educations: [
          Education(
            degree: 'M.Sc.',
            fieldOfStudy: 'Computer Science',
            institution: 'Imperial College',
            country: 'UK',
            currentlyStudying: false,
          ),
        ],
        experiences: [
          Experience(
            jobTitle: 'Lead Architect',
            company: 'Tech Corp',
            currentlyWorking: true,
            achievements: ['Achievement 1', 'Achievement 2'],
          ),
        ],
        publications: [
          Publication(
            title: 'High-Throughput Systems',
            authors: 'A. Wright',
            publisher: 'IEEE',
            date: '2023',
            url: 'https://doi.org/10.1234/test',
          ),
        ],
        awards: [
          Award(
            title: 'Excellence in Tech',
            issuer: 'Tech Forum',
            date: '2022',
            description: 'Best Architect',
          ),
        ],
        volunteering: [
          Volunteering(
            organization: 'Code Org',
            role: 'Mentor',
            startDate: '2020',
            endDate: 'Present',
            isCurrent: true,
            description: 'Mentoring youth',
          ),
        ],
        references: [
          Reference(
            name: 'Sarah Jenkins',
            position: 'VP',
            organization: 'Tech Corp',
            email: 'sarah@example.com',
            phone: '+123456789',
          ),
        ],
      );

      final json = cv.toJson();
      final restored = CvModel.fromJson(json);

      expect(restored.personalInfo.fullName, 'Alexander Wright');
      expect(restored.personalInfo.firstName, 'Alexander');
      expect(restored.personalInfo.lastName, 'Wright');
      expect(restored.personalInfo.dateOfBirth, '1990-05-14');
      expect(restored.personalInfo.nationality, 'British');

      expect(restored.educations.first.fieldOfStudy, 'Computer Science');
      expect(restored.educations.first.country, 'UK');

      expect(restored.experiences.first.jobTitle, 'Lead Architect');
      expect(restored.experiences.first.currentlyWorking, true);
      expect(restored.experiences.first.achievements.length, 2);

      expect(restored.publications.length, 1);
      expect(restored.publications.first.title, 'High-Throughput Systems');

      expect(restored.awards.length, 1);
      expect(restored.awards.first.title, 'Excellence in Tech');

      expect(restored.volunteering.length, 1);
      expect(restored.volunteering.first.role, 'Mentor');
      expect(restored.volunteering.first.isCurrent, true);

      expect(restored.references.length, 1);
      expect(restored.references.first.name, 'Sarah Jenkins');

      // Duplicate deep copy test
      final duplicate = restored.duplicate();
      expect(duplicate.publications.first.id, isNot(restored.publications.first.id));
      expect(duplicate.awards.first.id, isNot(restored.awards.first.id));
      expect(duplicate.volunteering.first.id, isNot(restored.volunteering.first.id));
      expect(duplicate.references.first.id, isNot(restored.references.first.id));
    });

    test('PersonalInfo hasPhoto logic', () {
      const withPhotoEnabled = PersonalInfo(photoBase64: 'abc', showPhoto: true);
      expect(withPhotoEnabled.hasPhoto, true);

      const withPhotoDisabled = PersonalInfo(photoBase64: 'abc', showPhoto: false);
      expect(withPhotoDisabled.hasPhoto, false);

      const emptyPhoto = PersonalInfo(photoBase64: '', showPhoto: true);
      expect(emptyPhoto.hasPhoto, false);

      const nullPhoto = PersonalInfo(photoBase64: null, showPhoto: true);
      expect(nullPhoto.hasPhoto, false);
    });
  });
}
