import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import '../../../../reusable/colors.dart';
import '../../../../reusable/sized_box_hw.dart';
import '../manageBanners/banner_widgets.dart';

class ManageRulesScreen extends StatelessWidget {
  const ManageRulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    QuillController updateTextcontroller = QuillController.basic();

    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        double leftWidth = screenWidth * 0.2;
        double rightWidth = (screenWidth * 0.8) - 60;

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              SizedBox(
                width: leftWidth,
                child: BannerCard(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Add New Rule',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: black),
                      ),
                      CustomTFCard(title: 'Rule', hintText: 'Enter rule', width: leftWidth),
                      hb20,

                      // Save Button
                      SizedBox(
                        height: 45,
                        width: leftWidth,
                        child: CmsCTAButton(
                          type: 1,
                          icon: Icons.save,
                          title: 'Add Rule',
                          action: () {
                            ///
                          },
                        ),
                      ),
                      Expanded(child: Text('data')),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),

              SizedBox(
                width: rightWidth,
                height: constraints.maxHeight,
                child: BannerCard(
                  child: Column(
                    children: [
                      Container(
                        width: rightWidth,
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: blue, width: 2)),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: QuillSimpleToolbar(
                            controller: updateTextcontroller,
                            config: QuillSimpleToolbarConfig(
                              showQuote: false,
                              showIndent: false,
                              showCodeBlock: false,
                              showSubscript: false,
                              showInlineCode: false,
                              showSuperscript: false,
                              showSearchButton: false,
                              iconTheme: QuillIconTheme(
                                iconButtonUnselectedData: const IconButtonData(color: blue),
                                iconButtonSelectedData: IconButtonData(
                                  color: white,
                                  style: ButtonStyle(backgroundColor: WidgetStateProperty.all(blue)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      hb20,
                      Expanded(
                        child: QuillEditor.basic(
                          controller: updateTextcontroller,
                          config: QuillEditorConfig(expands: true, autoFocus: true,showCursor: true, padding: const EdgeInsets.all(8)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
