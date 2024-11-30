class GetReportsDataModel {
  final int totalTickets;
  final int totalUsers;
  final int totalSale;
  final List<TopService> topServices;

  GetReportsDataModel({
    required this.totalTickets,
    required this.totalUsers,
    required this.totalSale,
    required this.topServices,
  });

  factory GetReportsDataModel.fromJson(Map<String, dynamic> json) {
    return GetReportsDataModel(
      totalTickets: json['totalTickets'] ?? 0,
      totalUsers: json['totalUsers'] ?? 0,
      totalSale: json['totalSale'] ?? 0,
      topServices: (json['topServices'] as List)
          .map((service) => TopService.fromJson(service))
          .toList(),
    );
  }
}

class TopService {
  final int count;
  final Service service;

  TopService({required this.count, required this.service});

  factory TopService.fromJson(Map<String, dynamic> json) {
    return TopService(
      count: json['count'] ?? 0,
      service: Service.fromJson(json['service']),
    );
  }
}

class Service {
  final int id;
  final String documentId;
  final String name;
  final String description;
  final String price;
  final int count;
  final String createdAt;
  final String updatedAt;
  final String publishedAt;

  Service({
    required this.id,
    required this.documentId,
    required this.name,
    required this.description,
    required this.price,
    required this.count,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] ?? 0,
      documentId: json['documentId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? '',
      count: json['count'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
    );
  }
}
