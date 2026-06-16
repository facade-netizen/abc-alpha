import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../bloc/addBlocs/add_new_fancy_bloc.dart';
import '../../../../../../../reusable/button.dart';
import '../../../../../../../reusable/custom_alert_dialog.dart';
import '../../../../../../../reusable/loader.dart';
import '../../../../../../../reusable/navigators.dart';
import '../../../../../../../reusable/snack_bar.dart';
import '../../../../../../reusable/colors.dart';
import '../../../../../../reusable/sized_box_hw.dart';

Future showCreateNewFancyMarketDialog(BuildContext context, String eventId, String marketType) {
  final addBloc = context.read<AddNewFancyMarketBloc>();
  return showDialog(
    context: context,
    builder: (_) => BlocProvider.value(
      value: addBloc,
      child: CreateNewFancyMarketDialogBody(marketType: marketType, eventId: eventId),
    ),
  );
}

class CreateNewFancyMarketDialogBody extends StatefulWidget {
  const CreateNewFancyMarketDialogBody({super.key, required this.eventId, required this.marketType});
  final String marketType;
  final String eventId;
  @override
  State<CreateNewFancyMarketDialogBody> createState() => _CreateNewFancyMarketDialogBodyState();
}

class _CreateNewFancyMarketDialogBodyState extends State<CreateNewFancyMarketDialogBody> {
  final TextEditingController fancyNameCtrl = TextEditingController();
  final createNewFacnyFormKey = GlobalKey<FormState>();
  double fieldWidth = 310;
  double fieldSpacing = 10;
  Map<String, dynamic> createFacyMap = {};

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddNewFancyMarketBloc, AddNewFancyMarketState>(
      listener: (context, cfm) {
        if (cfm is AddNewFancyMarketSuccess) {
          showSnackBar(context, "New fancy added successfully");
          removeScreen(context);
        }
        if (cfm is AddNewFancyMarketFailure) {
          showSnackBar(context, "Unable to add new fancy", error: true);
          removeScreen(context);
        }
      },
      builder: (context, cfm) {
        return CustomAlertDialog(
          title: 'Create Market',
          content: SizedBox(
            height: 100,
            child: cfm is AddNewFancyMarketProgress
                ? LoaderContainerWithMessage()
                : Form(
                    key: createNewFacnyFormKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Market Day: 1", style: TextStyle(color: textColor)),
                        hb5,
                        Row(
                          children: [
                            RadioGroup<bool>(groupValue: true, onChanged: (bool? value) {}, child: const Radio<bool>(value: true)),
                            Text(widget.marketType, style: const TextStyle(fontSize: 14)),
                            wb10,
                            SizedBox(
                              height: 30,
                              width: 200,
                              child: TextFormField(
                                controller: fancyNameCtrl,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                style: TextStyle(fontSize: 14),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                                  labelStyle: const TextStyle(fontSize: 14),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: blue, width: 2),
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
                      ],
                    ),
                  ),
          ),
          actions: cfm is AddNewFancyMarketProgress
              ? []
              : [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: CustomHoverButton(
                          width: 80,
                          height: 30,
                          onPressed: () {
                            if (createNewFacnyFormKey.currentState!.validate()) {
                              createFacyMap['marketName'] = fancyNameCtrl.text;
                              createFacyMap['eventId'] = widget.eventId;
                              createFacyMap['marketType'] = widget.marketType;
                              context.read<AddNewFancyMarketBloc>().add(AddNewFancyMarket(addNewFancyMap: createFacyMap));
                            } else {
                              showSnackBar(context, "Please fill all required fields", error: true);
                            }
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
