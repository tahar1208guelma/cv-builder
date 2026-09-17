import 'package:flutter/material.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../../domain/models/experience.dart';
import '../common/repeatable_entry_card.dart';
import '../common/section_header_with_badge.dart';

class ExperienceEditor extends StatelessWidget {
  final List<Experience> experiences;
  final ValueChanged<List<Experience>> onChanged;

  const ExperienceEditor({
    super.key,
    required this.experiences,
    required this.onChanged,
  });

  void _addExperience(BuildContext context) {
    _showExperienceDialog(context, null);
  }

  void _editExperience(BuildContext context, Experience exp, int index) {
    _showExperienceDialog(context, exp, index: index);
  }

  void _deleteExperience(int index) {
    final updated = List<Experience>.from(experiences)..removeAt(index);
    onChanged(updated);
  }

  void _moveUp(int index) {
    if (index <= 0) return;
    final updated = List<Experience>.from(experiences);
    final item = updated.removeAt(index);
    updated.insert(index - 1, item);
    onChanged(updated);
  }

  void _moveDown(int index) {
    if (index >= experiences.length - 1) return;
    final updated = List<Experience>.from(experiences);
    final item = updated.removeAt(index);
    updated.insert(index + 1, item);
    onChanged(updated);
  }

  void _showExperienceDialog(BuildContext context, Experience? exp, {int? index}) {
    final titleCtrl = TextEditingController(text: exp?.jobTitle ?? '');
    final compCtrl = TextEditingController(text: exp?.company ?? '');
    final locCtrl = TextEditingController(text: exp?.location ?? '');
    final startCtrl = TextEditingController(text: exp?.startDate ?? '');
    final endCtrl = TextEditingController(text: exp?.endDate ?? '');
    final descCtrl = TextEditingController(text: exp?.description ?? '');
    final achCtrl = TextEditingController(text: (exp?.achievements ?? []).join('\n'));
    bool isCurrentlyWorking = exp?.isCurrent ?? false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          title: Text(exp == null ? context.tr('add_experience') : context.tr('edit_experience')),
          content: SizedBox(
            width: 550,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleCtrl,
                    decoration: InputDecoration(
                      labelText: context.tr('position'),
                      hintText: context.tr('job_title_hint'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: compCtrl,
                    decoration: InputDecoration(
                      labelText: context.tr('company_name'),
                      hintText: context.tr('company_hint'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: locCtrl,
                    decoration: InputDecoration(
                      labelText: context.tr('address'),
                      hintText: context.tr('location_hint'),
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
                          enabled: !isCurrentlyWorking,
                          decoration: InputDecoration(
                            labelText: context.tr('end_date'),
                            hintText: isCurrentlyWorking ? context.tr('current_job') : context.tr('date_hint'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(context.tr('current_job'), style: const TextStyle(fontSize: 13)),
                    value: isCurrentlyWorking,
                    onChanged: (val) {
                      setModalState(() {
                        isCurrentlyWorking = val ?? false;
                        if (isCurrentlyWorking) {
                          endCtrl.clear();
                        }
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: descCtrl,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: context.tr('responsibilities'),
                      alignLabelWithHint: true,
                      hintText: context.tr('role_description_hint'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: achCtrl,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: context.tr('achievements'),
                      alignLabelWithHint: true,
                      hintText: context.tr('achievements_hint'),
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
                final rawAch = achCtrl.text.split('\n');
                final cleanedAch = rawAch.map((s) => s.trim()).where((s) => s.isNotEmpty).toList();

                final newExp = Experience(
                  id: exp?.id,
                  jobTitle: titleCtrl.text.trim(),
                  company: compCtrl.text.trim(),
                  location: locCtrl.text.trim(),
                  startDate: startCtrl.text.trim(),
                  endDate: isCurrentlyWorking ? '' : endCtrl.text.trim(),
                  currentlyWorking: isCurrentlyWorking,
                  description: descCtrl.text.trim(),
                  achievements: cleanedAch,
                );

                final updated = List<Experience>.from(experiences);
                if (index != null) {
                  updated[index] = newExp;
                } else {
                  updated.add(newExp);
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
            title: context.tr('section_experience'),
            count: experiences.length,
            addLabel: context.tr('add_experience'),
            onAdd: () => _addExperience(context),
          ),
          const SizedBox(height: 16),
          if (experiences.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.work_outline, size: 48, color: Theme.of(context).colorScheme.outline),
                      const SizedBox(height: 12),
                      Text(
                        context.tr('no_experience'),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            ...experiences.asMap().entries.map((entry) {
              final idx = entry.key;
              final exp = entry.value;
              final sub = [
                if (exp.company.isNotEmpty) exp.company,
                if (exp.location.isNotEmpty) exp.location,
              ].join(' • ');

              final dateStr = exp.isCurrent
                  ? '${exp.startDate} - ${context.tr("current_job")}'
                  : (exp.endDate.isNotEmpty ? '${exp.startDate} - ${exp.endDate}' : exp.startDate);

              return RepeatableEntryCard(
                index: idx,
                totalCount: experiences.length,
                title: exp.jobTitle.isNotEmpty ? exp.jobTitle : context.tr('untitled_entry'),
                subtitle: sub,
                date: dateStr,
                onEdit: () => _editExperience(context, exp, idx),
                onDelete: () => _deleteExperience(idx),
                onMoveUp: () => _moveUp(idx),
                onMoveDown: () => _moveDown(idx),
              );
            }),
        ],
      ),
    );
  }
}
