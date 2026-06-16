import 'package:flutter/material.dart';

import '../../../../model/banner_model.dart';
import '../../../../reusable/colors.dart';
import 'banner_widgets.dart';

class BannerTypeCard extends StatelessWidget {
  const BannerTypeCard({super.key, required this.banners});
  final List<BannerModel> banners;
  @override
  Widget build(BuildContext context) {
    return BannerCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Banner Types',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: black),
          ),
          const SizedBox(height: 4),
          BannerInfoCard(title: 'Carousel Banner', description: 'Top scrolling banners (1200x400)', icon: Icons.view_carousel, color: indigo),
          BannerInfoCard(title: '2x2 Banner', description: '4 featured games grid (400x400)', icon: Icons.grid_4x4, color: cyan),
          BannerInfoCard(title: '4x4 Banner', description: '16 game categories (200x200)', icon: Icons.grid_on, color: blue),
          BannerInfoCard(title: 'Total Banner', description: banners.length.toString(), icon: Icons.image, color: orange),
          BannerInfoCard(title: 'Active Banner', description: banners.where((b) => b.isActive).length.toString(), icon: Icons.image, color: green),
          BannerInfoCard(title: '', description: '', icon: Icons.grid_on, color: white),
        ],
      ),
    );
  }
}

class BannerInfoCard extends StatelessWidget {
  const BannerInfoCard({super.key, required this.title, required this.description, required this.icon, required this.color});
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: color, fontWeight: FontWeight.w600),
                  ),
                  Text(description, style: TextStyle(color: black.withValues(alpha: 0.7), fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
