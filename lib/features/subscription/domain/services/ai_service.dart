import '../../../cv/domain/models/cv_model.dart';

class AtsAnalysisResult {
  final int score; // 0 to 100
  final List<String> strengths;
  final List<String> improvements;
  final List<String> detectedKeywords;
  final List<String> missingKeywords;

  const AtsAnalysisResult({
    required this.score,
    required this.strengths,
    required this.improvements,
    required this.detectedKeywords,
    required this.missingKeywords,
  });
}

class JobMatchResult {
  final int matchPercentage;
  final List<String> matchedSkills;
  final List<String> missingSkills;
  final String recommendation;

  const JobMatchResult({
    required this.matchPercentage,
    required this.matchedSkills,
    required this.missingSkills,
    required this.recommendation,
  });
}

abstract class AiService {
  Future<String> improveCvSummary({
    required CvModel cv,
    required String targetLanguage,
  });

  Future<String> rewriteExperienceDescription({
    required String originalText,
    required String targetLanguage,
  });

  Future<List<String>> suggestSkills({
    required String jobTitle,
    required String targetLanguage,
  });

  Future<AtsAnalysisResult> analyzeAts({
    required CvModel cv,
    String? jobDescription,
  });

  Future<JobMatchResult> matchJobDescription({
    required CvModel cv,
    required String jobDescription,
  });

  Future<String> generateCoverLetter({
    required CvModel cv,
    required String companyName,
    required String targetRole,
    required String targetLanguage,
  });

  Future<List<String>> prepareInterviewQuestions({
    required CvModel cv,
    required String targetRole,
    required String targetLanguage,
  });
}
