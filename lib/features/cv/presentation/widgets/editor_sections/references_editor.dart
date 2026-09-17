import 'package:flutter/material.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../../domain/models/reference.dart';
import '../common/repeatable_entry_card.dart';
import '../common/section_header_with_badge.dart';

class ReferencesEditor extends StatelessWidget {
  final List<Reference> references;
  final ValueChanged<List<Reference>> onChanged;

  const ReferencesEditor({
    super.key,
    required this.references,
    required this.onChanged,
  });

  void _addReference(BuildContext context) {
    _showReferenceDialog(context, null);
  }

  void _editReference(BuildContext context, Reference refItem, int index) {
    _showReferenceDialog(context, refItem, index: index);
  }

  void _deleteReference(int index) {
    final updated = List<Reference>.from(references)..removeAt(index);
    onChanged(updated);
  }

  void _moveUp(int index) {
    if (index <= 0) return;
    final updated = List<Reference>.from(references);
    final item = updated.removeAt(index);
    updated.insert(index - 1, item);
    onChanged(updated);
  }

  void _moveDown(int index) {
    if (index >= references.length - 1) return;
    final updated = List<Reference>.from(references);
    final item = updated.removeAt(index);
    updated.insert(index + 1, item);
    onChanged(updated);
  }

  void _showReferenceDialog(BuildContext context, Reference? refItem, {int? index}) {
    final nameCtrl = TextEditingController(text: refItem?.name ?? '');
    final posCtrl = TextEditingController(text: refItem?.position ?? '');
    final orgCtrl = TextEditingController(text: refItem?.organization ?? '');
    final emailCtrl = TextEditingController(text: refItem?.email ?? '');
    final phoneCtrl = TextEditingController(text: refItem?.phone ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(refItem == null ? context.tr('add_reference') : context.tr('edit_reference')),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    labelText: context.tr('reference_name'),
                    hintText: context.tr('ref_name_hint'),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: posCtrl,
                  decoration: InputDecoration(
                    labelText: context.tr('position_title'),
                    hintText: context.tr('ref_title_hint'),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: orgCtrl,
                  decoration: InputDecoration(
                    labelText: context.tr('organization_name'),
                    hintText: context.tr('ref_org_hint'),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: context.tr('email'),
                          hintText: context.tr('ref_email_hint'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: phoneCtrl,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: context.tr('phone'),
                          hintText: context.tr('ref_phone_hint'),
                        ),
                      ),
                    ),
                  ],
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
              final newRef = Reference(
                id: refItem?.id,
                name: nameCtrl.text.trim(),
                position: posCtrl.text.trim(),
                organization: orgCtrl.text.trim(),
                email: emailCtrl.text.trim(),
                phone: phoneCtrl.text.trim(),
              );

              final updated = List<Reference>.from(references);
              if (index != null) {
                updated[index] = newRef;
              } else {
                updated.add(newRef);
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
            title: context.tr('section_references'),
            count: references.length,
            addLabel: context.tr('add_reference'),
            onAdd: () => _addReference(context),
          ),
          const SizedBox(height: 16),
          if (references.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Text(
                    context.tr('no_references'),
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ),
              ),
            )
          else
            ...references.asMap().entries.map((entry) {
              final idx = entry.key;
              final r = entry.value;
              final sub = [
                if (r.position.isNotEmpty) r.position,
                if (r.organization.isNotEmpty) r.organization,
                if (r.email.isNotEmpty) r.email,
                if (r.phone.isNotEmpty) r.phone,
              ].join(' • ');

              return RepeatableEntryCard(
                index: idx,
                totalCount: references.length,
                title: r.name.isNotEmpty ? r.name : context.tr('untitled_entry'),
                subtitle: sub,
                onEdit: () => _editReference(context, r, idx),
                onDelete: () => _deleteReference(idx),
                onMoveUp: () => _moveUp(idx),
                onMoveDown: () => _moveDown(idx),
              );
            }),
        ],
      ),
    );
  }
}
