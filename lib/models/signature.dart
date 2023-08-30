class SignatureModel {
  final String type;
  final String active;

  SignatureModel({
    required this.type,
    required this.active,
  });

  factory SignatureModel.fromJson(Map<String, dynamic> json) {
    return SignatureModel(
      type: json['type'],
      active: json['active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'active': active,
    };
  }
}
