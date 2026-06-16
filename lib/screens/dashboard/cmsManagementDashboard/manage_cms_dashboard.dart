import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../bloc/authBlocs/user_logout_bloc.dart';
import '../../../bloc/fetchBlocs/fetch_current_user_info_bloc.dart';
import '../../../constants/app_constant.dart';
import '../../../constants/images.dart';
import '../../../localDb/token/login_token_model.dart';
import '../../../model/user_details_model.dart';
import '../../../reusable/colors.dart';
import '../../../reusable/sized_box_hw.dart';
import 'manageBanners/manage_banner_screen.dart';
import 'manageMarquee/manage_marquee_screen.dart';
import 'manageRules/manage_rules_screen.dart';

class ManageCmsDashboard extends StatefulWidget {
  const ManageCmsDashboard({super.key, this.savedUserData});
  final SaveLoginTokenModel? savedUserData;
  @override
  State<ManageCmsDashboard> createState() => _ManageCmsDashboardState();
}

class _ManageCmsDashboardState extends State<ManageCmsDashboard> {
  String currentPage = "Manage Banners";
  String hoverMenu = "";
  UserRole? userRole;
  //
  Widget getPageWidget() {
    switch (currentPage) {
      case "Manage Banners":
        return BannerDashboard();
      case "Manage Rules":
        return ManageRulesScreen();
      case "Manage Marquee":
        return ManageMarqueeScreen();
      default:
        return Center(child: Text("Page not found"));
    }
  }

  Widget navItem(String title) {
    bool isSelected = currentPage == title;
    bool isHovered = hoverMenu == title;
    return MouseRegion(
      onEnter: (_) => setState(() => hoverMenu = title),
      onExit: (_) => setState(() => hoverMenu = ""),
      child: InkWell(
        onTap: () => setState(() => currentPage = title),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? selectedmanu
                : isHovered
                ? selectedmanu
                : Colors.transparent,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(
            title,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isSelected ? white : black),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    context.read<FetchCurrentUserDetailsBloc>().add(FetchCurrentUserDetails());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(gradient: headerGradient),
              child: Center(
                child: SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(padding: const EdgeInsets.all(4), child: Image.asset(AssetsConstants.logo512)),
                            wb5,
                            Text("${AppConstants.appVersion} (${AppConstants.build})", style: TextStyle(color: white)),
                          ],
                        ),
                        Row(
                          children: [
                            BlocBuilder<FetchCurrentUserDetailsBloc, FetchCurrentUserDetailsState>(
                              builder: (context, cus) {
                                return Text(
                                  cus is FetchCurrentUserDetailsSuccess ? cus.userDetails.userName : "",
                                  style: TextStyle(color: white, fontWeight: FontWeight.bold),
                                );
                              },
                            ),
                            wb10,
                            BlocBuilder<UserLogoutBloc, UserLogoutState>(
                              builder: (context, uls) {
                                return Material(
                                  elevation: 4,
                                  borderRadius: BorderRadius.circular(8),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(8),
                                    onTap: () {
                                      context.read<UserLogoutBloc>().add(UserLogoutListener(context: context));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: red),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Logout",
                                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: red),
                                          ),
                                          wb6,
                                          SvgPicture.asset(AssetsConstants.logout, height: 15, colorFilter: const ColorFilter.mode(red, BlendMode.srcIn)),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Navbar
            Container(
              width: double.infinity,
              height: 30,
              decoration: BoxDecoration(gradient: manuGradient),
              child: Center(
                child: SizedBox(
                  width: size.width * 0.72,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 8, child: Row(children: [navItem("Manage Banners"), navItem("Manage Rules"), navItem("Manage Marquee")])),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(child: getPageWidget()),
          ],
        ),
      ),
    );
  }
}
