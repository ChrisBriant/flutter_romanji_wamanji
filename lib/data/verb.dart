class Verb {
  final int id;
  final String english;
  final String japanese;
  final String present;
  final String past;
  final String negative;
  final String politePresent;
  final String politeNegative;
  final String politePast;
  final String politePastNegative;
  final String teForm;
  final String volitional;
  final DateTime createdAt;
  final DateTime updatedAt;

  Verb({
    required this.id,
    required this.english,
    required this.japanese,
    required this.present,
    required this.past,
    required this.negative,
    required this.politePresent,
    required this.politeNegative,
    required this.politePast,
    required this.politePastNegative,
    required this.teForm,
    required this.volitional,
    required this.createdAt,
    required this.updatedAt
  });

  /// Create from JSON (API response)
  factory Verb.fromJson(Map<String, dynamic> json) {
    return Verb(
      id: json['id'],
      english: json['english'],
      japanese: json['japanese'],
      present: json['present'],
      past: json['past'],
      negative: json['negative'],
      politePresent: json['polite_present'],
      politeNegative: json['polite_negative'],
      politePast: json['polite_past'],
      politePastNegative: json['polite_past_negative'],
      teForm: json['te_form'],
      volitional: json['volitional'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']), 
    );
  }

  /// Convert to JSON (for sending to API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'english': english,
      'japanese': japanese,
      'present': present,
      'past': past,
      'negative': negative,
      'polite_present': politePresent,
      'polite_negative': politeNegative,
      'polite_past': politePast,
      'polite_past_negative': politePastNegative,
      'te_form': teForm,
      'volitional': volitional,
    };
  }
}