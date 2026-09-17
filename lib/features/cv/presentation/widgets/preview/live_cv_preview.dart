import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../../../pdf_export/services/pdf_generator_service.dart';
import '../../../../pdf_export/templates/cv_template_registry.dart';
import '../../../domain/models/cv_model.dart';

/// Professional Live CV Preview Widget
///
/// Features:
/// - Reactive, debounced live PDF re-generation pipeline (smooth typing, immediate on actions)
/// - Zero CV data duplication: directly consumes the unified CvModel
/// - Interactive zoom controls (zoom in, zoom out, fit to width, 100% reset)
/// - Multi-page navigation (All pages, single page jump, next/prev)
/// - Live template switching without data loss
/// - Live photo / no-photo layout toggle
/// - Desktop split-screen support and responsive mobile adaptability
class LiveCvPreview extends StatefulWidget {
  final CvModel cv;
  final ValueChanged<String>? onTemplateChanged;
  final ValueChanged<bool>? onTogglePhoto;
  final VoidCallback? onFullscreen;
  final bool isSplitScreen;
  final VoidCallback? onToggleSplitView;

  const LiveCvPreview({
    super.key,
    required this.cv,
    this.onTemplateChanged,
    this.onTogglePhoto,
    this.onFullscreen,
    this.isSplitScreen = true,
    this.onToggleSplitView,
  });

  @override
  State<LiveCvPreview> createState() => _LiveCvPreviewState();
}

class _LiveCvPreviewState extends State<LiveCvPreview> {
  Uint8List? _cachedPdfBytes;
  int _pageCount = 1;
  int _selectedPage = 0; // 0 = All Pages; 1..N = Single Page
  double _zoomLevel = 1.0;
  bool _isGenerating = false;
  bool _needsRegen = false;
  Timer? _debounceTimer;
  int _previewKey = 0;

  @override
  void initState() {
    super.initState();
    _triggerGeneration(immediate: true);
  }

  @override
  void didUpdateWidget(covariant LiveCvPreview oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.cv != widget.cv) {
      final oldCv = oldWidget.cv;
      final newCv = widget.cv;

      // Check if the change is a discrete action (template, photo, language, color)
      final isImmediateAction = oldCv.style.templateId != newCv.style.templateId ||
          oldCv.personalInfo.showPhoto != newCv.personalInfo.showPhoto ||
          oldCv.personalInfo.hasPhoto != newCv.personalInfo.hasPhoto ||
          oldCv.language != newCv.language ||
          oldCv.style.primaryColorHex != newCv.style.primaryColorHex ||
          oldCv.experiences.length != newCv.experiences.length ||
          oldCv.educations.length != newCv.educations.length ||
          oldCv.skills.length != newCv.skills.length ||
          oldCv.languages.length != newCv.languages.length ||
          oldCv.projects.length != newCv.projects.length ||
          oldCv.certifications.length != newCv.certifications.length ||
          oldCv.customSections.length != newCv.customSections.length;

      _triggerGeneration(immediate: isImmediateAction);
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _triggerGeneration({required bool immediate}) {
    _debounceTimer?.cancel();

    if (immediate) {
      _generatePdf();
    } else {
      _debounceTimer = Timer(const Duration(milliseconds: 200), () {
        _generatePdf();
      });
    }
  }

  Future<void> _generatePdf() async {
    if (_isGenerating) {
      _needsRegen = true;
      return;
    }

    if (!mounted) return;
    setState(() {
      _isGenerating = true;
    });

    try {
      final result = await PdfGeneratorService.generatePdfWithMeta(widget.cv);
      if (!mounted) return;

      setState(() {
        _cachedPdfBytes = result.bytes;
        _pageCount = result.pageCount;
        if (_selectedPage > _pageCount) {
          _selectedPage = _pageCount;
        }
        _previewKey++;
        _isGenerating = false;
      });

      if (_needsRegen) {
        _needsRegen = false;
        _generatePdf();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  void _zoomIn() {
    setState(() {
      _zoomLevel = (_zoomLevel + 0.15).clamp(0.5, 2.2);
    });
  }

  void _zoomOut() {
    setState(() {
      _zoomLevel = (_zoomLevel - 0.15).clamp(0.5, 2.2);
    });
  }

  void _resetZoom() {
    setState(() {
      _zoomLevel = 1.0;
    });
  }

  void _fitZoom() {
    setState(() {
      _zoomLevel = 0.85;
    });
  }

  void _prevPage() {
    if (_selectedPage > 1) {
      setState(() {
        _selectedPage--;
      });
    } else if (_selectedPage == 0 && _pageCount > 1) {
      setState(() {
        _selectedPage = 1;
      });
    }
  }

  void _nextPage() {
    if (_selectedPage < _pageCount && _selectedPage > 0) {
      setState(() {
        _selectedPage++;
      });
    } else if (_selectedPage == 0 && _pageCount > 1) {
      setState(() {
        _selectedPage = 2;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryTemplates = CvTemplateRegistry.getPrimaryTemplates();
    final currentTemplate = primaryTemplates.firstWhere(
      (t) => t.id == widget.cv.style.templateId,
      orElse: () => primaryTemplates.first,
    );

    final showPhoto = widget.cv.personalInfo.showPhoto;

    return Container(
      color: isDark ? const Color(0xFF1E1E2C) : const Color(0xFFF3F4F6),
      child: Column(
        children: [
          // Upper Preview Toolbar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                bottom: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
              ),
            ),
            child: Column(
              children: [
                // Top controls line: Zoom, Navigation, Status
                Row(
                  children: [
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _isGenerating
                            ? theme.colorScheme.primaryContainer
                            : theme.colorScheme.secondaryContainer.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_isGenerating) ...[
                            SizedBox(
                              width: 10,
                              height: 10,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              context.tr('preview_updating'),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ] else ...[
                            Icon(Icons.check_circle, size: 12, color: theme.colorScheme.primary),
                            const SizedBox(width: 4),
                            Text(
                              context.tr('preview_ready'),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSecondaryContainer,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    const Spacer(),

                    // Page Navigation Controls
                    Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left, size: 18),
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(),
                            tooltip: context.tr('prev_page'),
                            onPressed: _selectedPage > 1 || (_selectedPage == 0 && _pageCount > 1)
                                ? _prevPage
                                : null,
                          ),
                          PopupMenuButton<int>(
                            tooltip: context.tr('page_navigation'),
                            initialValue: _selectedPage,
                            onSelected: (page) {
                              setState(() {
                                _selectedPage = page;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _selectedPage == 0
                                        ? '${context.tr("page_all")} ($_pageCount)'
                                        : '${context.tr("page_single")} $_selectedPage/$_pageCount',
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                  const Icon(Icons.arrow_drop_down, size: 16),
                                ],
                              ),
                            ),
                            itemBuilder: (ctx) => [
                              PopupMenuItem(
                                value: 0,
                                child: Text('${context.tr("page_all")} ($_pageCount)'),
                              ),
                              ...List.generate(_pageCount, (idx) {
                                final pNum = idx + 1;
                                return PopupMenuItem(
                                  value: pNum,
                                  child: Text('${context.tr("page_single")} $pNum / $_pageCount'),
                                );
                              }),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_right, size: 18),
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(),
                            tooltip: context.tr('next_page'),
                            onPressed: (_selectedPage < _pageCount && _selectedPage > 0) ||
                                    (_selectedPage == 0 && _pageCount > 1)
                                ? _nextPage
                                : null,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Zoom Controls
                    Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove, size: 16),
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(),
                            tooltip: context.tr('zoom_out'),
                            onPressed: _zoomLevel > 0.5 ? _zoomOut : null,
                          ),
                          InkWell(
                            onTap: _resetZoom,
                            borderRadius: BorderRadius.circular(4),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                              child: Text(
                                '${(_zoomLevel * 100).round()}%',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add, size: 16),
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(),
                            tooltip: context.tr('zoom_in'),
                            onPressed: _zoomLevel < 2.2 ? _zoomIn : null,
                          ),
                          IconButton(
                            icon: const Icon(Icons.fit_screen_outlined, size: 16),
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(),
                            tooltip: context.tr('zoom_fit'),
                            onPressed: _fitZoom,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // Bottom line of toolbar: Live Template Switcher & Photo Toggle
                Row(
                  children: [
                    // Template Switcher Dropdown
                    PopupMenuButton<String>(
                      tooltip: context.tr('switch_template'),
                      onSelected: (templateId) {
                        widget.onTemplateChanged?.call(templateId);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: theme.colorScheme.outlineVariant),
                          borderRadius: BorderRadius.circular(6),
                          color: theme.colorScheme.surface,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(currentTemplate.icon, size: 14, color: theme.colorScheme.primary),
                            const SizedBox(width: 6),
                            Text(
                              context.tr(currentTemplate.titleKey),
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            const Icon(Icons.arrow_drop_down, size: 16),
                          ],
                        ),
                      ),
                      itemBuilder: (ctx) => primaryTemplates.map((tpl) {
                        final isSelected = tpl.id == widget.cv.style.templateId;
                        return PopupMenuItem<String>(
                          value: tpl.id,
                          child: Row(
                            children: [
                              Icon(tpl.icon, size: 18, color: isSelected ? theme.colorScheme.primary : null),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  context.tr(tpl.titleKey),
                                  style: TextStyle(
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: isSelected ? theme.colorScheme.primary : null,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Icon(Icons.check, size: 16, color: theme.colorScheme.primary),
                            ],
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(width: 8),

                    // Photo / No-Photo Quick Toggle Button
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        visualDensity: VisualDensity.compact,
                        side: BorderSide(
                          color: showPhoto ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
                        ),
                        backgroundColor: showPhoto ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3) : null,
                      ),
                      onPressed: () {
                        widget.onTogglePhoto?.call(!showPhoto);
                      },
                      icon: Icon(
                        showPhoto ? Icons.account_circle : Icons.no_accounts_outlined,
                        size: 16,
                        color: showPhoto ? theme.colorScheme.primary : theme.colorScheme.outline,
                      ),
                      label: Text(
                        showPhoto ? context.tr('photo_visible') : context.tr('photo_hidden'),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: showPhoto ? FontWeight.bold : FontWeight.normal,
                          color: showPhoto ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Action buttons: Export, Print, Fullscreen
                    IconButton(
                      icon: const Icon(Icons.download_rounded, size: 18),
                      tooltip: context.tr('download_pdf'),
                      visualDensity: VisualDensity.compact,
                      onPressed: () => PdfGeneratorService.savePdf(widget.cv),
                    ),
                    IconButton(
                      icon: const Icon(Icons.print_outlined, size: 18),
                      tooltip: context.tr('print'),
                      visualDensity: VisualDensity.compact,
                      onPressed: () => PdfGeneratorService.printPdf(widget.cv),
                    ),
                    if (widget.onFullscreen != null)
                      IconButton(
                        icon: const Icon(Icons.fullscreen, size: 18),
                        tooltip: context.tr('fullscreen_preview'),
                        visualDensity: VisualDensity.compact,
                        onPressed: widget.onFullscreen,
                      ),
                  ],
                ),
              ],
            ),
          ),

          // Main Live PDF Preview Container
          Expanded(
            child: _cachedPdfBytes == null && _isGenerating
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(context.tr('generating_pdf')),
                      ],
                    ),
                  )
                : PdfPreview(
                    key: ValueKey('live_preview_$_previewKey'),
                    build: (format) async {
                      if (_cachedPdfBytes != null) {
                        return _cachedPdfBytes!;
                      }
                      return PdfGeneratorService.generatePdfBytes(widget.cv);
                    },
                    canChangeOrientation: false,
                    canChangePageFormat: false,
                    canDebug: false,
                    useActions: false, // Custom toolbar handles all actions
                    maxPageWidth: (600 * _zoomLevel).clamp(320.0, 1600.0),
                    pages: _selectedPage == 0 ? null : [_selectedPage - 1],
                    pdfFileName: '${PdfGeneratorService.sanitizeFilename(widget.cv.title)}.pdf',
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
                  ),
          ),
        ],
      ),
    );
  }
}
