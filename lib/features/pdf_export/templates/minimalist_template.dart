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

class MinimalistTemplate extends BasePdfTemplate {
  MinimalistTemplate({required super.cv, required super.fonts});

  @override
  Future<pw.Document> generate() async {
    final doc = pw.Document(theme: themeData);
    final photo = photoImage;

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        footer: buildFooter,
        build: (context) {
          return [
            wrapDirection(
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _buildHeader(photo),
                  pw.SizedBox(height: 18),
                  if (cv.personalInfo.summary.isNotEmpty) ...[
                    _buildSectionHeader(tr('summary')),
                    pw.Text(
                      cv.personalInfo.summary,
                      style: pw.TextStyle(fontSize: 9.5, height: 1.45, color: textPrimaryColor),
                    ),
                    pw.SizedBox(height: 14),
                  ],
                  if (cv.experiences.isNotEmpty) ...[
                    _buildSectionHeader(tr('experience')),
                    ...cv.experiences.map(_buildExperience),
                    pw.SizedBox(height: 14),
                  ],
                  if (cv.educations.isNotEmpty) ...[
                    _buildSectionHeader(tr('education')),
                    ...cv.educations.map(_buildEducation),
                    pw.SizedBox(height: 14),
                  ],
                  if (cv.skills.isNotEmpty) ...[
                    _buildSectionHeader(tr('skills')),
                    _buildSkillsList(),
                    pw.SizedBox(height: 14),
                  ],
                  if (cv.languages.isNotEmpty) ...[
                    _buildSectionHeader(tr('languages')),
                    _buildLanguagesList(),
                    pw.SizedBox(height: 14),
                  ],
                  if (cv.projects.isNotEmpty) ...[
                    _buildSectionHeader(tr('projects')),
                    ...cv.projects.map(_buildProject),
                    pw.SizedBox(height: 14),
                  ],
                  if (cv.certifications.isNotEmpty) ...[
                    _buildSectionHeader(tr('certifications')),
                    ...cv.certifications.map(_buildCert),
                    pw.SizedBox(height: 14),
                  ],
                  if (cv.publications.isNotEmpty) ...[
                    _buildSectionHeader(tr('publications')),
                    ...cv.publications.map(_buildPublication),
                    pw.SizedBox(height: 14),
                  ],
                  if (cv.awards.isNotEmpty) ...[
                    _buildSectionHeader(tr('awards')),
                    ...cv.awards.map(_buildAward),
                    pw.SizedBox(height: 14),
                  ],
                  if (cv.volunteering.isNotEmpty) ...[
                    _buildSectionHeader(tr('volunteering')),
                    ...cv.volunteering.map(_buildVolunteering),
                    pw.SizedBox(height: 14),
                  ],
                  if (cv.references.isNotEmpty) ...[
                    _buildSectionHeader(tr('references')),
                    ...cv.references.map(_buildReference),
                    pw.SizedBox(height: 14),
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
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        if (photo != null) ...[
          pw.Container(
            width: 60,
            height: 60,
            decoration: pw.BoxDecoration(
              shape: pw.BoxShape.circle,
              image: pw.DecorationImage(image: photo, fit: pw.BoxFit.cover),
            ),
          ),
          pw.SizedBox(width: 16),
        ],
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                info.fullName.isNotEmpty ? info.fullName : cv.title,
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: textPrimaryColor,
                ),
              ),
              if (info.jobTitle.isNotEmpty) ...[
                pw.SizedBox(height: 3),
                pw.Text(
                  info.jobTitle,
                  style: pw.TextStyle(fontSize: 12, color: primaryColor, font: fonts.bold),
                ),
              ],
              pw.SizedBox(height: 6),
              pw.Wrap(
                spacing: 12,
                runSpacing: 3,
                children: [
                  if (info.email.isNotEmpty) pw.Text(info.email, style: pw.TextStyle(fontSize: 8.5, color: textSecondaryColor)),
                  if (info.phone.isNotEmpty) pw.Text(info.phone, style: pw.TextStyle(fontSize: 8.5, color: textSecondaryColor)),
                  if (info.address.isNotEmpty) pw.Text(info.address, style: pw.TextStyle(fontSize: 8.5, color: textSecondaryColor)),
                  if (info.dateOfBirth.isNotEmpty) pw.Text(info.dateOfBirth, style: pw.TextStyle(fontSize: 8.5, color: textSecondaryColor)),
                  if (info.nationality.isNotEmpty) pw.Text(info.nationality, style: pw.TextStyle(fontSize: 8.5, color: textSecondaryColor)),
                  if (info.website.isNotEmpty) pw.Text(info.website, style: pw.TextStyle(fontSize: 8.5, color: textSecondaryColor)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildSectionHeader(String title) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Text(
        title.toUpperCase(),
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: pw.FontWeight.bold,
          letterSpacing: 1.5,
          color: primaryColor,
        ),
      ),
    );
  }

  pw.Widget _buildExperience(Experience exp) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 8),
      padding: const pw.EdgeInsets.only(left: 8, right: 8),
      decoration: pw.BoxDecoration(
        border: pw.Border(
          left: isRtl ? pw.BorderSide.none : pw.BorderSide(color: borderColor, width: 1.5),
          right: isRtl ? pw.BorderSide(color: borderColor, width: 1.5) : pw.BorderSide.none,
        ),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(exp.position, style: pw.TextStyle(fontSize: 10, font: fonts.bold, color: textPrimaryColor)),
              pw.Text('${exp.startDate} - ${exp.isCurrent ? tr('present') : exp.endDate}',
                  style: pw.TextStyle(fontSize: 8.5, color: textSecondaryColor)),
            ],
          ),
          pw.Text(exp.company, style: pw.TextStyle(fontSize: 9, color: primaryColor)),
          if (exp.description.isNotEmpty) ...[
            pw.SizedBox(height: 2),
            pw.Text(exp.description, style: pw.TextStyle(fontSize: 8.8, color: textPrimaryColor)),
          ],
          if (exp.highlights.isNotEmpty) ...[
            pw.SizedBox(height: 2),
            ...exp.highlights.map((b) => pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 2),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('– ', style: pw.TextStyle(fontSize: 8.5, color: textSecondaryColor)),
                      pw.Expanded(child: pw.Text(b, style: pw.TextStyle(fontSize: 8.5, color: textPrimaryColor))),
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
    final dateRange = edu.startDate.isNotEmpty ? '${edu.startDate} - $dateEnd' : dateEnd;
    final degreeTitle = edu.fieldOfStudy.isNotEmpty
        ? (edu.degree.isNotEmpty ? '${edu.degree} - ${edu.fieldOfStudy}' : edu.fieldOfStudy)
        : edu.degree;
    final loc = edu.country.isNotEmpty
        ? (edu.location.isNotEmpty ? '${edu.location}, ${edu.country}' : edu.country)
        : edu.location;
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(degreeTitle, style: pw.TextStyle(fontSize: 9.5, font: fonts.bold, color: textPrimaryColor)),
              pw.Text('${edu.institution}${loc.isNotEmpty ? ' ($loc)' : ''}', style: pw.TextStyle(fontSize: 8.5, color: textSecondaryColor)),
            ],
          ),
          if (dateRange.isNotEmpty)
            pw.Text(dateRange, style: pw.TextStyle(fontSize: 8.5, color: textSecondaryColor)),
        ],
      ),
    );
  }

  pw.Widget _buildSkillsList() {
    return pw.Text(
      cv.skills.map((s) => s.name).join('  •  '),
      style: pw.TextStyle(fontSize: 9, color: textPrimaryColor),
    );
  }

  pw.Widget _buildLanguagesList() {
    return pw.Text(
      cv.languages.map((l) => '${l.name} (${tr(l.proficiency.name)})').join('  •  '),
      style: pw.TextStyle(fontSize: 9, color: textPrimaryColor),
    );
  }

  pw.Widget _buildProject(Project proj) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 5),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(proj.title, style: pw.TextStyle(fontSize: 9.5, font: fonts.bold, color: textPrimaryColor)),
              if (proj.date.isNotEmpty)
                pw.Text(proj.date, style: pw.TextStyle(fontSize: 8.5, color: textSecondaryColor)),
            ],
          ),
          if (proj.role.isNotEmpty || proj.technologies.isNotEmpty)
            pw.Text(
              '${proj.role}${proj.role.isNotEmpty && proj.technologies.isNotEmpty ? ' | ' : ''}${proj.technologies}',
              style: pw.TextStyle(fontSize: 8.5, color: primaryColor),
            ),
          if (proj.description.isNotEmpty)
            pw.Text(proj.description, style: pw.TextStyle(fontSize: 8.5, color: textPrimaryColor)),
          if (proj.url.isNotEmpty)
            pw.Text(proj.url, style: pw.TextStyle(fontSize: 7.5, color: primaryColor)),
        ],
      ),
    );
  }

  pw.Widget _buildCert(Certification cert) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                '${cert.name} – ${cert.issuer}',
                style: pw.TextStyle(fontSize: 8.5, font: fonts.bold, color: textPrimaryColor),
              ),
              if (cert.issueDate.isNotEmpty)
                pw.Text(cert.issueDate, style: pw.TextStyle(fontSize: 8.5, color: textSecondaryColor)),
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
                  style: pw.TextStyle(fontSize: 9, font: fonts.bold, color: textPrimaryColor),
                ),
              ),
              if (pub.date.isNotEmpty)
                pw.Text(pub.date, style: pw.TextStyle(fontSize: 8.5, color: textSecondaryColor)),
            ],
          ),
          if (pub.authors.isNotEmpty)
            pw.Text(pub.authors, style: pw.TextStyle(fontSize: 8, color: textSecondaryColor)),
          if (pub.publisher.isNotEmpty)
            pw.Text(pub.publisher, style: pw.TextStyle(fontSize: 8, color: primaryColor)),
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
                  style: pw.TextStyle(fontSize: 9, font: fonts.bold, color: textPrimaryColor),
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
    final dateRange = vol.startDate.isNotEmpty ? '${vol.startDate}${dateEnd.isNotEmpty ? ' - $dateEnd' : ''}' : dateEnd;
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 5),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                '${vol.role} – ${vol.organization}',
                style: pw.TextStyle(fontSize: 9, font: fonts.bold, color: textPrimaryColor),
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
              pw.Text(ref.name, style: pw.TextStyle(fontSize: 9, font: fonts.bold, color: textPrimaryColor)),
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
        _buildSectionHeader(sec.title),
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
