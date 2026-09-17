import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../../domain/models/personal_info.dart';

class PhotoPickerWidget extends StatelessWidget {
  final PersonalInfo personalInfo;
  final ValueChanged<PersonalInfo> onChanged;

  const PhotoPickerWidget({
    super.key,
    required this.personalInfo,
    required this.onChanged,
  });

  Future<void> _pickPhoto(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'jpeg', 'webp'],
        withData: true, // For web / in-memory bytes
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        Uint8List? bytes;

        if (file.bytes != null) {
          bytes = file.bytes;
        } else if (file.path != null) {
          final f = File(file.path!);
          if (await f.exists()) {
            bytes = await f.readAsBytes();
          }
        }

        if (bytes != null) {
          final base64String = base64Encode(bytes);
          onChanged(personalInfo.copyWith(
            photoBase64: base64String,
            showPhoto: true,
          ));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${context.tr('photo_pick_error')}: $e')),
        );
      }
    }
  }

  void _removePhoto() {
    onChanged(personalInfo.copyWith(
      clearPhoto: true,
    ));
  }

  void _toggleShowPhoto(bool? value) {
    onChanged(personalInfo.copyWith(
      showPhoto: value ?? false,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final hasPhoto = personalInfo.photoBase64 != null && personalInfo.photoBase64!.isNotEmpty;
    Uint8List? imageBytes;

    if (hasPhoto) {
      try {
        final cleanBase64 = personalInfo.photoBase64!.contains(',')
            ? personalInfo.photoBase64!.split(',').last
            : personalInfo.photoBase64!;
        imageBytes = base64Decode(cleanBase64);
      } catch (_) {
        imageBytes = null;
      }
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr('profile_photo'),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                // Avatar Preview
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
                      width: 2,
                    ),
                    image: (imageBytes != null && personalInfo.showPhoto)
                        ? DecorationImage(
                            image: MemoryImage(imageBytes),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: (imageBytes == null || !personalInfo.showPhoto)
                      ? Icon(
                          Icons.person,
                          size: 40,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => _pickPhoto(context),
                            icon: const Icon(Icons.photo_camera, size: 16),
                            label: Text(
                              hasPhoto ? context.tr('change_photo') : context.tr('upload_photo'),
                            ),
                          ),
                          if (hasPhoto)
                            OutlinedButton.icon(
                              onPressed: _removePhoto,
                              icon: const Icon(Icons.delete_outline, size: 16),
                              label: Text(context.tr('remove_photo')),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Theme.of(context).colorScheme.error,
                                side: BorderSide(color: Theme.of(context).colorScheme.error),
                              ),
                            ),
                        ],
                      ),
                      if (hasPhoto) ...[
                        const SizedBox(height: 8),
                        CheckboxListTile(
                          value: personalInfo.showPhoto,
                          onChanged: _toggleShowPhoto,
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          title: Text(
                            context.tr('show_photo_in_cv'),
                            style: const TextStyle(fontSize: 13),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
