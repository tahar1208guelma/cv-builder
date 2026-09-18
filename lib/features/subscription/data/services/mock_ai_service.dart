import '../../../cv/domain/models/cv_model.dart';
import '../../domain/services/ai_service.dart';

class MockAiService implements AiService {
  const MockAiService();

  @override
  Future<String> improveCvSummary({
    required CvModel cv,
    required String targetLanguage,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final role = cv.personalInfo.jobTitle.isNotEmpty ? cv.personalInfo.jobTitle : 'Specialist';

    if (targetLanguage == 'ar') {
      return 'محترف متمرس في مجال $role يتمتع بخبرة مثبتة في تحقيق النتائج الاستراتيجية وقيادة المشاريع التقنية بكفاءة عالية. شغوف بتطبيق أفضل الممارسات وتطوير حلول مبتكرة تسهم في نمو المؤسسة وتحسين الأداء.';
    } else if (targetLanguage == 'fr') {
      return 'Professionnel chevronné en tant que $role, fort d\'une solide expérience dans la réalisation d\'objectifs stratégiques et la direction de projets complexes. Passionné par l\'innovation, l\'excellence opérationnelle et la création de valeur durable.';
    } else {
      return 'Results-driven and highly accomplished $role with a proven track record of delivering impactful solutions, leading cross-functional teams, and optimizing operational workflows. Committed to leveraging modern best practices to drive sustainable business growth.';
    }
  }

  @override
  Future<String> rewriteExperienceDescription({
    required String originalText,
    required String targetLanguage,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (originalText.trim().isEmpty) {
      if (targetLanguage == 'ar') {
        return '• قيادة تنفيذ المبادرات الاستراتيجية وتحسين كفاءة العمليات التشغيلية بنسبة 25%.\n• التعاون الفعال مع الفرق متعددة التخصصات لتقديم حلول عالية الجودة وفق الجداول الزمنية المحددة.\n• الإشراف على معايير الجودة وتطبيق أفضل الممارسات التقنية والإدارية.';
      } else if (targetLanguage == 'fr') {
        return '• Pilotage d\'initiatives stratégiques augmentant l\'efficacité opérationnelle de 25%.\n• Collaboration étroite avec des équipes pluridisciplinaires pour livrer des solutions conformes aux exigences.\n• Mise en place de standards de qualité élevés et optimisation continue des processus.';
      } else {
        return '• Spearheaded strategic initiatives that enhanced operational efficiency by over 25%.\n• Collaborated seamlessly with cross-functional stakeholders to deliver high-impact deliverables on schedule.\n• Championed engineering and management best practices, ensuring superior output quality and compliance.';
      }
    }

    if (targetLanguage == 'ar') {
      return '• تمكين وتطوير $originalText مع تعزيز الإنتاجية وتقليل التكاليف.\n• تطبيق منهجيات حديثة لضمان استدامة النتائج وتحقيق معايير الجودة المتميزة.';
    } else if (targetLanguage == 'fr') {
      return '• Optimisation de : $originalText avec une amélioration mesurable des performances.\n• Déploiement de méthodologies rigoureuses garantissant qualité et pérennité.';
    } else {
      return '• Strategically optimized $originalText, resulting in measurable performance improvements.\n• Implemented agile and scalable methodologies ensuring excellence and timely milestone achievements.';
    }
  }

  @override
  Future<List<String>> suggestSkills({
    required String jobTitle,
    required String targetLanguage,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final lowerTitle = jobTitle.toLowerCase();

    if (lowerTitle.contains('software') || lowerTitle.contains('developer') || lowerTitle.contains('engineer')) {
      if (targetLanguage == 'ar') {
        return ['هندسة البرمجيات', 'إدارة المشاريع Agile', 'الحوسبة السحابية (Cloud)', 'تحليل النظم', 'حل المشكلات المعقدة', 'DevOps & CI/CD'];
      } else if (targetLanguage == 'fr') {
        return ['Architecture logicielle', 'Méthodes Agiles / Scrum', 'Cloud Computing', 'Optimisation CI/CD', 'Résolution de problèmes', 'Sécurité informatique'];
      } else {
        return ['Software Architecture', 'Agile & Scrum Methodologies', 'Cloud Infrastructure (AWS/GCP)', 'CI/CD Pipelines', 'Complex Problem Solving', 'API Design & Integration'];
      }
    }

    if (targetLanguage == 'ar') {
      return ['القيادة وإدارة الفرق', 'التخطيط الاستراتيجي', 'التواصل الفعال', 'إدارة الوقت والأولويات', 'تحليل البيانات واتخاذ القرار'];
    } else if (targetLanguage == 'fr') {
      return ['Leadership d\'équipe', 'Planification stratégique', 'Communication persuasive', 'Analyse décisionnelle', 'Gestion de projet'];
    } else {
      return ['Strategic Planning', 'Team Leadership', 'Stakeholder Communication', 'Data-Driven Decision Making', 'Project Management'];
    }
  }

  @override
  Future<AtsAnalysisResult> analyzeAts({
    required CvModel cv,
    String? jobDescription,
  }) async {
    await Future.delayed(const Duration(milliseconds: 350));
    int score = 75;
    final strengths = <String>[];
    final improvements = <String>[];
    final detected = <String>[];
    final missing = <String>[];

    if (cv.personalInfo.fullName.isNotEmpty) strengths.add('Contact information is clearly visible');
    if (cv.experiences.isNotEmpty) {
      score += 10;
      strengths.add('Document contains structured professional experience');
    } else {
      improvements.add('Add relevant work experiences with quantifiable achievements');
    }

    if (cv.skills.isNotEmpty) {
      score += 10;
      strengths.add('Skills section is formatted with recognized keywords');
      detected.addAll(cv.skills.take(5).map((s) => s.name));
    } else {
      improvements.add('Add at least 5 core industry skills to improve keyword match');
    }

    if (cv.educations.isNotEmpty) {
      strengths.add('Academic credentials and graduation dates are present');
    }

    missing.addAll(['Leadership', 'Strategic Analysis', 'Cross-Functional Collaboration']);

    return AtsAnalysisResult(
      score: score.clamp(0, 98),
      strengths: strengths,
      improvements: improvements,
      detectedKeywords: detected,
      missingKeywords: missing,
    );
  }

  @override
  Future<JobMatchResult> matchJobDescription({
    required CvModel cv,
    required String jobDescription,
  }) async {
    await Future.delayed(const Duration(milliseconds: 350));
    final cvSkills = cv.skills.map((s) => s.name.toLowerCase()).toSet();
    final sampleJobSkills = ['flutter', 'dart', 'git', 'ci/cd', 'agile', 'architecture', 'api'];

    final matched = <String>[];
    final missing = <String>[];

    for (final skill in sampleJobSkills) {
      if (cvSkills.any((s) => s.contains(skill))) {
        matched.add(skill.toUpperCase());
      } else {
        missing.add(skill.toUpperCase());
      }
    }

    if (matched.isEmpty) {
      matched.addAll(['Communication', 'Problem Solving']);
    }

    final pct = ((matched.length / (matched.length + missing.length)) * 100).round().clamp(65, 95);

    return JobMatchResult(
      matchPercentage: pct,
      matchedSkills: matched,
      missingSkills: missing,
      recommendation: pct >= 80
          ? 'Strong match for this position. Tailor your recent accomplishments to highlight target keywords.'
          : 'Good baseline match. Consider emphasizing missing keywords and domain experience.',
    );
  }

  @override
  Future<String> generateCoverLetter({
    required CvModel cv,
    required String companyName,
    required String targetRole,
    required String targetLanguage,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final candidateName = cv.personalInfo.fullName.isNotEmpty ? cv.personalInfo.fullName : 'Applicant';

    if (targetLanguage == 'ar') {
      return '''إلى لجنة التوظيف الموقرة في $companyName،

يشرفني أن أتقدم بطلبي لشغل وظيفة $targetRole في شركتكم الرائدة. بفضل مسيرتي المهنية وخبرتي المتراكمة، يسعدني المساهمة الفعالة في تحقيق تطلعات فريقكم.

خلال مسيرتي المهنية، نجحت في قيادة العديد من المشاريع الحيوية وحققت نتائج ملموسة تواكب أعلى معايير الجودة والابتكار. إن بيئة العمل المتميزة في $companyName تمثل الوجهة المثالية لتوظيف مهاراتي وإضافة قيمة مستدامة.

أتطلع بكل سرور لفرصة مناقشة مؤهلاتي وكيف يمكن لخبراتي أن تلبي متطلباتكم في مقابلة شخصية.

مع خالص التقدير والاحترام،
$candidateName''';
    } else if (targetLanguage == 'fr') {
      return '''À l'attention du comité de recrutement de $companyName,

C'est avec un grand enthousiasme que je vous adresse ma candidature pour le poste de $targetRole. Ayant suivi le développement remarquable de votre organisation, je serais ravi de mettre mon expertise au service de vos objectifs stratégiques.

Fort de réalisations significatives dans la conduite de projets et l'optimisation des performances, je sais allier rigueur méthodologique et créativité technique pour délivrer des résultats mesurables.

Je me tiens à votre entière disposition pour échanger de vive voix lors d'un entretien.

Veuillez agréer mes salutations distinguées,
$candidateName''';
    } else {
      return '''Dear Hiring Team at $companyName,

I am writing to express my strong interest in the $targetRole position currently available at $companyName. With a solid foundation in driving high-impact initiatives and collaborating across dynamic teams, I am confident in my ability to deliver immediate value to your organization.

Throughout my career, I have consistently demonstrated a commitment to operational excellence, rigorous problem-solving, and continuous innovation. The forward-thinking mission of $companyName aligns closely with my professional values, and I am excited about the opportunity to contribute to your ongoing success.

Thank you for your time and consideration. I welcome the opportunity to discuss how my background and skill set align with your goals in an interview.

Sincerely,
$candidateName''';
    }
  }

  @override
  Future<List<String>> prepareInterviewQuestions({
    required CvModel cv,
    required String targetRole,
    required String targetLanguage,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (targetLanguage == 'ar') {
      return [
        'كيف تصف تجربتك الأكثر تحدياً في دور $targetRole وكيف تغلبت على الصعوبات؟',
        'ما هي الاستراتيجية التي تعتمدها لضمان تسليم المشاريع بالجودة المطلوبة وفي الوقت المحدد؟',
        'كيف تتعامل مع الأولويات المتضاربة وآراء أصحاب المصلحة متعددي التخصصات؟',
        'ما هي الإنجازات التقنية أو التنظيمية التي تفتخر بها في مسيرتك المهنية؟',
      ];
    } else if (targetLanguage == 'fr') {
      return [
        'Pouvez-vous décrire un défi majeur rencontré en tant que $targetRole et comment vous l\'avez résolu ?',
        'Quelle méthode appliquez-vous pour concilier délais serrés et haute qualité d\'exécution ?',
        'Comment gérez-vous les retours critiques et les divergences au sein d\'une équipe pluridisciplinaire ?',
        'Quelle réalisation professionnelle illustre le mieux votre impact direct sur les résultats de l\'entreprise ?',
      ];
    } else {
      return [
        'Can you describe your most challenging project as a $targetRole and how you navigated key roadblocks?',
        'How do you prioritize competing deadlines while maintaining high engineering and design quality?',
        'Describe a situation where you had to align cross-functional stakeholders with differing priorities.',
        'Which achievement in your recent career best demonstrates your strategic impact on business outcomes?',
      ];
    }
  }
}
