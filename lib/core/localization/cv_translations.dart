class CvDateFormatter {
  static const Map<String, List<String>> _months = {
    'en': [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ],
    'fr': [
      'janv.', 'févr.', 'mars', 'avr.', 'mai', 'juin',
      'juil.', 'août', 'sept.', 'oct.', 'nov.', 'déc.'
    ],
    'ar': [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ],
  };

  /// Localizes an ISO or YYYY-MM formatted date according to the CV's language
  static String formatCvDate(String rawDate, String langCode) {
    final trimmed = rawDate.trim();
    if (trimmed.isEmpty) return '';

    final monthsList = _months[langCode] ?? _months['en']!;

    // Match YYYY-MM-DD
    final fullIsoMatch = RegExp(r'^(\d{4})-(\d{1,2})-(\d{1,2})$').firstMatch(trimmed);
    if (fullIsoMatch != null) {
      final year = fullIsoMatch.group(1)!;
      final month = int.tryParse(fullIsoMatch.group(2)!) ?? 1;
      final day = int.tryParse(fullIsoMatch.group(3)!) ?? 1;
      final mIdx = (month - 1).clamp(0, 11);
      final monthStr = monthsList[mIdx];

      if (langCode == 'ar') {
        return '$day $monthStr $year';
      } else if (langCode == 'fr') {
        return '$day $monthStr $year';
      } else {
        return '$monthStr $day, $year';
      }
    }

    // Match YYYY-MM
    final yearMonthMatch = RegExp(r'^(\d{4})-(\d{1,2})$').firstMatch(trimmed);
    if (yearMonthMatch != null) {
      final year = yearMonthMatch.group(1)!;
      final month = int.tryParse(yearMonthMatch.group(2)!) ?? 1;
      final mIdx = (month - 1).clamp(0, 11);
      final monthStr = monthsList[mIdx];
      return '$monthStr $year';
    }

    return trimmed;
  }

  /// Formats a date range with localized "present" and separator
  static String formatDateRange({
    required String startDate,
    required String endDate,
    required bool isCurrent,
    required String langCode,
  }) {
    final startFormatted = formatCvDate(startDate, langCode);
    final endFormatted = isCurrent
        ? CvTranslations.get(langCode, 'present')
        : formatCvDate(endDate, langCode);

    if (startFormatted.isEmpty && endFormatted.isEmpty) return '';
    if (startFormatted.isEmpty) return endFormatted;
    if (endFormatted.isEmpty) return startFormatted;

    // Use consistent en-dash separator
    return '$startFormatted – $endFormatted';
  }
}

class CvTranslations {
  static const Map<String, Map<String, String>> _sectionTitles = {
    'en': {
      'personal_details': 'Personal Details',
      'summary': 'Professional Summary',
      'experience': 'Work Experience',
      'education': 'Education',
      'skills': 'Skills',
      'languages': 'Languages',
      'projects': 'Projects',
      'certifications': 'Certifications',
      'publications': 'Publications',
      'awards': 'Awards & Honors',
      'volunteering': 'Volunteering Experience',
      'references': 'References',
      'achievements': 'Key Achievements',
      'contact': 'Contact Information',
      'present': 'Present',
      'native': 'Native',
      'fluent': 'Fluent',
      'intermediate': 'Intermediate',
      'basic': 'Basic',
      'page': 'Page',
      'of': 'of',
      'dob': 'Date of Birth',
      'nationality': 'Nationality',
      'curriculum_vitae': 'Curriculum Vitae',
    },
    'fr': {
      'personal_details': 'Informations Personnelles',
      'summary': 'Profil Professionnel',
      'experience': 'Expérience Professionnelle',
      'education': 'Formation & Diplômes',
      'skills': 'Compétences',
      'languages': 'Langues',
      'projects': 'Projets Réalisés',
      'certifications': 'Certifications',
      'publications': 'Publications',
      'awards': 'Prix & Distinctions',
      'volunteering': 'Bénévolat & Engagement',
      'references': 'Références',
      'achievements': 'Réalisations Clés',
      'contact': 'Coordonnées',
      'present': 'Présent',
      'native': 'Langue maternelle',
      'fluent': 'Courant',
      'intermediate': 'Intermédiaire',
      'basic': 'Notions',
      'page': 'Page',
      'of': 'sur',
      'dob': 'Date de naissance',
      'nationality': 'Nationalité',
      'curriculum_vitae': 'Curriculum Vitae',
    },
    'ar': {
      'personal_details': 'المعلومات الشخصية',
      'summary': 'الملخص المهني',
      'experience': 'الخبرات المهنية',
      'education': 'المؤهلات التعليمية',
      'skills': 'المهارات والقدرات',
      'languages': 'اللغات',
      'projects': 'المشاريع والإنجازات',
      'certifications': 'الشهادات المهنية',
      'publications': 'المنشورات والأبحاث',
      'awards': 'الجوائز والتكريمات',
      'volunteering': 'العمل التطوعي',
      'references': 'المراجع والمعرفون',
      'achievements': 'أبرز الإنجازات',
      'contact': 'بيانات التواصل',
      'present': 'حتى الآن',
      'native': 'اللغة الأم',
      'fluent': 'متقن بطلاقة',
      'intermediate': 'متوسط',
      'basic': 'مبتدئ',
      'page': 'الصفحة',
      'of': 'من',
      'dob': 'تاريخ الميلاد',
      'nationality': 'الجنسية',
      'curriculum_vitae': 'السيرة الذاتية والأكاديمية',
    },
  };

  static String get(String langCode, String key) {
    final langMap = _sectionTitles[langCode] ?? _sectionTitles['en']!;
    return langMap[key] ?? key;
  }
}
