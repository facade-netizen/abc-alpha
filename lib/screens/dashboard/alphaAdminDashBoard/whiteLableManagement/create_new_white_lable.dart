import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../../../bloc/addBlocs/add_new_white_lable_bloc.dart';
import '../../../../bloc/fetchBlocs/fetch_all_wl_bloc.dart';
import '../../../../bloc/fileBlocs/select_wl_favicon_bloc.dart';
import '../../../../bloc/fileBlocs/select_wl_logo_bloc.dart';
import '../../../../reusable/button.dart';
import '../../../../reusable/colors.dart';
import '../../../../reusable/custom_dropdown.dart';
import '../../../../reusable/custom_text_form_field.dart';
import '../../../../reusable/loader.dart';
import '../../../../reusable/navigators.dart';
import '../../../../reusable/sized_box_hw.dart';
import '../../../../reusable/snack_bar.dart';
import '../../../../reusable/string.dart';
import '../../../../reusable/style.dart';

class CreateNewWhiteLable extends StatefulWidget {
  const CreateNewWhiteLable({super.key});

  @override
  State<CreateNewWhiteLable> createState() => _CreateNewWhiteLableState();
}

class _CreateNewWhiteLableState extends State<CreateNewWhiteLable> {
  final addNewAppFormKey = GlobalKey<FormState>();
  final TextEditingController appName = TextEditingController();
  final TextEditingController appId = TextEditingController();
  final TextEditingController appVersion = TextEditingController(text: "0.0.1+1");
  final TextEditingController remarks = TextEditingController();
  final TextEditingController adminDomainUrl = TextEditingController();
  final TextEditingController clientDomainUrl = TextEditingController();
  final TextEditingController adminLocalHost = TextEditingController();
  final TextEditingController clientLocalHost = TextEditingController();
  final TextEditingController favicon = TextEditingController();
  final TextEditingController logo = TextEditingController();
  final TextEditingController privacyPolicy = TextEditingController();
  final TextEditingController updateColorController = TextEditingController();

  // Form Data Map
  Map<String, dynamic> addNewAppData = <String, dynamic>{
    'appName': "",
    'appColor': '',
    'appId': "",
    'appTrack': appTracks[2],
    'appVersion': "",
    'inMaintenance': false,
    'platform': appPlatforms[1],
    'adminDomainUrl': '',
    'clientDomainUrl': '',
    'adminLocalHost': '',
    'clientLocalHost': '',
    'favicon': '',
    'logo': '',
    'privacyPolicy': '',
    'isEnabled': true,
    'remarks': "",
  };

  double fieldWidth = 300;
  double fieldSpacing = 15;
  Color selectedColor = primaryColor;
  String hex = '';
  String logoExtension = '';
  String faviconExtension = '';
  Uint8List? logoFile;
  Uint8List? faviconFile;

  Widget sectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  );
  @override
  void initState() {
    super.initState();
    if (hex.isNotEmpty) {
      selectedColor = Color(int.parse('0xFF$hex'));
      updateColorController.text = hex;
    } else {
      selectedColor = primaryColor;
      updateColorController.text = selectedColor.toARGB32().toRadixString(16).substring(2).toUpperCase();
    }
  }

  void openColorPicker() async {
    Color tempColor = selectedColor;
    Color? pickedColor = await showDialog<Color>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: white,
        title: const Text('Select Color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: tempColor,
            onColorChanged: (color) {
              setState(() {
                selectedColor = color;
                hex = color.toARGB32().toRadixString(16).substring(2).toUpperCase();
                updateColorController.text = hex;
              });
            },
            // showLabel: true,
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              removeScreen(context);
            },
            child: const Text('Done', style: TextStyle(color: black)),
          ),
        ],
      ),
    );

    if (pickedColor != null) {
      setState(() {
        selectedColor = pickedColor;
        hex = pickedColor.toARGB32().toRadixString(16).substring(2).toUpperCase(); // RGB hex
        updateColorController.text = hex;
        debugPrint('Selected Color: $selectedColor, Hex: #$hex');
      });
    }
  }

  void clearControllers() {
    appName.clear();
    appId.clear();
    appVersion.clear();
    remarks.clear();
    adminDomainUrl.clear();
    clientDomainUrl.clear();
    adminLocalHost.clear();
    clientLocalHost.clear();
    favicon.clear();
    logo.clear();
    privacyPolicy.clear();
    updateColorController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddNewWhiteLableBloc, AddNewWhiteLableState>(
      listener: (context, aws) {
        if (aws is AddNewWhiteLableSuccess) {
          showSnackBar(context, "White Lable App created successfully");
          clearControllers();
          context.read<FetchAllWLBloc>().add(FetchAllWL());
        } else if (aws is AddNewWhiteLableFailure) {
          showSnackBar(context, aws.error.toString(), error: true);
        }
      },
      builder: (context, aws) {
        return aws is AddNewWhiteLableProgress
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
                      key: addNewAppFormKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Create New White Label App", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
                          hb25,

                          /// -------- App Information --------
                          sectionTitle("App Information"),
                          Wrap(
                            spacing: fieldSpacing,
                            runSpacing: fieldSpacing,
                            children: [
                              CustomTextFormField(width: fieldWidth, title: 'App Name', controller: appName, validator: (value) => value!.isEmpty ? 'App name is required' : null),
                              CustomTextFormField(width: fieldWidth, title: 'App ID', controller: appId, validator: (value) => value!.isEmpty ? 'App ID is required' : null),
                              CustomTextFormField(
                                width: fieldWidth,
                                title: 'App Version',
                                controller: appVersion,
                                validator: (value) => value!.isEmpty ? 'App version is required' : null,
                              ),
                              CustomTextFormField(
                                width: fieldWidth,
                                title: 'App Color',
                                controller: updateColorController,
                                readOnly: true,
                                onTap: openColorPicker,
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      color: selectedColor,
                                      border: Border.all(color: black),
                                      borderRadius: BorderRadius.circular(4),
                                      // optional shadow
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          hb10,
                          const Divider(),

                          /// -------- Platform & Configuration --------
                          sectionTitle("Platform & Configuration"),
                          Wrap(
                            spacing: fieldSpacing,
                            runSpacing: fieldSpacing,
                            children: [
                              SizedBox(
                                width: fieldWidth,
                                child: DropdownButtonFormField<bool>(
                                  initialValue: addNewAppData['inMaintenance'],
                                  decoration: tfInputDecoration.copyWith(labelText: 'In Maintenance'),
                                  dropdownColor: white,
                                  items: [true, false].map((val) => DropdownMenuItem(value: val, child: Text(val ? 'Ongoing' : 'Done'))).toList(),
                                  onChanged: (val) => setState(() => addNewAppData['inMaintenance'] = val!),
                                ),
                              ),
                              SizedBox(
                                width: fieldWidth,
                                child: DropdownButtonFormField<bool>(
                                  initialValue: addNewAppData['isEnabled'],
                                  decoration: tfInputDecoration.copyWith(labelText: 'Enable / Disable App'),
                                  dropdownColor: white,
                                  items: [true, false].map((val) => DropdownMenuItem(value: val, child: Text(val ? 'Enable' : 'Disable'))).toList(),
                                  onChanged: (val) => setState(() => addNewAppData['isEnabled'] = val!),
                                ),
                              ),
                              SizedBox(
                                width: fieldWidth,
                                child: CustomDropdownWithTitle(
                                  title: 'Select Platform',
                                  item: appPlatforms,
                                  value: addNewAppData['platform'],
                                  onChanged: (value) => setState(() => addNewAppData['platform'] = value!),
                                ),
                              ),
                              SizedBox(
                                width: fieldWidth,
                                child: CustomDropdownWithTitle(
                                  title: 'Select Track',
                                  item: appTracks,
                                  value: addNewAppData['appTrack'],
                                  onChanged: (value) => setState(() => addNewAppData['appTrack'] = value!),
                                ),
                              ),
                            ],
                          ),
                          hb10,
                          const Divider(),
                          sectionTitle("URLs & Assets"),
                          Wrap(
                            spacing: fieldSpacing,
                            runSpacing: fieldSpacing,
                            children: [
                              CustomTextFormField(width: fieldWidth, title: 'Admin Domain', controller: adminDomainUrl),
                              CustomTextFormField(width: fieldWidth, title: 'Client Domain', controller: clientDomainUrl),
                              CustomTextFormField(width: fieldWidth, title: 'Admin Localhost', controller: adminLocalHost),
                              CustomTextFormField(width: fieldWidth, title: 'Client Localhost', controller: clientLocalHost),
                              BlocConsumer<SelectWLLogoBloc, SelectWLLogoState>(
                                listener: (context, uss) {
                                  if (uss is SelectWLLogoSuccess) {
                                    logoExtension = uss.imageExtension;
                                    logoFile = uss.selectedFileBytes;
                                    showSnackBar(context, "Logo selected");
                                  } else if (uss is SelectWLLogoFailure) {
                                    showSnackBar(context, uss.error, error: true);
                                  }
                                },
                                builder: (context, uss) {
                                  Color? color = logoFile != null ? green : grey;
                                  return CustomTextFormField(
                                    width: fieldWidth,
                                    title: 'Upload Logo',
                                    controller: logo,
                                    readOnly: true,
                                    hintText: logoFile != null ? 'Logo Selected' : 'Select Logo',
                                    suffixIcon: Icon(logoFile != null ? Icons.done : Icons.upload_file, color: color),
                                    onTap: () {
                                      context.read<SelectWLLogoBloc>().add(SelectWLLogo());
                                    },
                                  );
                                },
                              ),
                              BlocConsumer<SelectFaviconBloc, SelectFaviconState>(
                                listener: (context, ffs) {
                                  if (ffs is SelectFaviconSuccess) {
                                    faviconExtension = ffs.imageExtension;
                                    faviconFile = ffs.selectedFileBytes;
                                    showSnackBar(context, "Favicon selected");
                                  } else if (ffs is SelectFaviconFailure) {
                                    showSnackBar(context, ffs.error, error: true);
                                  }
                                },
                                builder: (context, uss) {
                                  Color? color = faviconFile != null ? green : grey;
                                  return CustomTextFormField(
                                    width: fieldWidth,
                                    title: 'Favicon',
                                    controller: favicon,
                                    readOnly: true,
                                    hintText: faviconFile != null ? 'Favicon Selected' : 'Select Favicon',
                                    suffixIcon: Icon(faviconFile != null ? Icons.done : Icons.upload_file, color: color),
                                    onTap: () {
                                      context.read<SelectFaviconBloc>().add(SelectFavicon());
                                    },
                                  );
                                },
                              ),
                              CustomTextFormField(width: fieldWidth, title: 'Privacy Policy', controller: privacyPolicy),
                              CustomTextFormField(width: fieldWidth, title: 'Remarks', controller: remarks),
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
                                name: "Create White Lable",
                                width: 200,
                                onTap: () {
                                  if (addNewAppFormKey.currentState!.validate()) {
                                    addNewAppFormKey.currentState!.save();
                                    addNewAppData['appName'] = appName.text.trim();
                                    addNewAppData['appId'] = appId.text.trim();
                                    addNewAppData['appVersion'] = appVersion.text.trim();
                                    addNewAppData['remarks'] = remarks.text.trim();
                                    addNewAppData['appColor'] = updateColorController.text.trim();
                                    addNewAppData['adminDomainUrl'] = adminDomainUrl.text.trim();
                                    addNewAppData['clientDomainUrl'] = clientDomainUrl.text.trim();
                                    addNewAppData['adminLocalHost'] = adminLocalHost.text.trim();
                                    addNewAppData['clientLocalHost'] = clientLocalHost.text.trim();
                                    addNewAppData['logo'] = base64Encode(logoFile!);
                                    addNewAppData['favicon'] = base64Encode(faviconFile!);
                                    addNewAppData['privacyPolicy'] = privacyPolicy.text.trim();
                                    context.read<AddNewWhiteLableBloc>().add(AddNewWhiteLable(addNewWhiteLableMap: addNewAppData));
                                  } else {
                                    showSnackBar(context, "Please fill all required fields", error: true);
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
