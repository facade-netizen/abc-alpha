import 'package:flutter/material.dart';

import '../../../../../../model/fancy_catalouges_on_markettype_model.dart';
import '../../../../../../model/fancy_events_model.dart';
import '../../../../../../reusable/colors.dart';
import '../../../../../../reusable/date_time_formatter.dart';
import '../../../../../../reusable/sized_box_hw.dart';

class FancyMarketDetailsWidget extends StatelessWidget {
  const FancyMarketDetailsWidget({super.key, this.catalogue, this.fancyBetEventData, this.onTap});
  final FancyCatalougesOnMarketType? catalogue;
  final FancyEventData? fancyBetEventData;
  final void Function()? onTap;

  String _valueOrDash(String? value) {
    if (value == null) return '-';
    final trimmed = value.trim();
    return trimmed.isEmpty ? '-' : trimmed;
  }

  @override
  Widget build(BuildContext context) {
    final startDate = fancyBetEventData?.openDate ?? catalogue?.marketTime;
    final competitionText = _valueOrDash(catalogue?.competitionName);
    final eventNameText = _valueOrDash(fancyBetEventData?.name ?? catalogue?.eventName);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SelectableText("Start Date:", style: TextStyle(fontWeight: FontWeight.w500)),
                  SelectableText(startDate != null ? formatDateString(startDate) : "-", style: TextStyle(fontSize: 14)),
                ],
              ),
              hb5,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SelectableText("Event Id:", style: TextStyle(fontWeight: FontWeight.w500)),
                  SelectableText(fancyBetEventData?.id.toString() ?? catalogue?.eventId.toString() ?? '-', style: TextStyle(fontSize: 14)),
                ],
              ),
              hb5,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SelectableText("Market Id:", style: TextStyle(fontWeight: FontWeight.w500)),
                  SelectableText(catalogue?.marketId ?? '-', style: TextStyle(fontSize: 14)),
                ],
              ),
              hb5,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SelectableText("Status:", style: TextStyle(fontWeight: FontWeight.w500)),
                  SelectableText(catalogue?.status.toUpperCase() ?? '-', style: TextStyle(fontSize: 14)),
                ],
              ),
            ],
          ),
        ),
        wb50,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SelectableText("Competition:", style: TextStyle(fontWeight: FontWeight.w500)),
                  SelectableText(competitionText != '-' ? competitionText : fancyBetEventData?.competitionId.toString() ?? '-', style: TextStyle(fontSize: 14)),
                ],
              ),
              hb5,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SelectableText("Event Name:", style: TextStyle(fontWeight: FontWeight.w500)),
                  Flexible(child: SelectableText(eventNameText, style: TextStyle(fontSize: 14))),
                ],
              ),
              hb5,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SelectableText("Market Name:", style: TextStyle(fontWeight: FontWeight.w500)),
                  SelectableText(catalogue!.marketName, style: TextStyle(fontSize: 14)),
                ],
              ),
              hb5,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SelectableText("Rating:", style: TextStyle(fontWeight: FontWeight.w500)),
                  InkWell(
                    onTap: onTap,
                    child: Text(
                      "Edit",
                      style: TextStyle(color: Colors.blue, fontSize: 14, decoration: TextDecoration.underline, decorationColor: blue, decorationThickness: 0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
