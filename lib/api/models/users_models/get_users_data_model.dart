class GetUserDataModel {
  final int id;
  final String documentId;
  final String username;
  final String email;
  final String provider;
  final bool confirmed;
  final bool blocked;
  final String createdAt;
  final String updatedAt;
  final String publishedAt;

  GetUserDataModel({
    required this.id,
    required this.documentId,
    required this.username,
    required this.email,
    required this.provider,
    required this.confirmed,
    required this.blocked,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
  });

  // متد سازنده برای تبدیل داده‌های JSON به مدل
  factory GetUserDataModel.fromJson(Map<String, dynamic> json) {
    return GetUserDataModel(
      id: json['id'],
      documentId: json['documentId'],
      username: json['username'],
      email: json['email'],
      provider: json['provider'],
      confirmed: json['confirmed'],
      blocked: json['blocked'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      publishedAt: json['publishedAt'],
    );
  }

  // متد تبدیل مدل به داده‌های JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentId': documentId,
      'username': username,
      'email': email,
      'provider': provider,
      'confirmed': confirmed,
      'blocked': blocked,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'publishedAt': publishedAt,
    };
  }
}
