import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../pdf_export/services/pdf_generator_service.dart';
import '../../domain/models/cv_model.dart';

class CvPreviewScreen extends StatelessWidget {
  final CvModel cv;

  const CvPreviewScreen({super.key, required this.cv});

  @override
  Widget build(BuildContext context) {
    final title = cv.title.isNotEmpty ? cv.title : context.tr('pdf_preview');
    final filename = '${PdfGeneratorService.sanitizeFilename(cv.title)}.pdf';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            tooltip: context.tr('download_pdf'),
            icon: const Icon(Icons.download_rounded),
            onPressed: () async {
              try {
                await PdfGeneratorService.savePdf(cv);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.tr('pdf_saved_desc')),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.tr('pdf_error')),
                      backgroundColor: Theme.of(context).colorScheme.error,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              }
            },
          ),
          IconButton(
            tooltip: context.tr('share'),
            icon: const Icon(Icons.share_rounded),
            onPressed: () => PdfGeneratorService.sharePdf(cv),
          ),
          IconButton(
            tooltip: context.tr('print'),
            icon: const Icon(Icons.print_rounded),
            onPressed: () => PdfGeneratorService.printPdf(cv),
          ),
        ],
      ),
      body: PdfPreview(
        build: (format) => PdfGeneratorService.generatePdfBytes(cv),
        canChangeOrientation: false,
        canChangePageFormat: false,
        canDebug: false,
        pdfFileName: filename,
        loadingWidget: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(context.tr('generating_pdf')),
            ],
          ),
        ),
        actions: [
          PdfPreviewAction(
            icon: const Icon(Icons.download_rounded),
            onPressed: (context, build, pageFormat) async {
              await PdfGeneratorService.savePdf(cv);
            },
          ),
        ],
      ),
    );
  }
}
