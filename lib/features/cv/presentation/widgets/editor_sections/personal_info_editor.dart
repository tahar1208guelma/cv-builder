import 'package:flutter/material.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../../domain/models/personal_info.dart';
import '../common/photo_picker_widget.dart';

class PersonalInfoEditor extends StatefulWidget {
  final PersonalInfo personalInfo;
  final ValueChanged<PersonalInfo> onChanged;

  const PersonalInfoEditor({
    super.key,
    required this.personalInfo,
    required this.onChanged,
  });

  @override
  State<PersonalInfoEditor> createState() => _PersonalInfoEditorState();
}

class _PersonalInfoEditorState extends State<PersonalInfoEditor> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _titleController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _dobController;
  late final TextEditingController _nationalityController;
  late final TextEditingController _websiteController;
  late final TextEditingController _linkedinController;
  late final TextEditingController _githubController;
  late final TextEditingController _summaryController;

  @override
  void initState() {
    super.initState();
    final p = widget.personalInfo;
    _firstNameController = TextEditingController(text: p.firstName);
    _lastNameController = TextEditingController(text: p.lastName);
    _titleController = TextEditingController(text: p.jobTitle);
    _emailController = TextEditingController(text: p.email);
    _phoneController = TextEditingController(text: p.phone);
    _addressController = TextEditingController(text: p.address);
    _dobController = TextEditingController(text: p.dateOfBirth);
    _nationalityController = TextEditingController(text: p.nationality);
    _websiteController = TextEditingController(text: p.website);
    _linkedinController = TextEditingController(text: p.linkedin);
    _githubController = TextEditingController(text: p.github);
    _summaryController = TextEditingController(text: p.summary);
  }

  @override
  void didUpdateWidget(covariant PersonalInfoEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.personalInfo != widget.personalInfo) {
      final p = widget.personalInfo;
      _syncIfDifferent(_firstNameController, p.firstName);
      _syncIfDifferent(_lastNameController, p.lastName);
      _syncIfDifferent(_titleController, p.jobTitle);
      _syncIfDifferent(_emailController, p.email);
      _syncIfDifferent(_phoneController, p.phone);
      _syncIfDifferent(_addressController, p.address);
      _syncIfDifferent(_dobController, p.dateOfBirth);
      _syncIfDifferent(_nationalityController, p.nationality);
      _syncIfDifferent(_websiteController, p.website);
      _syncIfDifferent(_linkedinController, p.linkedin);
      _syncIfDifferent(_githubController, p.github);
      _syncIfDifferent(_summaryController, p.summary);
    }
  }

  void _syncIfDifferent(TextEditingController controller, String value) {
    if (controller.text != value) {
      controller.text = value;
    }
  }

  void _notifyChange() {
    widget.onChanged(widget.personalInfo.copyWith(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      jobTitle: _titleController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      address: _addressController.text,
      dateOfBirth: _dobController.text,
      nationality: _nationalityController.text,
      website: _websiteController.text,
      linkedin: _linkedinController.text,
      github: _githubController.text,
      summary: _summaryController.text,
    ));
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _titleController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _dobController.dispose();
    _nationalityController.dispose();
    _websiteController.dispose();
    _linkedinController.dispose();
    _githubController.dispose();
    _summaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PhotoPickerWidget(
            personalInfo: widget.personalInfo,
            onChanged: widget.onChanged,
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr('section_personal_info'),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),

                  // First Name & Last Name in row
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _firstNameController,
                          decoration: InputDecoration(
                            labelText: context.tr('first_name'),
                            prefixIcon: const Icon(Icons.person_outline, size: 20),
                          ),
                          onChanged: (_) => _notifyChange(),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: TextFormField(
                          controller: _lastNameController,
                          decoration: InputDecoration(
                            labelText: context.tr('last_name'),
                            prefixIcon: const Icon(Icons.badge_outlined, size: 20),
                          ),
                          onChanged: (_) => _notifyChange(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Professional Title
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: context.tr('job_title'),
                      prefixIcon: const Icon(Icons.work_outline, size: 20),
                    ),
                    onChanged: (_) => _notifyChange(),
                  ),
                  const SizedBox(height: 14),

                  // Email & Phone
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: context.tr('email'),
                            prefixIcon: const Icon(Icons.email_outlined, size: 20),
                          ),
                          onChanged: (_) => _notifyChange(),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: context.tr('phone'),
                            prefixIcon: const Icon(Icons.phone_outlined, size: 20),
                          ),
                          onChanged: (_) => _notifyChange(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Address
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: context.tr('address'),
                      prefixIcon: const Icon(Icons.location_on_outlined, size: 20),
                    ),
                    onChanged: (_) => _notifyChange(),
                  ),
                  const SizedBox(height: 14),

                  // Date of Birth & Nationality (Optional)
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _dobController,
                          decoration: InputDecoration(
                            labelText: context.tr('date_of_birth'),
                            hintText: context.tr('dob_hint'),
                            prefixIcon: const Icon(Icons.cake_outlined, size: 20),
                          ),
                          onChanged: (_) => _notifyChange(),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: TextFormField(
                          controller: _nationalityController,
                          decoration: InputDecoration(
                            labelText: context.tr('nationality'),
                            hintText: context.tr('nationality_hint'),
                            prefixIcon: const Icon(Icons.flag_outlined, size: 20),
                          ),
                          onChanged: (_) => _notifyChange(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Website & LinkedIn
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _websiteController,
                          decoration: InputDecoration(
                            labelText: context.tr('website'),
                            prefixIcon: const Icon(Icons.language, size: 20),
                          ),
                          onChanged: (_) => _notifyChange(),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: TextFormField(
                          controller: _linkedinController,
                          decoration: InputDecoration(
                            labelText: context.tr('linkedin'),
                            prefixIcon: const Icon(Icons.link, size: 20),
                          ),
                          onChanged: (_) => _notifyChange(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // GitHub
                  TextFormField(
                    controller: _githubController,
                    decoration: InputDecoration(
                      labelText: context.tr('github'),
                      prefixIcon: const Icon(Icons.code, size: 20),
                    ),
                    onChanged: (_) => _notifyChange(),
                  ),
                  const SizedBox(height: 14),

                  // Summary
                  TextFormField(
                    controller: _summaryController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: context.tr('summary'),
                      alignLabelWithHint: true,
                      hintText: context.tr('summary_hint'),
                    ),
                    onChanged: (_) => _notifyChange(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
