import 'dart:async';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'apis/apiRepositories/accountsRepo/account_api_repository.dart';
import 'apis/apiRepositories/authRepo/auth_api_repository.dart';
import 'apis/apiRepositories/eventsManageRepo/em_api_repository.dart';
import 'apis/apiRepositories/ordersRepo/orders_api_repository.dart';
import 'apis/apiRepositories/settleManageRepo/ms_api_repository.dart';
import 'apis/apiRepositories/whiteLableRepo/white_lable_repository.dart';
import 'bloc/addBlocs/add_direct_funds_bloc.dart';
import 'bloc/addBlocs/add_new_fancy_bloc.dart';
import 'bloc/addBlocs/add_new_user_bloc.dart';
import 'bloc/addBlocs/add_new_white_lable_bloc.dart';
import 'bloc/addBlocs/deposit_and_withdrawal_bloc.dart';
import 'bloc/authBlocs/first_time_reset_password_bloc.dart';
import 'bloc/authBlocs/user_changed_bloc.dart';
import 'bloc/authBlocs/user_ip_bloc.dart';
import 'bloc/authBlocs/user_login_bloc.dart';
import 'bloc/authBlocs/user_logout_bloc.dart';
import 'bloc/fetchBlocs/fetch_all_transactions_bloc.dart';
import 'bloc/fetchBlocs/fetch_all_users_bloc.dart';
import 'bloc/fetchBlocs/fetch_all_wl_bloc.dart';
import 'bloc/fetchBlocs/fetch_catalouges_on_markettype_bloc.dart';
import 'bloc/fetchBlocs/fetch_competitions_by_eventype_bloc.dart';
import 'bloc/fetchBlocs/fetch_current_user_info_bloc.dart';
import 'bloc/fetchBlocs/fetch_custom_fancy_market_bloc.dart';
import 'bloc/fetchBlocs/fetch_deposit_requests_bloc.dart';
import 'bloc/fetchBlocs/fetch_fancy_events_bloc.dart';
import 'bloc/fetchBlocs/fetch_event_type_bloc.dart';
import 'bloc/fetchBlocs/fetch_events_by_competition_bloc.dart';
import 'bloc/fetchBlocs/fetch_fancy_bet_events_bloc.dart';
import 'bloc/fetchBlocs/fetch_fancy_bet_exposure_bloc.dart';
import 'bloc/fetchBlocs/fetch_mapped_users_bloc.dart';
import 'bloc/fetchBlocs/fetch_net_agr_report_bloc.dart';
import 'bloc/fetchBlocs/fetch_settle_history_bloc.dart';
import 'bloc/fetchBlocs/fetch_settlement_data_bloc.dart';
import 'bloc/fetchBlocs/fetch_sprots_category_bloc.dart';
import 'bloc/fetchBlocs/fetch_user_activity_logs_bloc.dart';
import 'bloc/fetchBlocs/fetch_withdrawal_requests_bloc.dart';
import 'bloc/fetchBlocs/fetch_wl_full_reports_bloc.dart';
import 'bloc/fetchBlocs/fetch_wl_net_reports_bloc.dart';
import 'bloc/fileBlocs/select_wl_favicon_bloc.dart';
import 'bloc/fileBlocs/select_wl_logo_bloc.dart';
import 'bloc/signalRBloc/signalRStreamers/single_fancy_market_data_bloc.dart';
import 'bloc/signalRBloc/signalr_event_listener_bloc.dart';
import 'bloc/signalRBloc/signalr_hub_listener_bloc.dart';
import 'bloc/signalRBloc/signalRStreamers/fancy_live_exposure_data_bloc.dart';
import 'bloc/signalRBloc/signalRStreamers/fancy_market_signalr_data_bloc.dart';
import 'bloc/signalRBloc/signalr_single_market_listener_bloc.dart';
import 'bloc/totpBlocs/check_2fa_enabled_bloc.dart';
import 'bloc/totpBlocs/set_2fa_lable_bloc.dart';
import 'bloc/totpBlocs/verify_otp_bloc.dart';
import 'bloc/updateBlocs/change_password_bloc.dart';
import 'bloc/updateBlocs/events_enable_and_disable_bloc.dart';
import 'bloc/updateBlocs/market_void_bloc.dart';
import 'bloc/updateBlocs/markets_settle_bloc.dart';
import 'bloc/updateBlocs/reset_password_bloc.dart';
import 'bloc/updateBlocs/save_market_to_settle_bloc.dart';
import 'bloc/updateBlocs/toggle_fancy_market_bloc.dart';
import 'bloc/updateBlocs/update_deposit_and_withdrawal_bloc.dart';
import 'bloc/updateBlocs/update_fancy_market_bloc.dart';
import 'bloc/updateBlocs/update_fancy_three_selection_bloc.dart';
import 'bloc/updateBlocs/update_market_condition_bloc.dart';
import 'bloc/updateBlocs/update_market_sequence_bloc.dart';
import 'bloc/updateBlocs/update_sr_id_bloc.dart';
import 'bloc/updateBlocs/update_suspend_ballrun_all_fancy_bloc.dart';
import 'bloc/updateBlocs/update_white_lable_bloc.dart';
import 'constants/app_constant.dart';
import 'localDb/hive_config.dart';
import 'reusable/theme_data.dart';
import 'routing/app_router.dart';
import 'services/app_bloc_observer.dart';
import 'services/log_service.dart';

/// Stored at top level so GC never collects the handle — keeps
/// the semantics tree alive for browser Ctrl+F find-in-page.
SemanticsHandle? semanticsHandle;

void main() async {
  // Run the app inside a Zone that intercepts all print() calls.
  // ensureInitialized + runApp must be in the same zone to avoid zone mismatch.
  runZonedGuarded(
    () async {
      // PathUrlStrategy: clean URLs without # (requires server to serve index.html for all paths)
      setUrlStrategy(PathUrlStrategy());

      // Set up BLoC observer (logs all BLoC events/transitions/errors)
      if (kDebugMode) {
        Bloc.observer = const AppBlocObserver();
      }

      // Capture Flutter framework errors
      FlutterError.onError = (details) {
        LogService.instance.error('FLUTTER', details.exceptionAsString(), error: details.exception, stackTrace: details.stack);
        // Also forward to default handler in debug mode
        if (kDebugMode) {
          FlutterError.presentError(details);
        }
      };

      // Capture platform-level async errors not caught by Flutter
      PlatformDispatcher.instance.onError = (error, stack) {
        LogService.instance.fatal('PLATFORM', error.toString(), error: error, stackTrace: stack);
        return true;
      };

      WidgetsFlutterBinding.ensureInitialized();

      // Keep semantics tree always active so the browser's Ctrl+F find-in-page
      // can discover text rendered by Flutter (via the accessible DOM overlay).
      semanticsHandle = SemanticsBinding.instance.ensureSemantics();

      // Suppress the browser's native right-click context menu so Flutter's
      // onSecondaryTap / custom context menus always take precedence on web.
      if (kIsWeb) {
        BrowserContextMenu.disableContextMenu();
      }

      await AppHiveConfig.init();
      LogService.instance.info('APP', 'Session ${LogService.instance.sessionId} started');
      runApp(const MyApp());
    },
    (error, stack) {
      LogService.instance.fatal('ZONE', error.toString(), error: error, stackTrace: stack);
    },
    zoneSpecification: kDebugMode
        ? ZoneSpecification(
            print: (self, parent, zone, line) {
              // Capture the print output into LogService
              LogService.instance.captureZonePrint(line);
              // Still pass through to the real console
              parent.print(zone, line);
            },
          )
        : null,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => EMApiRepository()),
        RepositoryProvider(create: (_) => AuthApiRepository()),
        RepositoryProvider(create: (_) => OrdersApiRepository()),
        RepositoryProvider(create: (_) => SettleApiRepository()),
        RepositoryProvider(create: (_) => AccountApiRepository()),
        RepositoryProvider(create: (_) => WhiteLableRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => UserIPBloc()),
          BlocProvider(create: (context) => UserLoginBloc()),
          BlocProvider(create: (context) => UserLogoutBloc()),
          BlocProvider(create: (context) => SelectWLLogoBloc()),
          BlocProvider(create: (context) => SelectFaviconBloc()),
          BlocProvider(create: (context) => UserAuthChangesBloc()),
          BlocProvider(create: (context) => AddNewWhiteLableBloc()),
          BlocProvider(create: (context) => UpdateWhiteLableBloc()),
          BlocProvider(create: (context) => FetchWLNetReportsBloc()),
          BlocProvider(create: (context) => SignalRHubListenerBloc()),
          BlocProvider(create: (context) => FetchSportsCategoryBloc()),
          BlocProvider(create: (context) => FancyLiveBetExposureBloc()),
          BlocProvider(create: (context) => SignalREventListenerBloc()),
          BlocProvider(create: (context) => FirstTimeResetPasswordBloc()),
          BlocProvider(create: (context) => SignalRFancyMarketDataBloc()),
          BlocProvider(create: (context) => SignalRSingleMarketListenerBloc()),
          BlocProvider(create: (context) => SignalRSingleFancyMarketDataBloc()),
          BlocProvider(create: (context) => MarketVoidBloc(context.read<EMApiRepository>())),
          BlocProvider(create: (context) => UpdateSrIdBloc(context.read<EMApiRepository>())),
          BlocProvider(create: (context) => VerifyOTPBloc(context.read<AuthApiRepository>())),
          BlocProvider(create: (context) => AddNewUserBloc(context.read<AuthApiRepository>())),
          BlocProvider(create: (context) => SetTOTPLableBloc(context.read<AuthApiRepository>())),
          BlocProvider(create: (context) => FetchAllWLBloc(context.read<WhiteLableRepository>())),
          BlocProvider(create: (context) => FetchEventTypesBloc(context.read<EMApiRepository>())),
          BlocProvider(create: (context) => MarketSettleBloc(context.read<SettleApiRepository>())),
          BlocProvider(create: (context) => ChangePasswordBloc(context.read<AuthApiRepository>())),
          BlocProvider(create: (context) => FetchFancyEventsBloc(context.read<EMApiRepository>())),
          BlocProvider(create: (context) => ToggleFancyMarketBloc(context.read<EMApiRepository>())),
          BlocProvider(create: (context) => UpdateFancyMarketBloc(context.read<EMApiRepository>())),
          BlocProvider(create: (context) => AddNewFancyMarketBloc(context.read<EMApiRepository>())),
          BlocProvider(create: (context) => Check2FAEnabledBloc(context.read<AuthApiRepository>())),
          BlocProvider(create: (context) => ResetPasswordBloc(context.read<AccountApiRepository>())),
          BlocProvider(create: (context) => FetchAllUsersBloc(context.read<AccountApiRepository>())),
          BlocProvider(create: (context) => AddDirectFundsBloc(context.read<AccountApiRepository>())),
          BlocProvider(create: (context) => FetchFancyBetEventsBloc(context.read<EMApiRepository>())),
          BlocProvider(create: (context) => FetchSettlementBloc(context.read<AccountApiRepository>())),
          BlocProvider(create: (context) => UpdateMarketSequenceBloc(context.read<EMApiRepository>())),
          BlocProvider(create: (context) => FetchMappedUsersBloc(context.read<AccountApiRepository>())),
          BlocProvider(create: (context) => FetchFancyBetExposureBloc(context.read<EMApiRepository>())),
          BlocProvider(create: (context) => UpdateMarketConditionBloc(context.read<EMApiRepository>())),
          BlocProvider(create: (context) => DespoiAndWithdrawBloc(context.read<AccountApiRepository>())),
          BlocProvider(create: (context) => FetchTransactionsBloc(context.read<AccountApiRepository>())),
          BlocProvider(create: (context) => FetchSettleHistoryBloc(context.read<SettleApiRepository>())),
          BlocProvider(create: (context) => EventsEnableAndDisableBloc(context.read<EMApiRepository>())),
          BlocProvider(create: (context) => SaveMarketToSettleBloc(context.read<SettleApiRepository>())),
          BlocProvider(create: (context) => FetchWLFullReportsBloc(context.read<WhiteLableRepository>())),
          BlocProvider(create: (context) => FetchNetAggrtReportBloc(context.read<OrdersApiRepository>())),
          BlocProvider(create: (context) => FetchEventsByCompetitionBloc(context.read<EMApiRepository>())),
          BlocProvider(create: (context) => FetchDepositRequestsBloc(context.read<AccountApiRepository>())),
          BlocProvider(create: (context) => UpdateFancyThreeSelectionBloc(context.read<EMApiRepository>())),
          BlocProvider(create: (context) => FetchCustomFancyMarketBloc(context.read<SettleApiRepository>())),
          BlocProvider(create: (context) => FetchUserActivityLogsBloc(context.read<AccountApiRepository>())),
          BlocProvider(create: (context) => FetchCatalougeOnMarketTypeBloc(context.read<EMApiRepository>())),
          BlocProvider(create: (context) => FetchCompetitionsByEventTypeBloc(context.read<EMApiRepository>())),
          BlocProvider(create: (context) => FetchWithdrawalRequestsBloc(context.read<AccountApiRepository>())),
          BlocProvider(create: (context) => FetchCurrentUserDetailsBloc(context.read<AccountApiRepository>())),
          BlocProvider(create: (context) => UpdateFancyMarketSuspendBallRunBloc(context.read<EMApiRepository>())),
          BlocProvider(create: (context) => UpdateDepositAndWithdrawalRequestBloc(context.read<AccountApiRepository>())),
        ],

        child: Builder(
          builder: (context) {
            // Fire initial auth check & IP detection
            context.read<UserIPBloc>().add(UserIP());
            context.read<UserAuthChangesBloc>().add(StartUserChangeListener());

            final router = createAppRouter(context.read<UserAuthChangesBloc>());
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: AppConstants.appTitle,
              theme: themeData,
              routerConfig: router,
              supportedLocales: const [Locale('en')],
            );
          },
        ),
      ),
    );
  }
}
