import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../bloc/authBlocs/user_logout_bloc.dart';
import '../../../bloc/fetchBlocs/fetch_current_user_info_bloc.dart';
import '../../../bloc/signalRBloc/signalr_hub_listener_bloc.dart';
import '../../../bloc/totpBlocs/check_2fa_enabled_bloc.dart';
import '../../../constants/app_constant.dart';
import '../../../constants/images.dart';
import '../../../reusable/colors.dart';
import '../../../reusable/formatters.dart';
import '../../../reusable/sized_box_hw.dart';
import '../../../routing/route_paths.dart';
import '../../../services/debug_log_fab.dart';
import '../../../services/web_utils.dart' as web_utils;
import 'totpSettings/enable_2fa_setting_dialog.dart';
import 'totpSettings/show_2fa_enabled_alert_dialog.dart';

/// Alpha dashboard shell — header + navbar.
/// Content is provided by GoRouter's ShellRoute as [child].
class AlphaDashboardShell extends StatefulWidget {
  final Widget child;
  const AlphaDashboardShell({super.key, required this.child});

  @override
  State<AlphaDashboardShell> createState() => _AlphaDashboardShellState();
}

class _AlphaDashboardShellState extends State<AlphaDashboardShell> {
  String hoverMenu = "";
  void Function()? _removePopStateListener;

  @override
  void initState() {
    super.initState();
    context.read<Check2FAEnabledBloc>().add(Check2FAEnabled());
    context.read<SignalRHubListenerBloc>().add(SignalRHubListener());
    context.read<FetchCurrentUserDetailsBloc>().add(FetchCurrentUserDetails());
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

  bool _isActive(String path) {
    final currentPath = GoRouterState.of(context).uri.path;
    return currentPath.startsWith(path);
  }

  bool _isAnyActive(List<String> paths) => paths.any(_isActive);

  Widget dropdownNavItem(String title, Map<String, String> items) {
    bool isHovered = hoverMenu == title;
    bool isSelected = _isAnyActive(items.values.toList());
    return MouseRegion(
      onEnter: (_) => setState(() => hoverMenu = title),
      onExit: (_) => setState(() => hoverMenu = ""),
      child: PopupMenuButton<String>(
        color: lightBlack,
        padding: EdgeInsets.zero,
        offset: const Offset(0, 25),
        onSelected: _navigate,
        itemBuilder: (menuCtx) {
          return items.entries.map((entry) {
            return PopupMenuItem<String>(
              value: entry.value,
              padding: EdgeInsets.zero,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onSecondaryTapDown: (_) {
                  Navigator.of(menuCtx).pop();
                  _openNewTab(entry.value);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(entry.key, style: TextStyle(color: white)),
                ),
              ),
            );
          }).toList();
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected || isHovered ? lightBlack : Colors.transparent,
            border: Border(right: BorderSide(color: white, width: 0.5)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: white),
              ),
              const Icon(Icons.arrow_drop_down, size: 18, color: grey),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                          "Alpha",
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
                        wb10,
                        BlocBuilder<Check2FAEnabledBloc, Check2FAEnabledState>(
                          builder: (context, cts) {
                            return BlocBuilder<UserLogoutBloc, UserLogoutState>(
                              builder: (context, uls) {
                                return PopupMenuButton<String>(
                                  onSelected: (value) {
                                    if (value == 'Enable 2FA') {
                                      if (cts is Check2FAEnabledSuccess && cts.is2FAEnabled) {
                                        showEnabledAlertDialog(context);
                                      } else {
                                        showEnable2FASettingsDialog(context);
                                      }
                                    } else if (value == 'Logout') {
                                      context.read<UserLogoutBloc>().add(UserLogoutListener(context: context));
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    PopupMenuItem(value: 'Enable 2FA', child: Text('Enable 2FA')),
                                    PopupMenuItem(
                                      value: 'Logout',
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Logout", style: const TextStyle(color: red)),
                                          SvgPicture.asset(AssetsConstants.logout, height: 15, colorFilter: const ColorFilter.mode(red, BlendMode.srcIn)),
                                        ],
                                      ),
                                    ),
                                  ],
                                  child: Row(
                                    children: [
                                      Text(
                                        "Alpha Admin",
                                        style: TextStyle(color: black, fontWeight: FontWeight.bold),
                                      ),
                                      Icon(Icons.arrow_drop_down, color: black),
                                    ],
                                  ),
                                );
                              },
                            );
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
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        dropdownNavItem("Markets Management", {"Events Management": RoutePaths.alphaEventsManagement}),
                        dropdownNavItem("Live Management", {
                          "Fancy Bet List": RoutePaths.alphaFancyBetList,
                          "Special Fancy List": RoutePaths.alphaSpecialFancyList,
                          "BookMaker List": RoutePaths.alphaBookmakerList,
                          "Tennis BookMaker List": RoutePaths.alphaTennisBookmakerList,
                          "Kabbdi BookMaker List": RoutePaths.alphaKabaddiBookmakerList,
                          "Election BookMaker List": RoutePaths.alphaElectionBookmakerList,
                        }),
                        dropdownNavItem("Settle", {
                          "Settle Market": RoutePaths.alphaSettleMarket,
                          "Special Settle Market": RoutePaths.alphaSpecialSettleMarket,
                          "Fany Bet Min/Max Runs": RoutePaths.alphaFancyMinMaxRuns,
                          "BookMaker Settle Market": RoutePaths.alphaBookmakerSettleMarket,
                          "BookMaker Bet Min/Max Runs": RoutePaths.alphaBookmakerMinMaxRuns,
                          "Tennis BookMaker Settle Market": RoutePaths.alphaTennisSettleMarket,
                          "Kabaddi BookMaker Settle Market": RoutePaths.alphaKabaddiSettleMarket,
                          "Result Source Management": RoutePaths.alphaResultSourceManagement,
                          "Election Settle Market": RoutePaths.alphaElectionSettleMarket,
                        }),
                        dropdownNavItem("Admin", {
                          "Create Admin": RoutePaths.alphaCreateAdmin,
                          "Manage WL Admin": RoutePaths.alphaManageWlAdmin,
                          "Manage RB Admin": RoutePaths.alphaManageRbAdmin,
                        }),
                        dropdownNavItem("Reports", {"WL Reports": RoutePaths.alphaWlReports, "Net Aggregated Report": RoutePaths.alphaNetAggregatedReport}),
                        dropdownNavItem("Manage White Lable", {"Create Label": RoutePaths.alphaCreateLabel, "White Label Management": RoutePaths.alphaWhiteLabelManagement}),
                        dropdownNavItem("Fund Management", {"Account": RoutePaths.alphaAccount, "Manage Fund": RoutePaths.alphaManageFund}),
                        dropdownNavItem("Personal", {"Change Password": RoutePaths.alphaChangePassword}),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Content (from GoRouter) ──
            Expanded(
              child: Container(color: white, child: widget.child),
            ),
          ],
        ),
      ),
    );
  }
}
