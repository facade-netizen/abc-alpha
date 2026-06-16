import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../bloc/updateBlocs/update_market_condition_bloc.dart';
import '../../../../../../model/fancy_catalouges_on_markettype_model.dart';
import '../../../../../../model/fancy_events_model.dart';
import '../../../../../../reusable/button.dart';
import '../../../../../../reusable/colors.dart';
import '../../../../../../reusable/custom_alert_dialog.dart';
import '../../../../../../reusable/loader.dart';
import '../../../../../../reusable/navigators.dart';
import '../../../../../../reusable/sized_box_hw.dart';
import '../../../../../../reusable/snack_bar.dart';
import '../../../../../../reusable/style.dart';
import '../../../betlistConstant/betlist_string_constants.dart';

Future showUpdateFancyMarketRatingDialog(
  BuildContext context,
  FancyCatalougesOnMarketType markets,
  FancyEventData? fancyEventData,
  double betDelay,
  double betExposure,
  double betMin,
  double betMax,
) {
  return showDialog(
    context: context,
    builder: (context) =>
        UpdateMarketRatingDialogBody(markets: markets, fancyEventData: fancyEventData, betDelay: betDelay, betExposure: betExposure, betMin: betMin, betMax: betMax),
  );
}

class UpdateMarketRatingDialogBody extends StatefulWidget {
  const UpdateMarketRatingDialogBody({
    super.key,
    required this.markets,
    this.fancyEventData,
    required this.betDelay,
    required this.betExposure,
    required this.betMin,
    required this.betMax,
  });
  final FancyCatalougesOnMarketType markets;
  final FancyEventData? fancyEventData;
  final double betDelay;
  final double betExposure;
  final double betMin;
  final double betMax;

  @override
  State<UpdateMarketRatingDialogBody> createState() => _UpdateMarketRatingDialogBodyState();
}

class _UpdateMarketRatingDialogBodyState extends State<UpdateMarketRatingDialogBody> {
  TextEditingController ratingCtrl = TextEditingController();
  TextEditingController delayCtrl = TextEditingController();
  TextEditingController rebateCtrl = TextEditingController();
  TextEditingController exposureCtrl = TextEditingController();
  late ValueNotifier<String?> selectedItem;
  late List<String> uniqueMinMaxBetList;
  @override
  void initState() {
    super.initState();
    uniqueMinMaxBetList = minMaxBetList.toSet().toList();
    final min = widget.betMin.toString();
    final max = widget.betMax.toString();
    String result = [min, max].join('-');
    String initialValue = uniqueMinMaxBetList.contains(result) ? result : uniqueMinMaxBetList.first;
    selectedItem = ValueNotifier(initialValue);
    delayCtrl.text = widget.betDelay.toString();
    exposureCtrl.text = widget.betExposure.toString();
  }

  @override
  void dispose() {
    selectedItem.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdateMarketConditionBloc, UpdateMarketConditionState>(
      listener: (context, umd) {
        if (umd is UpdateMarketConditionSuccess) {
          showSnackBar(context, "Update rating successfully");
          removeScreen(context);
        }
        if (umd is UpdateMarketConditionFailure) {
          showSnackBar(context, "Failed to update rating");
        }
      },
      builder: (context, umd) {
        return CustomAlertDialog(
          title: 'Update Rating',
          content: SizedBox(
            width: 500,
            height: 220,
            child: umd is UpdateMarketConditionProgress
                ? LoaderContainerWithMessage()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SelectableText("Rating Name:"),
                          SizedBox(
                            height: 30,
                            width: 200,
                            child: TextFormField(
                              readOnly: true,
                              controller: ratingCtrl,
                              decoration: tfInputDecoration.copyWith(contentPadding: const EdgeInsets.symmetric(horizontal: 10)),
                            ),
                          ),
                        ],
                      ),
                      hb10,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SelectableText("Rebate%:"),
                          SizedBox(
                            height: 30,
                            width: 200,
                            child: TextFormField(
                              readOnly: true,
                              controller: rebateCtrl,
                              decoration: tfInputDecoration.copyWith(contentPadding: const EdgeInsets.symmetric(horizontal: 10)),
                            ),
                          ),
                        ],
                      ),
                      hb10,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(child: SelectableText("Min/Max(${widget.markets.marketType}): ")),
                          SizedBox(
                            height: 30,
                            width: 200,
                            child: DropdownButtonFormField2<String>(
                              valueListenable: selectedItem,
                              isExpanded: true,
                              iconStyleData: const IconStyleData(icon: Icon(Icons.keyboard_arrow_down, color: black, size: 13)),
                              dropdownStyleData: DropdownStyleData(
                                decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: grey),
                                ),
                              ),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                              ),
                              items: uniqueMinMaxBetList.map((item) {
                                return DropdownItem<String>(
                                  value: item,
                                  child: Text(item, style: const TextStyle(fontSize: 12, color: black)),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  selectedItem.value = value;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      hb10,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SelectableText("Delay Betting:"),
                          SizedBox(
                            height: 30,
                            width: 200,
                            child: TextFormField(
                              controller: delayCtrl,
                              decoration: tfInputDecoration.copyWith(contentPadding: const EdgeInsets.symmetric(horizontal: 10), suffix: SelectableText("(Seconds)")),
                            ),
                          ),
                        ],
                      ),
                      hb10,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SelectableText("Exposure(${widget.markets.marketType}):"),
                          SizedBox(
                            height: 30,
                            width: 200,
                            child: TextFormField(
                              controller: exposureCtrl,
                              decoration: tfInputDecoration.copyWith(contentPadding: const EdgeInsets.symmetric(horizontal: 10)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: CustomHoverButton(
                    width: 80,
                    height: 30,
                    onPressed: () {
                      List<String> parts = selectedItem.value!.split('-');
                      int minBet = int.tryParse(parts[0]) ?? 0;
                      int maxBet = int.tryParse(parts[1]) ?? 0;
                      Map<String, dynamic> updateMarketConditionMap = {
                        "marketId": widget.markets.marketId,
                        "betLock": true,
                        "minBet": minBet,
                        "maxBet": maxBet,
                        "maxProfit": double.tryParse(exposureCtrl.text) ?? 0,
                        "betDelay": double.tryParse(delayCtrl.text) ?? 0,
                        "mtp": 0,
                        "allowUnmatchBet": true,
                        "potLimit": 0,
                        "volume": 0,
                      };
                      debugPrint('updateMarketConditionMap: $updateMarketConditionMap');
                      context.read<UpdateMarketConditionBloc>().add(UpdateMarketCondition(updateMarketConditionMap: updateMarketConditionMap));
                    },
                    title: 'Save',
                    textColor: white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: CustomHoverButton(
                    width: 80,
                    height: 30,
                    onPressed: () {
                      removeScreen(context);
                    },
                    title: 'Cancel',
                    textColor: white,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
