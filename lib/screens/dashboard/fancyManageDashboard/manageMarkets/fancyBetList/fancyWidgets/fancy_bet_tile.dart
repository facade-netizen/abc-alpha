import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../bloc/signalRBloc/signalRStreamers/fancy_market_signalr_data_bloc.dart';
import '../../../../../../model/fancy_catalouges_on_markettype_model.dart';
import '../../../../../../reusable/colors.dart';
import '../../../../../../reusable/sized_box_hw.dart';
import '../../../../../../reusable/style.dart';

class FancyBetTile extends StatefulWidget {
  const FancyBetTile({super.key, required this.idx, required this.action, required this.fancyBet, required this.activeIndex});

  final int idx;
  final int activeIndex;
  final FancyCatalougesOnMarketType fancyBet;
  final Function(int) action;

  @override
  State<FancyBetTile> createState() => _FancyBetTileState();
}

class _FancyBetTileState extends State<FancyBetTile> {
  final TextEditingController unit = TextEditingController();

  bool? isYes;
  String selectedPrice = '';
  String selectedLine = '';
  String runnerId = '';
  String noPrice = '';
  String yesPrice = '';

  MarketRunner? lastValidRunner;

  /// Hover
  bool isHovered = false;
  bool isClicked = false;

  /// Flash logic
  final Map<String, Color> flashColors = {};
  final Map<String, double> previousPrices = {};
  Timer? _flashTimer;

  @override
  void initState() {
    super.initState();
    unit.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    unit.dispose();
    _flashTimer?.cancel();
    super.dispose();
  }

  void _select(bool yes, String price, String line) {
    if (widget.activeIndex != widget.idx) {
      widget.action(widget.idx);
    }

    setState(() {
      isYes = yes;
      selectedPrice = price;
      selectedLine = line;
      isClicked = !isClicked;
    });
  }

  /// DETECT PRICE CHANGES (YES / NO) exactly as requested
  void detectPriceChanges(MarketRunner? newRunner) {
    if (newRunner == null) return;
    final marketId = widget.fancyBet.marketId;

    // NO (backs)
    if (newRunner.backs.isNotEmpty) {
      final currentPrice = newRunner.backs.first.price.toDouble();
      final noKey = '$marketId-NO';

      if (previousPrices.containsKey(noKey)) {
        final prevPrice = previousPrices[noKey]!;
        if (currentPrice > prevPrice) {
          flashColors[noKey] = yellowTextColor;
        } else if (currentPrice < prevPrice) {
          flashColors[noKey] = cyan;
        }
      }
      previousPrices[noKey] = currentPrice;
    }

    // YES (lays)
    if (newRunner.lays.isNotEmpty) {
      final currentPrice = newRunner.lays.first.price.toDouble();
      final yesKey = '$marketId-YES';

      if (previousPrices.containsKey(yesKey)) {
        final prevPrice = previousPrices[yesKey]!;
        if (currentPrice > prevPrice) {
          flashColors[yesKey] = yellowTextColor;
        } else if (currentPrice < prevPrice) {
          flashColors[yesKey] = cyan;
        }
      }
      previousPrices[yesKey] = currentPrice;
    }

    // Clear flash after 3 seconds
    if (flashColors.isNotEmpty) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) setState(() => flashColors.clear());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bet = widget.fancyBet;
    final isActive = widget.activeIndex == widget.idx;
    final marketId = bet.marketId;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: Container(
        decoration: BoxDecoration(
          color: isHovered ? highlightTileHover : white,
          border: const Border(bottom: BorderSide(color: black, width: 0.5)),
        ),
        child: Row(
          children: [
            FancyBetName(key: ValueKey(unit.text), bet: bet, isActive: isActive, fancyNetVisible: false, fancyExposure: '', fancyNet: ''),
            Expanded(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 50,
                      height: 25,
                      decoration: BoxDecoration(
                        color: const Color(0xffffcc51),
                        border: Border.all(color: black),
                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                      ),
                      child: const Center(
                        child: Text("Book", style: TextStyle(color: black)),
                      ),
                    ),
                  ),
                  BlocBuilder<SignalRFancyMarketDataBloc, SignalRFancyMarketDataState>(
                    builder: (context, frd) {
                      MarketRunner? runner;

                      if (frd is SignalRFancyMarketDataSuccess) {
                        final market = frd.fancyCatalogues.where((m) => m.marketId == marketId).toList();

                        if (market.isNotEmpty && market.first.runners.isNotEmpty) {
                          runner = market.first.runners.first;
                          lastValidRunner = runner;
                        }
                      }

                      runner ??= lastValidRunner;

                      detectPriceChanges(runner);

                      /// Runner null fallback
                      final hasNo = runner?.lays.isNotEmpty ?? false;
                      final hasYes = runner?.backs.isNotEmpty ?? false;

                      noPrice = runner?.lays.isNotEmpty == true ? runner!.lays.first.price.toString() : '';
                      final noLine = runner?.lays.isNotEmpty == true ? runner!.lays.first.line.toString() : '';

                      yesPrice = runner?.backs.isNotEmpty == true ? runner!.backs.first.price.toString() : '';
                      final yesLine = runner?.backs.isNotEmpty == true ? runner!.backs.first.line.toString() : '';

                      runnerId = runner?.id ?? '';

                      /// Derived status
                      final status = widget.fancyBet.status.toLowerCase();
                      final isBallRunning = bet.sportingEvent;

                      final isMarketActive =
                          !['closed', 'removed', 'inactive', 'removed_vacant', 'suspended'].contains(status) &&
                          (runner?.status == 'ACTIVE' || runner?.status == 'OPEN') &&
                          !isBallRunning &&
                          hasNo &&
                          hasYes;

                      return Stack(
                        children: [
                          Row(
                            children: [
                              YesNoCTAButton(
                                key: ValueKey('$marketId-NO'),
                                type: 0,
                                active: isActive && isYes == false,
                                price: noPrice,
                                line: noLine,
                                isFlash: flashColors.containsKey('$marketId-NO'),
                                flashColor: flashColors['$marketId-NO'],
                                action: isMarketActive && hasNo ? () => _select(false, noPrice, noLine) : null,
                              ),
                              YesNoCTAButton(
                                key: ValueKey('$marketId-YES'),
                                type: 1,
                                active: isActive && isYes == true,
                                price: yesPrice,
                                line: yesLine,
                                isFlash: flashColors.containsKey('$marketId-YES'),
                                flashColor: flashColors['$marketId-YES'],
                                action: isMarketActive && hasYes ? () => _select(true, yesPrice, yesLine) : null,
                              ),
                            ],
                          ),

                          /// STATUS OVERLAY
                          if (!isMarketActive)
                            FBStatus(
                              key: ValueKey('status_$marketId'),
                              status: isBallRunning
                                  ? 'Ball Running'
                                  : !(status.toLowerCase().contains("online") || status.toLowerCase().contains("active") || status.toLowerCase().contains("open"))
                                  ? 'Suspended'
                                  : "Suspended",
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  FancyExposureInfo(bet: bet),
                  FancyBetLimitInfo(bet: bet),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FancyExposureInfo extends StatelessWidget {
  const FancyExposureInfo({super.key, required this.bet});
  final FancyCatalougesOnMarketType bet;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Current Odds Exposure', style: TextStyle(color: applyOpacity(darkGreen, 0.7), fontSize: 12)),
            hb4,
            Text(
              "0.00/0.00",
              style: const TextStyle(color: black, fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class FancyBetLimitInfo extends StatelessWidget {
  const FancyBetLimitInfo({super.key, required this.bet});
  final FancyCatalougesOnMarketType bet;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bet Limit', style: TextStyle(color: applyOpacity(darkGreen, 0.7), fontSize: 12)),
            hb4,
            Text(
              "${bet.fancyMarketCondition?.minBet}/${bet.fancyMarketCondition?.maxBet}",
              style: const TextStyle(color: black, fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class YesNoCTAButton extends StatelessWidget {
  const YesNoCTAButton({super.key, this.price, this.line, this.active = false, this.action, this.color, this.type = 1, this.isFlash = false, this.flashColor});
  final int type;
  final Color? color;
  final bool active;
  final bool isFlash;
  final Color? flashColor;
  final String? price, line;
  final void Function()? action;

  @override
  Widget build(BuildContext context) {
    // Use flash color if flashing, otherwise use provided color or default
    final displayColor = isFlash && flashColor != null ? flashColor! : (color ?? (type == 1 ? (active ? oddsBackBtn : backBtn) : (active ? pinkButtonClr : layBtn)));
    return InkWell(
      onTap: action,
      child: Container(
        height: 45,
        width: blw(context),
        decoration: BoxDecoration(
          color: displayColor,
          border: Border.all(color: white),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(line ?? "-", style: b13ts(color: active ? white : black)),
              Text(
                price ?? "-",
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal, color: active ? white : black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

double blw(BuildContext context) {
  Size size = MediaQuery.sizeOf(context);
  return size.width * 0.055;
}

class FancyBetName extends StatelessWidget {
  const FancyBetName({super.key, required this.bet, required this.isActive, required this.fancyNetVisible, required this.fancyExposure, required this.fancyNet, this.color});
  final String fancyNet;
  final String fancyExposure;
  final Color? color;
  final FancyCatalougesOnMarketType bet;
  final bool isActive, fancyNetVisible;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Text(bet.marketName, style: b14ts),
      ),
    );
  }
}

class FBStatus extends StatelessWidget {
  const FBStatus({super.key, required this.status});
  final String status;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: blw(context) * 2,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: applyOpacity(black, 0.2)),
      child: Center(
        child: Text(status, style: b13ts(color: white)),
      ),
    );
  }
}
