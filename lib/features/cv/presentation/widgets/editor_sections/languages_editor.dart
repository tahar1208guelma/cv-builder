import 'package:flutter/material.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../../domain/models/language_item.dart';

class LanguagesEditor extends StatefulWidget {
  final List<LanguageItem> languages;
  final ValueChanged<List<LanguageItem>> onChanged;

  const LanguagesEditor({
    super.key,
    required this.languages,
    required this.onChanged,
  });

  @override
  State<LanguagesEditor> createState() => _LanguagesEditorState();
}

class _LanguagesEditorState extends State<LanguagesEditor> {
  final _nameController = TextEditingController();
  LanguageProficiency _selectedProficiency = LanguageProficiency.fluent;

  void _addLanguage() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final newLang = LanguageItem(
      name: name,
      proficiency: _selectedProficiency,
    );

    final updated = List<LanguageItem>.from(widget.languages)..add(newLang);
    widget.onChanged(updated);

    _nameController.clear();
  }

  void _editLanguage(LanguageItem item, int index) {
    final nameCtrl = TextEditingController(text: item.name);
    var prof = item.proficiency;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          title: Text(context.tr('edit')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(labelText: context.tr('language_name')),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<LanguageProficiency>(
                initialValue: prof,
                decoration: InputDecoration(labelText: context.tr('proficiency')),
                items: LanguageProficiency.values.map((p) {
                  return DropdownMenuItem(
                    value: p,
                    child: Text(_getProficiencyLabel(context, p)),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setModalState(() {
                      prof = val;
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(context.tr('cancel')),
            ),
            ElevatedButton(
              onPressed: () {
                final updated = List<LanguageItem>.from(widget.languages);
                updated[index] = item.copyWith(
                  name: nameCtrl.text.trim(),
                  proficiency: prof,
                );
                widget.onChanged(updated);
                Navigator.of(ctx).pop();
              },
              child: Text(context.tr('save')),
            ),
          ],
        ),
      ),
    );
  }

  void _removeLanguage(int index) {
    final updated = List<LanguageItem>.from(widget.languages)..removeAt(index);
    widget.onChanged(updated);
  }

  void _moveUp(int index) {
    if (index <= 0) return;
    final updated = List<LanguageItem>.from(widget.languages);
    final item = updated.removeAt(index);
    updated.insert(index - 1, item);
    widget.onChanged(updated);
  }

  void _moveDown(int index) {
    if (index >= widget.languages.length - 1) return;
    final updated = List<LanguageItem>.from(widget.languages);
    final item = updated.removeAt(index);
    updated.insert(index + 1, item);
    widget.onChanged(updated);
  }

  String _getProficiencyLabel(BuildContext context, LanguageProficiency prof) {
    switch (prof) {
      case LanguageProficiency.native:
        return context.tr('proficiency_native');
      case LanguageProficiency.fluent:
        return context.tr('proficiency_fluent');
      case LanguageProficiency.intermediate:
        return context.tr('proficiency_intermediate');
      case LanguageProficiency.basic:
        return context.tr('proficiency_basic');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                context.tr('section_languages'),
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${widget.languages.length}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Add Form
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: context.tr('language_name'),
                        hintText: context.tr('language_name_hint'),
                      ),
                      onSubmitted: (_) => _addLanguage(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<LanguageProficiency>(
                      initialValue: _selectedProficiency,
                      decoration: InputDecoration(
                        labelText: context.tr('proficiency'),
                      ),
                      items: LanguageProficiency.values.map((p) {
                        return DropdownMenuItem(
                          value: p,
                          child: Text(_getProficiencyLabel(context, p)),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedProficiency = val;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _addLanguage,
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(context.tr('add')),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Languages List
          if (widget.languages.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Text(
                    context.tr('no_languages'),
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ),
              ),
            )
          else
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: widget.languages.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final lang = entry.value;
                    final canMoveUp = idx > 0;
                    final canMoveDown = idx < widget.languages.length - 1;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          // Order badge
                          Container(
                            width: 26,
                            height: 26,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '#${idx + 1}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lang.name,
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                ),
                                Text(
                                  _getProficiencyLabel(context, lang.proficiency),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Move Up
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(),
                            icon: Icon(
                              Icons.arrow_upward,
                              size: 16,
                              color: canMoveUp ? theme.colorScheme.primary : theme.colorScheme.outline.withValues(alpha: 0.3),
                            ),
                            tooltip: context.tr('move_up'),
                            onPressed: canMoveUp ? () => _moveUp(idx) : null,
                          ),
                          // Move Down
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(),
                            icon: Icon(
                              Icons.arrow_downward,
                              size: 16,
                              color: canMoveDown ? theme.colorScheme.primary : theme.colorScheme.outline.withValues(alpha: 0.3),
                            ),
                            tooltip: context.tr('move_down'),
                            onPressed: canMoveDown ? () => _moveDown(idx) : null,
                          ),
                          // Edit
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(),
                            icon: const Icon(Icons.edit_outlined, size: 16),
                            tooltip: context.tr('edit'),
                            onPressed: () => _editLanguage(lang, idx),
                          ),
                          // Delete
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(),
                            icon: const Icon(Icons.delete_outline, size: 16, color: Color(0xFFDC2626)),
                            tooltip: context.tr('delete'),
                            onPressed: () => _removeLanguage(idx),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
