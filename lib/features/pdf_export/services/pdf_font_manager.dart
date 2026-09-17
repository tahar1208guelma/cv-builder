import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfFontBundle {
  final pw.Font regular;
  final pw.Font bold;
  final pw.Font? italic;
  final bool isArabic;

  PdfFontBundle({
    required this.regular,
    required this.bold,
    this.italic,
    this.isArabic = false,
  });
}

class PdfFontManager {
  static PdfFontBundle? _arabicBundle;
  static PdfFontBundle? _latinBundle;

  static Future<void> preloadFonts() async {
    await getArabicFont();
    await getLatinFont();
  }

  static Future<PdfFontBundle> getArabicFont() async {
    if (_arabicBundle != null) return _arabicBundle!;
    try {
      final regData = await rootBundle.load('assets/fonts/Cairo-Regular.ttf');
      final boldData = await rootBundle.load('assets/fonts/Cairo-Bold.ttf');
      _arabicBundle = PdfFontBundle(
        regular: pw.Font.ttf(regData),
        bold: pw.Font.ttf(boldData),
        isArabic: true,
      );
      return _arabicBundle!;
    } catch (_) {
      // Fallback
      _arabicBundle = PdfFontBundle(
        regular: pw.Font.helvetica(),
        bold: pw.Font.helveticaBold(),
        isArabic: true,
      );
      return _arabicBundle!;
    }
  }

  static Future<PdfFontBundle> getLatinFont() async {
    if (_latinBundle != null) return _latinBundle!;
    try {
      final regData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
      final boldData = await rootBundle.load('assets/fonts/Roboto-Bold.ttf');
      _latinBundle = PdfFontBundle(
        regular: pw.Font.ttf(regData),
        bold: pw.Font.ttf(boldData),
        isArabic: false,
      );
      return _latinBundle!;
    } catch (_) {
      // Fallback
      _latinBundle = PdfFontBundle(
        regular: pw.Font.helvetica(),
        bold: pw.Font.helveticaBold(),
        isArabic: false,
      );
      return _latinBundle!;
    }
  }

  static Future<PdfFontBundle> getFontForCv(String languageCode) async {
    if (languageCode == 'ar') {
      return getArabicFont();
    }
    return getLatinFont();
  }
}
