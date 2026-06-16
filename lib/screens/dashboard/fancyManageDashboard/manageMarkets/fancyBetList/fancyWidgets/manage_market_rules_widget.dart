import 'package:flutter/material.dart';

import '../../../../../../reusable/colors.dart';
import '../../../../../../reusable/sized_box_hw.dart';

class ManageMarketRulesWidget extends StatefulWidget {
  const ManageMarketRulesWidget({super.key, required this.settingsData});
  final List<Map<String, String>> settingsData;
  @override
  State<ManageMarketRulesWidget> createState() => _ManageMarketRulesWidgetState();
}

class _ManageMarketRulesWidgetState extends State<ManageMarketRulesWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        hb10,
        SelectableText("Input Command", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        hb10,
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: white,
            border: Border(
              top: BorderSide(color: grey),
              bottom: BorderSide(color: grey),
            ),
          ),
          child: const Row(
            children: [
              Expanded(
                flex: 2,
                child: SelectableText("Setting", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: SelectableText("Description", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: widget.settingsData.length,
          itemBuilder: (context, index) {
            final item = widget.settingsData[index];
            return Container(
              decoration: BoxDecoration(
                color: white,
                border: Border(bottom: BorderSide(color: grey, width: 0.2)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: SelectableText(item["setting"] ?? "")),
                    Expanded(flex: 3, child: SelectableText(item["description"] ?? "")),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
