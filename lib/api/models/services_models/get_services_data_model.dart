class GetServicesDataModel {
  final int id;
  final String documentId;
  final String name;
  final String description;
  final String price;
  final int count;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? publishedAt;
  final bool? isActive;

  GetServicesDataModel({
    required this.id,
    required this.documentId,
    required this.name,
    required this.description,
    required this.price,
    required this.count,
    required this.createdAt,
    required this.updatedAt,
    this.publishedAt,
    this.isActive,
  });

  factory GetServicesDataModel.fromJson(Map<String, dynamic> json) {
    return GetServicesDataModel(
      id: json['id'],
      documentId: json['documentId'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      count: json['count'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      publishedAt: json['publishedAt'] != null ? DateTime.parse(json['publishedAt']) : null,
      isActive: json['isactive'],
    );
  }
}
