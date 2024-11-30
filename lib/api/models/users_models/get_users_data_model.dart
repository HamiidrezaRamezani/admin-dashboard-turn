class GetUserDataModel {
  final int id;
  final String documentId;
  final String username;
  final String email;
  final String provider;
  final String password;
  final String? resetPasswordToken;
  final String? confirmationToken;
  final bool confirmed;
  final bool blocked;
  final String createdAt;
  final String updatedAt;
  final String publishedAt;
  final String? locale;
  final String? name;
  final String? nationalCode;
  final int totalTickets;
  final int totalAmountSpent;
  final String serviceListString;

  GetUserDataModel({
    required this.id,
    required this.documentId,
    required this.username,
    required this.email,
    required this.provider,
    required this.password,
    this.resetPasswordToken,
    this.confirmationToken,
    required this.confirmed,
    required this.blocked,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    this.locale,
    this.name,
    this.nationalCode,
    required this.totalTickets,
    required this.totalAmountSpent,
    required this.serviceListString,
  });

  // از JSON داده را به مدل Dart تبدیل می‌کند
  factory GetUserDataModel.fromJson(Map<String, dynamic> json) {
    return GetUserDataModel(
      id: json['id'],
      documentId: json['documentId'],
      username: json['username'],
      email: json['email'],
      provider: json['provider'],
      password: json['password'],
      resetPasswordToken: json['resetPasswordToken'],
      confirmationToken: json['confirmationToken'],
      confirmed: json['confirmed'],
      blocked: json['blocked'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      publishedAt: json['publishedAt'],
      locale: json['locale'],
      name: json['name'],
      nationalCode: json['national_code'],
      totalTickets: json['totalTickets'],
      totalAmountSpent: json['totalAmountSpent'],
      serviceListString: json['serviceListString'],
    );
  }

  // مدل را به JSON تبدیل می‌کند
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentId': documentId,
      'username': username,
      'email': email,
      'provider': provider,
      'password': password,
      'resetPasswordToken': resetPasswordToken,
      'confirmationToken': confirmationToken,
      'confirmed': confirmed,
      'blocked': blocked,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'publishedAt': publishedAt,
      'locale': locale,
      'name': name,
      'national_code': nationalCode,
      'totalTickets': totalTickets,
      'totalAmountSpent': totalAmountSpent,
      'serviceListString': serviceListString,
    };
  }
}
