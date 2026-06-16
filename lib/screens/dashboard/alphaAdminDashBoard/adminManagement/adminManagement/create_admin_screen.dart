import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../../../../apis/apiHandlers/api_constants.dart';
import '../../../../../bloc/addBlocs/add_new_user_bloc.dart';
import '../../../../../bloc/fetchBlocs/fetch_all_wl_bloc.dart';
import '../../../../../reusable/button.dart';
import '../../../../../reusable/colors.dart';
import '../../../../../reusable/custom_dropdown.dart';
import '../../../../../reusable/custom_text_form_field.dart';
import '../../../../../reusable/headers.dart';
import '../../../../../reusable/loader.dart';
import '../../../../../reusable/sized_box_hw.dart';
import '../../../../../reusable/snack_bar.dart';
import '../../../../../reusable/string.dart';
import '../../../../../reusable/validator.dart';

class CreateAdminScreen extends StatefulWidget {
  const CreateAdminScreen({super.key});

  @override
  State<CreateAdminScreen> createState() => _CreateAdminScreenState();
}

class _CreateAdminScreenState extends State<CreateAdminScreen> {
  Timer? _debounce;
  final createNewAdminFormKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController commissionController = TextEditingController(text: "2");
  TextEditingController pointController = TextEditingController(text: "0.2");
  TextEditingController blnController = TextEditingController();
  // Form Data Map
  Map<String, dynamic> createAdminDataMap = <String, dynamic>{'role': roles[0]};
  String selectedRole = '';
  String selectedWLId = '';
  double fieldWidth = 300;
  double fieldSpacing = 15;
  bool isWlAdded = false;
  bool obscurePassword = true;
  bool? isUsernameAvailable;
  bool isCheckingUsername = false;
  Future<void> checkUsername(String username) async {
    if (username.isEmpty) return;
    setState(() {
      isCheckingUsername = true;
    });
    try {
      var request = http.Request('GET', Uri.parse("${AuthApiConstants.checkUserName}$username"));
      http.StreamedResponse response = await request.send();
      final bodyString = await response.stream.bytesToString();
      final decoded = jsonDecode(bodyString);
      setState(() {
        isUsernameAvailable = decoded["data"];
        isCheckingUsername = false;
      });
    } catch (e) {
      setState(() {
        isCheckingUsername = false;
      });
    }
  }

  @override
  initState() {
    context.read<FetchAllWLBloc>().add(FetchAllWL());
    selectedRole = roles[0];
    super.initState();
  }

  void clearControllers() {
    userNameController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    fNameController.clear();
    lNameController.clear();
    commissionController.clear();
    pointController.clear();
    blnController.clear();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    userNameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    fNameController.dispose();
    lNameController.dispose();
    commissionController.dispose();
    pointController.dispose();
    blnController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddNewUserBloc, AddNewUserState>(
      listener: (context, cus) {
        if (cus is AddNewUserSuccess) {
          createAdminDataMap.clear();
          clearControllers();
          showSnackBar(context, "User Create Successfully");
        }
        if (cus is AddNewUserFailure) {
          showSnackBar(context, cus.error, error: true);
        }
      },
      builder: (context, cus) {
        return cus is AddNewUserProgress
            ? LoaderContainerWithMessage()
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: Form(
                      key: createNewAdminFormKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Create New Admin", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
                          hb25,
                          SectionTitle(title: "Role And Permissions"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: CustomDropdownWithTitle(
                                  width: fieldWidth,
                                  title: 'Select Role',
                                  item: roles,
                                  value: selectedRole,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedRole = value!;
                                      createAdminDataMap['role'] = value;
                                    });
                                  },
                                ),
                              ),
                              Flexible(
                                child: Visibility(
                                  visible: selectedRole == 'adminWL',
                                  child: BlocBuilder<FetchAllWLBloc, FetchAllWLState>(
                                    builder: (context, state) {
                                      if (state is! FetchAllWLSuccess || state.wlData.isEmpty) {
                                        return Padding(padding: const EdgeInsets.only(right: 20), child: const Text("No WL Available"));
                                      }
                                      final wlList = state.wlData.toList();
                                      final selectedId = createAdminDataMap['wlId'] ?? wlList.first.wlId;
                                      return CustomDropdownWithTitle(
                                        width: fieldWidth,
                                        title: 'Select WL',
                                        item: wlList.map((e) => e.appName).toList(),
                                        value: wlList.firstWhere((wl) => wl.wlId == selectedId).appName,
                                        onChanged: (name) {
                                          final selected = wlList.firstWhere((wl) => wl.appName == name);
                                          setState(() {
                                            isWlAdded = selected.hasAdmin;
                                            createAdminDataMap['wlId'] = selected.wlId;
                                            createAdminDataMap['appName'] = selected.appName;
                                            createAdminDataMap['appId'] = selected.appId;
                                          });
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          hb10,
                          const Divider(),
                          SectionTitle(title: "Personal Information"),
                          Wrap(
                            spacing: fieldSpacing,
                            runSpacing: fieldSpacing,
                            children: [
                              CustomTextFormField(
                                title: "Username",
                                controller: userNameController,
                                width: fieldWidth,
                                onChanged: (value) {
                                  if (_debounce?.isActive ?? false) _debounce!.cancel();
                                  _debounce = Timer(const Duration(seconds: 2), () {
                                    checkUsername(value);
                                  });
                                },
                                suffixIcon: isCheckingUsername
                                    ? Padding(
                                        padding: EdgeInsets.all(8),
                                        child: SizedBox(height: 15, width: 15, child: CircularProgressIndicator(strokeWidth: 2)),
                                      )
                                    : isUsernameAvailable == null
                                    ? null
                                    : Icon(isUsernameAvailable! ? Icons.check_circle : Icons.cancel, color: isUsernameAvailable! ? Colors.green : Colors.red, size: 18),
                              ),
                              CustomTextFormFieldWithOutValidator(title: "First Name", controller: fNameController, width: fieldWidth),
                              CustomTextFormFieldWithOutValidator(title: "Last Name", controller: lNameController, width: fieldWidth),
                              PasswordCustomTextFormField(
                                title: "Password",
                                controller: passwordController,
                                width: fieldWidth,
                                obscureText: obscurePassword,
                                obscuringCharacter: "*",
                                suffixIcon: IconButton(
                                  icon: Icon(obscurePassword ? Icons.visibility_off : Icons.visibility, size: 18, color: black),
                                  onPressed: () {
                                    setState(() {
                                      obscurePassword = !obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              PasswordCustomTextFormField(
                                title: "Confirm Password",
                                controller: confirmPasswordController,
                                width: fieldWidth,
                                obscureText: obscurePassword,
                                obscuringCharacter: "*",
                                suffixIcon: IconButton(
                                  icon: Icon(obscurePassword ? Icons.visibility_off : Icons.visibility, size: 18, color: black),
                                  onPressed: () {
                                    setState(() {
                                      obscurePassword = !obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              Visibility(
                                visible: selectedRole == 'adminWL',
                                child: CustomTextFormField(title: "Commission(%)", controller: commissionController, width: fieldWidth),
                              ),
                              Visibility(
                                visible: selectedRole == 'adminWL',
                                child: CustomTextFormField(title: "Point Value", controller: pointController, width: fieldWidth),
                              ),
                              Visibility(
                                visible: selectedRole == 'adminWL' && !isWlAdded,
                                child: CustomTextFormField(title: "Balance", controller: blnController, width: fieldWidth),
                              ),
                            ],
                          ),
                          hb10,
                          const Divider(),
                          hb20,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ColoredTextButton(
                                name: "Create Admin",
                                width: 200,
                                onTap: () {
                                  if (isUsernameAvailable == false) {
                                    showSnackBar(context, "Username is already taken", error: true);
                                    return;
                                  }
                                  if (createNewAdminFormKey.currentState!.validate()) {
                                    setState(() {});
                                    bool isUserName = isValidUsername(userNameController.text);
                                    if (isUserName && userNameController.text.isNotEmpty) {
                                      bool isPassword = isPasswordValid(passwordController.text, userNameController.text);
                                      if (isPassword && passwordController.text.isNotEmpty) {
                                        bool isConfirmPassword = isConfirmPasswordValid(confirmPasswordController.text, passwordController.text, userNameController.text);
                                        if (isConfirmPassword && confirmPasswordController.text.isNotEmpty) {
                                          setState(() {});
                                          createAdminDataMap['username'] = userNameController.text;
                                          createAdminDataMap['password'] = passwordController.text;
                                          createAdminDataMap['confirmPassword'] = confirmPasswordController.text;
                                          createAdminDataMap['firstName'] = fNameController.text;
                                          createAdminDataMap['lastName'] = lNameController.text;
                                          createAdminDataMap['commission'] = double.tryParse(commissionController.text) ?? 0;
                                          createAdminDataMap['openBalance'] = double.tryParse(blnController.text) ?? 0;
                                          createAdminDataMap['pointValue'] = double.tryParse(pointController.text) ?? 0;
                                          if (kDebugMode) debugPrint("Final Admin Data: $createAdminDataMap");
                                          context.read<AddNewUserBloc>().add(AddNewUser(addNewUserMap: createAdminDataMap));
                                        } else {
                                          String? confirmPasswordError = validateConfirmPassword(
                                            confirmPasswordController.text,
                                            passwordController.text,
                                            userNameController.text,
                                            cmfpasswordMessage,
                                          );
                                          showSnackBar(context, confirmPasswordError!, error: true);
                                        }
                                      } else {
                                        String? passwordError = validatePassword(passwordController.text, userNameController.text, passwordMessage);
                                        showSnackBar(context, passwordError!, error: true);
                                      }
                                    } else {
                                      String? validateUser = validateUsername(userNameController.text);
                                      showSnackBar(context, validateUser!, error: true);
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
      },
    );
  }
}
