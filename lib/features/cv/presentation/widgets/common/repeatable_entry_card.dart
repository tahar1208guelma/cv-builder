import 'package:flutter/material.dart';
import '../../../../../core/localization/app_localizations.dart';

class RepeatableEntryCard extends StatelessWidget {
  final int index;
  final int totalCount;
  final String title;
  final String? subtitle;
  final String? date;
  final Widget? extraContent;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onMoveUp;
  final VoidCallback? onMoveDown;

  const RepeatableEntryCard({
    super.key,
    required this.index,
    required this.totalCount,
    required this.title,
    this.subtitle,
    this.date,
    this.extraContent,
    required this.onEdit,
    required this.onDelete,
    this.onMoveUp,
    this.onMoveDown,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canMoveUp = index > 0;
    final canMoveDown = index < totalCount - 1;

    return Card(
      elevation: 0.8,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Order badge
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '#${index + 1}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title.isNotEmpty ? title : context.tr('untitled_entry'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                      if (date != null && date!.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Text(
                          date!,
                          style: TextStyle(fontSize: 11, color: theme.colorScheme.outline),
                        ),
                      ],
                    ],
                  ),
                  if (subtitle != null && subtitle!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  if (extraContent != null) ...[
                    const SizedBox(height: 4),
                    extraContent!,
                  ],
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Actions: Reorder (Up / Down) + Edit + Delete
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Move Up
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    Icons.arrow_upward,
                    size: 18,
                    color: canMoveUp ? theme.colorScheme.primary : theme.colorScheme.outline.withValues(alpha: 0.3),
                  ),
                  tooltip: context.tr('move_up'),
                  onPressed: canMoveUp ? onMoveUp : null,
                ),
                const SizedBox(width: 2),

                // Move Down
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    Icons.arrow_downward,
                    size: 18,
                    color: canMoveDown ? theme.colorScheme.primary : theme.colorScheme.outline.withValues(alpha: 0.3),
                  ),
                  tooltip: context.tr('move_down'),
                  onPressed: canMoveDown ? onMoveDown : null,
                ),
                const SizedBox(width: 4),

                // Edit
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  tooltip: context.tr('edit'),
                  onPressed: onEdit,
                ),
                const SizedBox(width: 4),

                // Delete
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.delete_outline, size: 18, color: Color(0xFFDC2626)),
                  tooltip: context.tr('delete'),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
