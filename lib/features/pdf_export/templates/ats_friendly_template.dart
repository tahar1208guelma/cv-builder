import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../cv/domain/models/award.dart';
import '../../cv/domain/models/certification.dart';
import '../../cv/domain/models/custom_section.dart';
import '../../cv/domain/models/education.dart';
import '../../cv/domain/models/experience.dart';
import '../../cv/domain/models/project.dart';
import '../../cv/domain/models/publication.dart';
import '../../cv/domain/models/reference.dart';
import '../../cv/domain/models/volunteering.dart';
import 'base_pdf_template.dart';

class AtsFriendlyTemplate extends BasePdfTemplate {
  AtsFriendlyTemplate({required super.cv, required super.fonts});

  // ATS-friendly palette: high-contrast monochrome with subtle dark neutral text
  static const PdfColor atsBlack = PdfColor(0.05, 0.05, 0.05);
  static const PdfColor atsGray = PdfColor(0.25, 0.25, 0.25);
  static const PdfColor atsRule = PdfColor(0.3, 0.3, 0.3);

  @override
  Future<pw.Document> generate() async {
    final doc = createDocument();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 36, vertical: 36),
        footer: buildFooter,
        build: (context) {
          final items = <pw.Widget>[];

          items.add(wrapDirection(_buildAtsHeader()));
          items.add(pw.SizedBox(height: 12));

          // 1. Summary
          if (cv.personalInfo.summary.isNotEmpty) {
            items.addAll(
              buildIntelligentSection(
                header: _buildAtsSectionTitle(tr('summary')),
                items: [
                  pw.Text(
                    cv.personalInfo.summary,
                    style: const pw.TextStyle(fontSize: 9.5, height: 1.45, color: atsBlack),
                  ),
                ],
              ),
            );
          }

          // 2. Experience
          if (cv.experiences.isNotEmpty) {
            items.addAll(
              buildIntelligentSection(
                header: _buildAtsSectionTitle(tr('experience')),
                items: cv.experiences.map(_buildAtsExperience).toList(),
              ),
            );
          }

          // 3. Education
          if (cv.educations.isNotEmpty) {
            items.addAll(
              buildIntelligentSection(
                header: _buildAtsSectionTitle(tr('education')),
                items: cv.educations.map(_buildAtsEducation).toList(),
              ),
            );
          }

          // 4. Skills
          if (cv.skills.isNotEmpty) {
            items.addAll(
              buildIntelligentSection(
                header: _buildAtsSectionTitle(tr('skills')),
                items: [_buildAtsSkills()],
              ),
            );
          }

          // 5. Certifications
          if (cv.certifications.isNotEmpty) {
            items.addAll(
              buildIntelligentSection(
                header: _buildAtsSectionTitle(tr('certifications')),
                items: cv.certifications.map(_buildAtsCertification).toList(),
              ),
            );
          }

          // 6. Projects
          if (cv.projects.isNotEmpty) {
            items.addAll(
              buildIntelligentSection(
                header: _buildAtsSectionTitle(tr('projects')),
                items: cv.projects.map(_buildAtsProject).toList(),
              ),
            );
          }

          // 7. Publications
          if (cv.publications.isNotEmpty) {
            items.addAll(
              buildIntelligentSection(
                header: _buildAtsSectionTitle(tr('publications')),
                items: cv.publications.map(_buildAtsPublication).toList(),
              ),
            );
          }

          // 8. Awards
          if (cv.awards.isNotEmpty) {
            items.addAll(
              buildIntelligentSection(
                header: _buildAtsSectionTitle(tr('awards')),
                items: cv.awards.map(_buildAtsAward).toList(),
              ),
            );
          }

          // 9. Volunteering
          if (cv.volunteering.isNotEmpty) {
            items.addAll(
              buildIntelligentSection(
                header: _buildAtsSectionTitle(tr('volunteering')),
                items: cv.volunteering.map(_buildAtsVolunteering).toList(),
              ),
            );
          }

          // 10. Languages
          if (cv.languages.isNotEmpty) {
            items.addAll(
              buildIntelligentSection(
                header: _buildAtsSectionTitle(tr('languages')),
                items: [_buildAtsLanguages()],
              ),
            );
          }

          // 11. References
          if (cv.references.isNotEmpty) {
            items.addAll(
              buildIntelligentSection(
                header: _buildAtsSectionTitle(tr('references')),
                items: cv.references.map(_buildAtsReference).toList(),
              ),
            );
          }

          // 12. Custom Sections
          if (cv.customSections.isNotEmpty) {
            for (final custom in cv.customSections) {
              if (custom.items.isNotEmpty) {
                items.addAll(
                  buildIntelligentSection(
                    header: _buildAtsSectionTitle(custom.title),
                    items: custom.items.map(_buildAtsCustomItem).toList(),
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

  pw.Widget _buildAtsHeader() {
    final info = cv.personalInfo;
    final contactWidgets = <pw.Widget>[];

    const linkStyle = pw.TextStyle(fontSize: 8.5, color: atsBlack);
    const textStyle = pw.TextStyle(fontSize: 8.5, color: atsGray);

    if (info.email.isNotEmpty) {
      contactWidgets.add(buildLink(text: info.email, url: 'mailto:${info.email}', style: linkStyle));
    }
    if (info.phone.isNotEmpty) {
      contactWidgets.add(buildLtrText(info.phone, style: textStyle));
    }
    if (info.address.isNotEmpty) {
      contactWidgets.add(pw.Text(info.address, style: textStyle));
    }
    if (info.dateOfBirth.isNotEmpty) {
      contactWidgets.add(pw.Text('${tr('dob')}: ${info.dateOfBirth}', style: textStyle));
    }
    if (info.nationality.isNotEmpty) {
      contactWidgets.add(pw.Text('${tr('nationality')}: ${info.nationality}', style: textStyle));
    }
    if (info.linkedin.isNotEmpty) {
      contactWidgets.add(buildLink(
        text: 'LinkedIn',
        url: info.linkedin.startsWith('http') ? info.linkedin : 'https://linkedin.com/in/${info.linkedin}',
        style: linkStyle,
      ));
    }
    if (info.github.isNotEmpty) {
      contactWidgets.add(buildLink(
        text: 'GitHub',
        url: info.github.startsWith('http') ? info.github : 'https://github.com/${info.github}',
        style: linkStyle,
      ));
    }
    if (info.website.isNotEmpty) {
      contactWidgets.add(buildLink(text: info.website, url: info.website, style: linkStyle));
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Text(
          info.fullName.isNotEmpty ? info.fullName.toUpperCase() : cv.title.toUpperCase(),
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
            fontSize: 20,
            font: fonts.bold,
            letterSpacing: 1.2,
            color: atsBlack,
          ),
        ),
        if (info.jobTitle.isNotEmpty) ...[
          pw.SizedBox(height: 2),
          pw.Text(
            info.jobTitle,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              fontSize: 11.5,
              font: fonts.bold,
              color: atsGray,
            ),
          ),
        ],
        if (contactWidgets.isNotEmpty) ...[
          pw.SizedBox(height: 5),
          pw.Wrap(
            alignment: pw.WrapAlignment.center,
            spacing: 10,
            runSpacing: 3,
            children: contactWidgets,
          ),
        ],
      ],
    );
  }

  pw.Widget _buildAtsSectionTitle(String title) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 4, bottom: 6),
      padding: const pw.EdgeInsets.only(bottom: 2),
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: atsRule, width: 1.0)),
      ),
      child: pw.Text(
        title.toUpperCase(),
        style: pw.TextStyle(
          fontSize: 10.5,
          font: fonts.bold,
          letterSpacing: 1.2,
          color: atsBlack,
        ),
      ),
    );
  }

  pw.Widget _buildAtsExperience(Experience exp) {
    final dateRange = '${exp.startDate} - ${exp.isCurrent ? tr('present') : exp.endDate}';
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                exp.position,
                style: pw.TextStyle(fontSize: 10, font: fonts.bold, color: atsBlack),
              ),
              pw.Text(
                dateRange,
                style: pw.TextStyle(fontSize: 8.5, font: fonts.bold, color: atsGray),
              ),
            ],
          ),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                exp.company,
                style: pw.TextStyle(fontSize: 9, font: fonts.bold, color: atsGray),
              ),
              if (exp.location.isNotEmpty)
                pw.Text(
                  exp.location,
                  style: const pw.TextStyle(fontSize: 8.5, color: atsGray),
                ),
            ],
          ),
          if (exp.description.isNotEmpty) ...[
            pw.SizedBox(height: 2),
            pw.Text(
              exp.description,
              style: const pw.TextStyle(fontSize: 8.8, height: 1.35, color: atsBlack),
            ),
          ],
          if (exp.highlights.isNotEmpty) ...[
            pw.SizedBox(height: 2),
            ...exp.highlights.map((bullet) => pw.Padding(
                  padding: const pw.EdgeInsets.only(left: 6, right: 6, bottom: 2),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('• ', style: const pw.TextStyle(fontSize: 8.5, color: atsBlack)),
                      pw.Expanded(
                        child: pw.Text(
                          bullet,
                          style: const pw.TextStyle(fontSize: 8.5, height: 1.3, color: atsBlack),
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

  pw.Widget _buildAtsEducation(Education edu) {
    final dateEnd = edu.currentlyStudying ? tr('present') : edu.endDate;
    final dateRange = edu.startDate.isNotEmpty ? '${edu.startDate} - $dateEnd' : dateEnd;
    final degreeTitle = edu.fieldOfStudy.isNotEmpty
        ? (edu.degree.isNotEmpty ? '${edu.degree}, ${edu.fieldOfStudy}' : edu.fieldOfStudy)
        : edu.degree;
    final locationPart = edu.country.isNotEmpty
        ? (edu.institution.isNotEmpty ? '${edu.institution}, ${edu.country}' : edu.country)
        : edu.institution;

    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  degreeTitle,
                  style: pw.TextStyle(fontSize: 9.5, font: fonts.bold, color: atsBlack),
                ),
                pw.Text(
                  locationPart,
                  style: const pw.TextStyle(fontSize: 8.5, color: atsGray),
                ),
                if (edu.grade.isNotEmpty)
                  pw.Text(
                    edu.grade,
                    style: const pw.TextStyle(fontSize: 8.5, color: atsGray),
                  ),
                if (edu.description.isNotEmpty)
                  pw.Text(
                    edu.description,
                    style: const pw.TextStyle(fontSize: 8.5, color: atsBlack),
                  ),
              ],
            ),
          ),
          if (dateRange.isNotEmpty)
            pw.Text(
              dateRange,
              style: const pw.TextStyle(fontSize: 8.5, color: atsGray),
            ),
        ],
      ),
    );
  }

  pw.Widget _buildAtsSkills() {
    return pw.Text(
      cv.skills.map((s) => s.name).join('  •  '),
      style: const pw.TextStyle(fontSize: 9, height: 1.4, color: atsBlack),
    );
  }

  pw.Widget _buildAtsCertification(Certification cert) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            '${cert.name} - ${cert.issuer}',
            style: pw.TextStyle(fontSize: 8.8, font: fonts.bold, color: atsBlack),
          ),
          if (cert.issueDate.isNotEmpty)
            pw.Text(cert.issueDate, style: const pw.TextStyle(fontSize: 8.5, color: atsGray)),
        ],
      ),
    );
  }

  pw.Widget _buildAtsProject(Project proj) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 5),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(proj.title, style: pw.TextStyle(fontSize: 9.5, font: fonts.bold, color: atsBlack)),
              if (proj.date.isNotEmpty)
                pw.Text(proj.date, style: const pw.TextStyle(fontSize: 8.5, color: atsGray)),
            ],
          ),
          if (proj.role.isNotEmpty || proj.technologies.isNotEmpty)
            pw.Text(
              '${proj.role}${proj.role.isNotEmpty && proj.technologies.isNotEmpty ? ' | ' : ''}${proj.technologies}',
              style: pw.TextStyle(fontSize: 8.5, font: fonts.bold, color: atsGray),
            ),
          if (proj.description.isNotEmpty)
            pw.Text(proj.description, style: const pw.TextStyle(fontSize: 8.5, color: atsBlack)),
          if (proj.url.isNotEmpty)
            buildLink(
              text: proj.url,
              url: proj.url,
              style: const pw.TextStyle(fontSize: 8, color: atsGray),
            ),
        ],
      ),
    );
  }

  pw.Widget _buildAtsPublication(Publication pub) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 5),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Expanded(
                child: pw.Text(
                  pub.title,
                  style: pw.TextStyle(fontSize: 9, font: fonts.bold, color: atsBlack),
                ),
              ),
              if (pub.date.isNotEmpty)
                pw.Text(pub.date, style: const pw.TextStyle(fontSize: 8.5, color: atsGray)),
            ],
          ),
          if (pub.authors.isNotEmpty)
            pw.Text(pub.authors, style: const pw.TextStyle(fontSize: 8.5, color: atsGray)),
          if (pub.publisher.isNotEmpty)
            pw.Text(pub.publisher, style: pw.TextStyle(fontSize: 8.5, font: fonts.bold, color: atsBlack)),
          if (pub.url.isNotEmpty)
            buildLink(
              text: pub.url,
              url: pub.url,
              style: const pw.TextStyle(fontSize: 7.5, color: atsGray),
            ),
        ],
      ),
    );
  }

  pw.Widget _buildAtsAward(Award award) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Expanded(
            child: pw.Text(
              '${award.title}${award.issuer.isNotEmpty ? ' - ${award.issuer}' : ''}',
              style: pw.TextStyle(fontSize: 9, font: fonts.bold, color: atsBlack),
            ),
          ),
          if (award.date.isNotEmpty)
            pw.Text(award.date, style: const pw.TextStyle(fontSize: 8.5, color: atsGray)),
        ],
      ),
    );
  }

  pw.Widget _buildAtsVolunteering(Volunteering vol) {
    final dateEnd = vol.isCurrent ? tr('present') : vol.endDate;
    final dateRange = vol.startDate.isNotEmpty ? '${vol.startDate}${dateEnd.isNotEmpty ? ' - $dateEnd' : ''}' : dateEnd;
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 5),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            '${vol.role} - ${vol.organization}',
            style: pw.TextStyle(fontSize: 9, font: fonts.bold, color: atsBlack),
          ),
          if (dateRange.isNotEmpty)
            pw.Text(dateRange, style: const pw.TextStyle(fontSize: 8.5, color: atsGray)),
        ],
      ),
    );
  }

  pw.Widget _buildAtsLanguages() {
    return pw.Text(
      cv.languages.map((l) => '${l.name} (${tr(l.proficiency.name)})').join('  •  '),
      style: const pw.TextStyle(fontSize: 8.8, color: atsBlack),
    );
  }

  pw.Widget _buildAtsReference(Reference ref) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 5),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            '${ref.name}${ref.position.isNotEmpty ? ' (${ref.position})' : ''}',
            style: pw.TextStyle(fontSize: 8.8, font: fonts.bold, color: atsBlack),
          ),
          if (ref.email.isNotEmpty || ref.phone.isNotEmpty)
            pw.Row(
              children: [
                if (ref.email.isNotEmpty)
                  buildLink(
                    text: ref.email,
                    url: 'mailto:${ref.email}',
                    style: const pw.TextStyle(fontSize: 8, color: atsGray),
                  ),
                if (ref.email.isNotEmpty && ref.phone.isNotEmpty)
                  pw.Text(' | ', style: const pw.TextStyle(fontSize: 8, color: atsGray)),
                if (ref.phone.isNotEmpty)
                  buildLtrText(ref.phone, style: const pw.TextStyle(fontSize: 8, color: atsGray)),
              ],
            ),
        ],
      ),
    );
  }

  pw.Widget _buildAtsCustomItem(CustomSectionItem item) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(item.title, style: pw.TextStyle(fontSize: 9, font: fonts.bold, color: atsBlack)),
              if (item.date.isNotEmpty)
                pw.Text(item.date, style: const pw.TextStyle(fontSize: 8.5, color: atsGray)),
            ],
          ),
          if (item.subtitle.isNotEmpty)
            pw.Text(item.subtitle, style: const pw.TextStyle(fontSize: 8.5, color: atsGray)),
          if (item.description.isNotEmpty)
            pw.Text(item.description, style: const pw.TextStyle(fontSize: 8.5, color: atsBlack)),
        ],
      ),
    );
  }
}
