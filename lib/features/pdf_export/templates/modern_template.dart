import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../cv/domain/models/award.dart';
import '../../cv/domain/models/certification.dart';
import '../../cv/domain/models/custom_section.dart';
import '../../cv/domain/models/education.dart';
import '../../cv/domain/models/experience.dart';
import '../../cv/domain/models/personal_info.dart';
import '../../cv/domain/models/project.dart';
import '../../cv/domain/models/publication.dart';
import '../../cv/domain/models/reference.dart';
import '../../cv/domain/models/volunteering.dart';
import 'base_pdf_template.dart';

class ModernTemplate extends BasePdfTemplate {
  ModernTemplate({required super.cv, required super.fonts});

  @override
  Future<pw.Document> generate() async {
    final doc = createDocument();
    final photo = photoImage;

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        footer: buildFooter,
        build: (context) {
          final items = <pw.Widget>[];

          items.add(wrapDirection(_buildHeader(photo)));
          items.add(pw.SizedBox(height: 14));

          if (cv.personalInfo.summary.isNotEmpty) {
            items.addAll(
              buildIntelligentSection(
                header: _buildSectionHeader(tr('summary')),
                items: [
                  pw.Text(
                    cv.personalInfo.summary,
                    style: pw.TextStyle(fontSize: 9.5, height: 1.4, color: textPrimaryColor),
                  ),
                ],
              ),
            );
          }

          if (cv.experiences.isNotEmpty) {
            items.addAll(
              buildIntelligentSection(
                header: _buildSectionHeader(tr('experience')),
                items: cv.experiences.map(_buildExperienceItem).toList(),
              ),
            );
          }

          if (cv.educations.isNotEmpty) {
            items.addAll(
              buildIntelligentSection(
                header: _buildSectionHeader(tr('education')),
                items: cv.educations.map(_buildEducationItem).toList(),
              ),
            );
          }

          if (cv.skills.isNotEmpty) {
            items.addAll(
              buildIntelligentSection(
                header: _buildSectionHeader(tr('skills')),
                items: [_buildModernSkills()],
              ),
            );
          }

          if (cv.languages.isNotEmpty) {
            items.addAll(
              buildIntelligentSection(
                header: _buildSectionHeader(tr('languages')),
                items: [_buildModernLanguages()],
              ),
            );
          }

          if (cv.projects.isNotEmpty) {
            items.addAll(
              buildIntelligentSection(
                header: _buildSectionHeader(tr('projects')),
                items: cv.projects.map(_buildProjectItem).toList(),
              ),
            );
          }

          if (cv.publications.isNotEmpty) {
            items.addAll(
              buildIntelligentSection(
                header: _buildSectionHeader(tr('publications')),
                items: cv.publications.map(_buildPublicationItem).toList(),
              ),
            );
          }

          if (cv.certifications.isNotEmpty) {
            items.addAll(
              buildIntelligentSection(
                header: _buildSectionHeader(tr('certifications')),
                items: cv.certifications.map(_buildCertificationItem).toList(),
              ),
            );
          }

          if (cv.awards.isNotEmpty) {
            items.addAll(
              buildIntelligentSection(
                header: _buildSectionHeader(tr('awards')),
                items: cv.awards.map(_buildAwardItem).toList(),
              ),
            );
          }

          if (cv.volunteering.isNotEmpty) {
            items.addAll(
              buildIntelligentSection(
                header: _buildSectionHeader(tr('volunteering')),
                items: cv.volunteering.map(_buildVolunteeringItem).toList(),
              ),
            );
          }

          if (cv.references.isNotEmpty) {
            items.addAll(
              buildIntelligentSection(
                header: _buildSectionHeader(tr('references')),
                items: cv.references.map(_buildReferenceItem).toList(),
              ),
            );
          }

          if (cv.customSections.isNotEmpty) {
            for (final custom in cv.customSections) {
              if (custom.items.isNotEmpty) {
                items.addAll(
                  buildIntelligentSection(
                    header: _buildSectionHeader(custom.title),
                    items: custom.items.map(_buildCustomItem).toList(),
                  ),
                );
              }
            }
          }

          return items;
        },
      ),
    );

    return doc;
  }

  pw.Widget _buildHeader(pw.ImageProvider? photo) {
    final info = cv.personalInfo;

    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: lightPrimaryColor,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
        border: pw.Border.all(color: primaryColor, width: 1),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          if (photo != null) ...[
            pw.Container(
              width: 70,
              height: 70,
              decoration: pw.BoxDecoration(
                shape: pw.BoxShape.circle,
                border: pw.Border.all(color: primaryColor, width: 2),
                image: pw.DecorationImage(image: photo, fit: pw.BoxFit.cover),
              ),
            ),
            pw.SizedBox(width: 18),
          ],
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  info.fullName.isNotEmpty ? info.fullName : cv.title,
                  style: pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                if (info.jobTitle.isNotEmpty) ...[
                  pw.SizedBox(height: 4),
                  pw.Text(
                    info.jobTitle,
                    style: pw.TextStyle(
                      fontSize: 13,
                      fontWeight: pw.FontWeight.bold,
                      color: textPrimaryColor,
                    ),
                  ),
                ],
                pw.SizedBox(height: 8),
                _buildContactInfoBar(info),
              ],
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildContactInfoBar(PersonalInfo info) {
    final contactStyle = pw.TextStyle(fontSize: 9, color: textSecondaryColor);
    final linkStyle = pw.TextStyle(fontSize: 9, color: primaryColor);

    final widgets = <pw.Widget>[];

    if (info.email.isNotEmpty) {
      widgets.add(buildLink(
        text: info.email,
        url: 'mailto:${info.email}',
        style: linkStyle,
      ));
    }
    if (info.phone.isNotEmpty) {
      widgets.add(buildLtrText(info.phone, style: contactStyle));
    }
    if (info.address.isNotEmpty) {
      widgets.add(pw.Text(info.address, style: contactStyle));
    }
    if (info.dateOfBirth.isNotEmpty) {
      widgets.add(pw.Text(info.dateOfBirth, style: contactStyle));
    }
    if (info.nationality.isNotEmpty) {
      widgets.add(pw.Text(info.nationality, style: contactStyle));
    }
    if (info.website.isNotEmpty) {
      widgets.add(buildLink(
        text: info.website,
        url: info.website,
        style: linkStyle,
      ));
    }
    if (info.linkedin.isNotEmpty) {
      widgets.add(buildLink(
        text: 'LinkedIn',
        url: info.linkedin.startsWith('http') ? info.linkedin : 'https://linkedin.com/in/${info.linkedin}',
        style: linkStyle,
      ));
    }
    if (info.github.isNotEmpty) {
      widgets.add(buildLink(
        text: 'GitHub',
        url: info.github.startsWith('http') ? info.github : 'https://github.com/${info.github}',
        style: linkStyle,
      ));
    }

    if (widgets.isEmpty) return pw.SizedBox();

    return pw.Wrap(
      spacing: 12,
      runSpacing: 4,
      children: widgets,
    );
  }

  pw.Widget _buildModernSkills() {
    return pw.Wrap(
      spacing: 8,
      runSpacing: 6,
      children: cv.skills.map((skill) {
        return pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 9, vertical: 4),
          decoration: pw.BoxDecoration(
            color: lightPrimaryColor,
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
            border: pw.Border.all(color: primaryColor, width: 0.6),
          ),
          child: pw.Row(
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              pw.Text(
                skill.name,
                style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                  color: textPrimaryColor,
                ),
              ),
              if (skill.level > 0) ...[
                pw.SizedBox(width: 5),
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: pw.BoxDecoration(
                    color: primaryColor,
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
                  ),
                  child: pw.Text(
                    '${skill.level}/5',
                    style: const pw.TextStyle(
                      fontSize: 7.5,
                      color: PdfColors.white,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  pw.Widget _buildModernLanguages() {
    return pw.Wrap(
      spacing: 8,
      runSpacing: 6,
      children: cv.languages.map((lang) {
        return pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 9, vertical: 4),
          decoration: pw.BoxDecoration(
            color: const PdfColor(0.96, 0.97, 0.98),
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
            border: pw.Border.all(color: borderColor, width: 0.8),
          ),
          child: pw.Row(
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              pw.Text(
                lang.name,
                style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                  color: textPrimaryColor,
                ),
              ),
              pw.SizedBox(width: 5),
              pw.Text(
                '(${tr(lang.proficiency.name)})',
                style: pw.TextStyle(
                  fontSize: 8,
                  color: textSecondaryColor,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  pw.Widget _buildSectionHeader(String title) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 8),
      padding: const pw.EdgeInsets.only(bottom: 4),
      decoration: pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: primaryColor, width: 1.5),
        ),
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 12,
          fontWeight: pw.FontWeight.bold,
          color: primaryColor,
        ),
      ),
    );
  }

  pw.Widget _buildExperienceItem(Experience exp) {
    final dateRange = '${exp.startDate} - ${exp.isCurrent ? tr('present') : exp.endDate}';
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Expanded(
                child: pw.Text(
                  exp.position,
                  style: pw.TextStyle(fontSize: 10.5, fontWeight: pw.FontWeight.bold, color: textPrimaryColor),
                ),
              ),
              pw.Text(
                dateRange,
                style: pw.TextStyle(fontSize: 8.5, color: textSecondaryColor, font: fonts.bold),
              ),
            ],
          ),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                exp.company,
                style: pw.TextStyle(fontSize: 9.5, color: primaryColor, font: fonts.bold),
              ),
              if (exp.location.isNotEmpty)
                pw.Text(
                  exp.location,
                  style: pw.TextStyle(fontSize: 8.5, color: textSecondaryColor),
                ),
            ],
          ),
          if (exp.description.isNotEmpty) ...[
            pw.SizedBox(height: 3),
            pw.Text(
              exp.description,
              style: pw.TextStyle(fontSize: 9, height: 1.35, color: textPrimaryColor),
            ),
          ],
          if (exp.highlights.isNotEmpty) ...[
            pw.SizedBox(height: 3),
            ...exp.highlights.map((bullet) => pw.Padding(
                  padding: const pw.EdgeInsets.only(left: 6, right: 6, bottom: 2),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('• ', style: pw.TextStyle(color: primaryColor, fontSize: 9, font: fonts.bold)),
                      pw.Expanded(
                        child: pw.Text(
                          bullet,
                          style: pw.TextStyle(fontSize: 8.8, height: 1.3, color: textPrimaryColor),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ],
      ),
    );
  }

  pw.Widget _buildEducationItem(Education edu) {
    final dateEnd = edu.currentlyStudying ? tr('present') : edu.endDate;
    final dateRange = edu.startDate.isNotEmpty ? '${edu.startDate} - $dateEnd' : dateEnd;
    final degreeTitle = edu.fieldOfStudy.isNotEmpty
        ? (edu.degree.isNotEmpty ? '${edu.degree} - ${edu.fieldOfStudy}' : edu.fieldOfStudy)
        : edu.degree;
    final instCountry = edu.country.isNotEmpty
        ? (edu.institution.isNotEmpty ? '${edu.institution}, ${edu.country}' : edu.country)
        : edu.institution;

    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Expanded(
                child: pw.Text(
                  degreeTitle,
                  style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: textPrimaryColor),
                ),
              ),
              if (dateRange.isNotEmpty)
                pw.Text(
                  dateRange,
                  style: pw.TextStyle(fontSize: 8.5, color: textSecondaryColor),
                ),
            ],
          ),
          pw.Text(
            instCountry,
            style: pw.TextStyle(fontSize: 9, color: primaryColor, font: fonts.bold),
          ),
          if (edu.grade.isNotEmpty)
            pw.Text(
              edu.grade,
              style: pw.TextStyle(fontSize: 8.5, color: textSecondaryColor),
            ),
          if (edu.description.isNotEmpty)
            pw.Text(
              edu.description,
              style: pw.TextStyle(fontSize: 8.5, color: textPrimaryColor),
            ),
        ],
      ),
    );
  }

  pw.Widget _buildProjectItem(Project proj) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 7),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Expanded(
                child: pw.Text(
                  proj.title,
                  style: pw.TextStyle(fontSize: 9.5, fontWeight: pw.FontWeight.bold, color: textPrimaryColor),
                ),
              ),
              if (proj.date.isNotEmpty)
                pw.Text(proj.date, style: pw.TextStyle(fontSize: 8.5, color: textSecondaryColor)),
            ],
          ),
          if (proj.role.isNotEmpty || proj.technologies.isNotEmpty)
            pw.Text(
              '${proj.role}${proj.role.isNotEmpty && proj.technologies.isNotEmpty ? ' | ' : ''}${proj.technologies}',
              style: pw.TextStyle(fontSize: 8.5, color: primaryColor, font: fonts.bold),
            ),
          if (proj.description.isNotEmpty)
            pw.Text(
              proj.description,
              style: pw.TextStyle(fontSize: 8.5, color: textPrimaryColor),
            ),
          if (proj.url.isNotEmpty)
            buildLink(
              text: proj.url,
              url: proj.url,
              style: pw.TextStyle(fontSize: 8, color: primaryColor),
            ),
        ],
      ),
    );
  }

  pw.Widget _buildCertificationItem(Certification cert) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 5),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            cert.name,
            style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: textPrimaryColor),
          ),
          pw.Text(
            '${cert.issuer} ${cert.issueDate.isNotEmpty ? '• ${cert.issueDate}' : ''}',
            style: pw.TextStyle(fontSize: 8, color: textSecondaryColor),
          ),
          if (cert.description.isNotEmpty)
            pw.Text(
              cert.description,
              style: pw.TextStyle(fontSize: 8, color: textPrimaryColor),
            ),
          if (cert.url.isNotEmpty)
            buildLink(
              text: cert.url,
              url: cert.url,
              style: pw.TextStyle(fontSize: 7.5, color: primaryColor),
            ),
        ],
      ),
    );
  }

  pw.Widget _buildPublicationItem(Publication pub) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 7),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Expanded(
                child: pw.Text(
                  pub.title,
                  style: pw.TextStyle(fontSize: 9.5, fontWeight: pw.FontWeight.bold, color: textPrimaryColor),
                ),
              ),
              if (pub.date.isNotEmpty)
                pw.Text(pub.date, style: pw.TextStyle(fontSize: 8.5, color: textSecondaryColor)),
            ],
          ),
          if (pub.authors.isNotEmpty)
            pw.Text(pub.authors, style: pw.TextStyle(fontSize: 8.5, color: primaryColor)),
          if (pub.publisher.isNotEmpty)
            pw.Text(pub.publisher, style: pw.TextStyle(fontSize: 8.5, color: textSecondaryColor, font: fonts.bold)),
          if (pub.url.isNotEmpty)
            buildLink(
              text: pub.url,
              url: pub.url,
              style: pw.TextStyle(fontSize: 8, color: primaryColor),
            ),
        ],
      ),
    );
  }

  pw.Widget _buildAwardItem(Award award) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Expanded(
                child: pw.Text(
                  award.title,
                  style: pw.TextStyle(fontSize: 9.5, fontWeight: pw.FontWeight.bold, color: textPrimaryColor),
                ),
              ),
              if (award.date.isNotEmpty)
                pw.Text(award.date, style: pw.TextStyle(fontSize: 8.5, color: textSecondaryColor)),
            ],
          ),
          if (award.issuer.isNotEmpty)
            pw.Text(award.issuer, style: pw.TextStyle(fontSize: 8.5, color: primaryColor)),
          if (award.description.isNotEmpty)
            pw.Text(award.description, style: pw.TextStyle(fontSize: 8.5, color: textPrimaryColor)),
        ],
      ),
    );
  }

  pw.Widget _buildVolunteeringItem(Volunteering vol) {
    final dateEnd = vol.isCurrent ? tr('present') : vol.endDate;
    final dateRange = vol.startDate.isNotEmpty ? '${vol.startDate}${dateEnd.isNotEmpty ? ' - $dateEnd' : ''}' : dateEnd;
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 7),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Expanded(
                child: pw.Text(
                  vol.role,
                  style: pw.TextStyle(fontSize: 9.5, fontWeight: pw.FontWeight.bold, color: textPrimaryColor),
                ),
              ),
              if (dateRange.isNotEmpty)
                pw.Text(dateRange, style: pw.TextStyle(fontSize: 8.5, color: textSecondaryColor)),
            ],
          ),
          if (vol.organization.isNotEmpty)
            pw.Text(vol.organization, style: pw.TextStyle(fontSize: 8.5, color: primaryColor)),
          if (vol.description.isNotEmpty)
            pw.Text(vol.description, style: pw.TextStyle(fontSize: 8.5, color: textPrimaryColor)),
        ],
      ),
    );
  }

  pw.Widget _buildReferenceItem(Reference ref) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            ref.name,
            style: pw.TextStyle(fontSize: 9.5, fontWeight: pw.FontWeight.bold, color: textPrimaryColor),
          ),
          if (ref.position.isNotEmpty || ref.organization.isNotEmpty)
            pw.Text(
              '${ref.position}${ref.position.isNotEmpty && ref.organization.isNotEmpty ? ' • ' : ''}${ref.organization}',
              style: pw.TextStyle(fontSize: 8.5, color: primaryColor),
            ),
          if (ref.email.isNotEmpty || ref.phone.isNotEmpty)
            pw.Text(
              '${ref.email}${ref.email.isNotEmpty && ref.phone.isNotEmpty ? ' | ' : ''}${ref.phone}',
              style: pw.TextStyle(fontSize: 8, color: textSecondaryColor),
            ),
        ],
      ),
    );
  }

  pw.Widget _buildCustomItem(CustomSectionItem item) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(item.title, style: pw.TextStyle(fontSize: 9.5, font: fonts.bold, color: textPrimaryColor)),
              if (item.date.isNotEmpty)
                pw.Text(item.date, style: pw.TextStyle(fontSize: 8.5, color: textSecondaryColor)),
            ],
          ),
          if (item.subtitle.isNotEmpty)
            pw.Text(item.subtitle, style: pw.TextStyle(fontSize: 8.5, color: primaryColor)),
          if (item.description.isNotEmpty)
            pw.Text(item.description, style: pw.TextStyle(fontSize: 8.5, color: textPrimaryColor)),
        ],
      ),
    );
  }
}
