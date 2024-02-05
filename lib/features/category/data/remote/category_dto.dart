class CategoryDTO {
  final int id;
  final String name;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String bannerImageUrl;

  CategoryDTO({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.bannerImageUrl,
    required this.type,
  });

  factory CategoryDTO.fromJson(Map<String, dynamic> json) {
    return CategoryDTO(
      id: json['id'] as int,
      name: json['name'] as String,
      type: json['type'] as String,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      bannerImageUrl: json['banner_image_url'] as String,
    );
  }
}
