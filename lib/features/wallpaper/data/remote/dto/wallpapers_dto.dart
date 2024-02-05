import 'package:alt__wally/features/wallpaper/data/remote/wallpaper_dto.dart';

class WallpapersDto {
  final int currentPage;
  final List<WallpaperDataDto> data;
  final String firstPageUrl;
  final int from;
  final int lastPage;
  final String lastPageUrl;
  final List<LinkDto> links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int to;
  final int total;

  WallpapersDto({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory WallpapersDto.fromJson(Map<String, dynamic> json) {
    return WallpapersDto(
      currentPage: json['current_page'],
      data: (json['data'] as List)
          .map((data) => WallpaperDataDto.fromJson(data))
          .toList(),
      firstPageUrl: json['first_page_url'],
      from: json['from'],
      lastPage: json['last_page'],
      lastPageUrl: json['last_page_url'],
      links: (json['links'] as List)
          .map((link) => LinkDto.fromJson(link))
          .toList(),
      nextPageUrl: json['next_page_url'],
      path: json['path'],
      perPage: json['per_page'],
      prevPageUrl: json['prev_page_url'],
      to: json['to'],
      total: json['total'],
    );
  }
}

class WallpaperDataDto {
  final int id;
  final int userId;
  final int categoryId;
  final String title;
  final String image;
  final String imageUrl;
  final int size;
  final int height;
  final int width;
  final bool? favourite;
  final int wallOfMonth;
  final String createdAt;
  final String updatedAt;
  final CategoryDto category;
  final UserDto user;

  WallpaperDataDto({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.title,
    required this.image,
    required this.imageUrl,
    required this.size,
    required this.height,
    this.favourite,
    required this.width,
    required this.wallOfMonth,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
    required this.user,
  });

  factory WallpaperDataDto.fromJson(Map<String, dynamic> json) {
    return WallpaperDataDto(
      id: json['id'],
      userId: json['user_id'],
      categoryId: json['category_id'],
      title: json['title'],
      image: json['image'],
      imageUrl: json['image_url'],
      size: json['size'],
      height: json['height'],
      width: json['width'],
      favourite: json['favourite'],
      wallOfMonth: json['wall_of_month'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      category: CategoryDto.fromJson(json['category']),
      user: UserDto.fromJson(json['user']),
    );
  }
}

class CategoryDto {
  final int id;
  final String name;
  final String banner;
  final String type;
  final String createdAt;
  final String updatedAt;
  final String bannerImageUrl;

  CategoryDto({
    required this.id,
    required this.name,
    required this.banner,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.bannerImageUrl,
  });

  factory CategoryDto.fromJson(Map<String, dynamic> json) {
    return CategoryDto(
      id: json['id'],
      name: json['name'],
      banner: json['banner'],
      type: json['type'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      bannerImageUrl: json['banner_image_url'],
    );
  }
}

class UserDto {
  final int id;
  final String name;
  final String email;
  final String? emailVerifiedAt;
  final String profileImage;
  final String role;
  final String createdAt;
  final String updatedAt;
  final String profileImageUrl;
  final String bannerImageUrl;

  UserDto({
    required this.id,
    required this.name,
    required this.email,
    required this.emailVerifiedAt,
    required this.profileImage,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    required this.profileImageUrl,
    required this.bannerImageUrl,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'],
      profileImage: json['profile_image'],
      role: json['role'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      profileImageUrl: json['profile_image_url'],
      bannerImageUrl: json['banner_image_url'],
    );
  }
}

class LinkDto {
  final String? url;
  final String label;
  final bool active;

  LinkDto({
    required this.url,
    required this.label,
    required this.active,
  });

  factory LinkDto.fromJson(Map<String, dynamic> json) {
    return LinkDto(
      url: json['url'],
      label: json['label'],
      active: json['active'],
    );
  }
}
