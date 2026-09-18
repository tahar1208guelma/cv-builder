import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../pdf_export/services/pdf_generator_service.dart';
import '../../../subscription/domain/models/subscription_tier.dart';
import '../../../subscription/presentation/providers/subscription_providers.dart';
import '../../../subscription/presentation/widgets/upgrade_dialog.dart';
import '../../domain/models/cv_model.dart';
import '../../domain/models/skill.dart';
import '../providers/cv_providers.dart';
import '../widgets/common/confirm_dialog.dart';
import '../widgets/common/language_selector_dialog.dart';
import '../widgets/editor_sections/awards_editor.dart';
import '../widgets/editor_sections/certifications_editor.dart';
import '../widgets/editor_sections/custom_sections_editor.dart';
import '../widgets/editor_sections/education_editor.dart';
import '../widgets/editor_sections/experience_editor.dart';
import '../widgets/editor_sections/languages_editor.dart';
import '../widgets/editor_sections/personal_info_editor.dart';
import '../widgets/editor_sections/projects_editor.dart';
import '../widgets/editor_sections/publications_editor.dart';
import '../widgets/editor_sections/references_editor.dart';
import '../widgets/editor_sections/skills_editor.dart';
import '../widgets/editor_sections/style_editor.dart';
import '../widgets/editor_sections/volunteering_editor.dart';
import '../widgets/preview/live_cv_preview.dart';
import 'cv_preview_screen.dart';
import 'settings_screen.dart';

class CvEditorScreen extends ConsumerStatefulWidget {
  final CvModel initialCv;

  const CvEditorScreen({super.key, required this.initialCv});

  @override
  ConsumerState<CvEditorScreen> createState() => _CvEditorScreenState();
}

class _CvEditorScreenState extends ConsumerState<CvEditorScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _titleController;
  int _mobileViewMode = 0; // 0 = Form Editor, 1 = Live Preview
  bool _isSplitPreviewVisible = true;
  final double _splitRatio = 0.50;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 13, vsync: this);
    _titleController = TextEditingController(text: widget.initialCv.title);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop(CvEditorState editorState) async {
    if (!editorState.isDirty) return true;

    final shouldLeave = await ConfirmDialog.show(
      context,
      title: context.tr('unsaved_changes'),
      content: context.tr('unsaved_changes_desc'),
      confirmText: context.tr('discard_changes'),
      cancelText: context.tr('stay'),
      isDestructive: true,
    );

    return shouldLeave;
  }

  void _refreshPreview() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final editorState = ref.watch(cvEditorProvider(widget.initialCv));
    final editorNotifier = ref.read(cvEditorProvider(widget.initialCv).notifier);
    final currentCv = editorState.cv;
    final isWide = MediaQuery.of(context).size.width >= 1000;

    return PopScope(
      canPop: !editorState.isDirty,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final leave = await _onWillPop(editorState);
        if (leave && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: SizedBox(
            width: 320,
            child: TextField(
              controller: _titleController,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (val) => editorNotifier.updateTitle(val),
            ),
          ),
          actions: [
            // CV document language chip
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.description_outlined, size: 14, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 4),
                  Text(
                    'CV: ${currentCv.language.toUpperCase()} (${currentCv.isRtl ? "RTL" : "LTR"})',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: context.tr('language'),
              icon: const Icon(Icons.translate),
              onPressed: () => LanguageSelectorDialog.show(context),
            ),
            if (isWide)
              IconButton(
                tooltip: _isSplitPreviewVisible ? context.tr('hide_preview') : context.tr('show_preview'),
                icon: Icon(_isSplitPreviewVisible ? Icons.vertical_split : Icons.vertical_split_outlined),
                onPressed: () {
                  setState(() {
                    _isSplitPreviewVisible = !_isSplitPreviewVisible;
                  });
                },
              ),
            if (!isWide)
              IconButton(
                tooltip: _mobileViewMode == 0 ? context.tr('mobile_tab_preview') : context.tr('mobile_tab_edit'),
                icon: Icon(_mobileViewMode == 0 ? Icons.visibility_outlined : Icons.edit_outlined),
                onPressed: () {
                  setState(() {
                    _mobileViewMode = _mobileViewMode == 0 ? 1 : 0;
                  });
                },
              ),
            IconButton(
              tooltip: context.tr('ai_assistant'),
              icon: const Icon(Icons.auto_awesome_rounded, color: Colors.purple),
              onPressed: () => _showAiAssistantModal(context, editorNotifier, currentCv),
            ),
            IconButton(
              tooltip: context.tr('export_pdf'),
              icon: const Icon(Icons.file_download_outlined),
              onPressed: () => PdfGeneratorService.shareOrSavePdf(currentCv),
            ),
            IconButton(
              tooltip: context.tr('settings_title'),
              icon: const Icon(Icons.settings_outlined),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const SettingsScreen(),
                  ),
                );
              },
            ),
            const SizedBox(width: 8),
            FilledButton.icon(
              onPressed: editorState.isSaving
                  ? null
                  : () async {
                      await editorNotifier.save();
                      _refreshPreview();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(context.tr('save_success')),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
              icon: editorState.isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Stack(
                      children: [
                        const Icon(Icons.save_outlined, size: 18),
                        if (editorState.isDirty)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.orange,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
              label: Text(context.tr('save')),
            ),
            const SizedBox(width: 16),
          ],
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: context.tr('tab_personal'), icon: const Icon(Icons.person_outline, size: 18)),
              Tab(text: context.tr('tab_experience'), icon: const Icon(Icons.work_outline, size: 18)),
              Tab(text: context.tr('tab_education'), icon: const Icon(Icons.school_outlined, size: 18)),
              Tab(text: context.tr('tab_skills'), icon: const Icon(Icons.star_outline, size: 18)),
              Tab(text: context.tr('tab_languages'), icon: const Icon(Icons.translate, size: 18)),
              Tab(text: context.tr('tab_certifications'), icon: const Icon(Icons.card_membership_outlined, size: 18)),
              Tab(text: context.tr('tab_projects'), icon: const Icon(Icons.code, size: 18)),
              Tab(text: context.tr('tab_publications'), icon: const Icon(Icons.menu_book_outlined, size: 18)),
              Tab(text: context.tr('tab_awards'), icon: const Icon(Icons.emoji_events_outlined, size: 18)),
              Tab(text: context.tr('tab_volunteering'), icon: const Icon(Icons.volunteer_activism_outlined, size: 18)),
              Tab(text: context.tr('tab_references'), icon: const Icon(Icons.people_outline, size: 18)),
              Tab(text: context.tr('tab_custom'), icon: const Icon(Icons.dashboard_customize_outlined, size: 18)),
              Tab(text: context.tr('tab_style'), icon: const Icon(Icons.palette_outlined, size: 18)),
            ],
          ),
        ),
        body: isWide
            ? Row(
                children: [
                  // Left: Form Editor
                  Expanded(
                    flex: _isSplitPreviewVisible ? (_splitRatio * 100).toInt() : 100,
                    child: _buildTabBarView(editorNotifier, currentCv),
                  ),
                  if (_isSplitPreviewVisible) ...[
                    const VerticalDivider(width: 1),
                    // Right: Live PDF Preview
                    Expanded(
                      flex: ((1.0 - _splitRatio) * 100).toInt(),
                      child: LiveCvPreview(
                        cv: currentCv,
                        isSplitScreen: true,
                        onTemplateChanged: (templateId) {
                          editorNotifier.updateTemplate(templateId);
                        },
                        onTogglePhoto: (show) {
                          editorNotifier.toggleShowPhoto();
                        },
                        onFullscreen: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => CvPreviewScreen(cv: currentCv),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              )
            : (_mobileViewMode == 0
                ? _buildTabBarView(editorNotifier, currentCv)
                : LiveCvPreview(
                    cv: currentCv,
                    isSplitScreen: false,
                    onTemplateChanged: (templateId) {
                      editorNotifier.updateTemplate(templateId);
                    },
                    onTogglePhoto: (show) {
                      editorNotifier.toggleShowPhoto();
                    },
                    onFullscreen: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => CvPreviewScreen(cv: currentCv),
                        ),
                      );
                    },
                  )),
        bottomNavigationBar: !isWide
            ? NavigationBar(
                selectedIndex: _mobileViewMode,
                onDestinationSelected: (idx) {
                  setState(() {
                    _mobileViewMode = idx;
                  });
                },
                destinations: [
                  NavigationDestination(
                    icon: const Icon(Icons.edit_outlined),
                    selectedIcon: const Icon(Icons.edit),
                    label: context.tr('mobile_tab_edit'),
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.visibility_outlined),
                    selectedIcon: const Icon(Icons.visibility),
                    label: context.tr('mobile_tab_preview'),
                  ),
                ],
              )
            : null,
      ),
    );
  }

  Widget _buildTabBarView(CvEditorNotifier editorNotifier, CvModel currentCv) {
    return TabBarView(
      controller: _tabController,
      children: [
        PersonalInfoEditor(
          personalInfo: currentCv.personalInfo,
          onChanged: (info) {
            editorNotifier.updatePersonalInfo(info);
          },
        ),
        ExperienceEditor(
          experiences: currentCv.experiences,
          onChanged: (exp) {
            editorNotifier.updateExperiences(exp);
          },
        ),
        EducationEditor(
          educations: currentCv.educations,
          onChanged: (edu) {
            editorNotifier.updateEducations(edu);
          },
        ),
        SkillsEditor(
          skills: currentCv.skills,
          onChanged: (skills) {
            editorNotifier.updateSkills(skills);
          },
        ),
        LanguagesEditor(
          languages: currentCv.languages,
          onChanged: (langs) {
            editorNotifier.updateLanguages(langs);
          },
        ),
        CertificationsEditor(
          certifications: currentCv.certifications,
          onChanged: (certs) {
            editorNotifier.updateCertifications(certs);
          },
        ),
        ProjectsEditor(
          projects: currentCv.projects,
          onChanged: (projs) {
            editorNotifier.updateProjects(projs);
          },
        ),
        PublicationsEditor(
          publications: currentCv.publications,
          onChanged: (pubs) {
            editorNotifier.updatePublications(pubs);
          },
        ),
        AwardsEditor(
          awards: currentCv.awards,
          onChanged: (awards) {
            editorNotifier.updateAwards(awards);
          },
        ),
        VolunteeringEditor(
          volunteering: currentCv.volunteering,
          onChanged: (vol) {
            editorNotifier.updateVolunteering(vol);
          },
        ),
        ReferencesEditor(
          references: currentCv.references,
          onChanged: (refs) {
            editorNotifier.updateReferences(refs);
          },
        ),
        CustomSectionsEditor(
          customSections: currentCv.customSections,
          onChanged: (custom) {
            editorNotifier.updateCustomSections(custom);
          },
        ),
        StyleEditor(
          style: currentCv.style,
          cvLanguage: currentCv.language,
          onStyleChanged: (style) {
            editorNotifier.updateStyle(style);
            _refreshPreview();
          },
          onLanguageChanged: (lang) {
            editorNotifier.updateLanguage(lang);
            _refreshPreview();
          },
        ),
      ],
    );
  }

  Future<void> _showAiAssistantModal(
    BuildContext context,
    CvEditorNotifier editorNotifier,
    CvModel currentCv,
  ) async {
    final status = ref.read(subscriptionStatusProvider);
    final usage = ref.read(usageMetricsProvider);
    final entitlement = ref.read(entitlementServiceProvider);

    if (!entitlement.canUseAi(tier: status.tier, currentUsage: usage.aiOperationsUsed)) {
      UpgradeDialog.show(
        context,
        featureKey: 'ai_assistant',
        requiredTier: status.tier == SubscriptionTier.free
            ? SubscriptionTier.pro
            : SubscriptionTier.premium,
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.auto_awesome_rounded, color: Colors.purple),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr('ai_assistant'),
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            status.tier.isUnlimitedAi
                                ? context.tr('usage_unlimited')
                                : '${entitlement.getRemainingAiOperations(tier: status.tier, currentUsage: usage.aiOperationsUsed)} ${context.tr('feature_ai_free')}',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFEDE7F6),
                    child: Icon(Icons.text_fields_rounded, color: Colors.deepPurple),
                  ),
                  title: Text(context.tr('ai_improve_summary')),
                  subtitle: Text(
                    context.tr('feature_ai_pro_30_benefit'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () async {
                    Navigator.of(ctx).pop();
                    await _improveSummaryWithAi(context, editorNotifier, currentCv);
                  },
                ),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFE8F5E9),
                    child: Icon(Icons.lightbulb_outline_rounded, color: Colors.green),
                  ),
                  title: Text(context.tr('ai_suggest_skills')),
                  subtitle: Text(
                    context.tr('feature_all_sections'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () async {
                    Navigator.of(ctx).pop();
                    await _suggestSkillsWithAi(context, editorNotifier, currentCv);
                  },
                ),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFE3F2FD),
                    child: Icon(Icons.analytics_outlined, color: Colors.blue),
                  ),
                  title: Text(context.tr('ai_ats_check')),
                  subtitle: Text(
                    status.tier.isProOrHigher
                        ? context.tr('feature_ats_analysis')
                        : context.tr('available_with_pro'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: status.tier.isProOrHigher
                      ? const Icon(Icons.arrow_forward_ios, size: 16)
                      : const Icon(Icons.lock_outline_rounded, size: 16, color: Colors.orange),
                  onTap: () async {
                    Navigator.of(ctx).pop();
                    if (!entitlement.canUseAtsAnalysis(status.tier)) {
                      UpgradeDialog.show(
                        context,
                        featureKey: 'feature_ats_analysis',
                        requiredTier: SubscriptionTier.pro,
                      );
                      return;
                    }
                    await _runAtsCheck(context, currentCv);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _improveSummaryWithAi(
    BuildContext context,
    CvEditorNotifier editorNotifier,
    CvModel currentCv,
  ) async {
    final aiService = ref.read(aiServiceProvider);
    final improved = await aiService.improveCvSummary(
      cv: currentCv,
      targetLanguage: currentCv.language,
    );
    final updatedInfo = currentCv.personalInfo.copyWith(summary: improved);
    editorNotifier.updatePersonalInfo(updatedInfo);
    await ref.read(usageMetricsProvider.notifier).recordAi();
    _refreshPreview();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.tr('ai_operation_success')),
          backgroundColor: Colors.green.shade700,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _suggestSkillsWithAi(
    BuildContext context,
    CvEditorNotifier editorNotifier,
    CvModel currentCv,
  ) async {
    final aiService = ref.read(aiServiceProvider);
    final jobTitle = currentCv.personalInfo.jobTitle.isNotEmpty
        ? currentCv.personalInfo.jobTitle
        : (currentCv.experiences.isNotEmpty ? currentCv.experiences.first.jobTitle : 'Software Developer');
    final skills = await aiService.suggestSkills(
      jobTitle: jobTitle,
      targetLanguage: currentCv.language,
    );

    final existingNames = currentCv.skills.map((s) => s.name.toLowerCase()).toSet();
    final newSkills = List<Skill>.from(currentCv.skills);
    for (final skillName in skills) {
      if (!existingNames.contains(skillName.toLowerCase())) {
        newSkills.add(Skill(
          name: skillName,
          level: 4,
        ));
      }
    }

    editorNotifier.updateSkills(newSkills);
    await ref.read(usageMetricsProvider.notifier).recordAi();
    _refreshPreview();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${context.tr('ai_operation_success')} (${skills.length} skills)'),
          backgroundColor: Colors.green.shade700,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _runAtsCheck(BuildContext context, CvModel currentCv) async {
    final aiService = ref.read(aiServiceProvider);
    final result = await aiService.analyzeAts(cv: currentCv);
    await ref.read(usageMetricsProvider.notifier).recordAts();
    await ref.read(usageMetricsProvider.notifier).recordAi();

    if (!context.mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.analytics_outlined, color: Colors.blue),
            const SizedBox(width: 8),
            Text(context.tr('ai_ats_check')),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Text(
                      '${result.score} / 100',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: result.score >= 80 ? Colors.green : Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      context.tr('feature_ats_analysis'),
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Strengths:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              ...result.strengths.map((s) => Text('• $s')),
              const SizedBox(height: 12),
              const Text(
                'Recommendations:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              ...result.improvements.map((i) => Text('• $i')),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

