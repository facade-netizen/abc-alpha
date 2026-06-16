import 'dart:convert';
import 'dart:typed_data';

import '../constants/images.dart';

class BannerModel {
  final String id;
  final String gameType; 
  final String position;
  final bool isActive;
  final Uint8List? imageData;
  final String? imageUrl;
  final double size;
  final String format;
  final DateTime createdAt;

  BannerModel({
    required this.id,
    required this.gameType,
    required this.position,
    required this.isActive,
    this.imageData,
    this.imageUrl,
    required this.size,
    required this.format,
    required this.createdAt,
  });
  BannerModel copyWith({
    String? id,
    String? gameType,
    String? position,
    bool? isActive,
    Uint8List? imageData,
    String? imageUrl,
    double? size,
    String? format,
    DateTime? createdAt,
    String? linkTo,
    String? description,
  }) {
    return BannerModel(
      id: id ?? this.id,
      gameType: gameType ?? this.gameType,
      position: position ?? this.position,
      isActive: isActive ?? this.isActive,
      imageData: imageData ?? this.imageData,
      imageUrl: imageUrl ?? this.imageUrl,
      size: size ?? this.size,
      format: format ?? this.format,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Create from JSON
  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      gameType: json['gameType'],
      position: json['position'],
      isActive: json['isActive'],
      imageData: json['imageData'] != null ? base64Decode(json['imageData']) : null,
      imageUrl: json['imageUrl'],
      size: json['size'].toDouble(),
      format: json['format'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // Helper methods
  bool get isCarousel => position == 'carousel';
  bool get isTwoByTwo => position == '2x2';
  bool get isFourByFour => position == '4x4';

  // For display purposes
  String get positionDisplay {
    switch (position) {
      case 'carousel':
        return 'Carousel Banner';
      case '2x2':
        return '2x2 Banner';
      case '4x4':
        return '4x4 Banner';
      default:
        return position;
    }
  }
}

class BannerService {
  final List<BannerModel> _banners = [];

  // Common game types for betting app
  final List<String> _gameTypes = ['Carousel', 'Esports', 'Cricket', 'Football', 'Tennis'];

  BannerService() {
    _initializeDemoData();
  }

  void _initializeDemoData() {
    _banners.addAll([
      // Carousel Banners (Top scrolling banners)
      BannerModel(
        id: '1',
        gameType: 'Carousel',
        position: 'carousel',
        isActive: true,
        imageUrl: imagePlaceholder,
        size: 0.8,
        format: 'JPG',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      BannerModel(
        id: '2',
        gameType: 'Esports',
        position: 'carousel',
        isActive: true,
        imageUrl: imagePlaceholder,
        size: 0.9,
        format: 'JPG',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      BannerModel(
        id: '3',
        gameType: 'Cricket',
        position: 'carousel',
        isActive: true,
        imageUrl: imagePlaceholder,
        size: 0.7,
        format: 'JPG',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),

      // 2x2 Banners (Featured games)
      BannerModel(
        id: '4',
        gameType: 'Football',
        position: '2x2',
        isActive: true,
        imageUrl: imagePlaceholder,
        size: 0.5,
        format: 'PNG',
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
      BannerModel(
        id: '5',
        gameType: 'Tennis',
        position: '2x2',
        isActive: true,
        imageUrl: imagePlaceholder,
        size: 0.4,
        format: 'PNG',
        createdAt: DateTime.now().subtract(const Duration(days: 6)),
      ),
      BannerModel(
        id: '6',
        gameType: 'Esports',
        position: '2x2',
        isActive: true,
        imageUrl: imagePlaceholder,
        size: 0.6,
        format: 'PNG',
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
      ),
      BannerModel(
        id: '7',
        gameType: 'Cricket',
        position: '2x2',
        isActive: false,
        imageUrl: imagePlaceholder,
        size: 0.5,
        format: 'PNG',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),

      // 4x4 Banners (Game categories)
      for (int i = 0; i < 4; i++)
        BannerModel(
          id: '8_$i',
          gameType: _gameTypes[i % _gameTypes.length],
          position: '4x4',
          isActive: i < 2,
          imageUrl: imagePlaceholder,
          size: 0.3,
          format: 'PNG',
          createdAt: DateTime.now().subtract(Duration(days: 4 - i)),
        ),
    ]);
  }

  List<BannerModel> getAllBanners() => List.from(_banners);

  List<String> getGameTypes() => List.from(_gameTypes);

  BannerModel? getBannerById(String id) {
    try {
      return _banners.firstWhere((banner) => banner.id == id);
    } catch (e) {
      return null;
    }
  }

  void addBanner(BannerModel banner) {
    _banners.insert(0, banner);
  }

  void removeBanner(String id) {
    _banners.removeWhere((banner) => banner.id == id);
  }

  void updateBanner(BannerModel updatedBanner) {
    final index = _banners.indexWhere((banner) => banner.id == updatedBanner.id);
    if (index != -1) {
      _banners[index] = updatedBanner;
    }
  }
}
