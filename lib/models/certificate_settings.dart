import 'dart:ui';

class CertificateSettings {
  final String eventName; // Nama acara
  
  final double nameX;
  final double nameY;
  final double nameFontSize;
  final Color nameColor;
  final String nameFontFamily;
  
  final bool includeRole;
  final double? roleX;
  final double? roleY;
  final double? roleFontSize;
  final Color? roleColor;
  final String? roleFontFamily;
  
  final bool includeAdditionalInfo;
  final double? additionalInfoX;
  final double? additionalInfoY;
  final double? additionalInfoFontSize;
  final Color? additionalInfoColor;
  final String? additionalInfoFontFamily;

  CertificateSettings({
    required this.eventName,
    required this.nameX,
    required this.nameY,
    required this.nameFontSize,
    required this.nameColor,
    required this.nameFontFamily,
    
    this.includeRole = false,
    this.roleX,
    this.roleY,
    this.roleFontSize,
    this.roleColor,
    this.roleFontFamily,
    
    this.includeAdditionalInfo = false,
    this.additionalInfoX,
    this.additionalInfoY,
    this.additionalInfoFontSize,
    this.additionalInfoColor,
    this.additionalInfoFontFamily,
  });

  Map<String, dynamic> toJson() {
    return {
      'eventName': eventName,
      'nameX': nameX,
      'nameY': nameY,
      'nameFontSize': nameFontSize,
      'nameColor': nameColor.value,
      'nameFontFamily': nameFontFamily,
      
      'includeRole': includeRole,
      'roleX': roleX,
      'roleY': roleY,
      'roleFontSize': roleFontSize,
      'roleColor': roleColor?.value,
      'roleFontFamily': roleFontFamily,
      
      'includeAdditionalInfo': includeAdditionalInfo,
      'additionalInfoX': additionalInfoX,
      'additionalInfoY': additionalInfoY,
      'additionalInfoFontSize': additionalInfoFontSize,
      'additionalInfoColor': additionalInfoColor?.value,
      'additionalInfoFontFamily': additionalInfoFontFamily,
    };
  }

  factory CertificateSettings.fromJson(Map<String, dynamic> json) {
    return CertificateSettings(
      eventName: json['eventName'] as String? ?? 'Acara Sertifikat',
      nameX: json['nameX'] as double,
      nameY: json['nameY'] as double,
      nameFontSize: json['nameFontSize'] as double,
      nameColor: Color(json['nameColor'] as int),
      nameFontFamily: json['nameFontFamily'] as String,
      
      includeRole: json['includeRole'] as bool,
      roleX: json['roleX'] as double?,
      roleY: json['roleY'] as double?,
      roleFontSize: json['roleFontSize'] as double?,
      roleColor: json['roleColor'] != null ? Color(json['roleColor'] as int) : null,
      roleFontFamily: json['roleFontFamily'] as String?,
      
      includeAdditionalInfo: json['includeAdditionalInfo'] as bool,
      additionalInfoX: json['additionalInfoX'] as double?,
      additionalInfoY: json['additionalInfoY'] as double?,
      additionalInfoFontSize: json['additionalInfoFontSize'] as double?,
      additionalInfoColor: json['additionalInfoColor'] != null 
          ? Color(json['additionalInfoColor'] as int) 
          : null,
      additionalInfoFontFamily: json['additionalInfoFontFamily'] as String?,
    );
  }
}
