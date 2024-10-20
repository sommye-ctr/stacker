import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:provider/provider.dart';
import 'package:simple_time_range_picker/simple_time_range_picker.dart';
import 'package:stacker/models/stack.dart';
import 'package:stacker/resources/style.dart';
import 'package:stacker/screens/view_bookings.dart';
import 'package:stacker/services/database.dart';
import 'package:stacker/services/local.dart';
import 'package:stacker/store/home/home_store.dart';
import 'package:stacker/utils/clipboard_helper.dart';
import 'package:stacker/utils/date_helper.dart';
import 'package:stacker/utils/location_helper.dart';
import 'package:stacker/utils/screen_size.dart';
import 'package:stacker/widgets/booking_info_dialog.dart';
import 'package:stacker/widgets/input_token_dialog.dart';
import 'package:stacker/widgets/rounded_image.dart';
import 'package:stacker/widgets/spacing.dart';

import '../resources/strings.dart';

class StackDetailsScreen extends StatefulWidget {
  static const String route = "/stack-details";

  final bool isCreated;
  const StackDetailsScreen({super.key, required this.isCreated});

  @override
  State<StackDetailsScreen> createState() => _StackDetailsScreenState();
}

class _StackDetailsScreenState extends State<StackDetailsScreen> {
  late HomeStore homeStore;
  late bool isClosed;
  late StackModel stack;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    homeStore = Provider.of<HomeStore>(context);
    if (widget.isCreated) {
      stack = homeStore.createdStacks[homeStore.selectedIndex!];
    } else {
      stack = homeStore.joinedStacks[homeStore.selectedIndex!];
    }
    isClosed = stack.status == Strings.closed;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: FScaffold(
          contentPad: true,
          header: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Hero(
                      tag: stack.id,
                      child: RoundedImage(
                        image: stack.image,
                        width: ScreenSize.getPercentOfWidth(context, 1),
                        ratio: Style.stackTileImageRatio,
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      stack.name,
                      style: context.theme.typography.xl3
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                    const Spacing(),
                    FBadge(
                      label: Text(stack.status),
                      style: isClosed
                          ? FBadgeStyle.destructive
                          : FBadgeStyle.primary,
                    ),
                  ],
                )
              ],
            ),
          ),
          content: SingleChildScrollView(
            child: FTabs(
              tabs: _getTabsEntry(),
            ),
          ),
          footer: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildButton(),
          ),
        ),
      ),
    );
  }

  List<FTabEntry> _getTabsEntry() {
    if (widget.isCreated) {
      return [
        FTabEntry(
          label: const Text("Operation"),
          content: _buildOperation(),
        ),
        FTabEntry(
          label: const Text(Strings.general),
          content: _buildGeneral(),
        ),
        FTabEntry(
          label: const Text("Settings"),
          content: _buildSettings(),
        )
      ];
    }

    return [
      FTabEntry(
        label: const Text(Strings.general),
        content: _buildGeneral(),
      ),
      FTabEntry(
        label: const Text(Strings.services),
        content: Container(),
      ),
      FTabEntry(
        label: const Text("Settings"),
        content: _buildSettings(),
      )
    ];
  }

  Widget _buildButton() {
    if (widget.isCreated) {
      if (isClosed) {
        return FButton(
          onPress: () async {
            Style.showLoadingDialog(context: context);
            var res = await Database().openStack(stack.id);
            Navigator.pop(context);
            res.when(
              (success) {
                if (widget.isCreated) {
                  homeStore.updateCreatedStack(stack.id, success);
                } else {
                  homeStore.updateJoinedStack(stack.id, success);
                }
                //Navigator.pop(context);
                Style.showToast(
                  context: context,
                  text:
                      "Succesfull. Kindly go back and load this screen again.",
                  long: true,
                );
              },
              (error) => Style.showToast(context: context, text: error),
            );
          },
          label: const Text("Open Stack"),
        );
      }
      return FButton(
        onPress: () async {
          Style.showLoadingDialog(context: context);
          var res = await Database().closeStack(stack.id);
          Navigator.pop(context);
          res.when(
            (success) {
              if (widget.isCreated) {
                homeStore.updateCreatedStack(stack.id, success);
              } else {
                homeStore.updateJoinedStack(stack.id, success);
              }
              //Navigator.pop(context);
              Style.showToast(
                context: context,
                text: "Succesfull. Kindly go back and load this screen again.",
                long: true,
              );
            },
            (error) => Style.showToast(context: context, text: error),
          );
        },
        label: const Text("Close Stack"),
        style: FButtonStyle.destructive,
      );
    }
    if (_checkIfAlrBooked()) {
      return FButton(
        onPress: () => Navigator.pushNamed(context, ViewBookingsScreen.route),
        label: const Text("View Booking"),
        style: FButtonStyle.secondary,
      );
    }

    return FButton(
      onPress: () => _bookNow(),
      label: const Text(Strings.bookNow),
    );
  }

  Widget _buildOperation() {
    if (isClosed) {
      return const Text("Open Stack to start operating");
    }
    return SizedBox(
      width: double.infinity,
      child: FCard(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "#${stack.currentToken}",
                style: context.theme.typography.xl5
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacing(),
              Text(
                Strings.currentToken,
                style: context.theme.typography.sm,
              ),
              const Spacing(),
              if (stack.currentToken != 0)
                FButton(
                  onPress: () async {
                    int token = await _showInputTokenDialog();
                    if (token == 0) return;
                    Style.showLoadingDialog(context: context);
                    var resp = await Database()
                        .markTokenAsDone(stack.id, stack.currentToken);
                    Navigator.pop(context);
                    resp.whenError(
                      (error) => Style.showToast(context: context, text: error),
                    );
                    resp.whenSuccess(
                      (success) {
                        _updateCurrentToken(token);
                      },
                    );
                  },
                  label: const Text("Mark this token as done"),
                  style: FButtonStyle.outline,
                ),
              const Spacing(),
              if (stack.currentToken == 0)
                FButton(
                  onPress: () async {
                    int token = await _showInputTokenDialog();
                    if (token != 0) _updateCurrentToken(token);
                  },
                  label: const Text("Input token number"),
                  style: FButtonStyle.secondary,
                )
            ],
          ),
        ),
      ),
    );
  }

  Future<int> _showInputTokenDialog() async {
    return await showAdaptiveDialog(
      context: context,
      builder: (context) {
        return InputTokenDialog(
          stackId: stack.id,
        );
      },
    );
  }

  void _updateCurrentToken(int token) async {
    Style.showLoadingDialog(context: context);
    var res = await Database().setCurrentToken(stack.id, token);

    Navigator.pop(context);
    res.when(
      (success) {
        homeStore.updateTokenOfStack(stack.id, token);
        homeStore.refresh();
        Navigator.pop(context);
      },
      (error) => Style.showToast(context: context, text: error),
    );
  }

  Widget _buildGeneral() {
    return FAccordion(
      items: [
        FAccordionItem(
          title: const Text(Strings.currentToken),
          child: Text(stack.currentToken.toString()),
        ),
        FAccordionItem(
          title: const Text(Strings.timing),
          child: Text(
            DateHelper.convertTimeRangeString(
              TimeRangeValue.value(
                startTime: stack.openTime,
                endTime: stack.closeTime,
              ),
            ),
          ),
        ),
        FAccordionItem(
          title: const Text(Strings.address),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(stack.address1),
              if (stack.address2.isNotEmpty) Text(stack.address2),
              if (stack.city.isNotEmpty) Text(stack.city),
              const Spacing(),
              FButton(
                onPress: () {
                  if (stack.latitude != 0) {
                    LocationHelper.openMaps(
                      lat: stack.latitude,
                      long: stack.longitude,
                    );
                    return;
                  }
                  LocationHelper.openMaps(
                      query:
                          "${stack.address1} ${stack.address2} ${stack.city}");
                },
                label: const Text(Strings.openMaps),
                style: FButtonStyle.outline,
              ),
            ],
          ),
        ),
        FAccordionItem(
          title: const Text(Strings.description),
          child: Text(stack.desc),
        ),
        FAccordionItem(
          title: const Text(Strings.ownerDetails),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${Strings.name} - ${stack.userName}"),
              if (stack.userEmail.isNotEmpty)
                Text("${Strings.email} - ${stack.userEmail}"),
              if (stack.userPhone.isNotEmpty)
                Text("${Strings.phoneNumber} - ${stack.userPhone}"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettings() {
    return Column(
      children: [
        FCard(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Stack ID - ${stack.shortId}"),
              const Spacing(),
              FButton.icon(
                onPress: () async {
                  var res =
                      await ClipboardHelper.copyToClipboard(stack.shortId);
                  if (res) {
                    Style.showToast(
                        context: context, text: "Copied to clipboard");
                  } else {
                    Style.showToast(
                        context: context, text: "Could not copy to clipboard");
                  }
                },
                style: FButtonStyle.ghost,
                child: FAssets.icons.copy(),
              ),
            ],
          ),
        )
      ],
    );
  }

  void _bookNow() async {
    Database database = Database();
    Style.showLoadingDialog(context: context);
    var resp =
        await database.getBookingDetails(LocalService.getUserId(), stack.id);

    Navigator.pop(context);

    resp.when(
      (success) async {
        var result = await showAdaptiveDialog(
          context: context,
          builder: (context) => BookingInfoDialog(map: success),
        );

        if (result != null && result) {
          homeStore.refresh();
          Navigator.pop(context);
        }
      },
      (error) => Style.showToast(context: context, text: error, long: true),
    );
  }

  bool _checkIfAlrBooked() {
    for (var element in homeStore.bookings) {
      if (element.stackId == stack.id) return true;
    }
    return false;
  }
}
