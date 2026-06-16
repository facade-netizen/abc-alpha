import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../apis/apiRepositories/eventsManageRepo/em_api_repository.dart';
import '../bloc/addBlocs/add_new_fancy_bloc.dart';
import '../bloc/authBlocs/user_changed_bloc.dart';
import '../bloc/fetchBlocs/fetch_catalouges_on_markettype_bloc.dart';
import '../bloc/fetchBlocs/fetch_fancy_bet_exposure_bloc.dart';
import '../bloc/signalRBloc/signalr_event_listener_bloc.dart';
import '../bloc/signalRBloc/signalRStreamers/fancy_live_exposure_data_bloc.dart';
import '../bloc/signalRBloc/signalRStreamers/fancy_market_signalr_data_bloc.dart';
import '../localDb/token/login_token_box.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/unauthorized_screen.dart';

// Dashboard shells (new files, will be created next)
import '../screens/dashboard/alphaAdminDashBoard/alpha_dashboard_shell.dart';
import '../screens/dashboard/balanceManageDashboard/loginLogs/user_activity_log_screen.dart';
import '../screens/dashboard/balanceManageDashboard/settlement/settlement_details.dart';
import '../screens/dashboard/balanceManageDashboard/wlAdminDetails/wl_admin_details.dart';
import '../screens/dashboard/fancyManageDashboard/fancy_dashboard_shell.dart';
import '../screens/dashboard/balanceManageDashboard/balance_dashboard_shell.dart';
import '../screens/dashboard/eventsManagementDashboard/events_dashboard_shell.dart';

// Alpha pages
import '../screens/dashboard/eventsManagementDashboard/manageEvents/manage_event_streamer.dart';
import '../screens/dashboard/fancyManageDashboard/manageMarkets/fancyBetList/fancyScreens/adjust_fancy_market_sequence.dart';
import '../screens/dashboard/fancyManageDashboard/manageMarkets/fancyBetList/fancyScreens/fancy_bet_list_screen.dart';
import '../screens/dashboard/fancyManageDashboard/manageMarkets/fancyBetList/fancyScreens/fancy_market_list_screen.dart';
import '../screens/dashboard/fancyManageDashboard/manageMarkets/fancyBetList/fancyScreens/manage_fancy_market_screen.dart';
import '../screens/dashboard/fancyManageDashboard/manageMarkets/fancyBetList/fancyScreens/fancy_manager_screen.dart';
import '../screens/dashboard/fancyManageDashboard/manageMarkets/specialFancyBetList/special_fancy_bet_list_screen.dart';
import '../screens/dashboard/fancyManageDashboard/manageMarkets/bookmakerBetList/bm_betlist_screen.dart';
import '../screens/dashboard/fancyManageDashboard/manageMarkets/tennisBetList/tennis_bet_list_screen.dart';
import '../screens/dashboard/fancyManageDashboard/manageMarkets/kabaddiBetList/kabaddi_bet_list_screen.dart';
import '../screens/dashboard/fancyManageDashboard/manageMarkets/electionBetList/election_bet_list_screen.dart';
import '../screens/dashboard/fancyManageDashboard/settleMarkets/fancySettle/settle_markets_screen.dart';
import '../screens/dashboard/fancyManageDashboard/settleMarkets/specialFancySettle/speical_fancy_bet_settle_screen.dart';
import '../screens/dashboard/fancyManageDashboard/settleMarkets/bmSettle/bookmaker_settle_screen.dart';
import '../screens/dashboard/fancyManageDashboard/settleMarkets/tennisSettle/tennis_settle_screen.dart';
import '../screens/dashboard/fancyManageDashboard/settleMarkets/kabaddiSettle/kabaddi_bookmaker_settle_screen.dart';
import '../screens/dashboard/fancyManageDashboard/settleMarkets/electionSettle/election_settle_screen.dart';
import '../screens/dashboard/fancyManageDashboard/marketMinMaxRun/fancy_bet_market_min_max_runs.dart';
import '../screens/dashboard/fancyManageDashboard/marketMinMaxRun/bookmaker_minmax_odds.dart';
import '../screens/dashboard/fancyManageDashboard/resultSources/result_source_screen.dart';
import '../screens/dashboard/alphaAdminDashBoard/adminManagement/adminManagement/create_admin_screen.dart';
import '../screens/dashboard/alphaAdminDashBoard/adminManagement/adminManagement/manage_admin_screen.dart';
import '../screens/dashboard/alphaAdminDashBoard/adminManagement/adminManagement/manage_role_base_admin.dart';
import '../screens/dashboard/alphaAdminDashBoard/adminReports/wl_reports_screen.dart';
import '../screens/dashboard/alphaAdminDashBoard/adminReports/net_aggregated_reports_screen.dart';
import '../screens/dashboard/alphaAdminDashBoard/whiteLableManagement/create_new_white_lable.dart';
import '../screens/dashboard/alphaAdminDashBoard/whiteLableManagement/manage_white_lables.dart';
import '../screens/dashboard/balanceManageDashboard/wlAccount/wl_account_summary_table.dart';
import '../screens/dashboard/alphaAdminDashBoard/alphaFundsManagement/alpha_funds_management_screen.dart';
import '../screens/auth/password_change_screen.dart';

import 'auth_notifier.dart';
import 'route_paths.dart';

/// Creates the app-wide GoRouter instance.
/// Call this from main.dart, passing the auth bloc instance.
GoRouter createAppRouter(UserAuthChangesBloc authBloc) {
  final authNotifier = AuthNotifier(authBloc);

  return GoRouter(
    initialLocation: RoutePaths.login,
    debugLogDiagnostics: true,
    refreshListenable: authNotifier,
    redirect: (context, state) => _authRedirect(state),
    routes: [
      // ── Home (empty landing page) ──
      GoRoute(path: RoutePaths.home, builder: (context, state) => const Scaffold()),

      // ── Login (no shell) ──
      GoRoute(path: RoutePaths.login, builder: (context, state) => const LoginScreen()),

      // ── Unauthorized ──
      GoRoute(path: '/unauthorized', builder: (context, state) => const UnAuthorizedScreen()),

      // ── Alpha Dashboard Shell ──
      ShellRoute(
        builder: (context, state, child) => AlphaDashboardShell(child: child),
        routes: _alphaRoutes(),
      ),

      // ── Fancy Dashboard Shell ──
      ShellRoute(
        builder: (context, state, child) => FancyDashboardShell(child: child),
        routes: _fancyRoutes(),
      ),

      // ── Balance Dashboard Shell ──
      ShellRoute(
        builder: (context, state, child) => BalanceDashboardShell(child: child),
        routes: _balanceRoutes(),
      ),

      // ── Events Dashboard Shell ──
      ShellRoute(
        builder: (context, state, child) => EventsDashboardShell(child: child),
        routes: _eventsRoutes(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('404 - Page Not Found', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text('Path: ${state.uri}', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () => GoRouter.of(context).go(RoutePaths.login), child: const Text('Go to Login')),
          ],
        ),
      ),
    ),
  );
}

/// Global auth redirect logic.
/// - No token + not on login: redirect to `/login?redirect=<current_url>`
/// - Has token + on login: redirect to role-default page (or redirect param)
/// - Has token + wrong role for path: redirect to correct role prefix
String? _authRedirect(GoRouterState state) {
  final savedData = SaveTokenBox.loginTokenBox.fetchLoginToken;
  final isAuthenticated = savedData != null && savedData.token != null;
  final isOnLogin = state.matchedLocation == RoutePaths.login;
  final isOnUnauthorized = state.matchedLocation == '/unauthorized';
  final isOnHome = state.matchedLocation == RoutePaths.home;
  final currentUri = state.uri.toString();

  // Not authenticated → go to login (unless already there)
  if (!isAuthenticated) {
    if (isOnLogin) return null;
    return '${RoutePaths.login}?redirect=${Uri.encodeComponent(currentUri)}';
  }

  // Authenticated + on bare home → go to role dashboard (which has the navbar shell)
  if (isAuthenticated && isOnHome) {
    return RoutePaths.defaultForRole(savedData.role ?? '');
  }

  // Authenticated + on login → go to redirect target or role-default
  if (isAuthenticated && isOnLogin) {
    final redirect = state.uri.queryParameters['redirect'];
    if (redirect != null && redirect.isNotEmpty) {
      final decoded = Uri.decodeComponent(redirect);
      // Validate the redirect is for the correct role
      if (RoutePaths.isRoleAllowedForPath(savedData.role ?? '', decoded)) {
        return decoded;
      }
    }
    return RoutePaths.defaultForRole(savedData.role ?? '');
  }

  // Authenticated + check role matches path prefix
  if (!isOnLogin && !isOnUnauthorized) {
    final role = savedData.role ?? '';
    if (!RoutePaths.isRoleAllowedForPath(role, state.matchedLocation)) {
      // Wrong role prefix → redirect to the user's own dashboard
      return RoutePaths.defaultForRole(role);
    }
  }

  return null; // No redirect needed
}

// ════════════════════════════════════════════════════════════════════
// ROUTE DEFINITIONS
// ════════════════════════════════════════════════════════════════════

List<GoRoute> _alphaRoutes() {
  return [
    // Show empty home inside the alpha shell
    GoRoute(path: RoutePaths.alphaRoot, builder: (_, _) => const Scaffold()),
    GoRoute(
      path: RoutePaths.alphaEventsManagement,
      builder: (context, state) => ManageEventStreamer(
        initialSportId: state.uri.queryParameters['sportId'] ?? '',
        initialCompetitionId: state.uri.queryParameters['competitionId'] ?? '',
        basePath: RoutePaths.alphaEventsManagement,
      ),
    ),

    // ── Betlist screens ──
    _fancyBetListRoute(RoutePaths.alphaFancyBetList),
    GoRoute(path: RoutePaths.alphaSpecialFancyList, builder: (_, _) => SpeicalFancyBetListScreen()),
    _bookmakerBetListRoute(RoutePaths.alphaBookmakerList),
    GoRoute(path: RoutePaths.alphaTennisBookmakerList, builder: (_, _) => TennisBetListScreen()),
    GoRoute(path: RoutePaths.alphaKabaddiBookmakerList, builder: (_, _) => KabaddiBetListScreen()),
    GoRoute(path: RoutePaths.alphaElectionBookmakerList, builder: (_, _) => ElectionBetListScreen()),

    // ── Settle screens ──
    GoRoute(
      path: RoutePaths.alphaSettleMarket,
      builder: (_, state) => SettleMarketsScreen(initialFromDate: state.uri.queryParameters['fromDate'], initialToDate: state.uri.queryParameters['toDate']),
    ),
    GoRoute(path: RoutePaths.alphaSpecialSettleMarket, builder: (_, _) => SpeicalFancyBetSettleScreen()),
    GoRoute(path: RoutePaths.alphaFancyMinMaxRuns, builder: (_, _) => FancyBetMarketMinMaxRuns()),
    GoRoute(path: RoutePaths.alphaBookmakerSettleMarket, builder: (_, _) => BookMakerSettleScreen()),
    GoRoute(path: RoutePaths.alphaBookmakerMinMaxRuns, builder: (_, _) => BookMakerMinMaxOdds()),
    GoRoute(path: RoutePaths.alphaTennisSettleMarket, builder: (_, _) => TennisBookMakerSettleScreen()),
    GoRoute(path: RoutePaths.alphaKabaddiSettleMarket, builder: (_, _) => KabaddiBookMakerSettleScreen()),
    GoRoute(path: RoutePaths.alphaResultSourceManagement, builder: (_, _) => ResultSourceScreen()),
    GoRoute(path: RoutePaths.alphaElectionSettleMarket, builder: (_, _) => ElectionSettleScreen()),

    // ── Admin screens ──
    GoRoute(path: RoutePaths.alphaCreateAdmin, builder: (_, _) => CreateAdminScreen()),
    GoRoute(path: RoutePaths.alphaManageWlAdmin, builder: (_, _) => ManageAdminScreen()),
    GoRoute(path: RoutePaths.alphaManageRbAdmin, builder: (_, _) => ManageRoleBaseAdminScreen()),

    // ── Reports ──
    GoRoute(path: RoutePaths.alphaWlReports, builder: (_, _) => WLAdminReportsScreen()),
    GoRoute(path: RoutePaths.alphaNetAggregatedReport, builder: (_, _) => NetAggregatedReportsScreen()),

    // ── White Label ──
    GoRoute(path: RoutePaths.alphaCreateLabel, builder: (_, _) => CreateNewWhiteLable()),
    GoRoute(path: RoutePaths.alphaWhiteLabelManagement, builder: (_, _) => ManageWhiteLable()),

    // ── Fund Management ──
    GoRoute(path: RoutePaths.alphaAccount, builder: (_, _) => WlAccountSummaryTable()),
    GoRoute(path: RoutePaths.alphaManageFund, builder: (_, _) => AlphaFundsManagementScreen()),

    // ── Personal ──
    GoRoute(path: RoutePaths.alphaChangePassword, builder: (_, _) => PasswordChangeScreen()),
  ];
}

List<GoRoute> _fancyRoutes() {
  return [
    GoRoute(path: RoutePaths.fancyRoot, builder: (_, _) => const Scaffold()),

    // ── Betlist screens ──
    _fancyBetListRoute(RoutePaths.fancyFancyBetList),
    GoRoute(path: RoutePaths.fancySpecialFancyList, builder: (_, _) => SpeicalFancyBetListScreen()),
    _bookmakerBetListRoute(RoutePaths.fancyBookmakerList),
    GoRoute(path: RoutePaths.fancyTennisBookmakerList, builder: (_, _) => TennisBetListScreen()),
    GoRoute(path: RoutePaths.fancyKabaddiBookmakerList, builder: (_, _) => KabaddiBetListScreen()),
    GoRoute(path: RoutePaths.fancyElectionBookmakerList, builder: (_, _) => ElectionBetListScreen()),

    // ── Settle screens ──
    GoRoute(
      path: RoutePaths.fancySettleMarket,
      builder: (_, state) => SettleMarketsScreen(initialFromDate: state.uri.queryParameters['fromDate'], initialToDate: state.uri.queryParameters['toDate']),
    ),
    GoRoute(path: RoutePaths.fancySpecialSettleMarket, builder: (_, _) => SpeicalFancyBetSettleScreen()),
    GoRoute(path: RoutePaths.fancyFancyMinMaxRuns, builder: (_, _) => FancyBetMarketMinMaxRuns()),
    GoRoute(path: RoutePaths.fancyBookmakerSettleMarket, builder: (_, _) => BookMakerSettleScreen()),
    GoRoute(path: RoutePaths.fancyBookmakerMinMaxRuns, builder: (_, _) => BookMakerMinMaxOdds()),
    GoRoute(path: RoutePaths.fancyTennisSettleMarket, builder: (_, _) => TennisBookMakerSettleScreen()),
    GoRoute(path: RoutePaths.fancyKabaddiSettleMarket, builder: (_, _) => KabaddiBookMakerSettleScreen()),
    GoRoute(path: RoutePaths.fancyResultSourceManagement, builder: (_, _) => ResultSourceScreen()),
    GoRoute(path: RoutePaths.fancyElectionSettleMarket, builder: (_, _) => ElectionSettleScreen()),

    // ── Personal ──
    GoRoute(path: RoutePaths.fancyChangePassword, builder: (_, _) => PasswordChangeScreen()),
  ];
}

List<GoRoute> _balanceRoutes() {
  return [
    GoRoute(path: RoutePaths.balanceRoot, builder: (_, _) => const Scaffold()),
    GoRoute(path: RoutePaths.balanceWlAdminDetails, builder: (_, state) => WlAdminDetails()),
    GoRoute(path: RoutePaths.balanceSettlementDetails, builder: (_, state) => SettlementDetails()),
    GoRoute(path: RoutePaths.balanceAccounts, builder: (_, _) => WlAccountSummaryTable()),
    GoRoute(path: RoutePaths.balanceUserActivityLog, builder: (_, _) => UserActivityLogScreen()),
    GoRoute(path: RoutePaths.balanceChangePassword, builder: (_, _) => PasswordChangeScreen()),
  ];
}

List<GoRoute> _eventsRoutes() {
  return [
    GoRoute(path: RoutePaths.eventsRoot, builder: (_, _) => const Scaffold()),
    GoRoute(
      path: RoutePaths.eventsManagement,
      builder: (context, state) => ManageEventStreamer(
        initialSportId: state.uri.queryParameters['sportId'] ?? '',
        initialCompetitionId: state.uri.queryParameters['competitionId'] ?? '',
        basePath: RoutePaths.eventsManagement,
      ),
    ),
  ];
}

/// Bookmaker bet list with drilldown sub-routes (alpha and fancy dashboards).
/// Mirrors _fancyBetListRoute but roots at BmBetlistScreen.
GoRoute _bookmakerBetListRoute(String basePath) {
  return GoRoute(
    path: basePath,
    builder: (_, _) => BmBetlistScreen(),
    routes: [
      // /:eventId/markets  — market catalogue for this event
      GoRoute(
        path: ':eventId/markets',
        builder: (context, state) {
          final eventId = state.pathParameters['eventId'] ?? '';
          final marketType = state.uri.queryParameters['marketType'] ?? '';
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => FetchCatalougeOnMarketTypeBloc(context.read<EMApiRepository>())),
              BlocProvider(create: (_) => AddNewFancyMarketBloc(context.read<EMApiRepository>())),
              BlocProvider(create: (_) => SignalREventListenerBloc()),
              BlocProvider(create: (_) => SignalRFancyMarketDataBloc()),
            ],
            child: FancyMarketListScreen(eventId: eventId, marketType: marketType),
          );
        },
        routes: [
          // /:eventId/markets/:marketId  — single market detail
          GoRoute(
            path: ':marketId',
            builder: (context, state) {
              final eventId = state.pathParameters['eventId'] ?? '';
              final marketId = state.pathParameters['marketId'] ?? '';
              return MultiBlocProvider(
                providers: [
                  BlocProvider(create: (_) => FetchCatalougeOnMarketTypeBloc(context.read<EMApiRepository>())),
                  BlocProvider(create: (_) => FetchFancyBetExposureBloc(context.read<EMApiRepository>())),
                  BlocProvider(create: (_) => FancyLiveBetExposureBloc()),
                  BlocProvider(create: (_) => SignalREventListenerBloc()),
                  BlocProvider(create: (_) => SignalRFancyMarketDataBloc()),
                ],
                child: ManageFancyMarketScreen(eventId: eventId, marketId: marketId),
              );
            },
          ),
        ],
      ),
      // /:eventId/manage  — manager page
      GoRoute(
        path: ':eventId/manage',
        builder: (context, state) {
          final eventId = state.pathParameters['eventId'] ?? '';
          return FancyManagerScreen(eventId: eventId);
        },
      ),
      GoRoute(
        path: ':eventId/sequence',
        builder: (context, state) {
          final eventId = state.pathParameters['eventId'] ?? '';
          return AdjustFancyMarketSequence(eventId: eventId);
        },
      ),
      // /:eventId/sequence — sequence manager page (newly added)
      GoRoute(
        path: ':eventId/sequence',
        builder: (context, state) {
          final eventId = state.pathParameters['eventId'] ?? "";
          // The sequence screen reuses FancyMarketListScreen in 'sequence' mode
          // if a dedicated screen exists replace this with that widget.
          return FancyMarketListScreen(eventId: eventId, marketType: 'SEQUENCE_MODE');
        },
      ),
    ],
  );
}

/// Fancy bet list with drilldown sub-routes (used by both alpha and fancy dashboards).
GoRoute _fancyBetListRoute(String basePath) {
  return GoRoute(
    path: basePath,
    builder: (_, state) => FancyBetListScreen(initialDate: state.uri.queryParameters['date']),
    routes: [
      // /alpha/fancy-bet-list/:eventId/markets?marketType=X
      // Each navigation creates fresh per-event blocs so switching between events
      // never shows stale catalogue or SignalR data from the previous event.
      GoRoute(
        path: ':eventId/markets',
        builder: (context, state) {
          final eventId = state.pathParameters['eventId'] ?? '';
          final marketType = state.uri.queryParameters['marketType'] ?? '';
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => FetchCatalougeOnMarketTypeBloc(context.read<EMApiRepository>())),
              BlocProvider(create: (_) => AddNewFancyMarketBloc(context.read<EMApiRepository>())),
              BlocProvider(create: (_) => SignalREventListenerBloc()),
              BlocProvider(create: (_) => SignalRFancyMarketDataBloc()),
            ],
            child: FancyMarketListScreen(eventId: eventId, marketType: marketType),
          );
        },
        routes: [
          // /alpha/fancy-bet-list/:eventId/markets/:marketId
          // Each navigation creates fresh per-market blocs so switching between markets
          // (or opening the same route in a new browser tab) is fully isolated.
          GoRoute(
            path: ':marketId',
            builder: (context, state) {
              final eventId = state.pathParameters['eventId'] ?? '';
              final marketId = state.pathParameters['marketId'] ?? '';
              return MultiBlocProvider(
                providers: [
                  BlocProvider(create: (_) => FetchCatalougeOnMarketTypeBloc(context.read<EMApiRepository>())),
                  BlocProvider(create: (_) => FetchFancyBetExposureBloc(context.read<EMApiRepository>())),
                  BlocProvider(create: (_) => FancyLiveBetExposureBloc()),
                  BlocProvider(create: (_) => SignalREventListenerBloc()),
                  BlocProvider(create: (_) => SignalRFancyMarketDataBloc()),
                ],
                child: ManageFancyMarketScreen(eventId: eventId, marketId: marketId),
              );
            },
          ),
        ],
      ),
      // /alpha/fancy-bet-list/:eventId/manage
      GoRoute(
        path: ':eventId/manage',
        builder: (context, state) {
          final eventId = state.pathParameters['eventId'] ?? '';
          return FancyManagerScreen(eventId: eventId);
        },
      ),
      // /alpha/fancy-bet-list/:eventId/sequence
      GoRoute(
        path: ':eventId/sequence',
        builder: (context, state) {
          final eventId = state.pathParameters['eventId'] ?? '';
          return AdjustFancyMarketSequence(eventId: eventId);
        },
      ),
    ],
  );
}
