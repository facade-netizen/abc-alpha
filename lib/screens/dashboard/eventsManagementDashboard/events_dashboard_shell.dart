import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../bloc/authBlocs/user_logout_bloc.dart';
import '../../../bloc/fetchBlocs/fetch_current_user_info_bloc.dart';
import '../../../constants/app_constant.dart';
import '../../../constants/images.dart';
import '../../../reusable/colors.dart';
import '../../../reusable/sized_box_hw.dart';
import '../../../routing/route_paths.dart';
import '../../../services/debug_log_fab.dart';

/// Events dashboard shell — header + navbar (single page).
/// Content is provided by GoRouter's ShellRoute as [child].
class EventsDashboardShell extends StatefulWidget {
  final Widget child;
  const EventsDashboardShell({super.key, required this.child});

  @override
  State<EventsDashboardShell> createState() => _EventsDashboardShellState();
}

class _EventsDashboardShellState extends State<EventsDashboardShell> {
  @override
  void initState() {
    super.initState();
    context.read<FetchCurrentUserDetailsBloc>().add(FetchCurrentUserDetails());
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
                          "Event System",
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
                  width: size.width * 0.72,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => context.go(RoutePaths.eventsManagement),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: lightBlack,
                            border: Border(right: BorderSide(color: white, width: 0.5)),
                          ),
                          child: Text(
                            "Events Management",
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: white),
                          ),
                        ),
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
