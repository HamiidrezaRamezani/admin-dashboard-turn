class GetServicesDataModel {
  final int id;
  final String documentId;
  final String name;
  final String description;
  final String basePrice;
  final int count;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime publishedAt;
  final bool isActive;
  final List<Picture>? pics;
  final List<Option>? options;

  GetServicesDataModel({
    required this.id,
    required this.documentId,
    required this.name,
    required this.description,
    required this.basePrice,
    required this.count,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    required this.isActive,
    required this.pics,
    required this.options
  });

  factory GetServicesDataModel.fromJson(Map<String, dynamic> json) {
    return GetServicesDataModel(
      id: json['id'],
      documentId: json['documentId'],
      name: json['name'],
      description: json['description'],
      basePrice: json['base_price'],
      count: json['count'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      publishedAt: DateTime.parse(json['publishedAt']),
      isActive: json['isactive'],
      pics:  (json['pic'] != null && json['pic'] is List)
          ? (json['pic'] as List).map((e) => Picture.fromJson(e)).toList()
          : [],
      options: (json['options'] != null && json['options'] is List)
          ? (json['options'] as List).map((e) => Option.fromJson(e)).toList()
          : [],
    );
  }
}

class Picture {
  final int id;
  final String documentId;
  final String name;
  final String? alternativeText;
  final String? caption;
  final int width;
  final int height;
  final Formats? formats;
  final String url;

  Picture({
    required this.id,
    required this.documentId,
    required this.name,
    this.alternativeText,
    this.caption,
    required this.width,
    required this.height,
    this.formats,
    required this.url,
  });

  factory Picture.fromJson(Map<String, dynamic> json) {
    return Picture(
      id: json['id'],
      documentId: json['documentId'],
      name: json['name'],
      alternativeText: json['alternativeText'],
      caption: json['caption'],
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
      formats: json['formats'] != null ? Formats.fromJson(json['formats']) : null,
      url: json['url'],
    );
  }
}

class Option {
  final String name;
  final int price;

  Option({
    required this.name,
    required this.price,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      name: json['name'],
      price: json['price'],
    );
  }
}

class Formats {
  final Format? thumbnail;
  final Format? small;
  final Format? medium;
  final Format? large;

  Formats({
    this.thumbnail,
    this.small,
    this.medium,
    this.large,
  });

  factory Formats.fromJson(Map<String, dynamic> json) {
    return Formats(
      thumbnail: json['thumbnail'] != null ? Format.fromJson(json['thumbnail']) : null,
      small: json['small'] != null ? Format.fromJson(json['small']) : null,
      medium: json['medium'] != null ? Format.fromJson(json['medium']) : null,
      large: json['large'] != null ? Format.fromJson(json['large']) : null,
    );
  }
}

class Format {
  final String name;
  final String hash;
  final String ext;
  final String mime;
  final int width;
  final int height;
  final double size;
  final String url;

  Format({
    required this.name,
    required this.hash,
    required this.ext,
    required this.mime,
    required this.width,
    required this.height,
    required this.size,
    required this.url,
  });

  factory Format.fromJson(Map<String, dynamic> json) {
    return Format(
      name: json['name'],
      hash: json['hash'],
      ext: json['ext'],
      mime: json['mime'],
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
      size: json['size'] != null ? json['size'].toDouble() : 0.0,
      url: json['url'],
    );
  }
}