class GetGalleryDataModel {
  final int id;
  final String documentId;
  final String name;
  final String? alternativeText;
  final String? caption;
  final int width;
  final int height;
  final Map<String, dynamic> formats;
  final String hash;
  final String ext;
  final String mime;
  final double size;
  final String url;
  final String? previewUrl;
  final String provider;
  final String createdAt;
  final String updatedAt;
  final String publishedAt;

  GetGalleryDataModel({
    required this.id,
    required this.documentId,
    required this.name,
    this.alternativeText,
    this.caption,
    required this.width,
    required this.height,
    required this.formats,
    required this.hash,
    required this.ext,
    required this.mime,
    required this.size,
    required this.url,
    this.previewUrl,
    required this.provider,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
  });

  // متد سازنده برای تبدیل داده‌های JSON به مدل
  factory GetGalleryDataModel.fromJson(Map<String, dynamic> json) {
    return GetGalleryDataModel(
      id: json['id'],
      documentId: json['documentId'],
      name: json['name'],
      alternativeText: json['alternativeText'],
      caption: json['caption'],
      width: json['width'],
      height: json['height'],
      formats: json['formats'] != null ? Map<String, dynamic>.from(json['formats']) : {},
      hash: json['hash'],
      ext: json['ext'],
      mime: json['mime'],
      size: json['size'].toDouble(),
      url: json['url'],
      previewUrl: json['previewUrl'],
      provider: json['provider'],
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
      'name': name,
      'alternativeText': alternativeText,
      'caption': caption,
      'width': width,
      'height': height,
      'formats': formats,
      'hash': hash,
      'ext': ext,
      'mime': mime,
      'size': size,
      'url': url,
      'previewUrl': previewUrl,
      'provider': provider,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'publishedAt': publishedAt,
    };
  }
}


class Formats {
  FormatData thumbnail;
  FormatData? small;
  FormatData? medium;
  FormatData? large;

  Formats({
    required this.thumbnail,
    this.small,
    this.medium,
    this.large,
  });

  factory Formats.fromJson(Map<String, dynamic> json) {
    return Formats(
      thumbnail: FormatData.fromJson(json['thumbnail']),
      small: json['small'] != null ? FormatData.fromJson(json['small']) : null,
      medium: json['medium'] != null ? FormatData.fromJson(json['medium']) : null,
      large: json['large'] != null ? FormatData.fromJson(json['large']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'thumbnail': thumbnail.toJson(),
      'small': small?.toJson(),
      'medium': medium?.toJson(),
      'large': large?.toJson(),
    };
  }
}

class FormatData {
  String name;
  String hash;
  String ext;
  String mime;
  String? path;
  int width;
  int height;
  double size;
  String url;

  FormatData({
    required this.name,
    required this.hash,
    required this.ext,
    required this.mime,
    this.path,
    required this.width,
    required this.height,
    required this.size,
    required this.url,
  });

  factory FormatData.fromJson(Map<String, dynamic> json) {
    return FormatData(
      name: json['name'],
      hash: json['hash'],
      ext: json['ext'],
      mime: json['mime'],
      path: json['path'],
      width: json['width'],
      height: json['height'],
      size: (json['size'] as num).toDouble(),
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'hash': hash,
      'ext': ext,
      'mime': mime,
      'path': path,
      'width': width,
      'height': height,
      'size': size,
      'url': url,
    };
  }
}
