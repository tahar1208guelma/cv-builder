import 'package:flutter/material.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../../domain/models/volunteering.dart';
import '../common/repeatable_entry_card.dart';
import '../common/section_header_with_badge.dart';

class VolunteeringEditor extends StatelessWidget {
  final List<Volunteering> volunteering;
  final ValueChanged<List<Volunteering>> onChanged;

  const VolunteeringEditor({
    super.key,
    required this.volunteering,
    required this.onChanged,
  });

  void _addVolunteering(BuildContext context) {
    _showVolunteeringDialog(context, null);
  }

  void _editVolunteering(BuildContext context, Volunteering vol, int index) {
    _showVolunteeringDialog(context, vol, index: index);
  }

  void _deleteVolunteering(int index) {
    final updated = List<Volunteering>.from(volunteering)..removeAt(index);
    onChanged(updated);
  }

  void _moveUp(int index) {
    if (index <= 0) return;
    final updated = List<Volunteering>.from(volunteering);
    final item = updated.removeAt(index);
    updated.insert(index - 1, item);
    onChanged(updated);
  }

  void _moveDown(int index) {
    if (index >= volunteering.length - 1) return;
    final updated = List<Volunteering>.from(volunteering);
    final item = updated.removeAt(index);
    updated.insert(index + 1, item);
    onChanged(updated);
  }

  void _showVolunteeringDialog(BuildContext context, Volunteering? vol, {int? index}) {
    final orgCtrl = TextEditingController(text: vol?.organization ?? '');
    final roleCtrl = TextEditingController(text: vol?.role ?? '');
    final startCtrl = TextEditingController(text: vol?.startDate ?? '');
    final endCtrl = TextEditingController(text: vol?.endDate ?? '');
    final descCtrl = TextEditingController(text: vol?.description ?? '');
    bool isCurrent = vol?.isCurrent ?? false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          title: Text(vol == null ? context.tr('add_volunteering') : context.tr('edit_volunteering')),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: orgCtrl,
                    decoration: InputDecoration(
                      labelText: context.tr('company_name'),
                      hintText: context.tr('vol_org_hint'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: roleCtrl,
                    decoration: InputDecoration(
                      labelText: context.tr('role_title'),
                      hintText: context.tr('vol_role_hint'),
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
                          enabled: !isCurrent,
                          decoration: InputDecoration(
                            labelText: context.tr('end_date'),
                            hintText: isCurrent ? context.tr('current_volunteering') : context.tr('date_hint'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(context.tr('current_volunteering'), style: const TextStyle(fontSize: 13)),
                    value: isCurrent,
                    onChanged: (val) {
                      setModalState(() {
                        isCurrent = val ?? false;
                        if (isCurrent) {
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
                      labelText: context.tr('description'),
                      alignLabelWithHint: true,
                      hintText: context.tr('vol_desc_hint'),
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
                final newVol = Volunteering(
                  id: vol?.id,
                  organization: orgCtrl.text.trim(),
                  role: roleCtrl.text.trim(),
                  startDate: startCtrl.text.trim(),
                  endDate: isCurrent ? '' : endCtrl.text.trim(),
                  isCurrent: isCurrent,
                  description: descCtrl.text.trim(),
                );

                final updated = List<Volunteering>.from(volunteering);
                if (index != null) {
                  updated[index] = newVol;
                } else {
                  updated.add(newVol);
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
            title: context.tr('section_volunteering'),
            count: volunteering.length,
            addLabel: context.tr('add_volunteering'),
            onAdd: () => _addVolunteering(context),
          ),
          const SizedBox(height: 16),
          if (volunteering.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Text(
                    context.tr('no_volunteering'),
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ),
              ),
            )
          else
            ...volunteering.asMap().entries.map((entry) {
              final idx = entry.key;
              final vol = entry.value;

              final dateStr = vol.isCurrent
                  ? '${vol.startDate} - ${context.tr("current_volunteering")}'
                  : (vol.endDate.isNotEmpty ? '${vol.startDate} - ${vol.endDate}' : vol.startDate);

              return RepeatableEntryCard(
                index: idx,
                totalCount: volunteering.length,
                title: vol.role.isNotEmpty ? vol.role : context.tr('untitled_entry'),
                subtitle: vol.organization,
                date: dateStr,
                onEdit: () => _editVolunteering(context, vol, idx),
                onDelete: () => _deleteVolunteering(idx),
                onMoveUp: () => _moveUp(idx),
                onMoveDown: () => _moveDown(idx),
              );
            }),
        ],
      ),
    );
  }
}
