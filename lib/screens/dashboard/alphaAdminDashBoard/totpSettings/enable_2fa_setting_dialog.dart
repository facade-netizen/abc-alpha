import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import '../../../../bloc/totpBlocs/set_2fa_lable_bloc.dart';
import '../../../../bloc/totpBlocs/verify_otp_bloc.dart';
import '../../../../reusable/button.dart';
import '../../../../reusable/custom_alert_dialog.dart';
import '../../../../reusable/loader.dart';
import '../../../../reusable/navigators.dart';
import '../../../../reusable/sized_box_hw.dart';
import '../../../../reusable/snack_bar.dart';
import '../../../../reusable/text_form_field.dart';

Future showEnable2FASettingsDialog(BuildContext context) {
  return showDialog(context: context, builder: (context) => Enable2FASettingsDialogBody());
}

class Enable2FASettingsDialogBody extends StatefulWidget {
  const Enable2FASettingsDialogBody({super.key});
  @override
  State<Enable2FASettingsDialogBody> createState() => _Enable2FASettingsDialogBodyState();
}

enum TOTPSetupStep { enterName, showQRAndVerifyOTP }

class _Enable2FASettingsDialogBodyState extends State<Enable2FASettingsDialogBody> {
  TOTPSetupStep currentStep = TOTPSetupStep.enterName;
  final TextEditingController levelNameController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  String qrCodeUri = "";

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VerifyOTPBloc, VerifyOTPState>(
      listener: (context, vts) {
        if (vts is VerifyOTPSuccess) {
          showSnackBar(context, "✅ 2FA Enabled Successfully");
          removeScreen(context);
        }
        if (vts is VerifyOTPFailure) {
          showSnackBar(context, "Unable authenticated ${vts.error}. Please try again.", error: true);
        }
      },
      builder: (context, vts) {
        return BlocConsumer<SetTOTPLableBloc, SetTOTPLableState>(
          listener: (context, sts) {
            if (sts is SetTOTPLableSuccess) {
              qrCodeUri = sts.qrCodeUri;
              setState(() {
                currentStep = TOTPSetupStep.showQRAndVerifyOTP;
              });
            }
            if (sts is SetTOTPLableFailure) {
              showSnackBar(context, "Unable to set Lable. Please try again.", error: true);
            }
          },
          builder: (context, sts) {
            return CustomAlertDialog(
              title: "Manage 2FA",
              content: SizedBox(
                width: 500,
                height: 370,
                child: Center(
                  child: sts is SetTOTPLableProgress || vts is VerifyOTPProgress
                      ? LoaderContainerWithMessage()
                      : currentStep == TOTPSetupStep.enterName
                      ? SizedBox(
                          width: 300,
                          child: TitleWithTextFormFieldSpaceBetween(controller: levelNameController, title: '2Fa Lable'),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Scan QR code in Authenticator App", style: TextStyle(fontSize: 16)),
                            hb20,
                            SizedBox(
                              width: 150,
                              height: 150,
                              child: PrettyQrView.data(
                                data: qrCodeUri,
                                decoration: const PrettyQrDecoration(quietZone: PrettyQrQuietZone.standard),
                              ),
                            ),
                            hb20,
                            SelectableText("Label: ${levelNameController.text}"),
                            hb20,
                            Text("Enter OTP from Authenticator", style: TextStyle(fontSize: 16)),
                            hb20,
                            Pinput(
                              length: 6,
                              controller: otpController,
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
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ColoredTextButton(
                    width: 200,
                    name: currentStep == TOTPSetupStep.enterName ? "Next" : "Verify OTP",
                    onTap: () async {
                      if (currentStep == TOTPSetupStep.enterName) {
                        if (levelNameController.text.isEmpty) {
                          showSnackBar(context, "Please enter a 2FA label", error: true);
                          return;
                        }
                        Map<String, dynamic> setTOTPLableMap = {"lable": levelNameController.text, "issuer": "Alpha User"};
                        context.read<SetTOTPLableBloc>().add(SetTOTPLable(setTOTPLableMap: setTOTPLableMap));
                      } else if (currentStep == TOTPSetupStep.showQRAndVerifyOTP) {
                        if (otpController.text.length != 6) {
                          showSnackBar(context, "Please enter a valid 6-digit OTP", error: true);
                          return;
                        }
                        context.read<VerifyOTPBloc>().add(VerifyOTP(otp: otpController.text));
                      }
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
