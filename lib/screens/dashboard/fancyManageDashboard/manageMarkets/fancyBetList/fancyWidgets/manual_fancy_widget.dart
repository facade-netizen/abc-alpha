import 'package:flutter/widgets.dart';

import '../../../../../../reusable/button.dart';
import '../../../../../../reusable/colors.dart';

class ManualFancyWidget extends StatefulWidget {
  const ManualFancyWidget({
    super.key,
    required this.titleSusp,
    required this.titleStart,
    required this.titleBall,
    required this.titleClose,
    required this.onTapStart,
    required this.onTapClose,
    required this.onTapSuspend,
    required this.onTapBallRunn,
    required this.isDisabledStart,
    required this.isDisabledSuspn,
    required this.isDisabledClose,
    required this.isDisabledBallRun,
  });
  final String titleSusp;
  final String titleStart;
  final String titleBall;
  final String titleClose;
  final bool isDisabledStart;
  final bool isDisabledSuspn;
  final bool isDisabledClose;
  final bool isDisabledBallRun;
  final void Function() onTapStart;
  final void Function() onTapSuspend;
  final void Function() onTapBallRunn;
  final void Function() onTapClose;
  @override
  State<ManualFancyWidget> createState() => _ManualFancyWidgetState();
}

class _ManualFancyWidgetState extends State<ManualFancyWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: white,
        border: Border(bottom: BorderSide()),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomHoverButton(width: 120, height: 30, isDisabled: widget.isDisabledStart, onPressed: widget.onTapStart, title: widget.titleStart, textColor: white),
            CustomHoverButton(width: 120, height: 30, isDisabled: widget.isDisabledSuspn, onPressed: widget.onTapSuspend, title: widget.titleSusp, textColor: white),
            CustomHoverButton(width: 120, height: 30, isDisabled: widget.isDisabledBallRun, onPressed: widget.onTapBallRunn, title: widget.titleBall, textColor: white),
            CustomHoverButton(width: 120, height: 30, isDisabled: widget.isDisabledClose, onPressed: widget.onTapClose, title: widget.titleClose, textColor: white),
          ],
        ),
      ),
    );
  }
}
