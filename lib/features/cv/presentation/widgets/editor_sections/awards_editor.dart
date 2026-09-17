import 'package:flutter/material.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../../domain/models/award.dart';
import '../common/repeatable_entry_card.dart';
import '../common/section_header_with_badge.dart';

class AwardsEditor extends StatelessWidget {
  final List<Award> awards;
  final ValueChanged<List<Award>> onChanged;

  const AwardsEditor({
    super.key,
    required this.awards,
    required this.onChanged,
  });

  void _addAward(BuildContext context) {
    _showAwardDialog(context, null);
  }

  void _editAward(BuildContext context, Award award, int index) {
    _showAwardDialog(context, award, index: index);
  }

  void _deleteAward(int index) {
    final updated = List<Award>.from(awards)..removeAt(index);
    onChanged(updated);
  }

  void _moveUp(int index) {
    if (index <= 0) return;
    final updated = List<Award>.from(awards);
    final item = updated.removeAt(index);
    updated.insert(index - 1, item);
    onChanged(updated);
  }

  void _moveDown(int index) {
    if (index >= awards.length - 1) return;
    final updated = List<Award>.from(awards);
    final item = updated.removeAt(index);
    updated.insert(index + 1, item);
    onChanged(updated);
  }

  void _showAwardDialog(BuildContext context, Award? award, {int? index}) {
    final titleCtrl = TextEditingController(text: award?.title ?? '');
    final issuerCtrl = TextEditingController(text: award?.issuer ?? '');
    final dateCtrl = TextEditingController(text: award?.date ?? '');
    final descCtrl = TextEditingController(text: award?.description ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(award == null ? context.tr('add_award') : context.tr('edit_award')),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleCtrl,
                  decoration: InputDecoration(
                    labelText: context.tr('award_title'),
                    hintText: context.tr('award_title_hint'),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: issuerCtrl,
                  decoration: InputDecoration(
                    labelText: context.tr('issuer_organization'),
                    hintText: context.tr('award_issuer_hint'),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: dateCtrl,
                  decoration: InputDecoration(
                    labelText: context.tr('cert_date'),
                    hintText: context.tr('award_date_hint'),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descCtrl,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: context.tr('description'),
                    hintText: context.tr('award_desc_hint'),
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
              final newAward = Award(
                id: award?.id,
                title: titleCtrl.text.trim(),
                issuer: issuerCtrl.text.trim(),
                date: dateCtrl.text.trim(),
                description: descCtrl.text.trim(),
              );

              final updated = List<Award>.from(awards);
              if (index != null) {
                updated[index] = newAward;
              } else {
                updated.add(newAward);
              }
              onChanged(updated);
              Navigator.of(ctx).pop();
            },
            child: Text(context.tr('save')),
          ),
        ],
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
            title: context.tr('section_awards'),
            count: awards.length,
            addLabel: context.tr('add_award'),
            onAdd: () => _addAward(context),
          ),
          const SizedBox(height: 16),
          if (awards.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Text(
                    context.tr('no_awards'),
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ),
              ),
            )
          else
            ...awards.asMap().entries.map((entry) {
              final idx = entry.key;
              final award = entry.value;

              return RepeatableEntryCard(
                index: idx,
                totalCount: awards.length,
                title: award.title.isNotEmpty ? award.title : context.tr('untitled_entry'),
                subtitle: award.issuer,
                date: award.date,
                onEdit: () => _editAward(context, award, idx),
                onDelete: () => _deleteAward(idx),
                onMoveUp: () => _moveUp(idx),
                onMoveDown: () => _moveDown(idx),
              );
            }),
        ],
      ),
    );
  }
}
