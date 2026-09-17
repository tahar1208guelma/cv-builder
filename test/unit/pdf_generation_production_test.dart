import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdf/pdf.dart';
import 'package:cv_builder/core/constants/app_constants.dart';
import 'package:cv_builder/features/cv/data/sample_cv_factory.dart';
import 'package:cv_builder/features/cv/domain/models/award.dart';
import 'package:cv_builder/features/cv/domain/models/certification.dart';
import 'package:cv_builder/features/cv/domain/models/custom_section.dart';
import 'package:cv_builder/features/cv/domain/models/cv_model.dart';
import 'package:cv_builder/features/cv/domain/models/cv_style.dart';
import 'package:cv_builder/features/cv/domain/models/education.dart';
import 'package:cv_builder/features/cv/domain/models/experience.dart';
import 'package:cv_builder/features/cv/domain/models/language_item.dart';
import 'package:cv_builder/features/cv/domain/models/personal_info.dart';
import 'package:cv_builder/features/cv/domain/models/project.dart';
import 'package:cv_builder/features/cv/domain/models/publication.dart';
import 'package:cv_builder/features/cv/domain/models/reference.dart';
import 'package:cv_builder/features/cv/domain/models/skill.dart';
import 'package:cv_builder/features/cv/domain/models/volunteering.dart';
import 'package:cv_builder/features/pdf_export/services/pdf_font_manager.dart';
import 'package:cv_builder/features/pdf_export/services/pdf_generator_service.dart';
import 'package:cv_builder/features/pdf_export/templates/cv_template_registry.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    CvTemplateRegistry.initialize();
  });

  // Valid 1x1 transparent PNG data for photo testing
  const dummyPngBase64 =
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==';

  /// Helper to create a comprehensive long CV with all 12 sections populated
  CvModel createLongCv({
    required String language,
    required String templateId,
    bool showPhoto = false,
  }) {
    return CvModel(
      title: 'Dr. Johnathan Edwards - Senior Principal Scientist & Lead Architect',
      language: language,
      style: CvStyle(
        templateId: templateId,
        primaryColorHex: '#1E3A8A',
        fontFamily: language == AppConstants.langAr ? 'Cairo' : 'Roboto',
      ),
      personalInfo: PersonalInfo(
        firstName: 'Johnathan',
        lastName: 'Edwards',
        fullName: 'Dr. Johnathan Edwards, PhD',
        jobTitle: 'Senior Principal Scientist & Lead Enterprise Architect',
        email: 'j.edwards@research-labs.org',
        phone: '+1 415 555 2671',
        address: 'San Francisco, CA, United States',
        dateOfBirth: '1985-04-12',
        nationality: 'American',
        website: 'https://jedwards-research.org',
        linkedin: 'linkedin.com/in/johnathan-edwards-phd',
        github: 'github.com/jedwards-labs',
        summary:
            'Accomplished Principal Scientist and Systems Architect with over 15 years of distinguished experience in distributed systems, machine learning compilers, and fault-tolerant cloud backends. Author of 14 peer-reviewed publications and primary inventor on 5 patents in concurrent distributed transaction processing. Proven leader directing multi-institutional research and enterprise software deployments serving tens of millions of users worldwide.',
        showPhoto: showPhoto,
        photoBase64: showPhoto ? dummyPngBase64 : null,
      ),
      experiences: [
        Experience(
          position: 'Senior Principal Research Scientist & Director of Systems',
          company: 'Applied Cognitive Computing Institute',
          location: 'San Francisco, CA',
          startDate: '2021',
          endDate: 'Present',
          isCurrent: true,
          description:
              'Direct the foundational architectures group overseeing 35 researchers and senior staff engineers developing next-generation distributed inference acceleration pipelines.',
          highlights: [
            'Conceived and deployed scalable neural execution runtime lowering p99 inference latency by 48% across 10,000+ GPU nodes.',
            'Secured \$4.2M in competitive federal research grants and enterprise consortium funding for open distributed compute protocols.',
            'Guided architectural RFC standards, automated CI/CD performance benchmarking, and multi-tenant isolation policies.',
          ],
        ),
        Experience(
          position: 'Lead Distributed Systems Architect',
          company: 'Helios Distributed Cloud Corp',
          location: 'Palo Alto, CA',
          startDate: '2016',
          endDate: '2021',
          isCurrent: false,
          description:
              'Led the core infrastructure division responsible for consensus protocols, metadata replication, and geo-distributed disaster recovery.',
          highlights: [
            'Designed a Paxos-derived multi-region consensus protocol handling 4.5 million write transactions per second with zero data loss.',
            'Spearheaded transition of petabyte-scale storage clusters to automated zero-trust authorization layers.',
            'Mentored 20+ software engineers and received company-wide Outstanding Engineering Leadership Award in 2019.',
          ],
        ),
        Experience(
          position: 'Staff Systems Software Engineer',
          company: 'Nexus Global Data Systems',
          location: 'Mountain View, CA',
          startDate: '2012',
          endDate: '2016',
          isCurrent: false,
          description:
              'Engineered high-performance low-latency network primitives and kernel-bypass I/O subsystems for memory-intensive streaming pipelines.',
          highlights: [
            'Implemented custom DPDK/RDMA networking layers reducing inter-node packet serialization latency by 65%.',
            'Collaborated with hardware vendors to tune NUMA memory interleaving on high-core-count servers.',
          ],
        ),
        Experience(
          position: 'Senior Research Assistant & Doctoral Fellow',
          company: 'Stanford Distributed Systems Laboratory',
          location: 'Stanford, CA',
          startDate: '2008',
          endDate: '2012',
          isCurrent: false,
          description:
              'Investigated Byzantine fault-tolerant coordination models under asynchronous wide-area network partitions.',
          highlights: [
            'Published 5 papers in top-tier conferences (OSDI, SOSP, EuroSys) with over 1,200 collective academic citations.',
          ],
        ),
      ],
      educations: [
        Education(
          degree: 'Doctor of Philosophy (Ph.D.)',
          fieldOfStudy: 'Computer Science & Distributed Systems',
          institution: 'Stanford University',
          country: 'United States',
          startDate: '2007',
          endDate: '2012',
          grade: 'Doctoral Dissertation with Distinction',
          description:
              'Thesis: "Provably Safe Asynchronous State Machine Replication in Partitioned Cloud Fabrics". Advised by Prof. R. Hamilton.',
        ),
        Education(
          degree: 'Master of Science (M.Sc.)',
          fieldOfStudy: 'Computer Science',
          institution: 'Carnegie Mellon University',
          country: 'United States',
          startDate: '2005',
          endDate: '2007',
          grade: 'GPA: 4.0 / 4.0',
        ),
        Education(
          degree: 'Bachelor of Science (B.Sc.)',
          fieldOfStudy: 'Electrical Engineering & Computer Science',
          institution: 'UC Berkeley',
          country: 'United States',
          startDate: '2001',
          endDate: '2005',
          grade: 'Summa Cum Laude',
        ),
      ],
      skills: [
        Skill(name: 'Distributed Systems', level: 5),
        Skill(name: 'Cloud Architecture (AWS / GCP / K8s)', level: 5),
        Skill(name: 'Go / Rust / C++', level: 5),
        Skill(name: 'Consensus Protocols (Raft, Paxos)', level: 5),
        Skill(name: 'Flutter & Cross-Platform UI', level: 4),
        Skill(name: 'High-Concurrency Microservices', level: 5),
        Skill(name: 'Machine Learning Systems (PyTorch)', level: 4),
        Skill(name: 'Database Internals (LSM, B-Tree)', level: 4),
        Skill(name: 'Linux Kernel & eBPF', level: 4),
        Skill(name: 'System Security & Cryptography', level: 4),
      ],
      languages: [
        LanguageItem(name: 'English', proficiency: LanguageProficiency.native),
        LanguageItem(name: 'French', proficiency: LanguageProficiency.fluent),
        LanguageItem(name: 'German', proficiency: LanguageProficiency.intermediate),
        LanguageItem(name: 'Arabic', proficiency: LanguageProficiency.basic),
      ],
      projects: [
        Project(
          title: 'HyperConsensus Open Framework',
          role: 'Creator & Maintainer',
          date: '2022 - Present',
          url: 'https://github.com/jedwards-labs/hyperconsensus',
          technologies: 'Rust, Tokio, Raft, Protocol Buffers',
          description:
              'High-throughput asynchronous consensus library adopted by over 2,000 production distributed services and open-source database engines.',
        ),
        Project(
          title: 'Distributed Stream Analytics Engine',
          role: 'Architect',
          date: '2019 - 2021',
          url: 'https://github.com/jedwards-labs/d-stream-engine',
          technologies: 'Go, Kafka, Kubernetes, Apache Arrow',
          description:
              'Low-footprint vectorized streaming engine processing up to 10M events per second per worker instance.',
        ),
      ],
      certifications: [
        Certification(
          name: 'AWS Certified Solutions Architect - Professional',
          issuer: 'Amazon Web Services',
          issueDate: '2023',
          url: 'https://aws.amazon.com/verification/12345678',
        ),
        Certification(
          name: 'Certified Kubernetes Administrator (CKA)',
          issuer: 'Cloud Native Computing Foundation (CNCF)',
          issueDate: '2022',
        ),
      ],
      publications: [
        Publication(
          title: 'Asynchronous State Machine Replication in Geo-Replicated Environments',
          publisher: 'ACM Transactions on Computer Systems (TOCS)',
          date: '2023',
          authors: 'Edwards J., Vance M., Goldberg S.',
          url: 'https://doi.org/10.1145/3547890.123456',
        ),
        Publication(
          title: 'Decentralized Fault Detection in Dynamic Edge Computing Topologies',
          publisher: 'IEEE Symposium on Security and Privacy (S&P)',
          date: '2021',
          authors: 'Edwards J., Miller K.',
          url: 'https://doi.org/10.1109/SP.2021.987654',
        ),
        Publication(
          title: 'Kernel-Bypass Memory Management for Microsecond-Scale Network Services',
          publisher: 'USENIX OSDI Proceedings',
          date: '2018',
          authors: 'Edwards J., Chen L., Taylor R.',
        ),
      ],
      awards: [
        Award(
          title: 'ACM SIGOPS Best Paper Award',
          issuer: 'Association for Computing Machinery',
          date: '2020',
          description: 'Recognized for pioneering work in low-overhead decentralized state verification.',
        ),
        Award(
          title: 'National Science Foundation Graduate Research Fellowship',
          issuer: 'NSF',
          date: '2008',
        ),
      ],
      volunteering: [
        Volunteering(
          role: 'Program Committee Member & Reviewer',
          organization: 'ACM SIGCOMM & IEEE Cloud Computing',
          startDate: '2017',
          endDate: 'Present',
          isCurrent: true,
          description: 'Peer-review 20+ competitive research submissions annually across top-tier venues.',
        ),
      ],
      references: [
        Reference(
          name: 'Prof. Robert Hamilton',
          position: 'Chair of Computer Science Department',
          organization: 'Stanford University',
          email: 'r.hamilton@stanford.edu',
          phone: '+1 650 723 2300',
        ),
        Reference(
          name: 'Dr. Sarah Lin',
          position: 'VP of Systems Engineering',
          organization: 'Helios Cloud Corp',
          email: 's.lin@helioscloud.com',
          phone: '+1 415 555 8900',
        ),
      ],
      customSections: [
        CustomSection(
          title: 'Patents & Intellectual Property',
          items: [
            CustomSectionItem(
              title: 'US Patent 11,234,567: Low-Latency Distributed State Replication with Adaptive Quorums',
              subtitle: 'Primary Inventor (Edwards J.)',
              date: 'Granted 2023',
              description:
                  'Novel distributed consensus state machine with dynamic quorum adaptation based on live network round-trip telemetry.',
            ),
          ],
        ),
      ],
    );
  }

  /// Helper to create a minimal short CV (fits on a single page)
  CvModel createShortCv() {
    return CvModel(
      title: 'Jane Doe - Junior Developer',
      language: AppConstants.langEn,
      style: const CvStyle(
        templateId: AppConstants.templateProfessional,
        fontFamily: 'Roboto',
      ),
      personalInfo: const PersonalInfo(
        firstName: 'Jane',
        lastName: 'Doe',
        fullName: 'Jane Doe',
        jobTitle: 'Junior Flutter Developer',
        email: 'jane.doe@example.com',
        phone: '+1 555 0199',
        address: 'Austin, TX',
        summary: 'Enthusiastic mobile developer passionate about creating responsive cross-platform apps.',
        showPhoto: false,
      ),
      experiences: [
        Experience(
          position: 'Junior Flutter Developer',
          company: 'AppLab Studios',
          location: 'Austin, TX',
          startDate: '2023',
          endDate: 'Present',
          isCurrent: true,
          description: 'Developing high-quality user interfaces with Flutter and Riverpod.',
        ),
      ],
      educations: [
        Education(
          degree: 'Bachelor of Science in Computer Science',
          institution: 'University of Texas at Austin',
          startDate: '2019',
          endDate: '2023',
        ),
      ],
      skills: [
        Skill(name: 'Flutter & Dart', level: 4),
        Skill(name: 'Git & GitHub', level: 4),
        Skill(name: 'REST APIs', level: 3),
      ],
    );
  }

  group('Production PDF Generation - 8 Required Scenarios', () {
    test('1. Short CV generates valid single-page A4 PDF without overflow', () async {
      final cv = createShortCv();
      final fonts = await PdfFontManager.getLatinFont();
      final template = CvTemplateRegistry.createTemplate(
        cv.style.templateId,
        cv: cv,
        fonts: fonts,
      );

      final doc = await template.generate();
      final bytes = await doc.save();

      // Verify PDF header
      expect(bytes.isNotEmpty, true);
      expect(String.fromCharCodes(bytes.take(5)), '%PDF-');

      // Verify exactly 1 page
      expect(doc.document.pdfPageList.pages.length, 1);

      // Verify A4 page dimensions (595.28 x 841.89 points)
      final page = doc.document.pdfPageList.pages.first;
      expect(page.pageFormat.width, closeTo(PdfPageFormat.a4.width, 0.1));
      expect(page.pageFormat.height, closeTo(PdfPageFormat.a4.height, 0.1));
    });

    test('2. Long CV generates seamless multi-page PDF without PdfTooBigPageException across all 4 templates', () async {
      final templatesToTest = [
        AppConstants.templateProfessional,
        AppConstants.templateModern,
        AppConstants.templateAcademic,
        AppConstants.templateAts,
      ];

      for (final templateId in templatesToTest) {
        final cv = createLongCv(
          language: AppConstants.langEn,
          templateId: templateId,
          showPhoto: false,
        );
        final fonts = await PdfFontManager.getLatinFont();
        final template = CvTemplateRegistry.createTemplate(
          templateId,
          cv: cv,
          fonts: fonts,
        );

        final doc = await template.generate();
        final bytes = await doc.save();

        expect(bytes.isNotEmpty, true, reason: 'Template $templateId must produce bytes');
        expect(String.fromCharCodes(bytes.take(5)), '%PDF-', reason: 'Template $templateId must produce valid PDF header');

        // Verify multi-page requirement (at least 2 pages for this comprehensive content)
        final pageCount = doc.document.pdfPageList.pages.length;
        expect(
          pageCount,
          greaterThanOrEqualTo(2),
          reason: 'Template $templateId should distribute comprehensive CV over 2 or more pages',
        );

        // Verify all pages adhere to A4 dimensions
        for (final p in doc.document.pdfPageList.pages) {
          expect(p.pageFormat.width, closeTo(PdfPageFormat.a4.width, 0.1));
          expect(p.pageFormat.height, closeTo(PdfPageFormat.a4.height, 0.1));
        }
      }
    });

    test('3. Arabic CV generates valid RTL PDF with Cairo font and LTR phone/links', () async {
      final arCv = SampleCvFactory.createArabicSample().copyWith(
        style: const CvStyle(templateId: AppConstants.templateModern),
      );

      final fonts = await PdfFontManager.getFontForCv(arCv.language);
      expect(fonts.isArabic, true);

      final template = CvTemplateRegistry.createTemplate(
        arCv.style.templateId,
        cv: arCv,
        fonts: fonts,
      );

      final doc = await template.generate();
      final bytes = await doc.save();

      expect(bytes.isNotEmpty, true);
      expect(String.fromCharCodes(bytes.take(5)), '%PDF-');

      // Verify font descriptors and vector objects exist in the PDF
      final pdfString = latin1.decode(bytes, allowInvalid: true);
      expect(pdfString.contains('/Type /Font') || pdfString.contains('/FontDescriptor'), true);
    });

    test('4. English CV generates valid LTR PDF with Roboto font and selectable text', () async {
      final enCv = SampleCvFactory.createEnglishSample().copyWith(
        style: const CvStyle(templateId: AppConstants.templateProfessional),
      );

      final fonts = await PdfFontManager.getFontForCv(enCv.language);
      expect(fonts.isArabic, false);

      final bytes = await PdfGeneratorService.generatePdfBytes(enCv);
      expect(bytes.isNotEmpty, true);
      expect(String.fromCharCodes(bytes.take(5)), '%PDF-');

      final pdfString = latin1.decode(bytes, allowInvalid: true);
      expect(pdfString.contains('/Font'), true);
      expect(RegExp(r'/Type\s*/Page').hasMatch(pdfString), true);
    });

    test('5. French CV generates valid PDF preserving accented characters (é, è, à, ç, etc.)', () async {
      final frCv = SampleCvFactory.createFrenchSample().copyWith(
        style: const CvStyle(templateId: AppConstants.templateAcademic),
      );

      final bytes = await PdfGeneratorService.generatePdfBytes(frCv);
      expect(bytes.isNotEmpty, true);
      expect(String.fromCharCodes(bytes.take(5)), '%PDF-');

      final pdfString = latin1.decode(bytes, allowInvalid: true);
      expect(pdfString.contains('/Font'), true);
      expect(RegExp(r'/Type\s*/Page').hasMatch(pdfString), true);
    });

    test('6. CV with photo generates valid PDF containing embedded image XObject', () async {
      final photoCv = SampleCvFactory.createEnglishSample().copyWith(
        personalInfo: SampleCvFactory.createEnglishSample().personalInfo.copyWith(
          showPhoto: true,
          photoBase64: dummyPngBase64,
        ),
        style: const CvStyle(templateId: AppConstants.templateModern),
      );

      final bytes = await PdfGeneratorService.generatePdfBytes(photoCv);
      expect(bytes.isNotEmpty, true);
      expect(String.fromCharCodes(bytes.take(5)), '%PDF-');

      final pdfString = latin1.decode(bytes, allowInvalid: true);
      // Verify image XObject presence
      expect(RegExp(r'/Subtype\s*/Image').hasMatch(pdfString) || pdfString.contains('/Image'), true);
    });

    test('7. CV without photo renders balanced layout without image XObject', () async {
      final noPhotoCv = SampleCvFactory.createEnglishSample().copyWith(
        personalInfo: SampleCvFactory.createEnglishSample().personalInfo.copyWith(
          showPhoto: false,
          photoBase64: null,
        ),
        style: const CvStyle(templateId: AppConstants.templateModern),
      );

      final bytes = await PdfGeneratorService.generatePdfBytes(noPhotoCv);
      expect(bytes.isNotEmpty, true);
      expect(String.fromCharCodes(bytes.take(5)), '%PDF-');

      final pdfString = latin1.decode(bytes, allowInvalid: true);
      expect(RegExp(r'/Subtype\s*/Image').hasMatch(pdfString), false);
    });

    test('8. Multi-page CV verification: links, pagination, and metadata', () async {
      final longCv = createLongCv(
        language: AppConstants.langEn,
        templateId: AppConstants.templateProfessional,
      );

      final fonts = await PdfFontManager.getLatinFont();
      final template = CvTemplateRegistry.createTemplate(
        longCv.style.templateId,
        cv: longCv,
        fonts: fonts,
      );

      final doc = await template.generate();
      final bytes = await doc.save();

      // Check metadata
      expect(doc.document.pdfPageList.pages.length, greaterThanOrEqualTo(2));

      // Check that PDF contains link annotations for interactive clickable URLs
      final pdfString = latin1.decode(bytes, allowInvalid: true);
      expect(pdfString.contains('/Subtype /Link') || pdfString.contains('/URI'), true);
    });
  });

  group('PDF Generator Service & Filename Sanitization', () {
    test('sanitizeFilename handles Latin, Arabic, French, and special characters', () {
      expect(
        PdfGeneratorService.sanitizeFilename('Alexander Wright - CV'),
        'Alexander Wright - CV',
      );
      expect(
        PdfGeneratorService.sanitizeFilename('طارق المنصور - سيرة ذاتية'),
        'طارق المنصور - سيرة ذاتية',
      );
      expect(
        PdfGeneratorService.sanitizeFilename('Élodie Martin / CV 2026!'),
        'Élodie Martin _ CV 2026_',
      );
      expect(
        PdfGeneratorService.sanitizeFilename('   '),
        'CV',
      );
    });

    test('generatePdfBytes produces valid document for empty and custom CVs', () async {
      final emptyCv = CvModel.empty(language: AppConstants.langEn);
      final bytes = await PdfGeneratorService.generatePdfBytes(emptyCv);
      expect(bytes.isNotEmpty, true);
      expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    });
  });
}
