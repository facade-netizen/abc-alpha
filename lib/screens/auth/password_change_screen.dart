import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/authBlocs/user_changed_bloc.dart';
import '../../bloc/authBlocs/user_logout_bloc.dart';
import '../../bloc/updateBlocs/change_password_bloc.dart';
import '../../constants/app_constant.dart';
import '../../reusable/button.dart';
import '../../reusable/colors.dart';
import '../../reusable/loader.dart';
import '../../reusable/sized_box_hw.dart';
import '../../reusable/snack_bar.dart';

class PasswordChangeScreen extends StatefulWidget {
  const PasswordChangeScreen({super.key});
  @override
  State<PasswordChangeScreen> createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangeScreen> {
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController newCrfmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserLogoutBloc, UserLogoutState>(
      listener: (context, state) {
        if (state is UserLogoutSuccess) {
          context.read<UserAuthChangesBloc>().add(StartUserChangeListener());
        }
      },
      builder: (context, state) {
        return BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
          listener: (context, cps) {
            if (cps is ChangePasswordSuccess) {
              context.read<UserLogoutBloc>().add(UserLogoutListener(context: context));
              showSnackBar(context, "Password updated successfully");
            }
            if (cps is ChangePasswordFailure) {
              showSnackBar(context, "Unable update your password. Please try again!", error: true);
            }
          },
          builder: (context, cps) {
            return Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 500,
                  child: cps is ChangePasswordProgress
                      ? LoaderContainerWithMessage()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Change Password", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                            Container(
                              width: 500,
                              color: selectedTabColor,
                              padding: const EdgeInsets.all(4),
                              child: Text("Change Password", style: TextStyle(color: white, fontSize: 14)),
                            ),
                            hb10,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Password"),
                                wb5,
                                SizedBox(
                                  height: 30,
                                  width: 300,
                                  child: TextFormField(
                                    controller: oldPassword,
                                    obscureText: true,
                                    obscuringCharacter: "*",
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("New Password"),
                                wb5,
                                SizedBox(
                                  height: 30,
                                  width: 300,
                                  child: TextFormField(
                                    controller: newPassword,
                                    obscureText: true,
                                    obscuringCharacter: "*",
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Confirm Password"),
                                wb5,
                                SizedBox(
                                  height: 30,
                                  width: 300,
                                  child: TextFormField(
                                    controller: newCrfmPassword,
                                    obscureText: true,
                                    obscuringCharacter: "*",
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
                            CustomHoverButton(
                              width: 500,
                              height: 30,
                              title: 'Update',
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              textColor: white,
                              onPressed: () {
                                Map<String, dynamic> changePasswordMap = {
                                  "oldPassword": oldPassword.text.trim(),
                                  "newPassword": newPassword.text.trim(),
                                  "confirmPassword": newCrfmPassword.text.trim(),
                                  "ip": ip.value,
                                  "isp": isp.value,
                                };
                                context.read<ChangePasswordBloc>().add(ChangePassword(changePassword: changePasswordMap));
                              },
                            ),
                          ],
                        ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
