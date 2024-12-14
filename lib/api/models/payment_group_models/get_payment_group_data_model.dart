class GetPaymentGroupDataModel {
  final int id;
  final String documentId;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime publishedAt;
  final String description;

  GetPaymentGroupDataModel({
    required this.id,
    required this.documentId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    required this.description,
  });

  // تبدیل از JSON به مدل
  factory GetPaymentGroupDataModel.fromJson(Map<String, dynamic> json) {
    return GetPaymentGroupDataModel(
      id: json['id'],
      documentId: json['documentId'],
      name: json['name'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      publishedAt: DateTime.parse(json['publishedAt']),
      description: json['description'],
    );
  }

  // تبدیل از مدل به JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentId': documentId,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'publishedAt': publishedAt.toIso8601String(),
      'description': description,
    };
  }
}
