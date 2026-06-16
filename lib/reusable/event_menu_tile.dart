import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../services/web_utils.dart' as web_utils;
import 'colors.dart';
import 'formatters.dart';
import 'sized_box_hw.dart';

class MenuTileWithLabelAndIcon extends StatelessWidget {
  const MenuTileWithLabelAndIcon({super.key, required this.action, required this.eventTypeName, required this.selectedEditorName, required this.eventTypeIcon, this.rightClickUrl});
  final void Function() action;
  final String selectedEditorName;
  final String eventTypeName;
  final String eventTypeIcon;
  final String? rightClickUrl;

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedEditorName == eventTypeName;
    final borderColor = isSelected ? blue : grey;
    final borderWidth = isSelected ? 2.0 : 1.0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Listener(
        onPointerDown: (PointerDownEvent event) {
          if (event.buttons == kSecondaryMouseButton && rightClickUrl != null) {
            web_utils.openNewTab(rightClickUrl!);
          }
        },
        child: InkWell(
          onTap: action,
          child: Container(
            height: 30,
            decoration: BoxDecoration(
              border: Border.all(width: borderWidth, color: borderColor),
              borderRadius: const BorderRadius.all(Radius.circular(8 / 2)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.network(
                    eventTypeIcon,
                    colorFilter: isSelected ? ColorFilter.mode(blue, BlendMode.srcIn) : ColorFilter.mode(grey, BlendMode.srcIn),
                    height: 22,
                    width: 22,
                  ),
                  wb4,
                  Expanded(
                    child: Text(
                      eventTypeName,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: isSelected ? blue : grey, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MenuTileWithLabel extends StatelessWidget {
  const MenuTileWithLabel({
    super.key,
    required this.action,
    required this.compName,
    required this.selectedEditorName,
    required this.compId,
    required this.selectedCompId,
    this.rightClickUrl,
  });
  final void Function() action;
  final String selectedEditorName;
  final String compName;
  final String compId;
  final String selectedCompId;
  final String? rightClickUrl;

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedEditorName == compName && selectedCompId == compId;
    final borderColor = isSelected ? blue : grey;
    final borderWidth = isSelected ? 2.0 : 1.0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Listener(
        onPointerDown: (PointerDownEvent event) {
          if (event.buttons == kSecondaryMouseButton && rightClickUrl != null) {
            web_utils.openNewTab(rightClickUrl!);
          }
        },
        child: InkWell(
          onTap: action,
          child: Container(
            height: 30,
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
            decoration: BoxDecoration(
              border: Border.all(width: borderWidth, color: borderColor),
              borderRadius: const BorderRadius.all(Radius.circular(8 / 2)),
            ),
            child: Text(
              compName,
              style: TextStyle(color: isSelected ? blue : black, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, fontSize: 12, overflow: TextOverflow.ellipsis),
            ),
          ),
        ),
      ),
    );
  }
}

class MenuTileWithLabelAndDate extends StatelessWidget {
  const MenuTileWithLabelAndDate({
    super.key,
    this.height,
    required this.action,
    required this.compName,
    required this.selectedEditorName,
    required this.compId,
    required this.selectedCompId,
    required this.eventOpenDate,
  });
  final void Function() action;
  final String selectedEditorName;
  final String eventOpenDate;
  final String compName;
  final int compId;
  final int selectedCompId;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedEditorName == compName && selectedCompId == compId;
    final borderColor = isSelected ? blue : grey;
    final borderWidth = isSelected ? 2.0 : 1.0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: InkWell(
        onTap: action,
        child: Container(
          height: height ?? 30,
          decoration: BoxDecoration(
            border: Border.all(width: borderWidth, color: borderColor),
            borderRadius: const BorderRadius.all(Radius.circular(8 / 2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                compName,
                style: TextStyle(color: isSelected ? blue : grey, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, fontSize: 12, overflow: TextOverflow.ellipsis),
              ),
              hb5,
              Text(
                formattedDateFromISO(eventOpenDate),
                style: TextStyle(color: isSelected ? blue : grey, fontSize: 10, overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuTileWithLabelWithDateAndEventId extends StatelessWidget {
  const MenuTileWithLabelWithDateAndEventId({
    super.key,
    this.height,
    required this.action,
    required this.compName,
    required this.selectedEditorName,
    required this.compId,
    required this.selectedCompId,
    required this.eventOpenDate,
  });
  final void Function() action;
  final String selectedEditorName;
  final String eventOpenDate;
  final String compName;
  final int compId;
  final int selectedCompId;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedEditorName == compName && selectedCompId == compId;
    final borderColor = isSelected ? blue : grey;
    final borderWidth = isSelected ? 2.0 : 1.0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: InkWell(
        onTap: action,
        child: Container(
          height: height ?? 30,
          decoration: BoxDecoration(
            border: Border.all(width: borderWidth, color: borderColor),
            borderRadius: const BorderRadius.all(Radius.circular(8 / 2)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      compName,
                      style: TextStyle(
                        color: isSelected ? blue : grey,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    hb5,
                    Text(
                      formattedDateFromISO(eventOpenDate),
                      style: TextStyle(color: isSelected ? blue : grey, fontSize: 10, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
                Text(
                  compId.toString(),
                  style: TextStyle(color: isSelected ? blue : grey, fontSize: 14, overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
