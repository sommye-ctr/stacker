import 'dart:io';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:simple_time_range_picker/simple_time_range_picker.dart';
import 'package:stacker/models/stack_details.dart';
import 'package:stacker/models/stack_dto.dart';
import 'package:stacker/resources/strings.dart';
import 'package:stacker/resources/style.dart';
import 'package:stacker/services/database.dart';
import 'package:stacker/services/local.dart';
import 'package:stacker/utils/date_helper.dart';
import 'package:stacker/utils/file_helper.dart';
import 'package:stacker/utils/location_helper.dart';
import 'package:stacker/utils/screen_size.dart';
import 'package:stacker/widgets/spacing.dart';

class CreateStackScreen extends StatefulWidget {
  static const String route = "/create-stack";
  const CreateStackScreen({super.key});

  @override
  State<CreateStackScreen> createState() => _CreateStackScreenState();
}

class _CreateStackScreenState extends State<CreateStackScreen>
    with SingleTickerProviderStateMixin {
  File? imageFile;
  TimeRangeValue? timings;
  bool manualAccept = false;
  TextEditingController name = TextEditingController();
  TextEditingController desc = TextEditingController();
  TextEditingController address1 = TextEditingController();
  TextEditingController address2 = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController avgBookDuration = TextEditingController();
  TextEditingController breakDuration = TextEditingController();
  TextEditingController maxTokens = TextEditingController();
  double lat = 0, long = 0;

  FAccordionController accordionController = FAccordionController.radio();
  late FPopoverController popoverController;

  @override
  void initState() {
    super.initState();
    popoverController = FPopoverController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FScaffold(
          contentPad: false,
          footer: FButton(
            onPress: () {
              if (_validate()) _createStack();
            },
            label: const Text(Strings.createStack),
          ),
          content: ListView(
            children: [
              _buildPickImage(context),
              const Spacing(large: true),
              FAccordion(
                controller: accordionController,
                items: [
                  _buildGeneral(),
                  _buildAddress(),
                  _buildConfig(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  FAccordionItem _buildGeneral() {
    return FAccordionItem(
      title: const Text(Strings.general),
      child: Column(
        children: [
          FTextField(
            controller: name,
            label: const Text(Strings.name),
            hint: "My First Stack",
          ),
          const Spacing(large: true),
          FTextField.multiline(
            controller: desc,
            label: const Text(Strings.description),
            hint: Strings.descriptionHint,
          ),
          const Spacing(large: true),
          FButton(
            style: FButtonStyle.outline,
            onPress: () {
              TimeRangePicker.show(
                context: context,
                startTime: const TimeOfDay(hour: 8, minute: 0),
                endTime: const TimeOfDay(hour: 20, minute: 0),
                onSubmitted: (value) {
                  timings = value;
                  setState(() {});
                },
              );
            },
            label: const Text(Strings.pickTimings),
          ),
          if (timings != null)
            Text("Timings - ${DateHelper.convertTimeRangeString(timings!)}"),
        ],
      ),
    );
  }

  FAccordionItem _buildAddress() {
    return FAccordionItem(
      title: const Text(Strings.address),
      child: Column(
        children: [
          FTextField(
            controller: address1,
            label: const Text(Strings.addressLine1),
            hint: Strings.addressLineHint,
          ),
          const Spacing(large: true),
          FTextField(
            controller: address2,
            label: const Text(Strings.addressLine2),
            hint: Strings.optional,
          ),
          const Spacing(large: true),
          FTextField(
            controller: city,
            label: const Text(Strings.city),
            hint: Strings.cityHint,
          ),
          const Spacing(
            large: true,
          ),
          FButton(
            style: FButtonStyle.outline,
            onPress: () => _handleCurrentLocation(),
            label: Row(
              children: [
                const Text(Strings.useMyCurrentLocation),
                FPopover(
                  controller: popoverController,
                  followerBuilder: (context, value, child) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      Strings.useCurrentLocationHint,
                      textAlign: TextAlign.center,
                      style: context.theme.typography.sm.copyWith(),
                    ),
                  ),
                  target: FButton.icon(
                    onPress: popoverController.toggle,
                    style: FButtonStyle.ghost,
                    child: FAssets.icons.circleHelp(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  FAccordionItem _buildConfig() {
    return FAccordionItem(
      title: const Text(Strings.configuration),
      child: Column(
        children: [
          FTextField(
            controller: avgBookDuration,
            label: const Text(Strings.avgBookDuration),
            hint: Strings.avgDurationHint,
            keyboardType: TextInputType.number,
          ),
          const Spacing(large: true),
          FTextField(
            controller: breakDuration,
            label: const Text(Strings.breakDuration),
            hint: Strings.breakDurationHint,
            keyboardType: TextInputType.number,
          ),
          const Spacing(large: true),
          FTextField(
            controller: maxTokens,
            label: const Text(Strings.maxTokens),
            hint: Strings.maxTokensHint,
            keyboardType: TextInputType.number,
          ),
          const Spacing(large: true),
          FSwitch(
            label: const Text(Strings.manualAccept),
            description: const Text(Strings.manualAcceptHint),
            value: manualAccept,
            onChange: (value) {
              setState(() {
                manualAccept = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPickImage(BuildContext context) {
    double width = ScreenSize.getPercentOfWidth(context, 0.8);

    Widget child;

    if (imageFile != null) {
      child = Image.file(
        imageFile!,
        fit: BoxFit.fill,
      );
    } else {
      child = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FAssets.icons.fileImage(
              color: Style.primaryColor,
              height: 48,
              width: 48,
            ),
            const Spacing(),
            Text(
              Strings.pickStackImage,
              style: context.theme.typography.lg,
            ),
            Text(
              Strings.pickImageHint,
              style: context.theme.typography.sm.copyWith(color: Colors.grey),
            )
          ],
        ),
      );
    }

    return InkWell(
      onTap: _handleFilePick,
      child: Container(
        width: width,
        height: width / Style.stackTileImageRatio,
        decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
        child: child,
      ),
    );
  }

  void _handleCurrentLocation() async {
    var res = await LocationHelper.determinePosition();

    res.whenError(
      (error) {
        Style.showToast(context: context, text: error);
      },
    );

    res.whenSuccess(
      (success) {
        lat = success.latitude;
        long = success.longitude;
        Style.showToast(
            context: context, text: "Successfuly detected location");
      },
    );
  }

  void _handleFilePick() async {
    var res = await FileHelper.pickFile();

    res.whenSuccess((success) {
      imageFile = success;
      setState(() {});
    });
  }

  bool _validate() {
    if (name.text.length < 3) {
      Style.showToast(
          context: context, text: "Name must have atleast 3 characters");
      return false;
    }
    if (desc.text.isEmpty) {
      Style.showToast(context: context, text: "Description cannot be empty");
      return false;
    }
    if (timings == null) {
      Style.showToast(context: context, text: "Kindly pick timings");
      return false;
    }
    if (address1.text.isEmpty) {
      Style.showToast(context: context, text: "Address Line 1 cannot be empty");
      return false;
    }
    if (city.text.isEmpty) {
      Style.showToast(context: context, text: "City cannot be empty");
      return false;
    }
    if (lat == 0 && long == 0) {
      Style.showToast(
          context: context, text: "Kindly click on 'Use my current location");
      return false;
    }
    if (avgBookDuration.text.isEmpty) {
      Style.showToast(
          context: context, text: "Average booking duration cannot be empty");
      return false;
    }
    if (breakDuration.text.isEmpty) {
      Style.showToast(context: context, text: "Break duration cannot be empty");
      return false;
    }
    if (maxTokens.text.isEmpty) {
      Style.showToast(context: context, text: "Max tokens cannot be empty");
      return false;
    }
    if (imageFile == null) {
      Style.showToast(context: context, text: "Stack image cannot be empty");
      return false;
    }
    return true;
  }

  void _createStack() async {
    StackDto dto = StackDto(
        userId: LocalService.getUserId(),
        name: name.text,
        address1: address1.text,
        address2: address2.text,
        city: city.text,
        openTime: timings!.startTime!,
        closeTime: timings!.endTime!,
        latitude: lat,
        longitude: long,
        desc: desc.text,
        userName: LocalService.getUsername(),
        userEmail: LocalService.getUserEmail(),
        userPhone: "" //TODO,
        );
    StackDetails stackDetails = StackDetails.withoutId(
      averageDuration: int.parse(avgBookDuration.text),
      breakDuration: int.parse(breakDuration.text),
      maxTokens: int.parse(maxTokens.text),
      manualAccept: manualAccept,
    );

    Style.showLoadingDialog(context: context);
    var resp = await Database().createStack(dto, imageFile!, stackDetails);

    if (!context.mounted) return;
    // ignore: use_build_context_synchronously
    Style.dismisLoadingDialog(context: context);
    resp.when(
      (success) {
        Style.showToast(context: context, text: "Succesfully Created Stack");
        Navigator.pop(context, true);
      },
      (error) {
        Style.showToast(context: context, text: error, long: true);
      },
    );
  }
}
