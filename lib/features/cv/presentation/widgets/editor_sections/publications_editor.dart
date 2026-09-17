import 'package:flutter/material.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../../domain/models/publication.dart';
import '../common/repeatable_entry_card.dart';
import '../common/section_header_with_badge.dart';

class PublicationsEditor extends StatelessWidget {
  final List<Publication> publications;
  final ValueChanged<List<Publication>> onChanged;

  const PublicationsEditor({
    super.key,
    required this.publications,
    required this.onChanged,
  });

  void _addPublication(BuildContext context) {
    _showPublicationDialog(context, null);
  }

  void _editPublication(BuildContext context, Publication pub, int index) {
    _showPublicationDialog(context, pub, index: index);
  }

  void _deletePublication(int index) {
    final updated = List<Publication>.from(publications)..removeAt(index);
    onChanged(updated);
  }

  void _moveUp(int index) {
    if (index <= 0) return;
    final updated = List<Publication>.from(publications);
    final item = updated.removeAt(index);
    updated.insert(index - 1, item);
    onChanged(updated);
  }

  void _moveDown(int index) {
    if (index >= publications.length - 1) return;
    final updated = List<Publication>.from(publications);
    final item = updated.removeAt(index);
    updated.insert(index + 1, item);
    onChanged(updated);
  }

  void _showPublicationDialog(BuildContext context, Publication? pub, {int? index}) {
    final titleCtrl = TextEditingController(text: pub?.title ?? '');
    final authorsCtrl = TextEditingController(text: pub?.authors ?? '');
    final pubCtrl = TextEditingController(text: pub?.publisher ?? '');
    final dateCtrl = TextEditingController(text: pub?.date ?? '');
    final urlCtrl = TextEditingController(text: pub?.url ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(pub == null ? context.tr('add_publication') : context.tr('edit_publication')),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleCtrl,
                  decoration: InputDecoration(
                    labelText: context.tr('publication_title'),
                    hintText: context.tr('pub_title_hint'),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: authorsCtrl,
                  decoration: InputDecoration(
                    labelText: context.tr('authors'),
                    hintText: context.tr('pub_authors_hint'),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: pubCtrl,
                  decoration: InputDecoration(
                    labelText: context.tr('journal_publisher'),
                    hintText: context.tr('pub_publisher_hint'),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: dateCtrl,
                        decoration: InputDecoration(
                          labelText: context.tr('start_date'),
                          hintText: context.tr('pub_date_hint'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: urlCtrl,
                        decoration: InputDecoration(
                          labelText: context.tr('doi_url'),
                          hintText: context.tr('pub_url_hint'),
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
              final newPub = Publication(
                id: pub?.id,
                title: titleCtrl.text.trim(),
                authors: authorsCtrl.text.trim(),
                publisher: pubCtrl.text.trim(),
                date: dateCtrl.text.trim(),
                url: urlCtrl.text.trim(),
              );

              final updated = List<Publication>.from(publications);
              if (index != null) {
                updated[index] = newPub;
              } else {
                updated.add(newPub);
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
            title: context.tr('section_publications'),
            count: publications.length,
            addLabel: context.tr('add_publication'),
            onAdd: () => _addPublication(context),
          ),
          const SizedBox(height: 16),
          if (publications.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Text(
                    context.tr('no_publications'),
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ),
              ),
            )
          else
            ...publications.asMap().entries.map((entry) {
              final idx = entry.key;
              final pub = entry.value;
              final sub = [
                if (pub.authors.isNotEmpty) pub.authors,
                if (pub.publisher.isNotEmpty) pub.publisher,
              ].join(' • ');

              return RepeatableEntryCard(
                index: idx,
                totalCount: publications.length,
                title: pub.title.isNotEmpty ? pub.title : context.tr('untitled_entry'),
                subtitle: sub,
                date: pub.date,
                onEdit: () => _editPublication(context, pub, idx),
                onDelete: () => _deletePublication(idx),
                onMoveUp: () => _moveUp(idx),
                onMoveDown: () => _moveDown(idx),
              );
            }),
        ],
      ),
    );
  }
}
