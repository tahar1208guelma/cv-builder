import 'package:flutter/material.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../../domain/models/certification.dart';
import '../common/repeatable_entry_card.dart';
import '../common/section_header_with_badge.dart';

class CertificationsEditor extends StatelessWidget {
  final List<Certification> certifications;
  final ValueChanged<List<Certification>> onChanged;

  const CertificationsEditor({
    super.key,
    required this.certifications,
    required this.onChanged,
  });

  void _addCert(BuildContext context) {
    _showCertDialog(context, null);
  }

  void _editCert(BuildContext context, Certification cert, int index) {
    _showCertDialog(context, cert, index: index);
  }

  void _deleteCert(int index) {
    final updated = List<Certification>.from(certifications)..removeAt(index);
    onChanged(updated);
  }

  void _moveUp(int index) {
    if (index <= 0) return;
    final updated = List<Certification>.from(certifications);
    final item = updated.removeAt(index);
    updated.insert(index - 1, item);
    onChanged(updated);
  }

  void _moveDown(int index) {
    if (index >= certifications.length - 1) return;
    final updated = List<Certification>.from(certifications);
    final item = updated.removeAt(index);
    updated.insert(index + 1, item);
    onChanged(updated);
  }

  void _showCertDialog(BuildContext context, Certification? cert, {int? index}) {
    final nameCtrl = TextEditingController(text: cert?.name ?? '');
    final issuerCtrl = TextEditingController(text: cert?.issuer ?? '');
    final dateCtrl = TextEditingController(text: cert?.issueDate ?? '');
    final urlCtrl = TextEditingController(text: cert?.url ?? '');
    final descCtrl = TextEditingController(text: cert?.description ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(cert == null ? context.tr('add_certification') : context.tr('edit_certification')),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    labelText: context.tr('cert_name'),
                    hintText: context.tr('cert_name_hint'),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: issuerCtrl,
                  decoration: InputDecoration(
                    labelText: context.tr('cert_issuer'),
                    hintText: context.tr('cert_issuer_hint'),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: dateCtrl,
                  decoration: InputDecoration(
                    labelText: context.tr('cert_date'),
                    hintText: context.tr('cert_date_hint'),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: urlCtrl,
                  decoration: InputDecoration(
                    labelText: context.tr('cert_url'),
                    hintText: context.tr('cert_url_hint'),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descCtrl,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: context.tr('cert_desc'),
                    hintText: context.tr('cert_desc_hint'),
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
              final newCert = Certification(
                id: cert?.id,
                name: nameCtrl.text.trim(),
                issuer: issuerCtrl.text.trim(),
                issueDate: dateCtrl.text.trim(),
                url: urlCtrl.text.trim(),
                description: descCtrl.text.trim(),
              );

              final updated = List<Certification>.from(certifications);
              if (index != null) {
                updated[index] = newCert;
              } else {
                updated.add(newCert);
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
            title: context.tr('section_certifications'),
            count: certifications.length,
            addLabel: context.tr('add_certification'),
            onAdd: () => _addCert(context),
          ),
          const SizedBox(height: 16),
          if (certifications.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Text(
                    context.tr('no_certifications'),
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ),
              ),
            )
          else
            ...certifications.asMap().entries.map((entry) {
              final idx = entry.key;
              final cert = entry.value;

              return RepeatableEntryCard(
                index: idx,
                totalCount: certifications.length,
                title: cert.name.isNotEmpty ? cert.name : context.tr('untitled_entry'),
                subtitle: cert.issuer,
                date: cert.issueDate,
                onEdit: () => _editCert(context, cert, idx),
                onDelete: () => _deleteCert(idx),
                onMoveUp: () => _moveUp(idx),
                onMoveDown: () => _moveDown(idx),
              );
            }),
        ],
      ),
    );
  }
}
