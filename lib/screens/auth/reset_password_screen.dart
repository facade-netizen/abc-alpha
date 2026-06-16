import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/authBlocs/first_time_reset_password_bloc.dart';
import '../../bloc/authBlocs/user_changed_bloc.dart';
import '../../bloc/authBlocs/user_login_bloc.dart';
import '../../constants/app_constant.dart';
import '../../constants/images.dart';
import '../../reusable/button.dart';
import '../../reusable/colors.dart';
import '../../reusable/navigators.dart';
import '../../reusable/sized_box_hw.dart';
import '../../reusable/snack_bar.dart';
import '../../reusable/style.dart';

class FirstTimeResetPasswordScreen extends StatefulWidget {
  const FirstTimeResetPasswordScreen({super.key, required this.userName});
  final String userName;

  @override
  State<FirstTimeResetPasswordScreen> createState() => _FirstTimeResetPasswordScreenState();
}

class _FirstTimeResetPasswordScreenState extends State<FirstTimeResetPasswordScreen> {
  final GlobalKey<FormState> resetFormKey = GlobalKey<FormState>();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController newConfirmPasswordController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();

  @override
  void dispose() {
    newPasswordController.dispose();
    newConfirmPasswordController.dispose();
    oldPasswordController.dispose();
    super.dispose();
  }

  String? validatePassword(String value) {
    if (value.isEmpty) return "Password is required";
    if (value.length < 6 || value.length > 15) return "Password must be 8-15 characters";
    if (value.contains(" ")) return "No spaces allowed";
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return "Must include upper, lower & number";
    }
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return "No special characters allowed";
    }
    if (value.toLowerCase().contains(widget.userName.toLowerCase())) {
      return "Password cannot contain your username";
    }
    if (value == oldPasswordController.text) return "New & Old password cannot be same";
    return null;
  }

  void onChangePassword() {
    final form = resetFormKey.currentState!;
    if (form.validate()) {
      Map<String, dynamic> resetasswordMap = {
        "username": widget.userName,
        "oldPassword": oldPasswordController.text.trim(),
        "newPassword": newPasswordController.text.trim(),
        "confirmPassword": newConfirmPasswordController.text.trim(),
        "ip": ip.value,
        "isp": isp.value,
      };
      context.read<FirstTimeResetPasswordBloc>().add(FirstTimeResetPassword(firstTimeResetPassword: resetasswordMap));
    } else {
      final newPasswordError = validatePassword(newPasswordController.text);
      if (newPasswordError != null) {
        showSnackBar(context, newPasswordError, error: true);
      } else if (newConfirmPasswordController.text != newPasswordController.text) {
        showSnackBar(context, "Passwords do not match", error: true);
      } else if (newPasswordController.text.toLowerCase().contains(widget.userName.toLowerCase())) {
        showSnackBar(context, "Password cannot contain your username", error: true);
      } else if (oldPasswordController.text.isEmpty) {
        showSnackBar(context, "Old password required", error: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserLoginBloc, UserLoginState>(
      listener: (context, state) {
        if (state is UserLoginSuccess) {
          context.read<UserAuthChangesBloc>().add(StartUserChangeListener());
          removeScreen(context);
        }
      },
      builder: (context, state) {
        return BlocConsumer<FirstTimeResetPasswordBloc, FirstTimeResetPasswordState>(
          listener: (context, rps) {
            if (rps is FirstTimeResetPasswordSuccess) {
              context.read<UserLoginBloc>().add(UserLogin(username: rps.userName, password: rps.password));
              removeScreen(context);
            }
            if (rps is FirstTimeResetPasswordFailure) {
              showSnackBar(context, rps.error, error: true);
            }
          },
          builder: (context, rps) {
            return Scaffold(
              body: SafeArea(
                child: Stack(
                  children: [
                    SizedBox.expand(child: Image.asset(AssetsConstants.loginBg2, fit: BoxFit.cover)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Container(
                            width: 500,
                            height: 300,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: white),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Text("• Password must have 6 to 15 characters", style: TextStyle(color: textColor)),
                                        Text("• Alphanumeric without white space", style: TextStyle(color: textColor)),
                                        SizedBox(height: 5),
                                        Text("• Password cannot be the same as username", style: TextStyle(color: textColor)),
                                        SizedBox(height: 5),
                                        Text("• Must contain at least 1 capital letter, 1 small letter and 1 number", style: TextStyle(color: textColor)),
                                        SizedBox(height: 5),
                                        Text("• Password must not contain any special characters (!,@,#,etc..)", style: TextStyle(color: textColor)),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: white,
                                      borderRadius: const BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                                    ),
                                    child: Center(
                                      child: Form(
                                        key: resetFormKey,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            TextFormField(
                                              keyboardType: TextInputType.text,
                                              controller: newPasswordController,
                                              obscureText: true,
                                              obscuringCharacter: "*",
                                              decoration: tfInputDecoration.copyWith(hintText: "New Password", contentPadding: const EdgeInsets.symmetric(horizontal: 10)),
                                              validator: (val) => validatePassword(val!),
                                            ),
                                            hb10,
                                            TextFormField(
                                              keyboardType: TextInputType.text,
                                              controller: newConfirmPasswordController,
                                              obscureText: true,
                                              obscuringCharacter: "*",
                                              decoration: tfInputDecoration.copyWith(hintText: "New Password Confirm", contentPadding: const EdgeInsets.symmetric(horizontal: 10)),
                                              validator: (val) {
                                                if (val == null || val.isEmpty) return "Confirm password required";
                                                if (val != newPasswordController.text) return "Passwords do not match";
                                                return null;
                                              },
                                            ),
                                            hb10,
                                            TextFormField(
                                              keyboardType: TextInputType.text,
                                              controller: oldPasswordController,
                                              obscureText: true,
                                              obscuringCharacter: "*",
                                              decoration: tfInputDecoration.copyWith(hintText: "Old Password", contentPadding: const EdgeInsets.symmetric(horizontal: 10)),
                                              validator: (val) {
                                                if (val == null || val.isEmpty) return "Old password required";
                                                return null;
                                              },
                                            ),
                                            hb10,
                                            SizedBox(
                                              width: 300,
                                              child: ColoredTextButton(name: "Change", onTap: onChangePassword),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
