import '../../../../core/constants/app_constants.dart';
import '../domain/models/award.dart';
import '../domain/models/certification.dart';
import '../domain/models/cv_model.dart';
import '../domain/models/cv_style.dart';
import '../domain/models/education.dart';
import '../domain/models/experience.dart';
import '../domain/models/language_item.dart';
import '../domain/models/personal_info.dart';
import '../domain/models/project.dart';
import '../domain/models/publication.dart';
import '../domain/models/reference.dart';
import '../domain/models/skill.dart';
import '../domain/models/volunteering.dart';

class SampleCvFactory {
  static CvModel createEnglishSample() {
    return CvModel(
      title: 'Alexander Wright - Senior Software Architect',
      language: AppConstants.langEn,
      style: const CvStyle(
        templateId: AppConstants.templateModern,
        primaryColorHex: '#1E3A8A', // Deep Navy
        fontFamily: 'Roboto',
        showIcons: true,
      ),
      personalInfo: const PersonalInfo(
        firstName: 'Alexander',
        lastName: 'Wright',
        fullName: 'Alexander Wright',
        jobTitle: 'Senior Software Architect',
        email: 'alexander.wright@techsolutions.com',
        phone: '+44 20 7946 0912',
        address: 'London, United Kingdom',
        dateOfBirth: '1990-05-14',
        nationality: 'British',
        website: 'https://alexwright.dev',
        linkedin: 'linkedin.com/in/alex-wright-dev',
        github: 'github.com/alexwright-tech',
        summary:
            'Forward-thinking Software Architect with 9+ years of experience engineering scalable distributed systems and high-concurrency microservices. Proven track record leading cross-functional engineering teams, reducing infrastructure costs by 35%, and architecting mission-critical cloud solutions handling millions of daily active users.',
        showPhoto: false,
      ),
      experiences: [
        Experience(
          position: 'Lead Cloud & Systems Architect',
          company: 'Apex Digital Infrastructure',
          location: 'London, UK',
          startDate: 'Jan 2022',
          endDate: 'Present',
          isCurrent: true,
          description:
              'Oversee global architectural governance, cloud modernization, and platform reliability across 4 distributed teams.',
          highlights: [
            'Architected event-driven microservices platform on AWS (EKS, Kafka) serving 12M+ monthly requests with 99.99% uptime.',
            'Spearheaded enterprise migration from monolithic legacy stack to Kubernetes, slashing cloud infrastructure costs by 35%.',
            'Mentored 18 senior engineers, establishing automated CI/CD security scanning and strict architectural RFC workflows.',
          ],
        ),
        Experience(
          position: 'Senior Full-Stack Engineer',
          company: 'OmniCloud Technologies',
          location: 'Cambridge, UK',
          startDate: 'Mar 2018',
          endDate: 'Dec 2021',
          isCurrent: false,
          description:
              'Delivered high-performance enterprise SaaS platforms and real-time streaming analytics pipelines.',
          highlights: [
            'Engineered sub-second analytics dashboard using Flutter Desktop, Go, and Redis cluster.',
            'Optimized relational database queries and partitioning in PostgreSQL, cutting 95th percentile latency from 1.2s to 180ms.',
            'Partnered with product and security leadership to achieve SOC2 Type II and ISO 27001 compliance certification.',
          ],
        ),
      ],
      educations: [
        Education(
          degree: 'M.Sc.',
          fieldOfStudy: 'Advanced Computing Science',
          institution: 'Imperial College London',
          country: 'United Kingdom',
          location: 'London, UK',
          startDate: '2016',
          endDate: '2018',
          grade: 'First Class Honours (Distinction)',
          description: 'Specialization in Distributed Systems, High-Performance Computing, and Fault-Tolerant Architectures.',
        ),
        Education(
          degree: 'B.Sc.',
          fieldOfStudy: 'Computer Science',
          institution: 'University of Manchester',
          country: 'United Kingdom',
          location: 'Manchester, UK',
          startDate: '2012',
          endDate: '2016',
          grade: 'Upper Second Class Honours',
          description: 'Core curriculum: Algorithms, Data Structures, Operating Systems, Compilers.',
        ),
      ],
      skills: [
        Skill(name: 'System Architecture & Microservices', level: 5, category: 'Architecture'),
        Skill(name: 'Flutter & Dart (Desktop & Mobile)', level: 5, category: 'Frontend'),
        Skill(name: 'Go & Node.js / TypeScript', level: 5, category: 'Backend'),
        Skill(name: 'Kubernetes, Docker & Terraform', level: 4, category: 'DevOps'),
        Skill(name: 'AWS, GCP & Cloud Governance', level: 5, category: 'Cloud'),
        Skill(name: 'PostgreSQL, Redis & Apache Kafka', level: 4, category: 'Databases'),
      ],
      languages: [
        LanguageItem(name: 'English', proficiency: LanguageProficiency.native),
        LanguageItem(name: 'French', proficiency: LanguageProficiency.intermediate),
      ],
      projects: [
        Project(
          title: 'Nexus Flow - Open-Source Workflow Orchestrator',
          url: 'https://github.com/alexwright-tech/nexus-flow',
          technologies: 'Go, Flutter, gRPC, SQLite',
          description:
              'Engineered a lightweight, offline-first orchestration engine with visual canvas UI, featured in InfoQ and Hacker News.',
        ),
        Project(
          title: 'Pulse Analytics Engine',
          url: 'https://pulse-telemetry.io',
          technologies: 'Kafka, ClickHouse, Docker',
          description:
              'Real-time streaming telemetry aggregator handling over 50,000 incoming metrics events per second.',
        ),
      ],
      certifications: [
        Certification(
          name: 'AWS Certified Solutions Architect - Professional',
          issuer: 'Amazon Web Services',
          issueDate: '2023',
          url: 'aws.amazon.com/verify',
        ),
        Certification(
          name: 'Certified Kubernetes Administrator (CKA)',
          issuer: 'The Linux Foundation & CNCF',
          issueDate: '2022',
          url: 'cncf.io/certification/cka',
        ),
      ],
      publications: [
        Publication(
          title: 'Designing High-Throughput Event-Driven Architectures with Kafka and Kubernetes',
          authors: 'Alexander Wright, David Chen',
          publisher: 'IEEE Software Architecture Journal',
          date: '2023',
          url: 'https://doi.org/10.1109/MS.2023.12345',
        ),
      ],
      awards: [
        Award(
          title: 'Cloud Architecture Excellence Award',
          issuer: 'UK Tech Leadership Forum',
          date: '2022',
          description: 'Awarded for exceptional contribution to cloud optimization and multi-cloud resilience architecture.',
        ),
      ],
      volunteering: [
        Volunteering(
          role: 'Open Source Mentor & Speaker',
          organization: 'Code First Girls UK',
          startDate: '2020',
          endDate: 'Present',
          isCurrent: true,
          description: 'Mentoring underrepresented engineering students and speaking at quarterly technical meetups.',
        ),
      ],
      references: [
        Reference(
          name: 'Sarah Jenkins',
          position: 'VP of Engineering',
          organization: 'Apex Digital Infrastructure',
          email: 's.jenkins@apexdigital.co.uk',
          phone: '+44 20 7123 4567',
        ),
      ],
    );
  }

  static CvModel createFrenchSample() {
    return CvModel(
      title: 'Élodie Martin - Chef de Projet Digital & Ingénieur Logiciel',
      language: AppConstants.langFr,
      style: const CvStyle(
        templateId: AppConstants.templateModern,
        primaryColorHex: '#0F766E', // Deep Teal
        fontFamily: 'Roboto',
        showIcons: true,
      ),
      personalInfo: const PersonalInfo(
        firstName: 'Élodie',
        lastName: 'Martin',
        fullName: 'Élodie Martin',
        jobTitle: 'Chef de Projet Digital & Ingénieur Logiciel',
        email: 'elodie.martin@conseil-tech.fr',
        phone: '+33 6 12 34 56 78',
        address: 'Paris, France',
        dateOfBirth: '1993-08-22',
        nationality: 'Française',
        website: 'https://elodiemartin.fr',
        linkedin: 'linkedin.com/in/elodie-martin-digital',
        github: 'github.com/elodie-martin',
        summary:
            'Ingénieure logicielle et cheffe de projet certifiée Scrum Master avec 7 ans d\'expérience dans le pilotage de transformations numériques et le développement d\'applications cross-platform. Expertise reconnue dans la gestion agile de projets complexes, l\'alignement métier-tech et l\'excellence opérationnelle.',
        showPhoto: false,
      ),
      experiences: [
        Experience(
          position: 'Chef de Projet Technique & Lead Développeuse',
          company: 'Capgemini Digital Services',
          location: 'Paris, France',
          startDate: 'Sept 2021',
          endDate: 'Présent',
          isCurrent: true,
          description:
              'Direction d\'une équipe agile de 10 ingénieurs dans la conception d\'une plateforme bancaire mobile sécurisée.',
          highlights: [
            'Livraison avec 3 semaines d\'avance de la nouvelle application client (1,2 million d\'utilisateurs actifs mensuels).',
            'Mise en place des cérémonies agiles (Scrum, Kanban) et réduction du délai de livraison des fonctionnalités de 40%.',
            'Pilotage du budget technique de 850 000 € et coordination étroite avec les parties prenantes métier.',
          ],
        ),
        Experience(
          position: 'Ingénieure d\'Études et Développement Flutter / Web',
          company: 'Sopra Steria',
          location: 'Lyon, France',
          startDate: 'Oct 2017',
          endDate: 'Août 2021',
          isCurrent: false,
          description:
              'Conception et développement d\'applications métiers ergonomiques et réactives pour le secteur de l\'énergie.',
          highlights: [
            'Développement d\'une application mobile multiplateforme sous Flutter pour 2 500 techniciens sur le terrain.',
            'Intégration d\'APIs REST temps réel avec synchronisation locale hors-ligne et gestion des conflits.',
            'Animation d\'ateliers UX/UI et formation des équipes internes aux bonnes pratiques Clean Architecture.',
          ],
        ),
      ],
      educations: [
        Education(
          degree: 'Diplôme d\'Ingénieur',
          fieldOfStudy: 'Informatique et Systèmes d\'Information',
          institution: 'INSA Lyon',
          country: 'France',
          location: 'Lyon, France',
          startDate: '2014',
          endDate: '2017',
          grade: 'Mention Très Bien',
          description: 'Spécialisation en génie logiciel, architectures réparties et gestion de projets innovants.',
        ),
        Education(
          degree: 'Licence',
          fieldOfStudy: 'Mathématiques & Informatique',
          institution: 'Sorbonne Université',
          country: 'France',
          location: 'Paris, France',
          startDate: '2011',
          endDate: '2014',
          grade: 'Mention Bien',
          description: 'Fondements algorithmiques, statistiques appliquées et programmation objet.',
        ),
      ],
      skills: [
        Skill(name: 'Gestion de Projet Agile & Scrum', level: 5, category: 'Management'),
        Skill(name: 'Flutter, Dart & Clean Architecture', level: 5, category: 'Technique'),
        Skill(name: 'TypeScript, React & Node.js', level: 4, category: 'Technique'),
        Skill(name: 'CI/CD, Docker & Gitlab CI', level: 4, category: 'DevOps'),
        Skill(name: 'Communication & Conduite du Changement', level: 5, category: 'Soft Skills'),
      ],
      languages: [
        LanguageItem(name: 'Français', proficiency: LanguageProficiency.native),
        LanguageItem(name: 'Anglais', proficiency: LanguageProficiency.fluent),
        LanguageItem(name: 'Espagnol', proficiency: LanguageProficiency.intermediate),
      ],
      projects: [
        Project(
          title: 'Portail Client Énergie Mobile',
          url: 'https://energiemobile.fr',
          technologies: 'Flutter, Spring Boot, PostgreSQL',
          description:
              'Application de gestion de consommation énergétique en temps réel adoptée par 400 000 foyers en France.',
        ),
      ],
      certifications: [
        Certification(
          name: 'Professional Scrum Master I (PSM I)',
          issuer: 'Scrum.org',
          issueDate: '2022',
          url: 'scrum.org/certificates/psm1',
        ),
        Certification(
          name: 'ITIL 4 Foundation Certificate',
          issuer: 'AXELOS Global Best Practice',
          issueDate: '2020',
          url: 'axelos.com',
        ),
      ],
      publications: [
        Publication(
          title: 'L\'agilité à l\'échelle dans les écosystèmes bancaires européens',
          authors: 'Élodie Martin, Jean Dupont',
          publisher: 'Revue Française de Gestion de Projet',
          date: '2022',
          url: 'https://doi.org/10.3917/rfgp.2022.045',
        ),
      ],
      awards: [
        Award(
          title: 'Prix de l\'Innovation Numérique',
          issuer: 'Fédération Syntec Numérique',
          date: '2021',
          description: 'Récompense décernée pour la conception d\'une solution mobile éco-responsable pour les techniciens.',
        ),
      ],
      volunteering: [
        Volunteering(
          role: 'Animatrice d\'Ateliers Numériques',
          organization: 'Emmaüs Connect',
          startDate: '2019',
          endDate: 'Présent',
          isCurrent: true,
          description: 'Accompagnement de personnes en situation d\'exclusion numérique dans l\'apprentissage des outils essentiels.',
        ),
      ],
      references: [
        Reference(
          name: 'Marc Lefebvre',
          position: 'Directeur de Département Tech',
          organization: 'Capgemini Digital Services',
          email: 'marc.lefebvre@capgemini.com',
          phone: '+33 1 40 50 60 70',
        ),
      ],
    );
  }

  static CvModel createArabicSample() {
    return CvModel(
      title: 'طارق المنصور - مهندس برمجيات ونظم ذكاء اصطناعي',
      language: AppConstants.langAr,
      style: const CvStyle(
        templateId: AppConstants.templateModern,
        primaryColorHex: '#1E3A8A', // Deep Navy
        fontFamily: 'Cairo',
        showIcons: true,
      ),
      personalInfo: const PersonalInfo(
        firstName: 'طارق',
        lastName: 'المنصور',
        fullName: 'طارق عبد الله المنصور',
        jobTitle: 'مهندس برمجيات أول وخبير بنية النظم السحابية',
        email: 'tariq.mansoor@techdev.net',
        phone: '+966 50 123 4567',
        address: 'الرياض، المملكة العربية السعودية',
        dateOfBirth: '1991-03-10',
        nationality: 'سعودي',
        website: 'https://tariqmansoor.dev',
        linkedin: 'linkedin.com/in/tariq-mansoor',
        github: 'github.com/tariq-mansoor',
        summary:
            'مهندس برمجيات أول بخبرة تزيد عن 8 سنوات في تصميم وتطوير النظم السحابية فائقة الأداء وتطبيقات المنصات المتعددة. قيادي متميز في إدارة فرق العمل التقنية وتحويل المتطلبات المعقدة إلى حلول برمجية متينة وقابلة للتوسع، مع خبرة واسعة في Flutter وGo والذكاء الاصطناعي التوليدي.',
        showPhoto: false,
      ),
      experiences: [
        Experience(
          position: 'مهندس برمجيات أول وقائد الفريق التقني',
          company: 'شركة المنظومة الرقمية للحلول السحابية',
          location: 'الرياض، السعودية',
          startDate: 'يناير 2022',
          endDate: 'حتى الآن',
          isCurrent: true,
          description:
              'قيادة فريق تطوير مكون من 12 مهندساً لبناء المنصة الوطنية الموحدة لخدمات قطاع الأعمال.',
          highlights: [
            'تصميم بنية تحتية سحابية قائمة على الحاويات الموزعة (Kubernetes) تخدم أكثر من 3 ملايين مستخدم نشط شهرياً.',
            'تحسين زمن استجابة واجهات البرمجة بنسبة 45% من خلال تطبيق التخزين المؤقت المتقدم واستراتيجيات استعلامات متطورة.',
            'بناء خطوط التكامل والنشر المستمر (CI/CD) وتقليص زمن إصدار التحديثات بنسبة 60%.',
          ],
        ),
        Experience(
          position: 'مطور تطبيقات أول (Flutter & Cloud)',
          company: 'مجموعة النخبة للتقنية والابتكار',
          location: 'دبي، الإمارات العربية المتحدة',
          startDate: 'مارس 2018',
          endDate: 'ديسمبر 2021',
          isCurrent: false,
          description:
              'تطوير وتوسيع نطاق الحلول الرقمية المصرفية والمالية لمنصات الهواتف وأجهزة سطح المكتب.',
          highlights: [
            'بناء تطبيق محفظة رقمية متعدد المنصات حصد جائزة أفضل تطبيق مالي لعام 2020 وتجاوز 500 ألف تحميل.',
            'تطبيق معايير الأمان المالي وتشفير البيانات المتوافقة مع PCI-DSS بأعلى درجات الموثوقية.',
            'تدريب وإرشاد المطورين الجدد في أطر العمل الحديثة ومفاهيم الهندسة النظيفة (Clean Architecture).',
          ],
        ),
      ],
      educations: [
        Education(
          degree: 'ماجستير',
          fieldOfStudy: 'علوم الحاسب وهندسة البرمجيات',
          institution: 'جامعة الملك سعود',
          country: 'المملكة العربية السعودية',
          location: 'الرياض، السعودية',
          startDate: '2016',
          endDate: '2018',
          grade: 'مرتبة الشرف الأولى (معدل 4.95/5.00)',
          description: 'أطروحة متقدمة في النظم الموزعة ومعالجة البيانات الضخمة في البيئات عالية التوافر.',
        ),
        Education(
          degree: 'بكالوريوس',
          fieldOfStudy: 'تقنية المعلومات والبرمجيات',
          institution: 'جامعة القاهرة - كلية الحاسبات والمعلومات',
          country: 'مصر',
          location: 'القاهرة، مصر',
          startDate: '2012',
          endDate: '2016',
          grade: 'امتياز مع مرتبة الشرف',
          description: 'دراسة مكثفة في الخوارزميات، هياكل البيانات، هندسة البرمجيات وقواعد البيانات.',
        ),
      ],
      skills: [
        Skill(name: 'هندسة البرمجيات والنظم الموزعة', level: 5, category: 'هندسة النظم'),
        Skill(name: 'تطوير Flutter وDart (مكتبي، محمول، ويب)', level: 5, category: 'تطوير الواجهات'),
        Skill(name: 'لغات البرمجة: Go, Python, TypeScript', level: 5, category: 'الخوادم'),
        Skill(name: 'الحوسبة السحابية: AWS, Google Cloud, Docker', level: 4, category: 'السحابة'),
        Skill(name: 'إدارة وتوجيه الفرق البرمجية والمنهجيات الرشيقة Agile', level: 5, category: 'القيادة'),
      ],
      languages: [
        LanguageItem(name: 'العربية', proficiency: LanguageProficiency.native),
        LanguageItem(name: 'الإنجليزية', proficiency: LanguageProficiency.fluent),
      ],
      projects: [
        Project(
          title: 'نظام إدارة المهام والأعمال الموزعة (مفتوح المصدر)',
          url: 'https://github.com/tariq-mansoor/task-mesh',
          technologies: 'Flutter, Go, gRPC, SQLite',
          description:
              'منظومة مفتوحة المصدر لإدارة سير العمل الجماعي تعمل محلياً دون الحاجة لاتصال مستمر بالإنترنت.',
        ),
        Project(
          title: 'محرك التحليل الذكي للبيانات المالية',
          url: 'https://finpulse-analytics.com',
          technologies: 'Python, FastAPI, Redis',
          description:
              'منصة تحليل فوري للمؤشرات المالية تتيح اتخاذ قرارات استثمارية دقيقة بدعم نماذج الذكاء الاصطناعي.',
        ),
      ],
      certifications: [
        Certification(
          name: 'شهادة مهندس حلول معتمد - Professional',
          issuer: 'Amazon Web Services (AWS)',
          issueDate: '2023',
          url: 'aws.amazon.com/verification',
        ),
        Certification(
          name: 'إدارة المشاريع الاحترافية (PMP)',
          issuer: 'Project Management Institute (PMI)',
          issueDate: '2021',
          url: 'pmi.org/verify',
        ),
      ],
      publications: [
        Publication(
          title: 'استراتيجيات تحسين الأداء في النظم السحابية الموزعة عالية التوافر',
          authors: 'طارق عبد الله المنصور، د. خالد السديري',
          publisher: 'المجلة العربية لهندسة البرمجيات والحاسب',
          date: '2023',
          url: 'https://doi.org/10.21608/ajse.2023.9876',
        ),
      ],
      awards: [
        Award(
          title: 'جائزة التميز في الابتكار التقني',
          issuer: 'هيئة الاتصالات والفضاء والتقنية',
          date: '2022',
          description: 'تكريم لأفضل مساهمة في تطوير حلول وطنية مفتوحة المصدر لبيئات العمل الرقمية.',
        ),
      ],
      volunteering: [
        Volunteering(
          role: 'مرشد تقني ومحاضر متطوع',
          organization: 'مبادرة العطاء الرقمي',
          startDate: '2020',
          endDate: 'حتى الآن',
          isCurrent: true,
          description: 'تقديم ورش عمل ودورات مجانية في تطوير تطبيقات الهاتف والحوسبة السحابية لأكثر من 1500 مستفيد.',
        ),
      ],
      references: [
        Reference(
          name: 'د. عبد الرحمن الغامدي',
          position: 'المدير التنفيذي للتقنية',
          organization: 'شركة المنظومة الرقمية للحلول السحابية',
          email: 'a.ghamdi@digital-system.sa',
          phone: '+966 11 234 5678',
        ),
      ],
    );
  }
}
