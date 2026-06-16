import 'package:flutter/material.dart';

import '../../../../reusable/button.dart';
import '../../../../reusable/colors.dart';
import '../../../../reusable/sized_box_hw.dart';

class FancyBetMarketMinMaxRuns extends StatefulWidget {
  const FancyBetMarketMinMaxRuns({super.key});

  @override
  State<FancyBetMarketMinMaxRuns> createState() => _FancyBetMarketMinMaxRunsState();
}

class _FancyBetMarketMinMaxRunsState extends State<FancyBetMarketMinMaxRuns> {
  TextEditingController minController = TextEditingController(text: "8");
  TextEditingController maxController = TextEditingController(text: "8");

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("FancyBet Market Min/Max Runs", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          Row(
            children: [
              Text("Min"),
              wb5,
              SizedBox(
                height: 30,
                width: 60,
                child: TextFormField(
                  controller: minController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                    labelStyle: const TextStyle(fontSize: 14),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: black, width: 2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: grey, width: 2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          ),
          hb10,
          Row(
            children: [
              Text("Max"),
              wb5,
              SizedBox(
                height: 30,
                width: 60,
                child: TextFormField(
                  controller: maxController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                    labelStyle: const TextStyle(fontSize: 14),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: black, width: 2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: grey, width: 2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          ),
          hb10,
          CustomHoverButton(width: 120, height: 20, title: 'Save', fontWeight: FontWeight.w700, fontSize: 11, textColor: white, onPressed: () {}),
        ],
      ),
    );
  }
}
