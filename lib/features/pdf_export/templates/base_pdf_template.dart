import 'dart:convert';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/cv_translations.dart';
import '../../cv/domain/models/cv_model.dart';
import '../services/pdf_font_manager.dart';

abstract class BasePdfTemplate {
  final CvModel cv;
  final PdfFontBundle fonts;

  BasePdfTemplate({required this.cv, required this.fonts});

  bool get isRtl => cv.isRtl;

  String tr(String key) => CvTranslations.get(cv.language, key);

  PdfColor get primaryColor {
    final hex = cv.style.primaryColorHex;
    final color = AppColors.fromHex(hex);
    return PdfColor(color.r, color.g, color.b);
  }

  PdfColor get lightPrimaryColor {
    final hex = cv.style.primaryColorHex;
    final color = AppColors.fromHex(hex);
    return PdfColor(color.r, color.g, color.b, 0.1);
  }

  PdfColor get textPrimaryColor => const PdfColor(0.1, 0.15, 0.2);
  PdfColor get textSecondaryColor => const PdfColor(0.4, 0.45, 0.5);
  PdfColor get borderColor => const PdfColor(0.88, 0.9, 0.92);

  pw.ThemeData get themeData {
    return pw.ThemeData.withFont(
      base: fonts.regular,
      bold: fonts.bold,
      italic: fonts.italic ?? fonts.regular,
    );
  }

  /// Create a document initialized with font theme and production metadata
  pw.Document createDocument() {
    return pw.Document(
      theme: themeData,
      title: cv.title.isNotEmpty ? cv.title : 'Curriculum Vitae',
      author: cv.personalInfo.fullName.isNotEmpty ? cv.personalInfo.fullName : 'CV Builder',
      subject: cv.personalInfo.jobTitle.isNotEmpty ? cv.personalInfo.jobTitle : cv.title,
      creator: 'CV Builder - Professional Resume Engine',
    );
  }

  pw.Widget wrapDirection(pw.Widget child) {
    if (isRtl) {
      return pw.Directionality(
        textDirection: pw.TextDirection.rtl,
        child: child,
      );
    }
    return child;
  }

  /// Forces text to render in LTR direction (critical for phone numbers, emails, and URLs in Arabic RTL documents)
  pw.Widget buildLtrText(String text, {pw.TextStyle? style}) {
    return pw.Directionality(
      textDirection: pw.TextDirection.ltr,
      child: pw.Text(text, style: style),
    );
  }

  /// Creates a clickable vector hyperlink in the generated PDF
  pw.Widget buildLink({
    required String text,
    required String url,
    pw.TextStyle? style,
    bool underline = true,
  }) {
    final cleanUrl = url.trim();
    if (cleanUrl.isEmpty) {
      return pw.Text(text, style: style);
    }

    String destination = cleanUrl;
    if (!destination.startsWith('http://') &&
        !destination.startsWith('https://') &&
        !destination.startsWith('mailto:') &&
        !destination.startsWith('tel:')) {
      if (cleanUrl.contains('@')) {
        destination = 'mailto:$cleanUrl';
      } else {
        destination = 'https://$cleanUrl';
      }
    }

    final linkStyle = (style ?? const pw.TextStyle()).copyWith(
      decoration: underline ? pw.TextDecoration.underline : pw.TextDecoration.none,
    );

    return pw.UrlLink(
      destination: destination,
      child: pw.Text(text, style: linkStyle),
    );
  }

  /// Bundles a section header with its first content item in an unbreakable atomic block.
  /// This guarantees the heading will NEVER appear as an orphan at the bottom of a page without content.
  List<pw.Widget> buildIntelligentSection({
    required pw.Widget header,
    required List<pw.Widget> items,
    double spacingBetween = 4.0,
    double spacingAfter = 12.0,
  }) {
    if (items.isEmpty) return [];

    final result = <pw.Widget>[];

    // Combine header and the very first item together so they can never be separated across a page break
    result.add(
      wrapDirection(
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          mainAxisSize: pw.MainAxisSize.min,
          children: [
            header,
            pw.SizedBox(height: spacingBetween),
            items.first,
          ],
        ),
      ),
    );

    // Any remaining items (item 2, 3, ...) are added individually so they CAN break across pages
    for (int i = 1; i < items.length; i++) {
      result.add(wrapDirection(items[i]));
    }

    result.add(pw.SizedBox(height: spacingAfter));
    return result;
  }

  pw.ImageProvider? get photoImage {
    if (!cv.personalInfo.hasPhoto) return null;
    try {
      final base64String = cv.personalInfo.photoBase64!;
      final cleanBase64 = base64String.contains(',') ? base64String.split(',').last : base64String;
      final Uint8List bytes = base64Decode(cleanBase64);
      return pw.MemoryImage(bytes);
    } catch (_) {
      return null;
    }
  }

  pw.Widget buildFooter(pw.Context context) {
    final pageStr = '${tr('page')} ${context.pageNumber} ${tr('of')} ${context.pagesCount}';
    return pw.Container(
      alignment: isRtl ? pw.Alignment.centerLeft : pw.Alignment.centerRight,
      margin: const pw.EdgeInsets.only(top: 12),
      padding: const pw.EdgeInsets.only(top: 6),
      decoration: const pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: PdfColor(0.9, 0.92, 0.94), width: 0.8)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            cv.personalInfo.fullName.isNotEmpty ? cv.personalInfo.fullName : cv.title,
            style: pw.TextStyle(color: textSecondaryColor, fontSize: 8, font: fonts.regular),
          ),
          pw.Text(
            pageStr,
            style: pw.TextStyle(color: textSecondaryColor, fontSize: 8, font: fonts.regular),
          ),
        ],
      ),
    );
  }

  Future<pw.Document> generate();
}
