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

class AcademicTemplate extends BasePdfTemplate {
  AcademicTemplate({required super.cv, required super.fonts});

  @override
  Future<pw.Document> generate() async {
    final doc = createDocument();
    final photo = photoImage;

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 38, vertical: 34),
        header: _buildPageHeader,
        footer: buildFooter,
        build: (context) {
          final items = <pw.Widget>[];

          items.add(wrapDirection(_buildMainHeader(photo)));
          items.add(pw.SizedBox(height: 14));

          // 1. Research / Academic Summary
          if (cv.personalInfo.summary.isNotEmpty) {
            items.addAll(
              buildIntelligentSection(
                header: _buildAcademicSectionTitle(tr('summary')),
                items: [
                  pw.Text(
                    cv.personalInfo.summary,
                    style: pw.TextStyle(
                      fontSize: 9.5,
                      height: 1.5,
                      color: textPrimaryColor,
                    ),
                  ),
                ],
              ),
            );
          }

          // 2. Education (First priority in Academic CV)
          if (cv.educations.isNotEmpty) {
            items.addAll(
              buildIntelligentSection(
                header: _buildAcademicSectionTitle(tr('education')),
                items: cv.educations.map(_buildEducationItem).toList(),
              ),
            );
          }

          // 3. Publications & Papers (Second priority in Academic CV)
          if (cv.publications.isNotEmpty) {
            items.addAll(
              buildIntelligentSection(
                header: _buildAcademicSectionTitle(tr('publications')),
                items: cv.publications.asMap().entries.map((entry) => _buildAcademicPublication(entry.key + 1, entry.value)).toList(),
              ),
            );
          }

          // 4. Research & Academic Projects / Grants
          if (cv.projects.isNotEmpty) {
            items.addAll(
              buildIntelligentSection(
                header: _buildAcademicSectionTitle(tr('projects')),
                items: cv.projects.map(_buildAcademicProject).toList(),
              ),
            );
          }

          // 5. Academic & Research Experience
          if (cv.experiences.isNotEmpty) {
            items.addAll(
              buildIntelligentSection(
                header: _buildAcademicSectionTitle(tr('experience')),
                items: cv.experiences.map(_buildAcademicExperience).toList(),
              ),
            );
          }

          // 6. Honors, Grants & Awards
          if (cv.awards.isNotEmpty) {
            items.addAll(
              buildIntelligentSection(
                header: _buildAcademicSectionTitle(tr('awards')),
                items: cv.awards.map(_buildAcademicAward).toList(),
              ),
            );
          }

          // 7. Academic Service, Teaching & Volunteering
          if (cv.volunteering.isNotEmpty) {
            items.addAll(
              buildIntelligentSection(
                header: _buildAcademicSectionTitle(tr('volunteering')),
                items: cv.volunteering.map(_buildAcademicService).toList(),
              ),
            );
          }

          // 8. Certifications & Credentials
          if (cv.certifications.isNotEmpty) {
            items.addAll(
              buildIntelligentSection(
                header: _buildAcademicSectionTitle(tr('certifications')),
                items: cv.certifications.map(_buildAcademicCert).toList(),
              ),
            );
          }

          // 9. Technical & Research Methodologies (Skills)
          if (cv.skills.isNotEmpty) {
            items.addAll(
              buildIntelligentSection(
                header: _buildAcademicSectionTitle(tr('skills')),
                items: [_buildAcademicSkills()],
              ),
            );
          }

          // 10. Languages
          if (cv.languages.isNotEmpty) {
            items.addAll(
              buildIntelligentSection(
                header: _buildAcademicSectionTitle(tr('languages')),
                items: [_buildAcademicLanguages()],
              ),
            );
          }

          // 11. Custom Academic Sections (e.g. Teaching, Grants, Memberships)
          if (cv.customSections.isNotEmpty) {
            for (final sec in cv.customSections) {
              if (sec.items.isNotEmpty) {
                items.addAll(
                  buildIntelligentSection(
                    header: _buildAcademicSectionTitle(sec.title),
                    items: sec.items.map(_buildAcademicCustomItem).toList(),
                  ),
                );
              }
            }
          }

          // 12. Academic & Professional References
          if (cv.references.isNotEmpty) {
            items.addAll(
              buildIntelligentSection(
                header: _buildAcademicSectionTitle(tr('references')),
                items: cv.references.map(_buildAcademicReference).toList(),
              ),
            );
          }

          return items;
        },
      ),
    );

    return doc;
  }

  pw.Widget _buildPageHeader(pw.Context context) {
    if (context.pageNumber == 1) return pw.SizedBox();

    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 14),
      padding: const pw.EdgeInsets.only(bottom: 4),
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: PdfColor(0.85, 0.88, 0.92), width: 0.8)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            '${tr('curriculum_vitae')} — ${cv.personalInfo.fullName.isNotEmpty ? cv.personalInfo.fullName : cv.title}',
            style: pw.TextStyle(
              fontSize: 8.5,
              font: fonts.italic ?? fonts.regular,
              color: textSecondaryColor,
            ),
          ),
          pw.Text(
            '${tr('page')} ${context.pageNumber} ${tr('of')} ${context.pagesCount}',
            style: pw.TextStyle(fontSize: 8.5, color: textSecondaryColor),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildMainHeader(pw.ImageProvider? photo) {
    final info = cv.personalInfo;

    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 12),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColor(0.2, 0.25, 0.3), width: 1.4),
        ),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          if (photo != null) ...[
            pw.Container(
              width: 68,
              height: 68,
              decoration: pw.BoxDecoration(
                shape: pw.BoxShape.rectangle,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                border: pw.Border.all(color: const PdfColor(0.4, 0.45, 0.5), width: 1),
                image: pw.DecorationImage(image: photo, fit: pw.BoxFit.cover),
              ),
            ),
            pw.SizedBox(width: 18),
          ],
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  info.fullName.isNotEmpty ? info.fullName.toUpperCase() : cv.title.toUpperCase(),
                  textAlign: pw.TextAlign.center,
                  // ignore: prefer_const_constructors
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                    letterSpacing: 1.5,
                    color: const PdfColor(0.1, 0.15, 0.25),
                  ),
                ),
                if (info.jobTitle.isNotEmpty) ...[
                  pw.SizedBox(height: 3),
                  pw.Text(
                    info.jobTitle,
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      fontSize: 11.5,
                      font: fonts.bold,
                      color: primaryColor,
                    ),
                  ),
                ],
                pw.SizedBox(height: 6),
                _buildAcademicContactRow(info),
              ],
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildAcademicContactRow(PersonalInfo info) {
    final contactStyle = pw.TextStyle(fontSize: 8.5, color: textSecondaryColor);
    final linkStyle = pw.TextStyle(fontSize: 8.5, color: primaryColor);

    final list = <pw.Widget>[];
    if (info.email.isNotEmpty) {
      list.add(buildLink(text: info.email, url: 'mailto:${info.email}', style: linkStyle));
    }
    if (info.phone.isNotEmpty) {
      list.add(buildLtrText(info.phone, style: contactStyle));
    }
    if (info.address.isNotEmpty) list.add(pw.Text(info.address, style: contactStyle));
    if (info.website.isNotEmpty) {
      list.add(buildLink(text: info.website, url: info.website, style: linkStyle));
    }
    if (info.linkedin.isNotEmpty) {
      list.add(buildLink(
        text: 'LinkedIn',
        url: info.linkedin.startsWith('http') ? info.linkedin : 'https://linkedin.com/in/${info.linkedin}',
        style: linkStyle,
      ));
    }
    if (info.github.isNotEmpty) {
      list.add(buildLink(
        text: 'GitHub',
        url: info.github.startsWith('http') ? info.github : 'https://github.com/${info.github}',
        style: linkStyle,
      ));
    }
    if (info.dateOfBirth.isNotEmpty) list.add(pw.Text('${tr('dob')}: ${info.dateOfBirth}', style: contactStyle));
    if (info.nationality.isNotEmpty) list.add(pw.Text('${tr('nationality')}: ${info.nationality}', style: contactStyle));

    return pw.Wrap(
      alignment: pw.WrapAlignment.center,
      spacing: 12,
      runSpacing: 3,
      children: list,
    );
  }

  pw.Widget _buildAcademicSectionTitle(String title) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 4, bottom: 6),
      padding: const pw.EdgeInsets.only(bottom: 2),
      decoration: pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: primaryColor, width: 1.0),
        ),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            title.toUpperCase(),
            style: pw.TextStyle(
              fontSize: 10.5,
              fontWeight: pw.FontWeight.bold,
              letterSpacing: 1.0,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildEducationItem(Education edu) {
    final dateEnd = edu.currentlyStudying ? tr('present') : edu.endDate;
    final dateRange = edu.startDate.isNotEmpty ? '${edu.startDate} – $dateEnd' : dateEnd;
    final degreeTitle = edu.fieldOfStudy.isNotEmpty
        ? (edu.degree.isNotEmpty ? '${edu.degree}, ${edu.fieldOfStudy}' : edu.fieldOfStudy)
        : edu.degree;
    final locationPart = edu.country.isNotEmpty
        ? (edu.institution.isNotEmpty ? '${edu.institution}, ${edu.country}' : edu.country)
        : edu.institution;

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
                  degreeTitle,
                  style: pw.TextStyle(fontSize: 9.8, fontWeight: pw.FontWeight.bold, color: textPrimaryColor),
                ),
              ),
              if (dateRange.isNotEmpty)
                pw.Text(
                  dateRange,
                  style: pw.TextStyle(fontSize: 8.5, color: textSecondaryColor, font: fonts.bold),
                ),
            ],
          ),
          pw.Text(
            locationPart,
            style: pw.TextStyle(fontSize: 8.8, font: fonts.italic ?? fonts.regular, color: primaryColor),
          ),
          if (edu.grade.isNotEmpty)
            pw.Text(
              edu.grade,
              style: pw.TextStyle(fontSize: 8.5, color: textSecondaryColor),
            ),
          if (edu.description.isNotEmpty)
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 2),
              child: pw.Text(
                edu.description,
                style: pw.TextStyle(fontSize: 8.5, height: 1.35, color: textPrimaryColor),
              ),
            ),
        ],
      ),
    );
  }

  pw.Widget _buildAcademicPublication(int index, Publication pub) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: 20,
            child: pw.Text(
              '[$index]',
              style: pw.TextStyle(fontSize: 8.5, font: fonts.bold, color: primaryColor),
            ),
          ),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.RichText(
                  text: pw.TextSpan(
                    children: [
                      if (pub.authors.isNotEmpty)
                        pw.TextSpan(
                          text: '${pub.authors}. ',
                          style: pw.TextStyle(fontSize: 8.8, font: fonts.bold, color: textPrimaryColor),
                        ),
                      pw.TextSpan(
                        text: '"${pub.title}"',
                        style: pw.TextStyle(fontSize: 8.8, color: textPrimaryColor),
                      ),
                      if (pub.publisher.isNotEmpty)
                        pw.TextSpan(
                          text: ', ${pub.publisher}',
                          style: pw.TextStyle(fontSize: 8.8, font: fonts.italic ?? fonts.regular, color: primaryColor),
                        ),
                      if (pub.date.isNotEmpty)
                        pw.TextSpan(
                          text: ' (${pub.date}).',
                          style: pw.TextStyle(fontSize: 8.8, color: textSecondaryColor),
                        ),
                    ],
                  ),
                ),
                if (pub.url.isNotEmpty)
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(top: 1),
                    child: buildLink(
                      text: pub.url,
                      url: pub.url,
                      style: pw.TextStyle(fontSize: 7.8, color: primaryColor),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildAcademicProject(Project proj) {
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
              style: pw.TextStyle(fontSize: 8.5, color: primaryColor, font: fonts.italic ?? fonts.regular),
            ),
          if (proj.description.isNotEmpty)
            pw.Text(
              proj.description,
              style: pw.TextStyle(fontSize: 8.5, height: 1.35, color: textPrimaryColor),
            ),
          if (proj.url.isNotEmpty)
            buildLink(
              text: proj.url,
              url: proj.url,
              style: pw.TextStyle(fontSize: 7.8, color: primaryColor),
            ),
        ],
      ),
    );
  }

  pw.Widget _buildAcademicExperience(Experience exp) {
    final dateRange = '${exp.startDate} – ${exp.isCurrent ? tr('present') : exp.endDate}';
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
                style: pw.TextStyle(fontSize: 9.8, fontWeight: pw.FontWeight.bold, color: textPrimaryColor),
              ),
              pw.Text(
                dateRange,
                style: pw.TextStyle(fontSize: 8.5, color: textSecondaryColor, font: fonts.bold),
              ),
            ],
          ),
          pw.Text(
            '${exp.company}${exp.location.isNotEmpty ? ' • ${exp.location}' : ''}',
            style: pw.TextStyle(fontSize: 8.8, font: fonts.italic ?? fonts.regular, color: primaryColor),
          ),
          if (exp.description.isNotEmpty) ...[
            pw.SizedBox(height: 2),
            pw.Text(
              exp.description,
              style: pw.TextStyle(fontSize: 8.8, height: 1.35, color: textPrimaryColor),
            ),
          ],
          if (exp.highlights.isNotEmpty) ...[
            pw.SizedBox(height: 2),
            ...exp.highlights.map((bullet) => pw.Padding(
                  padding: const pw.EdgeInsets.only(left: 8, right: 8, bottom: 2),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('– ', style: pw.TextStyle(fontSize: 8.5, color: primaryColor)),
                      pw.Expanded(
                        child: pw.Text(
                          bullet,
                          style: pw.TextStyle(fontSize: 8.5, height: 1.3, color: textPrimaryColor),
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

  pw.Widget _buildAcademicAward(Award award) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 5),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  award.title,
                  style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: textPrimaryColor),
                ),
                if (award.issuer.isNotEmpty)
                  pw.Text(award.issuer, style: pw.TextStyle(fontSize: 8.5, color: primaryColor)),
                if (award.description.isNotEmpty)
                  pw.Text(award.description, style: pw.TextStyle(fontSize: 8.5, color: textPrimaryColor)),
              ],
            ),
          ),
          if (award.date.isNotEmpty)
            pw.Text(award.date, style: pw.TextStyle(fontSize: 8.5, color: textSecondaryColor)),
        ],
      ),
    );
  }

  pw.Widget _buildAcademicService(Volunteering vol) {
    final dateEnd = vol.isCurrent ? tr('present') : vol.endDate;
    final dateRange = vol.startDate.isNotEmpty ? '${vol.startDate}${dateEnd.isNotEmpty ? ' – $dateEnd' : ''}' : dateEnd;
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  '${vol.role} – ${vol.organization}',
                  style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: textPrimaryColor),
                ),
                if (vol.description.isNotEmpty)
                  pw.Text(vol.description, style: pw.TextStyle(fontSize: 8.5, color: textPrimaryColor)),
              ],
            ),
          ),
          if (dateRange.isNotEmpty)
            pw.Text(dateRange, style: pw.TextStyle(fontSize: 8.5, color: textSecondaryColor)),
        ],
      ),
    );
  }

  pw.Widget _buildAcademicCert(Certification cert) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 5),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                '${cert.name} – ${cert.issuer}',
                style: pw.TextStyle(fontSize: 8.8, font: fonts.bold, color: textPrimaryColor),
              ),
              if (cert.description.isNotEmpty)
                pw.Text(cert.description, style: pw.TextStyle(fontSize: 8, color: textPrimaryColor)),
              if (cert.url.isNotEmpty)
                buildLink(
                  text: cert.url,
                  url: cert.url,
                  style: pw.TextStyle(fontSize: 7.5, color: primaryColor),
                ),
            ],
          ),
          if (cert.issueDate.isNotEmpty)
            pw.Text(cert.issueDate, style: pw.TextStyle(fontSize: 8.5, color: textSecondaryColor)),
        ],
      ),
    );
  }

  pw.Widget _buildAcademicSkills() {
    return pw.Wrap(
      spacing: 14,
      runSpacing: 4,
      children: cv.skills.map((skill) {
        return pw.Text(
          '• ${skill.name}',
          style: pw.TextStyle(fontSize: 8.8, color: textPrimaryColor),
        );
      }).toList(),
    );
  }

  pw.Widget _buildAcademicLanguages() {
    return pw.Wrap(
      spacing: 16,
      runSpacing: 4,
      children: cv.languages.map((lang) {
        return pw.Text(
          '${lang.name} (${tr(lang.proficiency.name)})',
          style: pw.TextStyle(fontSize: 8.8, color: textPrimaryColor),
        );
      }).toList(),
    );
  }

  pw.Widget _buildAcademicReference(Reference ref) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(ref.name, style: pw.TextStyle(fontSize: 9.2, font: fonts.bold, color: textPrimaryColor)),
          if (ref.position.isNotEmpty || ref.organization.isNotEmpty)
            pw.Text(
              '${ref.position}${ref.position.isNotEmpty && ref.organization.isNotEmpty ? ', ' : ''}${ref.organization}',
              style: pw.TextStyle(fontSize: 8.5, color: primaryColor),
            ),
          if (ref.email.isNotEmpty || ref.phone.isNotEmpty)
            pw.Row(
              children: [
                if (ref.email.isNotEmpty)
                  buildLink(
                    text: ref.email,
                    url: 'mailto:${ref.email}',
                    style: pw.TextStyle(fontSize: 8, color: primaryColor),
                  ),
                if (ref.email.isNotEmpty && ref.phone.isNotEmpty)
                  pw.Text(' • ', style: pw.TextStyle(fontSize: 8, color: textSecondaryColor)),
                if (ref.phone.isNotEmpty)
                  buildLtrText(ref.phone, style: pw.TextStyle(fontSize: 8, color: textSecondaryColor)),
              ],
            ),
        ],
      ),
    );
  }

  pw.Widget _buildAcademicCustomItem(CustomSectionItem item) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(item.title, style: pw.TextStyle(fontSize: 9, font: fonts.bold, color: textPrimaryColor)),
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
