import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../bloc/authBlocs/user_logout_bloc.dart';
import '../../../bloc/fetchBlocs/fetch_all_users_bloc.dart';
import '../../../bloc/fetchBlocs/fetch_current_user_info_bloc.dart';
import '../../../bloc/fetchBlocs/fetch_sprots_category_bloc.dart';
import '../../../constants/app_constant.dart';
import '../../../constants/images.dart';
import '../../../reusable/button.dart';
import '../../../reusable/colors.dart';
import '../../../reusable/formatters.dart';
import '../../../reusable/sized_box_hw.dart';
import '../../../routing/route_paths.dart';
import '../../../services/debug_log_fab.dart';
import '../../../services/web_utils.dart' as web_utils;
import 'directDepositAndWithdrawal/direct_deposit_and_withdrawal_dialog.dart';

/// Balance dashboard shell — header + navbar.
/// Content is provided by GoRouter's ShellRoute as [child].
class BalanceDashboardShell extends StatefulWidget {
  final Widget child;
  const BalanceDashboardShell({super.key, required this.child});

  @override
  State<BalanceDashboardShell> createState() => _BalanceDashboardShellState();
}

class _BalanceDashboardShellState extends State<BalanceDashboardShell> {
  String hoverMenu = "";
  void Function()? _removePopStateListener;

  @override
  void initState() {
    super.initState();
    context.read<FetchCurrentUserDetailsBloc>().add(FetchCurrentUserDetails());
    context.read<FetchSportsCategoryBloc>().add(FetchSportsCategory());
    context.read<FetchAllUsersBloc>().add(FetchAllUsers(role: 'adminWL'));
    _removePopStateListener = web_utils.onPopState(() {
      if (mounted) GoRouter.of(context).refresh();
    });
  }

  @override
  void dispose() {
    _removePopStateListener?.call();
    super.dispose();
  }

  void _navigate(String path) => context.go(path);
  void _openNewTab(String path) => web_utils.openNewTab(path);

  Widget navItem(String label, String path) {
    final currentPath = GoRouterState.of(context).uri.path;
    bool isSelected = currentPath.startsWith(path);
    bool isHovered = hoverMenu == label;
    return InkWell(
      onTap: () => _navigate(path),
      onSecondaryTapDown: (_) => _openNewTab(path),
      onHover: (hovering) => setState(() => hoverMenu = hovering ? label : ""),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected || isHovered ? lightBlack : Colors.transparent,
          border: Border(right: BorderSide(color: white, width: 0.5)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          label,
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
      floatingActionButton: const DebugLogFab(),
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(color: lightBlueShade),
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
                            }
                            return SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // ── Navbar ──
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
                      Expanded(
                        flex: 8,
                        child: Row(
                          children: [
                            navItem("Manage WL Admin", RoutePaths.balanceWlAdminDetails),
                            navItem("Settlement", RoutePaths.balanceSettlementDetails),
                            navItem("Login Logs", RoutePaths.balanceUserActivityLog),
                            navItem("Accounts", RoutePaths.balanceAccounts),
                            navItem("Personal", RoutePaths.balanceChangePassword),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: CustomHoverButton(title: "Funds", width: 120, fontSize: 13, height: 30, onPressed: () => showDirectDepositAndWithdrawalDialog(context)),
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
            // ── Content ──
            Expanded(child: widget.child),
          ],
        ),
      ),
    );
  }
}
