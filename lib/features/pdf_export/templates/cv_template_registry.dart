import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../cv/domain/models/cv_model.dart';
import '../../subscription/domain/models/subscription_tier.dart';
import '../services/pdf_font_manager.dart';
import 'academic_template.dart';
import 'ats_friendly_template.dart';
import 'base_pdf_template.dart';
import 'classic_template.dart';
import 'cv_template_definition.dart';
import 'executive_template.dart';
import 'minimalist_template.dart';
import 'modern_template.dart';
import 'professional_template.dart';

/// Registry managing all available CV templates.
/// Allows adding new templates modularly without modifying CV models or callers.
class CvTemplateRegistry {
  static final Map<String, CvTemplateDefinition> _templates = {};

  static bool _initialized = false;

  static void initialize() {
    if (_initialized) return;

    // Primary 4 Templates
    register(CvTemplateDefinition(
      id: AppConstants.templateProfessional,
      titleKey: 'template_professional_title',
      descriptionKey: 'template_professional_desc',
      icon: Icons.business_center_outlined,
      isPrimary: true,
      factory: ({required cv, required fonts}) =>
          ProfessionalTemplate(cv: cv, fonts: fonts),
    ));

    register(CvTemplateDefinition(
      id: AppConstants.templateModern,
      titleKey: 'template_modern_title',
      descriptionKey: 'template_modern_desc',
      icon: Icons.view_sidebar_outlined,
      isPrimary: true,
      factory: ({required cv, required fonts}) =>
          ModernTemplate(cv: cv, fonts: fonts),
    ));

    register(CvTemplateDefinition(
      id: AppConstants.templateAcademic,
      titleKey: 'template_academic_title',
      descriptionKey: 'template_academic_desc',
      icon: Icons.school_outlined,
      isPrimary: true,
      factory: ({required cv, required fonts}) =>
          AcademicTemplate(cv: cv, fonts: fonts),
    ));

    register(CvTemplateDefinition(
      id: AppConstants.templateAts,
      titleKey: 'template_ats_title',
      descriptionKey: 'template_ats_desc',
      icon: Icons.text_snippet_outlined,
      isPrimary: true,
      factory: ({required cv, required fonts}) =>
          AtsFriendlyTemplate(cv: cv, fonts: fonts),
    ));

    // Legacy templates preserved for backward compatibility
    register(CvTemplateDefinition(
      id: AppConstants.templateClassic,
      titleKey: 'template_classic_title',
      descriptionKey: 'template_classic_desc',
      icon: Icons.article_outlined,
      isPrimary: false,
      factory: ({required cv, required fonts}) =>
          ClassicTemplate(cv: cv, fonts: fonts),
    ));

    register(CvTemplateDefinition(
      id: AppConstants.templateMinimalist,
      titleKey: 'template_minimalist_title',
      descriptionKey: 'template_minimalist_desc',
      icon: Icons.space_dashboard_outlined,
      isPrimary: false,
      factory: ({required cv, required fonts}) =>
          MinimalistTemplate(cv: cv, fonts: fonts),
    ));

    register(CvTemplateDefinition(
      id: AppConstants.templateExecutive,
      titleKey: 'template_executive_title',
      descriptionKey: 'template_executive_desc',
      icon: Icons.web_asset_outlined,
      isPrimary: false,
      requiredTier: SubscriptionTier.premium,
      factory: ({required cv, required fonts}) =>
          ExecutiveTemplate(cv: cv, fonts: fonts),
    ));

    _initialized = true;
  }

  /// Register a template definition (allows custom/plugin templates)
  static void register(CvTemplateDefinition definition) {
    _templates[definition.id] = definition;
  }

  /// Get all registered templates
  static List<CvTemplateDefinition> getAllTemplates() {
    _ensureInitialized();
    return _templates.values.toList();
  }

  /// Get only primary templates recommended in the UI selector
  static List<CvTemplateDefinition> getPrimaryTemplates() {
    _ensureInitialized();
    return _templates.values.where((t) => t.isPrimary).toList();
  }

  /// Look up a template definition by ID
  static CvTemplateDefinition? getTemplate(String id) {
    _ensureInitialized();
    return _templates[id];
  }

  /// Instantiate the appropriate template implementation
  static BasePdfTemplate createTemplate(
    String? templateId, {
    required CvModel cv,
    required PdfFontBundle fonts,
  }) {
    _ensureInitialized();
    final def = _templates[templateId];
    if (def != null) {
      return def.createInstance(cv: cv, fonts: fonts);
    }
    // Fallback: ModernTemplate as standard default
    return ModernTemplate(cv: cv, fonts: fonts);
  }

  static void _ensureInitialized() {
    if (!_initialized) {
      initialize();
    }
  }
}
