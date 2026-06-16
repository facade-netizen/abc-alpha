import 'package:flutter/material.dart';

import '../../../../model/banner_model.dart';
import 'banner_list_card.dart';
import 'banner_type_card.dart';
import 'banner_upload_card.dart';

class BannerDashboard extends StatefulWidget {
  const BannerDashboard({super.key});

  @override
  State<BannerDashboard> createState() => _BannerDashboardState();
}

class _BannerDashboardState extends State<BannerDashboard> {
  final BannerService bannerService = BannerService();
  @override
  Widget build(BuildContext context) {
    final allBanners = bannerService.getAllBanners();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///add banner
                Expanded(
                  child: BannerUploadCard(
                    bannerService: bannerService,
                    onUpload: (banner) {
                      bannerService.addBanner(banner);
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(width: 24),

                ///banner types
                Expanded(child: BannerTypeCard(banners: allBanners)),
              ],
            ),

            ///banners view
            BannerListCard(
              banners: allBanners,
              onDelete: (id) {
                bannerService.removeBanner(id);
                setState(() {});
              },
              onToggleStatus: (id) {
                final banner = bannerService.getBannerById(id);
                if (banner != null) {
                  final updated = banner.copyWith(isActive: !banner.isActive);
                  bannerService.updateBanner(updated);
                  setState(() {});
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
