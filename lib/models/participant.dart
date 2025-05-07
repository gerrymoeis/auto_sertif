class Participant {
  final String name;
  final String? role;
  final String? additionalInfo;

  Participant({
    required this.name, 
    this.role, 
    this.additionalInfo
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'role': role,
      'additionalInfo': additionalInfo,
    };
  }

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      name: json['name'] as String,
      role: json['role'] as String?,
      additionalInfo: json['additionalInfo'] as String?,
    );
  }
}
