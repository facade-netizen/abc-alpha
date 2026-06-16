import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../bloc/authBlocs/user_logout_bloc.dart';
import '../../../bloc/fetchBlocs/fetch_current_user_info_bloc.dart';
import '../../../bloc/signalRBloc/signalr_hub_listener_bloc.dart';
import '../../../constants/app_constant.dart';
import '../../../constants/images.dart';
import '../../../reusable/colors.dart';
import '../../../reusable/sized_box_hw.dart';
import '../../../routing/route_paths.dart';
import '../../../services/debug_log_fab.dart';
import '../../../services/web_utils.dart' as web_utils;

/// Fancy dashboard shell — header + navbar.
/// Content is provided by GoRouter's ShellRoute as [child].
class FancyDashboardShell extends StatefulWidget {
  final Widget child;
  const FancyDashboardShell({super.key, required this.child});

  @override
  State<FancyDashboardShell> createState() => _FancyDashboardShellState();
}

class _FancyDashboardShellState extends State<FancyDashboardShell> {
  void Function()? _removePopStateListener;
  @override
  void initState() {
    super.initState();
    context.read<FetchCurrentUserDetailsBloc>().add(FetchCurrentUserDetails());
    context.read<SignalRHubListenerBloc>().add(SignalRHubListener());
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

  bool _isAnyActive(List<String> paths) {
    final currentPath = GoRouterState.of(context).uri.path;
    return paths.any((p) => currentPath.startsWith(p));
  }

  Widget dropdownNavItem(String title, Map<String, String> items) {
    bool isSelected = _isAnyActive(items.values.toList());
    return PopupMenuButton<String>(
      color: lightBlack,
      padding: EdgeInsets.zero,
      offset: const Offset(0, 25),
      onSelected: _navigate,
      itemBuilder: (menuCtx) => items.entries
          .map(
            (entry) => PopupMenuItem<String>(
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
                  child: Text(entry.key, style: const TextStyle(color: Colors.white)),
                ),
              ),
            ),
          )
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? lightBlack : Colors.transparent,
          border: Border(right: BorderSide(color: white, width: 0.5)),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(color: white, fontWeight: FontWeight.bold),
            ),
            Icon(Icons.arrow_drop_down, color: grey),
          ],
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
                          "Trader System",
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
                            return Text(
                              cus is FetchCurrentUserDetailsSuccess ? "User ${cus.userDetails.userName}" : "",
                              style: TextStyle(color: black, fontWeight: FontWeight.bold),
                            );
                          },
                        ),
                      ],
                    ),
                    Text("${AppConstants.appVersion} (${AppConstants.build})", style: TextStyle(color: black)),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                dropdownNavItem("Live Management", {
                                  "Fancy Bet List": RoutePaths.fancyFancyBetList,
                                  "Special Fancy List": RoutePaths.fancySpecialFancyList,
                                  "BookMaker List": RoutePaths.fancyBookmakerList,
                                  "Tennis BookMaker List": RoutePaths.fancyTennisBookmakerList,
                                  "Kabbdi BookMaker List": RoutePaths.fancyKabaddiBookmakerList,
                                  "Election BookMaker List": RoutePaths.fancyElectionBookmakerList,
                                }),
                                dropdownNavItem("Admin", {
                                  "Settle Market": RoutePaths.fancySettleMarket,
                                  "Special Settle Market": RoutePaths.fancySpecialSettleMarket,
                                  "Fany Bet Min/Max Runs": RoutePaths.fancyFancyMinMaxRuns,
                                  "BookMaker Settle Market": RoutePaths.fancyBookmakerSettleMarket,
                                  "BookMaker Bet Min/Max Runs": RoutePaths.fancyBookmakerMinMaxRuns,
                                  "Tennis BookMaker Settle Market": RoutePaths.fancyTennisSettleMarket,
                                  "Kabaddi BookMaker Settle Market": RoutePaths.fancyKabaddiSettleMarket,
                                  "Result Source Management": RoutePaths.fancyResultSourceManagement,
                                  "Election Settle Market": RoutePaths.fancyElectionSettleMarket,
                                }),
                                dropdownNavItem("Personal", {"Change Password": RoutePaths.fancyChangePassword}),
                              ],
                            ),
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // ── Content ──
            Expanded(
              child: Container(color: white, child: widget.child),
            ),
          ],
        ),
      ),
    );
  }
}
