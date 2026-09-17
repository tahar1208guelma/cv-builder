import '../../../../core/constants/app_constants.dart';

class CvStyle {
  final String templateId;
  final String primaryColorHex;
  final String fontFamily;
  final bool showIcons;
  final bool compactMode;
  final double fontSizeScale;

  const CvStyle({
    this.templateId = AppConstants.templateModern,
    this.primaryColorHex = '#1E3A8A',
    this.fontFamily = 'Cairo',
    this.showIcons = true,
    this.compactMode = false,
    this.fontSizeScale = 1.0,
  });

  CvStyle copyWith({
    String? templateId,
    String? primaryColorHex,
    String? fontFamily,
    bool? showIcons,
    bool? compactMode,
    double? fontSizeScale,
  }) {
    return CvStyle(
      templateId: templateId ?? this.templateId,
      primaryColorHex: primaryColorHex ?? this.primaryColorHex,
      fontFamily: fontFamily ?? this.fontFamily,
      showIcons: showIcons ?? this.showIcons,
      compactMode: compactMode ?? this.compactMode,
      fontSizeScale: fontSizeScale ?? this.fontSizeScale,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'templateId': templateId,
      'primaryColorHex': primaryColorHex,
      'fontFamily': fontFamily,
      'showIcons': showIcons,
      'compactMode': compactMode,
      'fontSizeScale': fontSizeScale,
    };
  }

  factory CvStyle.fromJson(Map<String, dynamic> json) {
    return CvStyle(
      templateId: json['templateId'] as String? ?? AppConstants.templateModern,
      primaryColorHex: json['primaryColorHex'] as String? ?? '#1E3A8A',
      fontFamily: json['fontFamily'] as String? ?? 'Cairo',
      showIcons: json['showIcons'] as bool? ?? true,
      compactMode: json['compactMode'] as bool? ?? false,
      fontSizeScale: (json['fontSizeScale'] as num?)?.toDouble() ?? 1.0,
    );
  }

  static const CvStyle defaultStyle = CvStyle();
}
