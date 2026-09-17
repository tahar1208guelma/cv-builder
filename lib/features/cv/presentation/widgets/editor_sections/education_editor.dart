import 'package:flutter/material.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../../domain/models/education.dart';
import '../common/repeatable_entry_card.dart';
import '../common/section_header_with_badge.dart';

class EducationEditor extends StatelessWidget {
  final List<Education> educations;
  final ValueChanged<List<Education>> onChanged;

  const EducationEditor({
    super.key,
    required this.educations,
    required this.onChanged,
  });

  void _addEducation(BuildContext context) {
    _showEducationDialog(context, null);
  }

  void _editEducation(BuildContext context, Education edu, int index) {
    _showEducationDialog(context, edu, index: index);
  }

  void _deleteEducation(int index) {
    final updated = List<Education>.from(educations)..removeAt(index);
    onChanged(updated);
  }

  void _moveUp(int index) {
    if (index <= 0) return;
    final updated = List<Education>.from(educations);
    final item = updated.removeAt(index);
    updated.insert(index - 1, item);
    onChanged(updated);
  }

  void _moveDown(int index) {
    if (index >= educations.length - 1) return;
    final updated = List<Education>.from(educations);
    final item = updated.removeAt(index);
    updated.insert(index + 1, item);
    onChanged(updated);
  }

  void _showEducationDialog(BuildContext context, Education? edu, {int? index}) {
    final degCtrl = TextEditingController(text: edu?.degree ?? '');
    final fieldCtrl = TextEditingController(text: edu?.fieldOfStudy ?? '');
    final instCtrl = TextEditingController(text: edu?.institution ?? '');
    final countryCtrl = TextEditingController(text: edu?.country ?? '');
    final startCtrl = TextEditingController(text: edu?.startDate ?? '');
    final endCtrl = TextEditingController(text: edu?.endDate ?? '');
    final gradeCtrl = TextEditingController(text: edu?.grade ?? '');
    final descCtrl = TextEditingController(text: edu?.description ?? '');
    bool isCurrentlyStudying = edu?.currentlyStudying ?? false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          title: Text(edu == null ? context.tr('add_education') : context.tr('edit_education')),
          content: SizedBox(
            width: 520,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: degCtrl,
                    decoration: InputDecoration(
                      labelText: context.tr('degree'),
                      hintText: context.tr('degree_hint'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: fieldCtrl,
                    decoration: InputDecoration(
                      labelText: context.tr('field_of_study'),
                      hintText: context.tr('field_of_study_hint'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: instCtrl,
                    decoration: InputDecoration(
                      labelText: context.tr('institution'),
                      hintText: context.tr('institution_hint'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: countryCtrl,
                    decoration: InputDecoration(
                      labelText: context.tr('country'),
                      hintText: context.tr('country_hint'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: startCtrl,
                          decoration: InputDecoration(
                            labelText: context.tr('start_date'),
                            hintText: context.tr('date_hint'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: endCtrl,
                          enabled: !isCurrentlyStudying,
                          decoration: InputDecoration(
                            labelText: context.tr('end_date'),
                            hintText: isCurrentlyStudying ? context.tr('currently_studying') : context.tr('date_hint'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(context.tr('currently_studying'), style: const TextStyle(fontSize: 13)),
                    value: isCurrentlyStudying,
                    onChanged: (val) {
                      setModalState(() {
                        isCurrentlyStudying = val ?? false;
                        if (isCurrentlyStudying) {
                          endCtrl.clear();
                        }
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: gradeCtrl,
                    decoration: InputDecoration(
                      labelText: context.tr('grade_or_honors'),
                      hintText: context.tr('grade_hint'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descCtrl,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: context.tr('description'),
                      alignLabelWithHint: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(context.tr('cancel')),
            ),
            ElevatedButton(
              onPressed: () {
                final newEdu = Education(
                  id: edu?.id,
                  degree: degCtrl.text.trim(),
                  fieldOfStudy: fieldCtrl.text.trim(),
                  institution: instCtrl.text.trim(),
                  country: countryCtrl.text.trim(),
                  location: countryCtrl.text.trim(),
                  startDate: startCtrl.text.trim(),
                  endDate: isCurrentlyStudying ? '' : endCtrl.text.trim(),
                  currentlyStudying: isCurrentlyStudying,
                  grade: gradeCtrl.text.trim(),
                  description: descCtrl.text.trim(),
                );

                final updated = List<Education>.from(educations);
                if (index != null) {
                  updated[index] = newEdu;
                } else {
                  updated.add(newEdu);
                }
                onChanged(updated);
                Navigator.of(ctx).pop();
              },
              child: Text(context.tr('save')),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeaderWithBadge(
            title: context.tr('section_education'),
            count: educations.length,
            addLabel: context.tr('add_education'),
            onAdd: () => _addEducation(context),
          ),
          const SizedBox(height: 16),
          if (educations.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.school_outlined, size: 48, color: Theme.of(context).colorScheme.outline),
                      const SizedBox(height: 12),
                      Text(
                        context.tr('no_education'),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            ...educations.asMap().entries.map((entry) {
              final idx = entry.key;
              final edu = entry.value;
              final sub = [
                if (edu.fieldOfStudy.isNotEmpty) edu.fieldOfStudy,
                if (edu.institution.isNotEmpty) edu.institution,
                if (edu.country.isNotEmpty) edu.country,
              ].join(' • ');

              final dateStr = edu.currentlyStudying
                  ? '${edu.startDate} - ${context.tr("currently_studying")}'
                  : (edu.endDate.isNotEmpty ? '${edu.startDate} - ${edu.endDate}' : edu.startDate);

              return RepeatableEntryCard(
                index: idx,
                totalCount: educations.length,
                title: edu.degree.isNotEmpty ? edu.degree : context.tr('untitled_entry'),
                subtitle: sub,
                date: dateStr,
                onEdit: () => _editEducation(context, edu, idx),
                onDelete: () => _deleteEducation(idx),
                onMoveUp: () => _moveUp(idx),
                onMoveDown: () => _moveDown(idx),
              );
            }),
        ],
      ),
    );
  }
}
