import 'dart:typed_data';
import 'package:printing/printing.dart';
import '../../cv/domain/models/cv_model.dart';
import '../templates/cv_template_registry.dart';
import 'pdf_font_manager.dart';

class GeneratedPdfResult {
  final Uint8List bytes;
  final int pageCount;

  const GeneratedPdfResult({
    required this.bytes,
    required this.pageCount,
  });
}

class PdfGeneratorService {
  /// Sanitize filename to be safe across operating systems while preserving Arabic, accented Latin and ASCII characters
  static String sanitizeFilename(String title) {
    final clean = title.trim().replaceAll(RegExp(r'[^\w\s\u00C0-\u024F\u0600-\u06FF-]'), '_');
    return clean.isEmpty ? 'CV' : clean;
  }

  /// Generate real vector PDF bytes and metadata (including exact page count) from CV data
  static Future<GeneratedPdfResult> generatePdfWithMeta(CvModel cv) async {
    final fonts = await PdfFontManager.getFontForCv(cv.language);
    final template = CvTemplateRegistry.createTemplate(
      cv.style.templateId,
      cv: cv,
      fonts: fonts,
    );
    final doc = await template.generate();
    final bytes = await doc.save();
    final pageCount = doc.document.pdfPageList.pages.length;
    return GeneratedPdfResult(bytes: bytes, pageCount: pageCount > 0 ? pageCount : 1);
  }

  /// Generate real vector PDF bytes from CV data
  static Future<Uint8List> generatePdfBytes(CvModel cv) async {
    final result = await generatePdfWithMeta(cv);
    return result.bytes;
  }

  /// Save PDF file to user's device
  static Future<void> savePdf(CvModel cv) async {
    final bytes = await generatePdfBytes(cv);
    final filename = '${sanitizeFilename(cv.title)}.pdf';
    await Printing.sharePdf(bytes: bytes, filename: filename);
  }

  /// Share PDF file via system sharing sheet where supported
  static Future<void> sharePdf(CvModel cv) async {
    final bytes = await generatePdfBytes(cv);
    final filename = '${sanitizeFilename(cv.title)}.pdf';
    await Printing.sharePdf(bytes: bytes, filename: filename);
  }

  /// Backward-compatible alias for sharing or saving
  static Future<void> shareOrSavePdf(CvModel cv) async {
    await savePdf(cv);
  }

  /// Print PDF file directly to default or selected printer
  static Future<void> printPdf(CvModel cv) async {
    final bytes = await generatePdfBytes(cv);
    await Printing.layoutPdf(
      onLayout: (format) async => bytes,
      name: '${sanitizeFilename(cv.title)}.pdf',
    );
  }
}
