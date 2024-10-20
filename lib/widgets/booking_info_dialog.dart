import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:stacker/resources/strings.dart';
import 'package:stacker/resources/style.dart';
import 'package:stacker/services/database.dart';
import 'package:stacker/utils/date_helper.dart';
import 'package:stacker/widgets/spacing.dart';

class BookingInfoDialog extends StatefulWidget {
  final Map<String, dynamic> map;
  const BookingInfoDialog({super.key, required this.map});

  @override
  State<BookingInfoDialog> createState() => _BookingInfoDialogState();
}

class _BookingInfoDialogState extends State<BookingInfoDialog> {
  late TimeOfDay t =
      DateHelper.convertIso8601ToTimeOfDay(widget.map['time_arrival']);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: context.theme.cardStyle.decoration.borderRadius!,
      ),
      child: IntrinsicHeight(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "#${widget.map['token']}",
                style: context.theme.typography.xl2,
              ),
              const Spacing(),
              Text(
                  "Your estimated time of booking is ${DateHelper.formatTimeOfDay(t)}"),
              const Spacing(),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: FButton(
                      onPress: () => Navigator.pop(context),
                      label: const Text("Cancel"),
                    ),
                  ),
                  const Spacing(),
                  Expanded(
                    child: FButton(
                      onPress: () async {
                        Style.showLoadingDialog(context: context);
                        var resp = await Database().proceedBooking(widget.map);
                        Navigator.pop(context);

                        resp.when(
                          (success) {
                            Style.showToast(
                                context: context, text: "Booked succesfully");
                            Navigator.pop(context, true);
                          },
                          (error) => Style.showToast(
                            context: context,
                            text: error,
                            long: true,
                          ),
                        );
                      },
                      label: const Text(Strings.proceed),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
