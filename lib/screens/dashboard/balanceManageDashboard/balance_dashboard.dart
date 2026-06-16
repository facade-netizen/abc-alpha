import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../bloc/authBlocs/user_logout_bloc.dart';
import '../../../bloc/fetchBlocs/fetch_all_users_bloc.dart';
import '../../../bloc/fetchBlocs/fetch_current_user_info_bloc.dart';
import '../../../bloc/fetchBlocs/fetch_sprots_category_bloc.dart';
import '../../../constants/app_constant.dart';
import '../../../constants/images.dart';
import '../../../services/web_utils.dart' as web_utils;
import '../../../localDb/token/login_token_model.dart';
import '../../../reusable/button.dart';
import '../../../reusable/colors.dart';
import '../../../reusable/formatters.dart';
import '../../../reusable/sized_box_hw.dart';
import '../../auth/password_change_screen.dart';
import 'directDepositAndWithdrawal/direct_deposit_and_withdrawal_dialog.dart';
import 'loginLogs/user_activity_log_screen.dart';
import 'settlement/settlement_details.dart';
import 'wlAccount/wl_account_summary_table.dart';
import 'wlAdminDetails/wl_admin_details.dart';

class BalanceManagerDashboard extends StatefulWidget {
  const BalanceManagerDashboard({super.key, this.savedUserData, this.initialPage});
  final SaveLoginTokenModel? savedUserData;
  final String? initialPage;
  @override
  State<BalanceManagerDashboard> createState() => _BalanceManagerDashboardState();
}

class _BalanceManagerDashboardState extends State<BalanceManagerDashboard> {
  late String currentPage;
  int reloadKey = 0;
  String hoverMenu = "";
  final List<String> validPages = ["Manage WL Admin", "Accounts", "Settlement", "Login Logs", "Personal"];

  @override
  void initState() {
    super.initState();
    context.read<FetchCurrentUserDetailsBloc>().add(FetchCurrentUserDetails());
    context.read<FetchCurrentUserDetailsBloc>().add(FetchCurrentUserDetails());
    context.read<FetchSportsCategoryBloc>().add(FetchSportsCategory());
    context.read<FetchAllUsersBloc>().add(FetchAllUsers(role: 'adminWL'));
    // 🔹 Set initial page from widget.initialPage or fallback
    String page = widget.initialPage ?? "Manage WL Admin";
    if (!validPages.contains(page)) {
      page = "Manage WL Admin";
      // 🔹 Update URL to valid page
      final safePage = page.replaceAll(" ", "_");
      web_utils.historyReplaceState('/$safePage');
    }
    currentPage = page;
    reloadKey++;
  }

  // 🔹 Open page in new tab
  void openNewTab(String page) {
    final safePage = page.replaceAll(" ", "_");
    web_utils.openNewTab('/$safePage');
  }

  // 🔹 Set current page + update clean URL
  void _setCurrentPage(String page) {
    if (!validPages.contains(page)) return;
    setState(() {
      currentPage = page;
      reloadKey++;
      final safePage = page.replaceAll(" ", "_");
      web_utils.historyPushState('/$safePage');
    });
  }

  //
  Widget getPageWidget() {
    switch (currentPage) {
      case "Manage WL Admin":
        return WlAdminDetails();
      case "Accounts":
        return WlAccountSummaryTable();
      case "Settlement":
        return SettlementDetails();
      case "Login Logs":
        return UserActivityLogScreen();
      case "Personal":
        return PasswordChangeScreen();
      default:
        return Center(child: Text("Page not found"));
    }
  }

  Widget navItem(String page) {
    bool isSelected = currentPage == page;
    bool isHovered = hoverMenu == page;
    return InkWell(
      onTap: () => _setCurrentPage(page),
      onSecondaryTap: () => openNewTab(page),
      onHover: (hovering) {
        setState(() {
          hoverMenu = hovering ? page : "";
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected || isHovered ? lightBlack : Colors.transparent,
          border: Border(right: BorderSide(color: white, width: 0.5)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          page,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(color: lightBlueShade),
              child: Center(
                child: SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Balance System",
                              style: TextStyle(color: black, fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            wb10,
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: VerticalDivider(color: black, thickness: 0.5, width: 1),
                            ),
                            wb10,
                            BlocBuilder<FetchCurrentUserDetailsBloc, FetchCurrentUserDetailsState>(
                              builder: (context, cus) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${AppConstants.appVersion} (${AppConstants.build})", style: TextStyle(color: black, fontSize: 11)),
                                    hb5,
                                    Text(
                                      cus is FetchCurrentUserDetailsSuccess ? "User ${cus.userDetails.userName}" : "",
                                      style: TextStyle(color: black, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            BlocBuilder<FetchCurrentUserDetailsBloc, FetchCurrentUserDetailsState>(
                              builder: (context, cus) {
                                if (cus is FetchCurrentUserDetailsSuccess) {
                                  return Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(color: white, border: Border.all(), borderRadius: BorderRadius.circular(5)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Text("Net Point ${formattedAmounts(cus.userDetails.netPoint)}", style: TextStyle(fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                      wb5,
                                      Container(
                                        decoration: BoxDecoration(color: white, border: Border.all(), borderRadius: BorderRadius.circular(5)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Text("Net Remaining Point ${formattedAmounts(cus.userDetails.balancePoint)}", style: TextStyle(fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                      wb5,
                                      Container(
                                        decoration: BoxDecoration(color: white, border: Border.all(), borderRadius: BorderRadius.circular(5)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Text("Net Point Sold ${formattedAmounts(cus.userDetails.soldPoint)}", style: TextStyle(fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return SizedBox.shrink();
                                }
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
              decoration: BoxDecoration(color: lightBlack),
              child: Center(
                child: SizedBox(
                  width: size.width * 0.95,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 8, child: Row(children: [navItem("Manage WL Admin"), navItem("Accounts"), navItem("Settlement"), navItem("Login Logs"), navItem("Personal")])),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: CustomHoverButton(
                              title: "Funds",
                              width: 120,
                              fontSize: 13,
                              height: 30,
                              onPressed: () {
                                showDirectDepositAndWithdrawalDialog(context);
                              },
                            ),
                          ),
                          wb10,
                          BlocBuilder<UserLogoutBloc, UserLogoutState>(
                            builder: (context, uls) {
                              return InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: () {
                                  context.read<UserLogoutBloc>().add(UserLogoutListener(context: context));
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    VerticalDivider(color: white, thickness: 1, width: 1),
                                    wb2,
                                    Text(
                                      "Logout",
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: white),
                                    ),
                                    wb6,
                                    SvgPicture.asset(AssetsConstants.logout, height: 15, colorFilter: const ColorFilter.mode(white, BlendMode.srcIn)),
                                  ],
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
            Expanded(child: getPageWidget()),
          ],
        ),
      ),
    );
  }
}
