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

class ExecutiveTemplate extends BasePdfTemplate {
  ExecutiveTemplate({required super.cv, required super.fonts});

  @override
  Future<pw.Document> generate() async {
    final doc = pw.Document(theme: themeData);
    final photo = photoImage;

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(0),
        footer: (context) => pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 28, vertical: 10),
          child: buildFooter(context),
        ),
        build: (context) {
          return [
            wrapDirection(
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  _buildBannerHeader(photo),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(28),
                    child: _buildContent(),
                  ),
                ],
              ),
            ),
          ];
        },
      ),
    );

    return doc;
  }

  pw.Widget _buildBannerHeader(pw.ImageProvider? photo) {
    final info = cv.personalInfo;

    return pw.Container(
      color: primaryColor,
      padding: const pw.EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          if (photo != null) ...[
            pw.Container(
              width: 72,
              height: 72,
              decoration: pw.BoxDecoration(
                shape: pw.BoxShape.circle,
                border: pw.Border.all(color: PdfColors.white, width: 2.5),
                image: pw.DecorationImage(image: photo, fit: pw.BoxFit.cover),
              ),
            ),
            pw.SizedBox(width: 20),
          ],
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  info.fullName.isNotEmpty ? info.fullName : cv.title,
                  style: const pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                ),
                if (info.jobTitle.isNotEmpty) ...[
                  pw.SizedBox(height: 4),
                  pw.Text(
                    info.jobTitle,
                    style: const pw.TextStyle(
                      fontSize: 13,
                      color: PdfColor(0.85, 0.9, 1.0),
                    ),
                  ),
                ],
                pw.SizedBox(height: 8),
                pw.Wrap(
                  spacing: 12,
                  runSpacing: 4,
                  children: [
                    if (info.email.isNotEmpty)
                      pw.Text(info.email, style: const pw.TextStyle(fontSize: 8.5, color: PdfColor(0.8, 0.85, 0.95))),
                    if (info.phone.isNotEmpty)
                      pw.Text(info.phone, style: const pw.TextStyle(fontSize: 8.5, color: PdfColor(0.8, 0.85, 0.95))),
                    if (info.address.isNotEmpty)
                      pw.Text(info.address, style: const pw.TextStyle(fontSize: 8.5, color: PdfColor(0.8, 0.85, 0.95))),
                    if (info.dateOfBirth.isNotEmpty)
                      pw.Text(info.dateOfBirth, style: const pw.TextStyle(fontSize: 8.5, color: PdfColor(0.8, 0.85, 0.95))),
                    if (info.nationality.isNotEmpty)
                      pw.Text(info.nationality, style: const pw.TextStyle(fontSize: 8.5, color: PdfColor(0.8, 0.85, 0.95))),
                    if (info.website.isNotEmpty)
                      pw.Text(info.website, style: const pw.TextStyle(fontSize: 8.5, color: PdfColor(0.8, 0.85, 0.95))),
                    if (info.linkedin.isNotEmpty)
                      pw.Text(info.linkedin, style: const pw.TextStyle(fontSize: 8.5, color: PdfColor(0.8, 0.85, 0.95))),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildContent() {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Main Content (68%)
        pw.Expanded(
          flex: 68,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              if (cv.personalInfo.summary.isNotEmpty) ...[
                _buildSectionTitle(tr('summary')),
                pw.Text(
                  cv.personalInfo.summary,
                  style: pw.TextStyle(fontSize: 9.5, height: 1.4, color: textPrimaryColor),
                ),
                pw.SizedBox(height: 14),
              ],
              if (cv.experiences.isNotEmpty) ...[
                _buildSectionTitle(tr('experience')),
                ...cv.experiences.map(_buildExperience),
                pw.SizedBox(height: 14),
              ],
              if (cv.educations.isNotEmpty) ...[
                _buildSectionTitle(tr('education')),
                ...cv.educations.map(_buildEducation),
                pw.SizedBox(height: 14),
              ],
              if (cv.projects.isNotEmpty) ...[
                _buildSectionTitle(tr('projects')),
                ...cv.projects.map(_buildProject),
                pw.SizedBox(height: 14),
              ],
              if (cv.publications.isNotEmpty) ...[
                _buildSectionTitle(tr('publications')),
                ...cv.publications.map(_buildPublication),
                pw.SizedBox(height: 14),
              ],
              if (cv.awards.isNotEmpty) ...[
                _buildSectionTitle(tr('awards')),
                ...cv.awards.map(_buildAward),
                pw.SizedBox(height: 14),
              ],
              if (cv.volunteering.isNotEmpty) ...[
                _buildSectionTitle(tr('volunteering')),
                ...cv.volunteering.map(_buildVolunteering),
                pw.SizedBox(height: 14),
              ],
              if (cv.references.isNotEmpty) ...[
                _buildSectionTitle(tr('references')),
                ...cv.references.map(_buildReference),
                pw.SizedBox(height: 14),
              ],
              if (cv.customSections.isNotEmpty) ...[
                ...cv.customSections.map(_buildCustomSection),
              ],
            ],
          ),
        ),
        pw.SizedBox(width: 20),
        // Side Column (32%)
        pw.Expanded(
          flex: 32,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              if (cv.skills.isNotEmpty) ...[
                _buildSectionTitle(tr('skills')),
                ...cv.skills.map((s) => pw.Container(
                      margin: const pw.EdgeInsets.only(bottom: 4),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(s.name, style: pw.TextStyle(fontSize: 8.8, color: textPrimaryColor)),
                          pw.Text('${s.level}/5', style: pw.TextStyle(fontSize: 8, font: fonts.bold, color: primaryColor)),
                        ],
                      ),
                    )),
                pw.SizedBox(height: 14),
              ],
              if (cv.languages.isNotEmpty) ...[
                _buildSectionTitle(tr('languages')),
                ...cv.languages.map((l) => pw.Container(
                      margin: const pw.EdgeInsets.only(bottom: 4),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(l.name, style: pw.TextStyle(fontSize: 8.8, color: textPrimaryColor)),
                          pw.Text(tr(l.proficiency.name), style: pw.TextStyle(fontSize: 8, color: textSecondaryColor)),
                        ],
                      ),
                    )),
                pw.SizedBox(height: 14),
              ],
              if (cv.certifications.isNotEmpty) ...[
                _buildSectionTitle(tr('certifications')),
                ...cv.certifications.map(_buildCertification),
                pw.SizedBox(height: 14),
              ],
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildSectionTitle(String title) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 8),
      padding: const pw.EdgeInsets.only(bottom: 3),
      decoration: pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: primaryColor, width: 1.2)),
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 11,
          fontWeight: pw.FontWeight.bold,
          color: primaryColor,
        ),
      ),
    );
  }

  pw.Widget _buildExperience(Experience exp) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(exp.position, style: pw.TextStyle(fontSize: 10, font: fonts.bold, color: textPrimaryColor)),
              pw.Text('${exp.startDate} - ${exp.isCurrent ? tr('present') : exp.endDate}',
                  style: pw.TextStyle(fontSize: 8.5, font: fonts.bold, color: textSecondaryColor)),
            ],
          ),
          pw.Text(exp.company, style: pw.TextStyle(fontSize: 9, color: primaryColor)),
          if (exp.description.isNotEmpty) ...[
            pw.SizedBox(height: 2),
            pw.Text(exp.description, style: pw.TextStyle(fontSize: 8.8, color: textPrimaryColor)),
          ],
          if (exp.highlights.isNotEmpty) ...[
            pw.SizedBox(height: 2),
            ...exp.highlights.map((h) => pw.Padding(
                  padding: const pw.EdgeInsets.only(left: 6, right: 6, bottom: 2),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('• ', style: pw.TextStyle(fontSize: 8.5, color: primaryColor)),
                      pw.Expanded(child: pw.Text(h, style: pw.TextStyle(fontSize: 8.5, color: textPrimaryColor))),
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
        ? (edu.institution.isNotEmpty ? '${edu.institution}, ${edu.country}' : edu.country)
        : edu.institution;
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(degreeTitle, style: pw.TextStyle(fontSize: 9.5, font: fonts.bold, color: textPrimaryColor)),
              pw.Text(loc, style: pw.TextStyle(fontSize: 8.5, color: textSecondaryColor)),
            ],
          ),
          if (dateRange.isNotEmpty)
            pw.Text(dateRange, style: pw.TextStyle(fontSize: 8.5, color: textSecondaryColor)),
        ],
      ),
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
              pw.Text(proj.title, style: pw.TextStyle(fontSize: 9, font: fonts.bold, color: textPrimaryColor)),
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
            pw.Text(proj.description, style: pw.TextStyle(fontSize: 8.5, color: textPrimaryColor)),
          if (proj.url.isNotEmpty)
            pw.Text(proj.url, style: pw.TextStyle(fontSize: 7.5, color: primaryColor)),
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
          pw.Text(cert.name, style: pw.TextStyle(fontSize: 8.8, font: fonts.bold, color: textPrimaryColor)),
          pw.Text('${cert.issuer}${cert.issueDate.isNotEmpty ? ' • ${cert.issueDate}' : ''}',
              style: pw.TextStyle(fontSize: 7.8, color: textSecondaryColor)),
          if (cert.description.isNotEmpty)
            pw.Text(cert.description, style: pw.TextStyle(fontSize: 7.8, color: textPrimaryColor)),
          if (cert.url.isNotEmpty)
            pw.Text(cert.url, style: pw.TextStyle(fontSize: 7.2, color: primaryColor)),
        ],
      ),
    );
  }

  pw.Widget _buildPublication(Publication pub) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Expanded(
                child: pw.Text(pub.title, style: pw.TextStyle(fontSize: 9, font: fonts.bold, color: textPrimaryColor)),
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
                child: pw.Text(award.title, style: pw.TextStyle(fontSize: 9, font: fonts.bold, color: textPrimaryColor)),
              ),
              if (award.date.isNotEmpty)
                pw.Text(award.date, style: pw.TextStyle(fontSize: 8.5, color: textSecondaryColor)),
            ],
          ),
          if (award.issuer.isNotEmpty)
            pw.Text(award.issuer, style: pw.TextStyle(fontSize: 8, color: primaryColor)),
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
      margin: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('${vol.role} – ${vol.organization}',
                  style: pw.TextStyle(fontSize: 9, font: fonts.bold, color: textPrimaryColor)),
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
                pw.Text('${ref.position}${ref.position.isNotEmpty && ref.organization.isNotEmpty ? ' • ' : ''}${ref.organization}',
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
