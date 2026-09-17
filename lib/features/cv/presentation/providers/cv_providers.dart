import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/datasources/cv_local_data_source.dart';
import '../../data/repositories/cv_repository_impl.dart';
import '../../data/sample_cv_factory.dart';
import '../../domain/models/certification.dart';
import '../../domain/models/custom_section.dart';
import '../../domain/models/cv_model.dart';
import '../../domain/models/cv_style.dart';
import '../../domain/models/education.dart';
import '../../domain/models/experience.dart';
import '../../domain/models/language_item.dart';
import '../../domain/models/personal_info.dart';
import '../../domain/models/project.dart';
import '../../domain/models/publication.dart';
import '../../domain/models/award.dart';
import '../../domain/models/volunteering.dart';
import '../../domain/models/reference.dart';
import '../../domain/models/skill.dart';
import '../../domain/repositories/cv_repository.dart';

final cvLocalDataSourceProvider = Provider<CvLocalDataSource>((ref) {
  return CvLocalDataSource();
});

final cvRepositoryProvider = Provider<CvRepository>((ref) {
  final dataSource = ref.watch(cvLocalDataSourceProvider);
  return CvRepositoryImpl(dataSource);
});

// CV List State
class CvListState {
  final List<CvModel> cvs;
  final bool isLoading;
  final String searchQuery;
  final String languageFilter; // 'all', 'en', 'fr', 'ar'
  final String? errorMessage;

  const CvListState({
    this.cvs = const [],
    this.isLoading = true,
    this.searchQuery = '',
    this.languageFilter = 'all',
    this.errorMessage,
  });

  CvListState copyWith({
    List<CvModel>? cvs,
    bool? isLoading,
    String? searchQuery,
    String? languageFilter,
    String? errorMessage,
  }) {
    return CvListState(
      cvs: cvs ?? this.cvs,
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
      languageFilter: languageFilter ?? this.languageFilter,
      errorMessage: errorMessage,
    );
  }

  List<CvModel> get filteredCvs {
    return cvs.where((cv) {
      final matchesLang = languageFilter == 'all' || cv.language == languageFilter;
      final query = searchQuery.toLowerCase().trim();
      if (query.isEmpty) return matchesLang;

      final matchesQuery = cv.title.toLowerCase().contains(query) ||
          cv.personalInfo.fullName.toLowerCase().contains(query) ||
          cv.personalInfo.jobTitle.toLowerCase().contains(query);

      return matchesLang && matchesQuery;
    }).toList();
  }
}

class CvListNotifier extends StateNotifier<CvListState> {
  final CvRepository _repository;

  CvListNotifier(this._repository) : super(const CvListState()) {
    loadCvs();
  }

  Future<void> loadCvs() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _repository.seedInitialDataIfEmpty();
      final list = await _repository.getAllCvs();
      state = state.copyWith(cvs: list, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setLanguageFilter(String lang) {
    state = state.copyWith(languageFilter: lang);
  }

  Future<CvModel> createNewCv({
    required String title,
    required String language,
    bool prefillSample = false,
  }) async {
    CvModel newCv;
    if (prefillSample) {
      if (language == AppConstants.langAr) {
        newCv = SampleCvFactory.createArabicSample().copyWith(title: title);
      } else if (language == AppConstants.langFr) {
        newCv = SampleCvFactory.createFrenchSample().copyWith(title: title);
      } else {
        newCv = SampleCvFactory.createEnglishSample().copyWith(title: title);
      }
    } else {
      newCv = CvModel.empty(title: title, language: language);
    }

    await _repository.saveCv(newCv);
    await loadCvs();
    return newCv;
  }

  Future<CvModel> duplicateCv(String id) async {
    final duplicate = await _repository.duplicateCv(id);
    await loadCvs();
    return duplicate;
  }

  Future<void> deleteCv(String id) async {
    await _repository.deleteCv(id);
    await loadCvs();
  }

  Future<void> updateCv(CvModel cv) async {
    await _repository.saveCv(cv);
    final updatedList = state.cvs.map((c) => c.id == cv.id ? cv : c).toList();
    state = state.copyWith(cvs: updatedList);
  }
}

final cvListProvider = StateNotifierProvider<CvListNotifier, CvListState>((ref) {
  final repository = ref.watch(cvRepositoryProvider);
  return CvListNotifier(repository);
});

// CV Editor State
class CvEditorState {
  final CvModel cv;
  final bool isDirty;
  final bool isSaving;

  const CvEditorState({
    required this.cv,
    this.isDirty = false,
    this.isSaving = false,
  });

  CvEditorState copyWith({
    CvModel? cv,
    bool? isDirty,
    bool? isSaving,
  }) {
    return CvEditorState(
      cv: cv ?? this.cv,
      isDirty: isDirty ?? this.isDirty,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

class CvEditorNotifier extends StateNotifier<CvEditorState> {
  final CvRepository _repository;
  final Ref _ref;

  CvEditorNotifier(this._repository, this._ref, CvModel initialCv)
      : super(CvEditorState(cv: initialCv));

  void updatePersonalInfo(PersonalInfo info) {
    state = state.copyWith(
      cv: state.cv.copyWith(personalInfo: info),
      isDirty: true,
    );
  }

  void updateTitle(String title) {
    state = state.copyWith(
      cv: state.cv.copyWith(title: title),
      isDirty: true,
    );
  }

  void updateLanguage(String language) {
    state = state.copyWith(
      cv: state.cv.copyWith(
        language: language,
        style: state.cv.style.copyWith(
          fontFamily: language == AppConstants.langAr ? 'Cairo' : 'Roboto',
        ),
      ),
      isDirty: true,
    );
  }

  void updateExperiences(List<Experience> experiences) {
    state = state.copyWith(
      cv: state.cv.copyWith(experiences: experiences),
      isDirty: true,
    );
  }

  void updateEducations(List<Education> educations) {
    state = state.copyWith(
      cv: state.cv.copyWith(educations: educations),
      isDirty: true,
    );
  }

  void updateSkills(List<Skill> skills) {
    state = state.copyWith(
      cv: state.cv.copyWith(skills: skills),
      isDirty: true,
    );
  }

  void updateLanguages(List<LanguageItem> languages) {
    state = state.copyWith(
      cv: state.cv.copyWith(languages: languages),
      isDirty: true,
    );
  }

  void updateProjects(List<Project> projects) {
    state = state.copyWith(
      cv: state.cv.copyWith(projects: projects),
      isDirty: true,
    );
  }

  void updateCertifications(List<Certification> certifications) {
    state = state.copyWith(
      cv: state.cv.copyWith(certifications: certifications),
      isDirty: true,
    );
  }

  void updatePublications(List<Publication> publications) {
    state = state.copyWith(
      cv: state.cv.copyWith(publications: publications),
      isDirty: true,
    );
  }

  void updateAwards(List<Award> awards) {
    state = state.copyWith(
      cv: state.cv.copyWith(awards: awards),
      isDirty: true,
    );
  }

  void updateVolunteering(List<Volunteering> volunteering) {
    state = state.copyWith(
      cv: state.cv.copyWith(volunteering: volunteering),
      isDirty: true,
    );
  }

  void updateReferences(List<Reference> references) {
    state = state.copyWith(
      cv: state.cv.copyWith(references: references),
      isDirty: true,
    );
  }

  void updateCustomSections(List<CustomSection> customSections) {
    state = state.copyWith(
      cv: state.cv.copyWith(customSections: customSections),
      isDirty: true,
    );
  }

  void updateStyle(CvStyle style) {
    state = state.copyWith(
      cv: state.cv.copyWith(style: style),
      isDirty: true,
    );
  }

  void toggleShowPhoto() {
    state = state.copyWith(
      cv: state.cv.copyWith(
        personalInfo: state.cv.personalInfo.copyWith(
          showPhoto: !state.cv.personalInfo.showPhoto,
        ),
      ),
      isDirty: true,
    );
  }

  void updateTemplate(String templateId) {
    state = state.copyWith(
      cv: state.cv.copyWith(
        style: state.cv.style.copyWith(templateId: templateId),
      ),
      isDirty: true,
    );
  }

  Future<void> save() async {
    state = state.copyWith(isSaving: true);
    final updatedCv = state.cv.copyWith(updatedAt: DateTime.now());
    await _repository.saveCv(updatedCv);
    _ref.read(cvListProvider.notifier).updateCv(updatedCv);
    state = state.copyWith(cv: updatedCv, isDirty: false, isSaving: false);
  }
}

final cvEditorProvider =
    StateNotifierProvider.family<CvEditorNotifier, CvEditorState, CvModel>((ref, initialCv) {
  final repository = ref.watch(cvRepositoryProvider);
  return CvEditorNotifier(repository, ref, initialCv);
});
