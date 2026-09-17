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

class ClassicTemplate extends BasePdfTemplate {
  ClassicTemplate({required super.cv, required super.fonts});

  @override
  Future<pw.Document> generate() async {
    final doc = pw.Document(theme: themeData);
    final photo = photoImage;

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 36, vertical: 32),
        footer: buildFooter,
        build: (context) {
          return [
            wrapDirection(
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(photo),
                  pw.SizedBox(height: 14),
                  if (cv.personalInfo.summary.isNotEmpty) ...[
                    _buildSectionTitle(tr('summary')),
                    pw.Text(
                      cv.personalInfo.summary,
                      style: pw.TextStyle(fontSize: 9.5, height: 1.4, color: textPrimaryColor),
                    ),
                    pw.SizedBox(height: 12),
                  ],
                  if (cv.experiences.isNotEmpty) ...[
                    _buildSectionTitle(tr('experience')),
                    ...cv.experiences.map(_buildExperience),
                    pw.SizedBox(height: 12),
                  ],
                  if (cv.educations.isNotEmpty) ...[
                    _buildSectionTitle(tr('education')),
                    ...cv.educations.map(_buildEducation),
                    pw.SizedBox(height: 12),
                  ],
                  if (cv.skills.isNotEmpty) ...[
                    _buildSectionTitle(tr('skills')),
                    _buildSkillsGrid(),
                    pw.SizedBox(height: 12),
                  ],
                  if (cv.languages.isNotEmpty) ...[
                    _buildSectionTitle(tr('languages')),
                    _buildLanguagesRow(),
                    pw.SizedBox(height: 12),
                  ],
                  if (cv.projects.isNotEmpty) ...[
                    _buildSectionTitle(tr('projects')),
                    ...cv.projects.map(_buildProject),
                    pw.SizedBox(height: 12),
                  ],
                  if (cv.certifications.isNotEmpty) ...[
                    _buildSectionTitle(tr('certifications')),
                    ...cv.certifications.map(_buildCertification),
                    pw.SizedBox(height: 12),
                  ],
                  if (cv.publications.isNotEmpty) ...[
                    _buildSectionTitle(tr('publications')),
                    ...cv.publications.map(_buildPublication),
                    pw.SizedBox(height: 12),
                  ],
                  if (cv.awards.isNotEmpty) ...[
                    _buildSectionTitle(tr('awards')),
                    ...cv.awards.map(_buildAward),
                    pw.SizedBox(height: 12),
                  ],
                  if (cv.volunteering.isNotEmpty) ...[
                    _buildSectionTitle(tr('volunteering')),
                    ...cv.volunteering.map(_buildVolunteering),
                    pw.SizedBox(height: 12),
                  ],
                  if (cv.references.isNotEmpty) ...[
                    _buildSectionTitle(tr('references')),
                    ...cv.references.map(_buildReference),
                    pw.SizedBox(height: 12),
                  ],
                  if (cv.customSections.isNotEmpty) ...[
                    ...cv.customSections.map(_buildCustomSection),
                  ],
                ],
              ),
            ),
          ];
        },
      ),
    );

    return doc;
  }

  pw.Widget _buildHeader(pw.ImageProvider? photo) {
    final info = cv.personalInfo;

    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 12),
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: PdfColor(0.2, 0.2, 0.2), width: 1.2)),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          if (photo != null) ...[
            pw.Container(
              width: 65,
              height: 65,
              decoration: pw.BoxDecoration(
                shape: pw.BoxShape.rectangle,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
                border: pw.Border.all(color: primaryColor, width: 1.5),
                image: pw.DecorationImage(image: photo, fit: pw.BoxFit.cover),
              ),
            ),
            pw.SizedBox(width: 16),
          ],
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: isRtl ? pw.CrossAxisAlignment.end : pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  info.fullName.isNotEmpty ? info.fullName.toUpperCase() : cv.title.toUpperCase(),
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                    letterSpacing: 1.2,
                    color: primaryColor,
                  ),
                ),
                if (info.jobTitle.isNotEmpty) ...[
                  pw.SizedBox(height: 3),
                  pw.Text(
                    info.jobTitle,
                    style: pw.TextStyle(fontSize: 12, font: fonts.bold, color: textPrimaryColor),
                  ),
                ],
                pw.SizedBox(height: 6),
                _buildContactRow(info),
              ],
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildContactRow(PersonalInfo info) {
    final list = <String>[];
    if (info.email.isNotEmpty) list.add(info.email);
    if (info.phone.isNotEmpty) list.add(info.phone);
    if (info.address.isNotEmpty) list.add(info.address);
    if (info.dateOfBirth.isNotEmpty) list.add(info.dateOfBirth);
    if (info.nationality.isNotEmpty) list.add(info.nationality);
    if (info.website.isNotEmpty) list.add(info.website);
    if (info.linkedin.isNotEmpty) list.add(info.linkedin);

    return pw.Wrap(
      spacing: 10,
      runSpacing: 3,
      children: list
          .map((item) => pw.Text(
                item,
                style: pw.TextStyle(fontSize: 8.5, color: textSecondaryColor),
              ))
          .toList(),
    );
  }

  pw.Widget _buildSectionTitle(String title) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 6),
      padding: const pw.EdgeInsets.only(bottom: 2),
      decoration: pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: primaryColor, width: 1.0)),
      ),
      child: pw.Text(
        title.toUpperCase(),
        style: pw.TextStyle(
          fontSize: 11,
          fontWeight: pw.FontWeight.bold,
          letterSpacing: 0.8,
          color: primaryColor,
        ),
      ),
    );
  }

  pw.Widget _buildExperience(Experience exp) {
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
                style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: textPrimaryColor),
              ),
              pw.Text(
                dateRange,
                style: pw.TextStyle(fontSize: 8.5, font: fonts.bold, color: textSecondaryColor),
              ),
            ],
          ),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                exp.company,
                style: pw.TextStyle(fontSize: 9, font: fonts.italic ?? fonts.regular, color: primaryColor),
              ),
              if (exp.location.isNotEmpty)
                pw.Text(
                  exp.location,
                  style: pw.TextStyle(fontSize: 8.5, color: textSecondaryColor),
                ),
            ],
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
                  padding: const pw.EdgeInsets.only(left: 6, right: 6, bottom: 2),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('• ', style: pw.TextStyle(fontSize: 8.5, color: textPrimaryColor)),
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

  pw.Widget _buildEducation(Education edu) {
    final dateEnd = edu.currentlyStudying ? tr('present') : edu.endDate;
    final dateRange = edu.startDate.isNotEmpty ? '${edu.startDate} – $dateEnd' : dateEnd;
    final degreeTitle = edu.fieldOfStudy.isNotEmpty
        ? (edu.degree.isNotEmpty ? '${edu.degree} – ${edu.fieldOfStudy}' : edu.fieldOfStudy)
        : edu.degree;
    final locationPart = edu.country.isNotEmpty
        ? (edu.location.isNotEmpty ? '${edu.location}, ${edu.country}' : edu.country)
        : edu.location;
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
                  style: pw.TextStyle(fontSize: 9.5, fontWeight: pw.FontWeight.bold, color: textPrimaryColor),
                ),
                pw.Text(
                  '${edu.institution}${locationPart.isNotEmpty ? ', $locationPart' : ''}',
                  style: pw.TextStyle(fontSize: 8.5, color: textSecondaryColor),
                ),
                if (edu.grade.isNotEmpty)
                  pw.Text(
                    edu.grade,
                    style: pw.TextStyle(fontSize: 8.5, color: primaryColor),
                  ),
                if (edu.description.isNotEmpty)
                  pw.Text(
                    edu.description,
                    style: pw.TextStyle(fontSize: 8, color: textPrimaryColor),
                  ),
              ],
            ),
          ),
          if (dateRange.isNotEmpty)
            pw.Text(
              dateRange,
              style: pw.TextStyle(fontSize: 8.5, color: textSecondaryColor),
            ),
        ],
      ),
    );
  }

  pw.Widget _buildSkillsGrid() {
    return pw.Wrap(
      spacing: 8,
      runSpacing: 4,
      children: cv.skills.map((skill) {
        return pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: pw.BoxDecoration(
            color: const PdfColor(0.95, 0.96, 0.98),
            border: pw.Border.all(color: const PdfColor(0.85, 0.88, 0.92)),
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(3)),
          ),
          child: pw.Text(
            skill.name,
            style: pw.TextStyle(fontSize: 8.5, color: textPrimaryColor),
          ),
        );
      }).toList(),
    );
  }

  pw.Widget _buildLanguagesRow() {
    return pw.Wrap(
      spacing: 12,
      runSpacing: 4,
      children: cv.languages.map((lang) {
        return pw.Text(
          '${lang.name} (${tr(lang.proficiency.name)})',
          style: pw.TextStyle(fontSize: 8.5, color: textPrimaryColor),
        );
      }).toList(),
    );
  }

  pw.Widget _buildProject(Project proj) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                proj.title,
                style: pw.TextStyle(fontSize: 9.5, fontWeight: pw.FontWeight.bold, color: textPrimaryColor),
              ),
              if (proj.date.isNotEmpty)
                pw.Text(proj.date, style: pw.TextStyle(fontSize: 8.5, color: textSecondaryColor)),
            ],
          ),
          if (proj.role.isNotEmpty || proj.technologies.isNotEmpty)
            pw.Text(
              '${proj.role}${proj.role.isNotEmpty && proj.technologies.isNotEmpty ? ' | ' : ''}${proj.technologies}',
              style: pw.TextStyle(fontSize: 8, font: fonts.bold, color: primaryColor),
            ),
          if (proj.description.isNotEmpty)
            pw.Text(
              proj.description,
              style: pw.TextStyle(fontSize: 8.5, color: textPrimaryColor),
            ),
          if (proj.url.isNotEmpty)
            pw.Text(
              proj.url,
              style: pw.TextStyle(fontSize: 7.5, color: primaryColor),
            ),
        ],
      ),
    );
  }

  pw.Widget _buildCertification(Certification cert) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 5),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                '${cert.name} – ${cert.issuer}',
                style: pw.TextStyle(fontSize: 8.5, color: textPrimaryColor, font: fonts.bold),
              ),
              if (cert.issueDate.isNotEmpty)
                pw.Text(
                  cert.issueDate,
                  style: pw.TextStyle(fontSize: 8.5, color: textSecondaryColor),
                ),
            ],
          ),
          if (cert.description.isNotEmpty)
            pw.Text(cert.description, style: pw.TextStyle(fontSize: 8, color: textPrimaryColor)),
          if (cert.url.isNotEmpty)
            pw.Text(cert.url, style: pw.TextStyle(fontSize: 7.5, color: primaryColor)),
        ],
      ),
    );
  }

  pw.Widget _buildPublication(Publication pub) {
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
                  style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: textPrimaryColor),
                ),
              ),
              if (pub.date.isNotEmpty)
                pw.Text(pub.date, style: pw.TextStyle(fontSize: 8.5, color: textSecondaryColor)),
            ],
          ),
          if (pub.authors.isNotEmpty)
            pw.Text(pub.authors, style: pw.TextStyle(fontSize: 8, color: textSecondaryColor)),
          if (pub.publisher.isNotEmpty)
            pw.Text(pub.publisher, style: pw.TextStyle(fontSize: 8, color: primaryColor, font: fonts.bold)),
          if (pub.url.isNotEmpty)
            pw.Text(pub.url, style: pw.TextStyle(fontSize: 7.5, color: primaryColor)),
        ],
      ),
    );
  }

  pw.Widget _buildAward(Award award) {
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
                  award.title,
                  style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: textPrimaryColor),
                ),
              ),
              if (award.date.isNotEmpty)
                pw.Text(award.date, style: pw.TextStyle(fontSize: 8.5, color: textSecondaryColor)),
            ],
          ),
          if (award.issuer.isNotEmpty)
            pw.Text(award.issuer, style: pw.TextStyle(fontSize: 8.5, color: primaryColor)),
          if (award.description.isNotEmpty)
            pw.Text(award.description, style: pw.TextStyle(fontSize: 8, color: textPrimaryColor)),
        ],
      ),
    );
  }

  pw.Widget _buildVolunteering(Volunteering vol) {
    final dateEnd = vol.isCurrent ? tr('present') : vol.endDate;
    final dateRange = vol.startDate.isNotEmpty ? '${vol.startDate}${dateEnd.isNotEmpty ? ' – $dateEnd' : ''}' : dateEnd;
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                '${vol.role} – ${vol.organization}',
                style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: textPrimaryColor),
              ),
              if (dateRange.isNotEmpty)
                pw.Text(dateRange, style: pw.TextStyle(fontSize: 8.5, color: textSecondaryColor)),
            ],
          ),
          if (vol.description.isNotEmpty)
            pw.Text(vol.description, style: pw.TextStyle(fontSize: 8, color: textPrimaryColor)),
        ],
      ),
    );
  }

  pw.Widget _buildReference(Reference ref) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 5),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(ref.name, style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: textPrimaryColor)),
              if (ref.position.isNotEmpty || ref.organization.isNotEmpty)
                pw.Text('${ref.position}${ref.position.isNotEmpty && ref.organization.isNotEmpty ? ' – ' : ''}${ref.organization}',
                    style: pw.TextStyle(fontSize: 8, color: primaryColor)),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              if (ref.email.isNotEmpty)
                pw.Text(ref.email, style: pw.TextStyle(fontSize: 8, color: textSecondaryColor)),
              if (ref.phone.isNotEmpty)
                pw.Text(ref.phone, style: pw.TextStyle(fontSize: 8, color: textSecondaryColor)),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildCustomSection(CustomSection sec) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(sec.title),
        ...sec.items.map((item) => pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 5),
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
                    pw.Text(item.subtitle, style: pw.TextStyle(fontSize: 8, color: primaryColor)),
                  if (item.description.isNotEmpty)
                    pw.Text(item.description, style: pw.TextStyle(fontSize: 8, color: textPrimaryColor)),
                ],
              ),
            )),
        pw.SizedBox(height: 12),
      ],
    );
  }
}
