import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

import '../../../../bloc/addBlocs/deposit_and_withdrawal_bloc.dart';
import '../../../../bloc/fetchBlocs/fetch_current_user_info_bloc.dart';
import '../../../../reusable/button.dart';
import '../../../../reusable/colors.dart';
import '../../../../reusable/custom_alert_dialog.dart';
import '../../../../reusable/loader.dart';
import '../../../../reusable/navigators.dart';
import '../../../../reusable/sized_box_hw.dart';
import '../../../../reusable/snack_bar.dart';

Future showAddPointsDialog(BuildContext context) {
  return showDialog(context: context, builder: (_) => const ShowAddPointsDialogBody());
}

class ShowAddPointsDialogBody extends StatefulWidget {
  const ShowAddPointsDialogBody({super.key});

  @override
  State<ShowAddPointsDialogBody> createState() => _ShowAddPointsDialogBodyState();
}

class _ShowAddPointsDialogBodyState extends State<ShowAddPointsDialogBody> {
  final TextEditingController amountCtrl = TextEditingController(text: "10000");
  final TextEditingController otpCtrl = TextEditingController();
  final amountFormKey = GlobalKey<FormState>();
  final otpFormKey = GlobalKey<FormState>();
  int step = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return BlocConsumer<DespoiAndWithdrawBloc, DespoiAndWithdrawState>(
      listener: (context, dws) {
        if (dws is DespoiAndWithdrawSuccess) {
          showSnackBar(context, "Points addedd successfully");
          context.read<FetchCurrentUserDetailsBloc>().add(FetchCurrentUserDetails());
          removeScreen(context);
        }
        if (dws is DespoiAndWithdrawFailure) {
          showSnackBar(context, "Unable to add your points ${dws.error}. Please Try again!", error: true);
        }
      },
      builder: (context, dws) {
        return CustomAlertDialog(
          title: 'Add Points',
          content: SizedBox(
            height: size.height * 0.15,
            width: size.width * 0.15,
            child: dws is DespoiAndWithdrawProgress
                ? LoaderContainerWithMessage()
                : step == 0
                ? amountStep()
                : otpStep(),
          ),
          actions: dws is DespoiAndWithdrawProgress ? [] : actions(),
        );
      },
    );
  }

  Widget amountStep() {
    return Form(
      key: amountFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Enter Amount", style: TextStyle(fontWeight: FontWeight.bold)),
          hb10,
          TextFormField(
            controller: amountCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: "Amount", border: OutlineInputBorder()),
            validator: (v) {
              if (v == null || v.isEmpty) return "Amount required";
              if (int.tryParse(v) == null || int.parse(v) <= 0) {
                return "Invalid amount";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget otpStep() {
    return Form(
      key: otpFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Enter OTP", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Pinput(
            length: 6,
            controller: otpCtrl,
            defaultPinTheme: PinTheme(
              width: 38,
              height: 38,
              textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> actions() {
    return [
      if (step == 1)
        Padding(
          padding: const EdgeInsets.all(8),
          child: CustomOutlineTextButton(width: 80, height: 30, title: "Back", boxColor: white, textColor: red, onPressed: () => setState(() => step = 0)),
        ),
      Padding(
        padding: const EdgeInsets.all(8),
        child: CustomOutlineTextButton(width: 80, height: 30, title: step == 0 ? "Next" : "Submit", boxColor: white, textColor: blue, onPressed: onNext),
      ),
    ];
  }

  void onNext() {
    if (step == 0) {
      if (amountFormKey.currentState!.validate()) {
        setState(() => step = 1);
      }
    } else {
      if (otpFormKey.currentState!.validate()) {
        final depositAndWithdrawMap = {"amount": double.tryParse(amountCtrl.text) ?? 0.0, "totp": otpCtrl.text, "action": 0};
        context.read<DespoiAndWithdrawBloc>().add(DespoiAndWithdraw(depositAndWithdrawMap: depositAndWithdrawMap));
      }
    }
  }
}
