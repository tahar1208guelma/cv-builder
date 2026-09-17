import 'package:flutter/material.dart';
import '../../cv/domain/models/cv_model.dart';
import '../services/pdf_font_manager.dart';
import 'base_pdf_template.dart';

typedef TemplateFactory = BasePdfTemplate Function({required CvModel cv, required PdfFontBundle fonts});

class CvTemplateDefinition {
  final String id;
  final String titleKey;
  final String descriptionKey;
  final IconData icon;
  final bool isPrimary;
  final TemplateFactory factory;

  const CvTemplateDefinition({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.icon,
    this.isPrimary = true,
    required this.factory,
  });

  BasePdfTemplate createInstance({required CvModel cv, required PdfFontBundle fonts}) {
    return factory(cv: cv, fonts: fonts);
  }
}
