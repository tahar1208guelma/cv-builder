import 'package:flutter/material.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../../domain/models/skill.dart';

class SkillsEditor extends StatefulWidget {
  final List<Skill> skills;
  final ValueChanged<List<Skill>> onChanged;

  const SkillsEditor({
    super.key,
    required this.skills,
    required this.onChanged,
  });

  @override
  State<SkillsEditor> createState() => _SkillsEditorState();
}

class _SkillsEditorState extends State<SkillsEditor> {
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  int _selectedLevel = 4;

  void _addSkill() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final newSkill = Skill(
      name: name,
      level: _selectedLevel,
      category: _categoryController.text.trim(),
    );

    final updated = List<Skill>.from(widget.skills)..add(newSkill);
    widget.onChanged(updated);

    _nameController.clear();
    _categoryController.clear();
    setState(() {
      _selectedLevel = 4;
    });
  }

  void _editSkill(Skill skill, int index) {
    final nameCtrl = TextEditingController(text: skill.name);
    final catCtrl = TextEditingController(text: skill.category);
    int level = skill.level;

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
                decoration: InputDecoration(labelText: context.tr('skill_name')),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: catCtrl,
                decoration: InputDecoration(labelText: context.tr('skill_category')),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(context.tr('skill_level')),
                  Row(
                    children: List.generate(5, (starIdx) {
                      final starNum = starIdx + 1;
                      return IconButton(
                        iconSize: 22,
                        padding: const EdgeInsets.all(2),
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          starNum <= level ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () {
                          setModalState(() {
                            level = starNum;
                          });
                        },
                      );
                    }),
                  ),
                ],
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
                final updated = List<Skill>.from(widget.skills);
                updated[index] = skill.copyWith(
                  name: nameCtrl.text.trim(),
                  category: catCtrl.text.trim(),
                  level: level,
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

  void _removeSkill(int index) {
    final updated = List<Skill>.from(widget.skills)..removeAt(index);
    widget.onChanged(updated);
  }

  void _updateSkillLevel(int index, int newLevel) {
    final updated = List<Skill>.from(widget.skills);
    updated[index] = updated[index].copyWith(level: newLevel);
    widget.onChanged(updated);
  }

  void _moveUp(int index) {
    if (index <= 0) return;
    final updated = List<Skill>.from(widget.skills);
    final item = updated.removeAt(index);
    updated.insert(index - 1, item);
    widget.onChanged(updated);
  }

  void _moveDown(int index) {
    if (index >= widget.skills.length - 1) return;
    final updated = List<Skill>.from(widget.skills);
    final item = updated.removeAt(index);
    updated.insert(index + 1, item);
    widget.onChanged(updated);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
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
                context.tr('section_skills'),
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
                  '${widget.skills.length}',
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

          // Add Skill Form Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr('add_skill'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: context.tr('skill_name'),
                            hintText: context.tr('skill_name_hint'),
                          ),
                          onSubmitted: (_) => _addSkill(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _categoryController,
                          decoration: InputDecoration(
                            labelText: context.tr('skill_category'),
                            hintText: context.tr('skill_category_hint'),
                          ),
                          onSubmitted: (_) => _addSkill(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(context.tr('skill_level')),
                          const SizedBox(width: 8),
                          Row(
                            children: List.generate(5, (starIdx) {
                              final starNum = starIdx + 1;
                              return IconButton(
                                iconSize: 20,
                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                constraints: const BoxConstraints(),
                                icon: Icon(
                                  starNum <= _selectedLevel ? Icons.star : Icons.star_border,
                                  color: Colors.amber,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _selectedLevel = starNum;
                                  });
                                },
                              );
                            }),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: _addSkill,
                        icon: const Icon(Icons.add, size: 18),
                        label: Text(context.tr('add')),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Skills List
          if (widget.skills.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Text(
                    context.tr('no_skills'),
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
                  children: widget.skills.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final skill = entry.value;
                    final canMoveUp = idx > 0;
                    final canMoveDown = idx < widget.skills.length - 1;

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
                                  skill.name,
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                ),
                                if (skill.category.isNotEmpty)
                                  Text(
                                    skill.category,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          // Star rating row
                          Row(
                            children: List.generate(5, (starIdx) {
                              final starNum = starIdx + 1;
                              return IconButton(
                                iconSize: 18,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                icon: Icon(
                                  starNum <= skill.level ? Icons.star : Icons.star_border,
                                  color: Colors.amber,
                                ),
                                onPressed: () => _updateSkillLevel(idx, starNum),
                              );
                            }),
                          ),
                          const SizedBox(width: 6),

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
                            onPressed: () => _editSkill(skill, idx),
                          ),
                          // Delete
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(),
                            icon: const Icon(Icons.delete_outline, size: 16, color: Color(0xFFDC2626)),
                            tooltip: context.tr('delete'),
                            onPressed: () => _removeSkill(idx),
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
