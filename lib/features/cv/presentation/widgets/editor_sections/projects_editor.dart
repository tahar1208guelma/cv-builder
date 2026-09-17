import 'package:flutter/material.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../../domain/models/project.dart';
import '../common/repeatable_entry_card.dart';
import '../common/section_header_with_badge.dart';

class ProjectsEditor extends StatelessWidget {
  final List<Project> projects;
  final ValueChanged<List<Project>> onChanged;

  const ProjectsEditor({
    super.key,
    required this.projects,
    required this.onChanged,
  });

  void _addProject(BuildContext context) {
    _showProjectDialog(context, null);
  }

  void _editProject(BuildContext context, Project proj, int index) {
    _showProjectDialog(context, proj, index: index);
  }

  void _deleteProject(int index) {
    final updated = List<Project>.from(projects)..removeAt(index);
    onChanged(updated);
  }

  void _moveUp(int index) {
    if (index <= 0) return;
    final updated = List<Project>.from(projects);
    final item = updated.removeAt(index);
    updated.insert(index - 1, item);
    onChanged(updated);
  }

  void _moveDown(int index) {
    if (index >= projects.length - 1) return;
    final updated = List<Project>.from(projects);
    final item = updated.removeAt(index);
    updated.insert(index + 1, item);
    onChanged(updated);
  }

  void _showProjectDialog(BuildContext context, Project? proj, {int? index}) {
    final titleCtrl = TextEditingController(text: proj?.title ?? '');
    final roleCtrl = TextEditingController(text: proj?.role ?? '');
    final dateCtrl = TextEditingController(text: proj?.date ?? '');
    final urlCtrl = TextEditingController(text: proj?.url ?? '');
    final techCtrl = TextEditingController(text: proj?.technologies ?? '');
    final descCtrl = TextEditingController(text: proj?.description ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(proj == null ? context.tr('add_project') : context.tr('edit_project')),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleCtrl,
                  decoration: InputDecoration(
                    labelText: context.tr('project_name'),
                    hintText: context.tr('project_title_hint'),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: roleCtrl,
                        decoration: InputDecoration(
                          labelText: context.tr('project_role'),
                          hintText: context.tr('project_role_hint'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: dateCtrl,
                        decoration: InputDecoration(
                          labelText: context.tr('project_date'),
                          hintText: context.tr('project_date_hint'),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: urlCtrl,
                  decoration: InputDecoration(
                    labelText: context.tr('project_url'),
                    hintText: context.tr('project_url_hint'),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: techCtrl,
                  decoration: InputDecoration(
                    labelText: context.tr('project_tech'),
                    hintText: context.tr('project_tech_hint'),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descCtrl,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: context.tr('project_desc'),
                    alignLabelWithHint: true,
                    hintText: context.tr('project_desc_hint'),
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
              final newProj = Project(
                id: proj?.id,
                title: titleCtrl.text.trim(),
                role: roleCtrl.text.trim(),
                date: dateCtrl.text.trim(),
                url: urlCtrl.text.trim(),
                technologies: techCtrl.text.trim(),
                description: descCtrl.text.trim(),
              );

              final updated = List<Project>.from(projects);
              if (index != null) {
                updated[index] = newProj;
              } else {
                updated.add(newProj);
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
            title: context.tr('section_projects'),
            count: projects.length,
            addLabel: context.tr('add_project'),
            onAdd: () => _addProject(context),
          ),
          const SizedBox(height: 16),
          if (projects.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Text(
                    context.tr('no_projects'),
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ),
              ),
            )
          else
            ...projects.asMap().entries.map((entry) {
              final idx = entry.key;
              final proj = entry.value;
              final sub = [
                if (proj.role.isNotEmpty) proj.role,
                if (proj.technologies.isNotEmpty) proj.technologies,
              ].join(' • ');

              return RepeatableEntryCard(
                index: idx,
                totalCount: projects.length,
                title: proj.title.isNotEmpty ? proj.title : context.tr('untitled_entry'),
                subtitle: sub,
                date: proj.date,
                onEdit: () => _editProject(context, proj, idx),
                onDelete: () => _deleteProject(idx),
                onMoveUp: () => _moveUp(idx),
                onMoveDown: () => _moveDown(idx),
              );
            }),
        ],
      ),
    );
  }
}
