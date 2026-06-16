import 'package:flutter/material.dart';

import '../../../../model/banner_model.dart';
import '../../../../reusable/colors.dart';
import 'banner_widgets.dart';

class BannerListCard extends StatelessWidget {
  final List<BannerModel> banners;
  final Function(String) onDelete;
  final Function(String) onToggleStatus;

  const BannerListCard({super.key, required this.banners, required this.onDelete, required this.onToggleStatus});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    // Group banners by position
    final carouselBanners = banners.where((b) => b.isCarousel).toList();
    final twoByTwoBanners = banners.where((b) => b.isTwoByTwo).toList();
    final fourByFourBanners = banners.where((b) => b.isFourByFour).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),

        // Carousel Banners Section
        if (carouselBanners.isNotEmpty) ...[
          BannerGrid(title: 'Carousel Banners', count: carouselBanners.length, banners: carouselBanners, onDelete: onDelete, onToggleStatus: onToggleStatus),
          const SizedBox(height: 24),
        ],

        // 2x2 Banners Section
        if (twoByTwoBanners.isNotEmpty) ...[
          BannerGrid(title: '2x2 Banners', count: twoByTwoBanners.length, banners: twoByTwoBanners, onDelete: onDelete, onToggleStatus: onToggleStatus),
          const SizedBox(height: 24),
        ],

        // 4x4 Banners Section
        if (fourByFourBanners.isNotEmpty) ...[
          BannerGrid(title: '4x4 Banners', count: fourByFourBanners.length, banners: fourByFourBanners, onDelete: onDelete, onToggleStatus: onToggleStatus),
          const SizedBox(height: 24),
        ],

        // Empty State
        if (banners.isEmpty)
          Container(
            width: size.width,
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                Icon(Icons.image, size: 48, color: grey),
                const SizedBox(height: 16),
                Text(
                  'No banners added yet',
                  style: TextStyle(color: cmsHeader, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Text('Add your first banner to get started', style: TextStyle(color: cmsHeader.withValues(alpha: 0.7))),
              ],
            ),
          ),
      ],
    );
  }
}

class BannerGrid extends StatelessWidget {
  const BannerGrid({super.key, required this.banners, required this.title, required this.count, required this.onDelete, required this.onToggleStatus});
  final List<BannerModel> banners;
  final String title;
  final int count;
  final Function(String) onDelete;
  final Function(String) onToggleStatus;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: black),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: blue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                child: Text('$count', style: TextStyle(color: blue, fontSize: 12)),
              ),
            ],
          ),
        ),
        CustomGridViewCard(
          height: 270,
          count: 4,
          children: banners.map((banner) {
            return Container(
              decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Banner Image
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: cmsCardBorder,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: banner.imageData != null
                          ? Image.memory(banner.imageData!, fit: BoxFit.cover)
                          : banner.imageUrl != null
                          ? Image.network(banner.imageUrl!, fit: BoxFit.cover)
                          : Center(child: Icon(Icons.image, size: 40, color: grey)),
                    ),
                  ),

                  // Info Section
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              banner.gameType,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: black),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(color: banner.isActive ? green.withValues(alpha: 0.1) : red.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                              child: Row(
                                children: [
                                  Icon(Icons.circle, size: 8, color: banner.isActive ? green : red),
                                  const SizedBox(width: 4),
                                  Text(
                                    banner.positionDisplay,
                                    style: TextStyle(fontSize: 10, color: banner.isActive ? green : red, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('${banner.size.toStringAsFixed(1)} MB', style: TextStyle(color: black.withValues(alpha: 0.6), fontSize: 10)),
                            Text('${banner.createdAt.day}/${banner.createdAt.month}/${banner.createdAt.year}', style: TextStyle(color: black.withValues(alpha: 0.6), fontSize: 10)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Action Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: CmsCTAButton(action: () => onToggleStatus(banner.id), icon: Icons.power_settings_new, title: banner.isActive ? 'Deactivate' : 'Activate'),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: CmsCTAButton(action: () => onDelete(banner.id), icon: Icons.delete_outline, title: 'Delete', color: red),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
