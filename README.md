# CV Builder - Professional Cross-Platform Resume Application

A production-grade, local-first, cross-platform Flutter application for creating and exporting professional resumes and CV documents in **English**, **French**, and **Arabic (RTL)** with high-fidelity PDF generation.

---

## Key Features

1. **Independent Interface & CV Languages**:
   - **UI Languages**: Arabic, French, and English with instant RTL/LTR switching.
   - **CV Document Languages**: Arabic (RTL), French (LTR), and English (LTR).
   - The UI language and CV language operate completely independently (e.g. an Arabic user can create an English CV while the UI remains in Arabic, or vice-versa).

2. **Full Photo & No-Photo Support**:
   - Upload profile photos with instant thumbnail preview and responsive cropping.
   - Dynamic auto-layout: When photo is disabled or absent, headers gracefully expand across the full width without blank gaps.

3. **Multiple CV Document Management**:
   - **Create**: Blank resumes or pre-filled templates with realistic data in Arabic, French, or English.
   - **Edit**: Structured multi-section editor (Personal, Experience, Education, Skills, Languages, Projects, Certifications, Custom Sections, Style & Layout).
   - **Duplicate**: Deep-clone any existing CV with new unique identifiers and "(Copy)" naming.
   - **Delete**: Safely delete resumes with confirmation prompts.
   - **Save Locally**: Local-first JSON persistence with atomic file writes for zero corruption.

4. **Professional PDF Generation & Templates**:
   - Built-in reusable template architecture supporting 4 primary + 3 additional templates:
     - **Professional**: Clean corporate layout with subtle accent headers, ideal for business and enterprise roles.
     - **Modern**: Elegant split styling with skill level indicators, dynamic badge chips, and header accent.
     - **Academic**: Comprehensive layout designed for researchers, PhD holders, and university faculty with publications, research grants, awards, and affiliations.
     - **ATS-Friendly**: Pure text-oriented structure without tables or complex graphics, engineered for maximum ATS parser compliance.
     - **Classic, Minimalist, Executive**: Additional layouts for versatile professional needs.
   - 100% offline generation with bundled Cairo and Roboto fonts.
   - Full bidirectional (bidi) shaping and RTL orientation for Arabic documents with LTR preservation for contact info and links.
   - Intelligent page-breaking: Section headers and items are kept intact without awkward mid-item page splits.
   - Native Print, Share, and Save to Disk capabilities.

5. **Live CV Preview System**:
   - Real-time split-screen preview on desktop/tablet and responsive bottom-sheet/tab preview on mobile.
   - Debounced reactive rendering (200ms input debounce, 0ms immediate action response).
   - Interactive zoom controls (Fit, Zoom In/Out, Reset), page navigation counter, template selector, and photo layout switcher without data loss.

6. **Responsive & Adaptive UI**:
   - **Desktop (Windows, macOS)**: Master-detail split-view with live PDF preview pane.
   - **Mobile (Android)**: Adaptive navigation bar with quick preview modal.

---

## Clean Architecture Structure

```
lib/
├── core/
│   ├── constants/       # App colors, templates, storage keys
│   ├── localization/    # Tri-lingual dictionary (EN, FR, AR) and RTL directionality
│   ├── theme/           # Material 3 light and dark themes
│   └── utils/           # Date formatting, responsive layout builders
├── features/
│   ├── cv/
│   │   ├── domain/      # Domain entities (CvModel, PersonalInfo, Experience, etc.) & Repo interface
│   │   ├── data/        # Local JSON datasource, atomic writes, sample CV factory
│   │   └── presentation/# Riverpod providers, Dashboard, Editor, and Section widgets
│   └── pdf_export/      # PDF generator service, font manager, and 4 layout templates
└── main.dart            # App entry point with ProviderScope and Localization delegates
```

---

## Running the Application

### Prerequisites
- Flutter SDK (>= 3.10.0)
- Platform toolchain (Visual Studio C++ for Windows, Xcode for macOS, Android Studio for Android)

### Commands
```bash
# Get dependencies
flutter pub get

# Run unit tests
flutter test

# Run on Windows Desktop
flutter run -d windows

# Run on macOS
flutter run -d macos

# Run on Android
flutter run -d android
```
