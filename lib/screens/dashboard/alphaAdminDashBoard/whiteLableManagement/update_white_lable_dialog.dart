import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../bloc/fetchBlocs/fetch_all_wl_bloc.dart';
import '../../../../bloc/fileBlocs/select_wl_favicon_bloc.dart';
import '../../../../bloc/fileBlocs/select_wl_logo_bloc.dart';
import '../../../../bloc/updateBlocs/update_white_lable_bloc.dart';
import '../../../../model/white_lable_model.dart';
import '../../../../reusable/button.dart';
import '../../../../reusable/colors.dart';
import '../../../../reusable/custom_alert_dialog.dart';
import '../../../../reusable/custom_dropdown.dart';
import '../../../../reusable/custom_text_form_field.dart';
import '../../../../reusable/headers.dart';
import '../../../../reusable/loader.dart';
import '../../../../reusable/navigators.dart';
import '../../../../reusable/sized_box_hw.dart';
import '../../../../reusable/snack_bar.dart';
import '../../../../reusable/string.dart';
import '../../../../reusable/style.dart';

Future<dynamic> updateAndViewWL(BuildContext context, {required WhiteLableAppData whiteLableAppData}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext ctxt) {
      return UpdateAndViewWhiteLableDialogBody(whiteLableAppData: whiteLableAppData);
    },
  );
}

class UpdateAndViewWhiteLableDialogBody extends StatefulWidget {
  const UpdateAndViewWhiteLableDialogBody({super.key, required this.whiteLableAppData});
  final WhiteLableAppData whiteLableAppData;

  @override
  State<UpdateAndViewWhiteLableDialogBody> createState() => _UpdateAndViewWhiteLableDialogBodyState();
}

class _UpdateAndViewWhiteLableDialogBodyState extends State<UpdateAndViewWhiteLableDialogBody> {
  final updateWLAppFormKey = GlobalKey<FormState>();
  TextEditingController appName = TextEditingController();
  TextEditingController appId = TextEditingController();
  TextEditingController appVersion = TextEditingController();
  TextEditingController remarks = TextEditingController();
  TextEditingController adminDomainUrl = TextEditingController();
  TextEditingController clientDomainUrl = TextEditingController();
  TextEditingController privacyPolicy = TextEditingController();
  TextEditingController updateColorController = TextEditingController();
  TextEditingController adminLocalHost = TextEditingController();
  TextEditingController clientLocalHost = TextEditingController();

  // Form Data Map
  double fieldWidth = 300;
  double fieldSpacing = 10;
  String hex = '';
  String logoExtension = '';
  String faviconExtension = '';
  Uint8List? logoFile;
  Uint8List? faviconFile;
  Color selectedColor = primaryColor;
  bool inMaintenance = false;
  bool isEnabled = false;
  String appTrack = '';
  String platform = '';
  Map<String, dynamic> updatedWLMapData = <String, dynamic>{};
  void openColorPicker() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: selectedColor,
              onColorChanged: (color) {
                setState(() {
                  selectedColor = color;
                  hex = color.toARGB32().toRadixString(16).substring(2).toUpperCase();
                  updateColorController.text = hex;
                });
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                removeScreen(context);
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    hex = widget.whiteLableAppData.appColor;
    updateColorController.text = hex;
    String color = '0xFF$hex';
    selectedColor = Color(int.parse(color));
    appName = TextEditingController(text: widget.whiteLableAppData.appName);
    appId = TextEditingController(text: widget.whiteLableAppData.appId);
    appVersion = TextEditingController(text: widget.whiteLableAppData.appVersion);
    adminDomainUrl = TextEditingController(text: widget.whiteLableAppData.adminDomainUrl);
    clientDomainUrl = TextEditingController(text: widget.whiteLableAppData.clientDomainUrl);
    adminLocalHost = TextEditingController(text: widget.whiteLableAppData.adminLocalHost);
    clientLocalHost = TextEditingController(text: widget.whiteLableAppData.clientLocalHost);
    privacyPolicy = TextEditingController(text: widget.whiteLableAppData.privacyPolicy);
    updateColorController = TextEditingController(text: widget.whiteLableAppData.appColor);
    remarks = TextEditingController(text: widget.whiteLableAppData.remarks);
    inMaintenance = widget.whiteLableAppData.inMaintenance;
    isEnabled = widget.whiteLableAppData.isEnabled;
    platform = widget.whiteLableAppData.platform;
    appTrack = widget.whiteLableAppData.appTrack;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdateWhiteLableBloc, UpdateWhiteLableState>(
      listener: (context, uwl) {
        if (uwl is UpdateWhiteLableSuccess) {
          showSnackBar(context, "White Lable updated successfully");
          context.read<FetchAllWLBloc>().add(FetchAllWL());
          removeScreen(context);
        } else if (uwl is UpdateWhiteLableFailure) {
          showSnackBar(context, uwl.error.toString(), error: true);
          removeScreen(context);
        }
      },
      builder: (context, uwl) {
        return CustomAlertDialog(
          title: 'Update ${widget.whiteLableAppData.appName.toUpperCase()}',
          content: SizedBox(
            height: 700,
            width: 700,
            child: uwl is UpdateWhiteLableProgress
                ? LoaderContainerWithMessage()
                : Form(
                    key: updateWLAppFormKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// -------- App Information --------
                          SectionTitle(title: "App Information"),
                          Wrap(
                            spacing: fieldSpacing,
                            runSpacing: fieldSpacing,
                            children: [
                              CustomTextFormField(
                                width: fieldWidth,
                                lTFPadding: 0,
                                title: 'App Name',
                                controller: appName,
                                validator: (value) => value!.isEmpty ? 'App name is required' : null,
                              ),
                              CustomTextFormField(
                                width: fieldWidth,
                                lTFPadding: 0,
                                title: 'App ID',
                                controller: appId,
                                validator: (value) => value!.isEmpty ? 'App ID is required' : null,
                              ),
                              CustomTextFormField(
                                width: fieldWidth,
                                lTFPadding: 0,
                                title: 'App Version',
                                controller: appVersion,
                                validator: (value) => value!.isEmpty ? 'App version is required' : null,
                              ),
                              CustomTextFormField(
                                width: fieldWidth,
                                lTFPadding: 0,
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
                          SectionTitle(title: "Platform & Configuration"),
                          Wrap(
                            spacing: fieldSpacing,
                            runSpacing: fieldSpacing,
                            children: [
                              SizedBox(
                                width: fieldWidth,
                                child: DropdownButtonFormField<bool>(
                                  initialValue: widget.whiteLableAppData.inMaintenance,
                                  decoration: tfInputDecoration.copyWith(labelText: 'In Maintenance'),
                                  dropdownColor: white,
                                  items: [true, false].map((val) => DropdownMenuItem(value: val, child: Text(val ? 'Ongoing' : 'Done'))).toList(),
                                  onChanged: (bool? value) {
                                    setState(() {
                                      inMaintenance = value!;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: fieldWidth,
                                child: DropdownButtonFormField<bool>(
                                  initialValue : widget.whiteLableAppData.isEnabled,
                                  decoration: tfInputDecoration.copyWith(labelText: 'Enable / Disable App'),
                                  dropdownColor: white,
                                  items: [true, false].map((val) => DropdownMenuItem(value: val, child: Text(val ? 'Enable' : 'Disable'))).toList(),
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isEnabled = value!;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: fieldWidth,
                                child: CustomDropdownWithTitle(
                                  title: 'Select Platform',
                                  item: appPlatforms,
                                  value: widget.whiteLableAppData.platform,
                                  onChanged: (value) {
                                    setState(() {
                                      platform = value!;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: fieldWidth,
                                child: CustomDropdownWithTitle(
                                  title: 'Select Track',
                                  item: appTracks,
                                  value: widget.whiteLableAppData.appTrack,
                                  onChanged: (value) {
                                    setState(() {
                                      appTrack = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          hb10,
                          const Divider(),

                          /// -------- URLs & Assets --------
                          SectionTitle(title: "URLs & Assets"),
                          Wrap(
                            spacing: fieldSpacing,
                            runSpacing: fieldSpacing,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                                child: BlocConsumer<SelectWLLogoBloc, SelectWLLogoState>(
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
                                    Uint8List? imageBytes;
                                    if (uss is SelectWLLogoSuccess) {
                                      imageBytes = uss.selectedFileBytes;
                                    }
                                    return Container(
                                      decoration: BoxDecoration(border: Border.all(color: black, width: 1)),
                                      height: 100,
                                      width: 100,
                                      child: Stack(
                                        children: [
                                          Positioned.fill(
                                            child: () {
                                              if (imageBytes != null) {
                                                return Image.memory(imageBytes, fit: BoxFit.contain, gaplessPlayback: true);
                                              }
                                              if (widget.whiteLableAppData.favicon.isNotEmpty) {
                                                return CachedNetworkImage(imageUrl: widget.whiteLableAppData.favicon, fit: BoxFit.contain);
                                              }
                                              return Container(alignment: Alignment.center, color: Colors.grey[200], child: const Text("Logo not uploaded"));
                                            }(),
                                          ),
                                          Positioned(
                                            right: 10,
                                            bottom: 10,
                                            child: InkWell(
                                              onTap: () {
                                                context.read<SelectWLLogoBloc>().add(SelectWLLogo());
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                  color: green,
                                                  shape: BoxShape.circle,
                                                  boxShadow: [BoxShadow(color: applyOpacity(black, 0.2), blurRadius: 6, offset: const Offset(0, 2))],
                                                ),
                                                child: Icon(widget.whiteLableAppData.logo.isNotEmpty ? Icons.edit : Icons.add, color: white, size: 20),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                                child: BlocConsumer<SelectFaviconBloc, SelectFaviconState>(
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
                                    Uint8List? imageBytes;
                                    if (uss is SelectFaviconSuccess) {
                                      imageBytes = uss.selectedFileBytes;
                                    }
                                    return Container(
                                      decoration: BoxDecoration(border: Border.all(color: black, width: 1)),
                                      height: 100,
                                      width: 100,
                                      child: Stack(
                                        children: [
                                          Positioned.fill(
                                            child: () {
                                              if (imageBytes != null) {
                                                return Image.memory(imageBytes, fit: BoxFit.contain, gaplessPlayback: true);
                                              }
                                              if (widget.whiteLableAppData.favicon.isNotEmpty) {
                                                return CachedNetworkImage(imageUrl: widget.whiteLableAppData.favicon, fit: BoxFit.contain);
                                              }
                                              return Container(alignment: Alignment.center, color: Colors.grey[200], child: const Text("Logo not uploaded"));
                                            }(),
                                          ),
                                          Positioned(
                                            right: 10,
                                            bottom: 10,
                                            child: InkWell(
                                              onTap: () {
                                                context.read<SelectFaviconBloc>().add(SelectFavicon());
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                  color: green,
                                                  shape: BoxShape.circle,
                                                  boxShadow: [BoxShadow(color: applyOpacity(black, 0.2), blurRadius: 6, offset: const Offset(0, 2))],
                                                ),
                                                child: Icon(widget.whiteLableAppData.favicon.isNotEmpty ? Icons.edit : Icons.add, color: white, size: 20),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          Wrap(
                            spacing: fieldSpacing,
                            runSpacing: fieldSpacing,
                            children: [
                              CustomTextFormField(width: fieldWidth, lTFPadding: 0, title: 'Admin Domain', controller: adminDomainUrl),
                              CustomTextFormField(width: fieldWidth, lTFPadding: 0, title: 'Client Domain', controller: clientDomainUrl),
                              CustomTextFormField(width: fieldWidth, title: 'Admin Localhost', controller: adminLocalHost),
                              CustomTextFormField(width: fieldWidth, title: 'Client Localhost', controller: clientLocalHost),
                              CustomTextFormField(width: fieldWidth, lTFPadding: 0, title: 'Privacy Policy', controller: privacyPolicy, readOnly: true),
                              CustomTextFormField(width: fieldWidth, lTFPadding: 0, title: 'Remarks', controller: remarks, readOnly: true),
                            ],
                          ),
                          const Divider(),
                        ],
                      ),
                    ),
                  ),
          ),
          actions: uwl is UpdateWhiteLableProgress
              ? []
              : [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ColoredTextButton(
                      name: "Update White Lable",
                      width: 200,
                      onTap: () {
                        if (updateWLAppFormKey.currentState!.validate()) {
                          updateWLAppFormKey.currentState!.save();
                          setState(() {});
                          updatedWLMapData["wLid"] = widget.whiteLableAppData.wlId;
                          updatedWLMapData['appName'] = appName.text.trim();
                          updatedWLMapData['appId'] = appId.text.trim();
                          updatedWLMapData['appVersion'] = appVersion.text.trim();
                          updatedWLMapData['remarks'] = remarks.text.trim();
                          updatedWLMapData['appColor'] = updateColorController.text.trim();
                          updatedWLMapData['adminDomainUrl'] = adminDomainUrl.text.trim();
                          updatedWLMapData['clientDomainUrl'] = clientDomainUrl.text.trim();
                          updatedWLMapData['adminLocalHost'] = adminLocalHost.text.trim();
                          updatedWLMapData['clientLocalHost'] = clientLocalHost.text.trim();
                          updatedWLMapData['logo'] = logoFile == null ? '' : base64Encode(logoFile!);
                          updatedWLMapData['favicon'] = faviconFile == null ? '' : base64Encode(faviconFile!);
                          updatedWLMapData['privacyPolicy'] = privacyPolicy.text.trim();
                          updatedWLMapData['appTrack'] = appTrack;
                          updatedWLMapData['inMaintenance'] = inMaintenance;
                          updatedWLMapData['platform'] = platform;
                          updatedWLMapData['isEnabled'] = isEnabled;
                          updatedWLMapData['hasAdmin'] = widget.whiteLableAppData.hasAdmin;
                          context.read<UpdateWhiteLableBloc>().add(UpdateWhiteLable(updateWhiteLableMap: updatedWLMapData));
                        } else {
                          showSnackBar(context, "Please fill all required fields", error: true);
                        }
                      },
                    ),
                  ),
                ],
        );
      },
    );
  }
}
