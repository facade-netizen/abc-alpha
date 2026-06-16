import 'package:flutter/material.dart';

import '../../../../reusable/colors.dart';
import '../../../../reusable/sized_box_hw.dart';
import '../../../../reusable/snack_bar.dart';
import '../manageBanners/banner_widgets.dart';
import 'marquee_widgets.dart';

class ManageMarqueeScreen extends StatefulWidget {
  const ManageMarqueeScreen({super.key});

  @override
  State<ManageMarqueeScreen> createState() => _ManageMarqueeScreenState();
}

class _ManageMarqueeScreenState extends State<ManageMarqueeScreen> {
  final TextEditingController marqueeController = TextEditingController();
  String preview = '🏆 Champions League Final: Real Madrid vs Liverpool - Bet now! ⚽';

  @override
  void initState() {
    super.initState();
    marqueeController.text = '🔥 IPL 2025: Mumbai Indians vs CSK - Live odds: 2.10 | 1.95 | 2.30';
  }

  @override
  void dispose() {
    marqueeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    double tfw = size.width * 0.4;
    return Container(
      color: white,
      width: size.width,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Betting App Marquee Preview with Sports Theme
              MarqueePreviewCard(preview: preview, width: tfw),
              hb20,

              // Marquee Input Field with Betting Context
              CustomTFCard(
                width: tfw,
                title: 'Edit Betting Marquee',
                hintText: 'e.g. ⚽ UCL: Man City vs Bayern - Odds: 1.95 | 2.10 | 3.40',
                maxLines: 3,
                controller: marqueeController,
              ),
              hb10,

              // Betting-Specific Hint Text
              MarqueeHintCard(width: tfw),
              hb20,

              // Save Button
              SizedBox(
                width: tfw,
                height: 45,
                child: CmsCTAButton(
                  type: 1,
                  icon: Icons.save,
                  title: 'Update Marquee',
                  action: () {
                    setState(() {
                      preview = marqueeController.text.isNotEmpty ? marqueeController.text : '🏆 Champions League Final: Real Madrid vs Liverpool - Bet now! ⚽';
                    });

                    showSnackBar(context, 'Marquee updated: ${marqueeController.text.length > 30 ? '${marqueeController.text.substring(0, 30)}...' : marqueeController.text}');
                  },
                ),
              ),
              hb20,

              // Betting App Tips Section
              MarqueeTips(width: tfw),
              hb20,
              // Quick Templates Section
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  TemplateChip(
                    label: '⚽ UCL Final',
                    onTap: () {
                      setState(() {
                        marqueeController.text = '⚽ UCL Final: Real Madrid vs Liverpool - Odds: 2.10 | 2.80 | 3.20';
                      });
                    },
                  ),
                  TemplateChip(
                    label: '🏏 IPL',
                    onTap: () {
                      setState(() {
                        marqueeController.text = '🏏 IPL 2025: MI vs CSK - Who will win? Bet now! 1.95 | 2.05';
                      });
                    },
                  ),
                  TemplateChip(
                    label: '🎾 Grand Slam',
                    onTap: () {
                      setState(() {
                        marqueeController.text = '🎾 Wimbledon: Alcaraz vs Djokovic - Live odds: 2.30 | 1.85';
                      });
                    },
                  ),
                  TemplateChip(
                    label: '💰 Bonus',
                    onTap: () {
                      setState(() {
                        marqueeController.text = '💰 Welcome Bonus: 100% up to €50 - Sign up & bet today!';
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
