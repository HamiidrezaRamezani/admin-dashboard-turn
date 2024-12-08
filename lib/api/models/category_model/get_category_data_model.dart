class GetCategoryDataModel {
  int id;
  String documentId;
  String name;
  String description;
  String createdAt;
  String updatedAt;
  String publishedAt;
  List<Pic> pics;
  List<Service> services;

  GetCategoryDataModel({
    required this.id,
    required this.documentId,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    required this.pics,
    required this.services,
  });

  factory GetCategoryDataModel.fromJson(Map<String, dynamic> json) {
    return GetCategoryDataModel(
      id: json['id'],
      documentId: json['documentId'],
      name: json['name'],
      description: json['description'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      publishedAt: json['publishedAt'],
      pics: (json['pics'] as List).map((e) => Pic.fromJson(e)).toList(),
      services: (json['services'] as List).map((e) => Service.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentId': documentId,
      'name': name,
      'description': description,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'publishedAt': publishedAt,
      'pics': pics.map((e) => e.toJson()).toList(),
      'services': services.map((e) => e.toJson()).toList(),
    };
  }
}

class Pic {
  int id;
  String documentId;
  String name;
  String? alternativeText;
  String? caption;
  int width;
  int height;
  Formats formats;

  Pic({
    required this.id,
    required this.documentId,
    required this.name,
    this.alternativeText,
    this.caption,
    required this.width,
    required this.height,
    required this.formats,
  });

  factory Pic.fromJson(Map<String, dynamic> json) {
    return Pic(
      id: json['id'],
      documentId: json['documentId'],
      name: json['name'],
      alternativeText: json['alternativeText'],
      caption: json['caption'],
      width: json['width'],
      height: json['height'],
      formats: Formats.fromJson(json['formats']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentId': documentId,
      'name': name,
      'alternativeText': alternativeText,
      'caption': caption,
      'width': width,
      'height': height,
      'formats': formats.toJson(),
    };
  }
}

class Formats {
  Format thumbnail;
  Format medium;
  Format small;
  Format large;

  Formats({
    required this.thumbnail,
    required this.medium,
    required this.small,
    required this.large,
  });

  factory Formats.fromJson(Map<String, dynamic> json) {
    return Formats(
      thumbnail: Format.fromJson(json['thumbnail']),
      medium: Format.fromJson(json['medium']),
      small: Format.fromJson(json['small']),
      large: Format.fromJson(json['large']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'thumbnail': thumbnail.toJson(),
      'medium': medium.toJson(),
      'small': small.toJson(),
      'large': large.toJson(),
    };
  }
}

class Format {
  String name;
  String hash;
  String ext;
  String mime;
  int width;
  int height;
  double size;
  String url;

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
      width: json['width'],
      height: json['height'],
      size: json['size'].toDouble(),
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'hash': hash,
      'ext': ext,
      'mime': mime,
      'width': width,
      'height': height,
      'size': size,
      'url': url,
    };
  }
}

class Service {
  int id;
  String documentId;
  String name;
  String description;
  int count;
  String createdAt;
  String updatedAt;
  String publishedAt;
  bool isactive;
  String basePrice;
  List<Option> options;

  Service({
    required this.id,
    required this.documentId,
    required this.name,
    required this.description,
    required this.count,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    required this.isactive,
    required this.basePrice,
    required this.options,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      documentId: json['documentId'],
      name: json['name'],
      description: json['description'],
      count: json['count'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      publishedAt: json['publishedAt'],
      isactive: json['isactive'],
      basePrice: json['base_price'],
      options: (json['options'] as List).map((e) => Option.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentId': documentId,
      'name': name,
      'description': description,
      'count': count,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'publishedAt': publishedAt,
      'isactive': isactive,
      'base_price': basePrice,
      'options': options.map((e) => e.toJson()).toList(),
    };
  }
}

class Option {
  String name;
  int price;

  Option({required this.name, required this.price});

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      name: json['name'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
    };
  }
}
