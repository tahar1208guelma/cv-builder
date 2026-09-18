class UsageMetrics {
  final int aiOperationsUsed;
  final int coverLettersCreated;
  final int atsAnalysesRun;
  final int jobMatchesRun;
  final DateTime periodStartDate;

  const UsageMetrics({
    this.aiOperationsUsed = 0,
    this.coverLettersCreated = 0,
    this.atsAnalysesRun = 0,
    this.jobMatchesRun = 0,
    required this.periodStartDate,
  });

  factory UsageMetrics.initial() {
    final now = DateTime.now();
    return UsageMetrics(
      aiOperationsUsed: 0,
      coverLettersCreated: 0,
      atsAnalysesRun: 0,
      jobMatchesRun: 0,
      periodStartDate: DateTime(now.year, now.month, 1),
    );
  }

  bool isNewMonth(DateTime now) {
    return now.year != periodStartDate.year || now.month != periodStartDate.month;
  }

  UsageMetrics resetForNewPeriod(DateTime newPeriodStart) {
    return UsageMetrics(
      aiOperationsUsed: 0,
      coverLettersCreated: 0,
      atsAnalysesRun: 0,
      jobMatchesRun: 0,
      periodStartDate: DateTime(newPeriodStart.year, newPeriodStart.month, 1),
    );
  }

  UsageMetrics incrementAi() {
    return copyWith(aiOperationsUsed: aiOperationsUsed + 1);
  }

  UsageMetrics incrementCoverLetters() {
    return copyWith(coverLettersCreated: coverLettersCreated + 1);
  }

  UsageMetrics incrementAts() {
    return copyWith(atsAnalysesRun: atsAnalysesRun + 1);
  }

  UsageMetrics incrementJobMatches() {
    return copyWith(jobMatchesRun: jobMatchesRun + 1);
  }

  UsageMetrics copyWith({
    int? aiOperationsUsed,
    int? coverLettersCreated,
    int? atsAnalysesRun,
    int? jobMatchesRun,
    DateTime? periodStartDate,
  }) {
    return UsageMetrics(
      aiOperationsUsed: aiOperationsUsed ?? this.aiOperationsUsed,
      coverLettersCreated: coverLettersCreated ?? this.coverLettersCreated,
      atsAnalysesRun: atsAnalysesRun ?? this.atsAnalysesRun,
      jobMatchesRun: jobMatchesRun ?? this.jobMatchesRun,
      periodStartDate: periodStartDate ?? this.periodStartDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ai_operations_used': aiOperationsUsed,
      'cover_letters_created': coverLettersCreated,
      'ats_analyses_run': atsAnalysesRun,
      'job_matches_run': jobMatchesRun,
      'period_start_date': periodStartDate.toIso8601String(),
    };
  }

  factory UsageMetrics.fromJson(Map<String, dynamic> json) {
    return UsageMetrics(
      aiOperationsUsed: json['ai_operations_used'] as int? ?? 0,
      coverLettersCreated: json['cover_letters_created'] as int? ?? 0,
      atsAnalysesRun: json['ats_analyses_run'] as int? ?? 0,
      jobMatchesRun: json['job_matches_run'] as int? ?? 0,
      periodStartDate: json['period_start_date'] != null
          ? DateTime.tryParse(json['period_start_date'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
