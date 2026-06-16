import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../../../bloc/fetchBlocs/fetch_catalouges_on_markettype_bloc.dart';
import '../../../../../../bloc/fetchBlocs/fetch_fancy_bet_exposure_bloc.dart';
import '../../../../../../bloc/fetchBlocs/fetch_fancy_events_bloc.dart';
import '../../../../../../bloc/signalRBloc/signalRStreamers/fancy_live_exposure_data_bloc.dart';
import '../../../../../../bloc/signalRBloc/signalRStreamers/single_fancy_market_data_bloc.dart';
import '../../../../../../bloc/signalRBloc/signalr_single_market_listener_bloc.dart';
import '../../../../../../bloc/updateBlocs/update_fancy_market_bloc.dart';
import '../../../../../../model/fancy_bet_exposure_model.dart';
import '../../../../../../model/fancy_catalouges_on_markettype_model.dart';
import '../../../../../../model/fancy_events_model.dart';
import '../../../../../../reusable/colors.dart';
import '../../../../../../reusable/custom_switch.dart';
import '../../../../../../reusable/loader.dart';
import '../../../../../../reusable/sized_box_hw.dart';
import '../../../../../../reusable/snack_bar.dart';
import '../../../betlistConstant/betlist_string_constants.dart';
import '../fancyWidgets/fancy_market_details_widget.dart';
import '../fancyWidgets/fancy_market_widget.dart';
import '../fancyDialogs/update_market_rating_dialog.dart';
import '../fancyWidgets/manage_auto_market_widget.dart';
import '../fancyWidgets/manage_manual_market_widget.dart';
import '../fancyWidgets/manage_market_rules_widget.dart';
import '../fancyWidgets/manage_three_selection_market_widget.dart';
import '../fancyWidgets/manage_three_selections_market_rate_widget.dart';
import '../fancyWidgets/market_runner_rate_widget.dart';

class ManageFancyMarketScreen extends StatefulWidget {
  const ManageFancyMarketScreen({super.key, this.catalogue, this.fancyEventData, this.toggleScreen, this.eventId, this.marketId});
  final FancyCatalougesOnMarketType? catalogue;
  final FancyEventData? fancyEventData;
  final Function(FancyCatalougesOnMarketType catalogue)? toggleScreen;

  /// When navigated via GoRouter, these are passed instead of widget objects.
  final String? eventId;
  final String? marketId;

  @override
  State<ManageFancyMarketScreen> createState() => _ManageFancyMarketScreenState();
}

class _ManageFancyMarketScreenState extends State<ManageFancyMarketScreen> {
  TextEditingController inputController = TextEditingController();
  bool isOn = true;
  String? runnerId;
  String? marketId;
  String backPrice = '';
  String backLine = '';
  String layPrice = '';
  String layLine = '';
  String back2Price = '';
  String back2Line = '';
  String lay2Price = '';
  String lay2Line = '';
  String back3Price = '';
  String back3Line = '';
  String lay3Price = '';
  String lay3Line = '';
  String localStatus = '';
  double yesExp = 0.0;
  double noExp = 0.0;
  double runOddsYes = 0.0;
  double runOddsNO = 0.0;
  bool isBallingRun = false;
  bool pauseByAlpha = false;
  double betDelay = 0.0;
  double betExposure = 0.0;
  double betMin = 0.0;
  double betMax = 0.0;

  /// The resolved catalogue — either from widget.catalogue directly or
  /// fetched from the bloc when the screen is opened via URL (marketId path param).
  FancyCatalougesOnMarketType? _catalogue;

  String get _effectiveEventId => _catalogue?.eventId ?? widget.eventId ?? widget.fancyEventData?.id ?? "0";

  @override
  void initState() {
    super.initState();
    context.read<FancyLiveBetExposureBloc>().add(FancyLiveBetExposureListener());
    if (widget.catalogue != null) {
      // Opened inline from FancyMarketListScreen — catalogue is already available
      _catalogue = widget.catalogue;
      context.read<FetchFancyBetExposureBloc>().add(FetchFancyBetExposure(marketId: _catalogue!.marketId));
      context.read<SignalRSingleMarketListenerBloc>().add(SignalRSingleMarketListener(marketId: _catalogue!.marketId));
      context.read<SignalRSingleFancyMarketDataBloc>().add(SignalRSingleFancyMarketDataListener());
      _initializeFromCatalogue(_catalogue!);
    } else {
      // Opened via URL — find by marketId
      final effectiveEventId = widget.eventId ?? "";
      context.read<SignalRSingleMarketListenerBloc>().add(SignalRSingleMarketListener(marketId: widget.marketId ?? ""));
      context.read<SignalRSingleFancyMarketDataBloc>().add(SignalRSingleFancyMarketDataListener());
      // For URL navigation: eagerly fetch today's fancy events so event metadata is available
      final now = DateTime.now();
      final dateStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} 00:00:00.000';
      context.read<FetchFancyEventsBloc>().add(FetchFancyEvents(selectedDate: dateStr));
      final currentState = context.read<FetchCatalougeOnMarketTypeBloc>().state;
      if (currentState is FetchCatalougeOnMarketTypeSuccess) {
        final found = currentState.catalougeDetails.firstWhereOrNull((c) => c.marketId == widget.marketId && c.eventId == effectiveEventId);
        if (found != null) {
          _catalogue = found;
          context.read<FetchFancyBetExposureBloc>().add(FetchFancyBetExposure(marketId: found.marketId));
          _initializeFromCatalogue(found);
          return; // Already resolved — no loader needed
        }
      }
      // Catalogue not yet available — trigger a fetch
      context.read<FetchCatalougeOnMarketTypeBloc>().add(FetchCatalougeOnMarketType(eventId: int.tryParse(effectiveEventId) ?? 0, marketType: ""));
    }
  }

  void _initializeFromCatalogue(FancyCatalougesOnMarketType cat) {
    pauseByAlpha = cat.pauseByAlpha ?? false;
    final runner = cat.runners.isNotEmpty ? cat.runners.first : null;
    if (runner != null) {
      runnerId = runner.id;
      marketId = cat.marketId;
      backPrice = runner.backs.isNotEmpty ? runner.backs.first.price.toString() : '';
      backLine = runner.backs.isNotEmpty ? runner.backs.first.line.toString() : '';
      layPrice = runner.lays.isNotEmpty ? runner.lays.first.price.toString() : '';
      layLine = runner.lays.isNotEmpty ? runner.lays.first.line.toString() : '';
    }
    betDelay = cat.fancyMarketCondition?.betDelay ?? 0;
    betExposure = cat.fancyMarketCondition?.maxProfit ?? 0;
    betMin = cat.fancyMarketCondition?.minBet ?? 0;
    betMax = cat.fancyMarketCondition?.maxBet ?? 0;
    localStatus = cat.status;
    isBallingRun = cat.sportingEvent;
  }

  void _updateFromSignalR(FancyCatalougesOnMarketType updatedMarket) {
    betDelay = updatedMarket.fancyMarketCondition?.betDelay ?? betDelay;
    betExposure = updatedMarket.fancyMarketCondition?.maxProfit ?? betExposure;
    betMin = updatedMarket.fancyMarketCondition?.minBet ?? betMin;
    betMax = updatedMarket.fancyMarketCondition?.maxBet ?? betMax;
    if (updatedMarket.runners.isNotEmpty) {
      final runner = updatedMarket.runners.first;
      runnerId = runner.id;
      marketId = updatedMarket.marketId;
      backPrice = runner.backs.isNotEmpty ? runner.backs.first.price.toString() : '';
      backLine = runner.backs.isNotEmpty ? runner.backs.first.line.toString() : '';
      layPrice = runner.lays.isNotEmpty ? runner.lays.first.price.toString() : '';
      layLine = runner.lays.isNotEmpty ? runner.lays.first.line.toString() : '';
      if (runner.backs.isNotEmpty) {
        if (runner.backs.length > 1) {
          back2Price = runner.backs[1].price.toString();
          back2Line = runner.backs[1].line.toString();
          lay2Price = runner.lays.length > 1 ? runner.lays[1].price.toString() : '';
          lay2Line = runner.lays.length > 1 ? runner.lays[1].line.toString() : '';
          back3Price = runner.backs.last.price.toString();
          back3Line = runner.backs.last.line.toString();
          lay3Price = runner.lays.isNotEmpty ? runner.lays.last.price.toString() : '';
          lay3Line = runner.lays.isNotEmpty ? runner.lays.last.line.toString() : '';
        }
      }
    }
    localStatus = updatedMarket.status;
    isBallingRun = updatedMarket.sportingEvent;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    // When opened via URL, wait for the bloc to provide the catalogue
    if (_catalogue == null) {
      return BlocConsumer<FetchCatalougeOnMarketTypeBloc, FetchCatalougeOnMarketTypeState>(
        // listener: fired on every state *change* (normal async path)
        listener: (context, cms) {
          if (cms is FetchCatalougeOnMarketTypeSuccess) {
            final found = cms.catalougeDetails.firstWhereOrNull((c) => c.marketId == widget.marketId && c.eventId == (widget.eventId ?? 0));
            if (found != null && mounted) {
              setState(() {
                _catalogue = found;
              });
              context.read<FetchFancyBetExposureBloc>().add(FetchFancyBetExposure(marketId: found.marketId));
              _initializeFromCatalogue(found);
            }
          }
        },
        // builder: also checks the *current* state on each build — catches the
        // race where Success is already emitted before the listener subscribes.
        builder: (context, cms) {
          if (cms is FetchCatalougeOnMarketTypeSuccess && _catalogue == null) {
            final found = cms.catalougeDetails.firstWhereOrNull((c) => c.marketId == widget.marketId && c.eventId == (widget.eventId ?? 0));
            if (found != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted && _catalogue == null) {
                  setState(() {
                    _catalogue = found;
                  });
                  context.read<FetchFancyBetExposureBloc>().add(FetchFancyBetExposure(marketId: found.marketId));
                  _initializeFromCatalogue(found);
                }
              });
            }
          }
          return const LoaderContainerWithMessage();
        },
      );
    }

    // --- Resolve event data ---
    FancyEventData? resolvedEvent = widget.fancyEventData;
    if (resolvedEvent == null) {
      // Watch the bloc so the widget auto-rebuilds when the fetch completes
      final fancyState = context.watch<FetchFancyEventsBloc>().state;
      if (fancyState is FetchFancyEventsSuccess) {
        for (final e in fancyState.eventDetails) {
          if (e.id == _effectiveEventId) {
            resolvedEvent = e;
            break;
          }
        }
      }
    }

    return BlocListener<SignalRSingleFancyMarketDataBloc, SignalRSingleFancyMarketDataState>(
      listener: (context, state) {
        if (state is SignalRSingleFancyMarketDataSuccess) {
          if (!mounted) return;
          setState(() {
            _catalogue = state.fancyCatalogue;

            _updateFromSignalR(state.fancyCatalogue);
          });
        }
      },
      child: BlocListener<UpdateFancyMarketBloc, UpdateFancyMarketState>(
        listener: (context, ums) {
          if (ums is UpdateFancyMarketSuccess) {
            showSnackBar(context, "Market updated");
          }
          if (ums is UpdateFancyMarketFailure) {
            showSnackBar(context, "${ums.error}", error: true);
          }
        },

        child: Container(
          width: size.width * 0.9,
          color: const Color.fromARGB(131, 233, 236, 213),
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FancyBetListHeader(
                  title: "Live Operation",
                  onTap: () {
                    widget.toggleScreen?.call(_catalogue!);
                  },
                ),
                hb20,
                BlocBuilder<SignalRSingleFancyMarketDataBloc, SignalRSingleFancyMarketDataState>(
                  builder: (context, frd) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SelectableText("Market Information", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              hb4,
                              Divider(color: grey, thickness: 1),
                              hb8,
                              FancyMarketDetailsWidget(
                                catalogue: _catalogue,
                                fancyBetEventData: resolvedEvent,
                                onTap: () {
                                  if (localStatus.toUpperCase().contains("SUSPENDED") || localStatus.toUpperCase().contains("SUSPEND") || isBallingRun == true) {
                                    showUpdateFancyMarketRatingDialog(context, _catalogue!, resolvedEvent, betDelay, betExposure, betMin, betMax);
                                  } else {
                                    showSnackBar(context, "You can't update in running market.", error: true);
                                  }
                                },
                              ),
                              hb10,
                              SelectableText("Market Setting", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              if (_catalogue!.marketId.startsWith("_") && !_catalogue!.marketType.startsWith("THREE_SELECTIONS"))
                                ManageManualMarketWidget(
                                  catalogue: _catalogue!,
                                  backPrice: backPrice,
                                  backLine: backLine,
                                  layPrice: layPrice,
                                  layLine: layLine,
                                  localStatus: localStatus,
                                  isBallingRun: isBallingRun,
                                  pauseByAlpha: pauseByAlpha,
                                ),
                              if (_catalogue!.marketId.startsWith("_") && _catalogue!.marketType.startsWith("THREE_SELECTIONS"))
                                ManageManualThreeSelectionMarketWidget(
                                  key: ValueKey("manage${DateTime.now().toIso8601String()}"),
                                  catalogue: _catalogue!,
                                  backPrice: backPrice,
                                  backLine: backLine,
                                  layPrice: layPrice,
                                  layLine: layLine,
                                  localStatus: localStatus,
                                  isBallingRun: isBallingRun,
                                  pauseByAlpha: pauseByAlpha,
                                  back2ndPrice: back2Price,
                                  back2ndLine: back2Line,
                                  back3rdPrice: back3Price,
                                  back3rdLine: back3Line,
                                  lay2ndPrice: lay2Price,
                                  lay2ndLine: lay2Line,
                                  lay3rdPrice: lay3Price,
                                  lay3rdLine: lay3Line,
                                ),
                              hb20,
                              if (!_catalogue!.marketId.startsWith("_"))
                                ManageAutoMarketWidget(
                                  catalogue: _catalogue!,
                                  backPrice: backPrice,
                                  backLine: backLine,
                                  layPrice: layPrice,
                                  layLine: layLine,
                                  localStatus: localStatus,
                                  isBallingRun: isBallingRun,
                                  pauseByAlpha: pauseByAlpha,
                                ),
                              hb5,
                              SelectableText("Automatic odds", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              hb5,
                              CustomToggleSwitch(
                                initialValue: isOn,
                                onChanged: (value) {
                                  setState(() {
                                    isOn = !isOn;
                                  });
                                },
                              ),
                              hb20,
                              SelectableText("Min/Max Runs Setting", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              hb5,
                              Row(
                                children: [
                                  CustomToggleSwitch(
                                    initialValue: isOn,
                                    onChanged: (value) {
                                      setState(() {
                                        isOn = !isOn;
                                      });
                                    },
                                  ),
                                  wb2,
                                  SelectableText("8/8", style: TextStyle(fontSize: 12)),
                                ],
                              ),
                              hb20,
                              SelectableText("Run/Odds Settings", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              if (!_catalogue!.marketType.startsWith("THREE_SELECTIONS"))
                                MarketRunnerRateWidget(
                                  catalogue: _catalogue!,
                                  backPrice: backPrice,
                                  backLine: backLine,
                                  layPrice: layPrice,
                                  layLine: layLine,
                                  localStatus: localStatus,
                                  isBallingRun: isBallingRun,
                                ),
                              hb10,
                              if (_catalogue!.marketType.startsWith("THREE_SELECTIONS"))
                                ManageThreeSelectionsMarketRateWidget(
                                  catalogue: _catalogue!,
                                  localStatus: localStatus,
                                  isBallingRun: isBallingRun,
                                  back1stPrice: backPrice,
                                  back1stLine: backLine,
                                  back2ndPrice: back2Price,
                                  back2ndLine: back2Line,
                                  back3rdPrice: back3Price,
                                  back3rdLine: back3Line,
                                  lay1stPrice: layPrice,
                                  lay1stLine: layLine,
                                  lay2ndPrice: lay2Price,
                                  lay2ndLine: lay2Line,
                                  lay3rdPrice: lay3Price,
                                  lay3rdLine: lay3Line,
                                ),
                              ManageMarketRulesWidget(settingsData: _catalogue!.marketType.startsWith("THREE_SELECTIONS") ? settingsThreeSelectionData : settingsData),
                            ],
                          ),
                        ),
                        wb20,
                        BlocBuilder<FetchFancyBetExposureBloc, FetchFancyBetExposureState>(
                          builder: (context, bes) {
                            List<FancyBetData> fancyBetData = [];
                            if (bes is FetchFancyBetExposureSuccess) {
                              fancyBetData = bes.fancyBetData;
                            }
                            return BlocBuilder<FancyLiveBetExposureBloc, FancyLiveBetExposureState>(
                              builder: (context, ble) {
                                yesExp = ble is FancyLiveBetExposureSuccess
                                    ? ble.fancyLiveBetExposure.exposureYes
                                    : fancyBetData.isNotEmpty
                                    ? fancyBetData.first.exposureYes
                                    : 0.0;
                                noExp = ble is FancyLiveBetExposureSuccess
                                    ? ble.fancyLiveBetExposure.exposureNo
                                    : fancyBetData.isNotEmpty
                                    ? fancyBetData.first.exposureNo
                                    : 0.0;
                                runOddsYes = ble is FancyLiveBetExposureSuccess
                                    ? ble.fancyLiveBetExposure.runsYes
                                    : fancyBetData.isNotEmpty
                                    ? fancyBetData.first.runsYes
                                    : 0.0;
                                runOddsNO = ble is FancyLiveBetExposureSuccess
                                    ? ble.fancyLiveBetExposure.runsNo
                                    : fancyBetData.isNotEmpty
                                    ? fancyBetData.first.runsNo
                                    : 0.0;
                                return Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SelectableText("Run Position", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                      const SizedBox(height: 4),
                                      Divider(color: grey, thickness: 1),
                                      Container(
                                        decoration: BoxDecoration(color: grey.withValues(alpha: 0.3)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              SelectableText("Run", style: TextStyle(fontWeight: FontWeight.w500)),
                                              SelectableText("Amount", style: TextStyle(fontSize: 14)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(color: backBtn),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              SelectableText("$runOddsYes", style: TextStyle(fontWeight: FontWeight.w500)),
                                              SelectableText("$yesExp", style: TextStyle(fontSize: 14)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(color: layBtn),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              SelectableText("$runOddsNO", style: TextStyle(fontWeight: FontWeight.w500)),
                                              SelectableText("$noExp", style: TextStyle(fontSize: 14)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
