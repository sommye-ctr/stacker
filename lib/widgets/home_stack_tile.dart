import 'package:flutter/material.dart' hide Stack;
import 'package:forui/forui.dart';
import 'package:simple_time_range_picker/simple_time_range_picker.dart';
import 'package:stacker/models/stack.dart';
import 'package:stacker/resources/strings.dart';
import 'package:stacker/resources/style.dart';
import 'package:stacker/utils/date_helper.dart';
import 'package:stacker/utils/screen_size.dart';
import 'package:stacker/widgets/rounded_image.dart';

class HomeStackTile extends StatelessWidget {
  final StackModel stack;
  final void Function()? onClick;
  const HomeStackTile({super.key, required this.stack, this.onClick});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onClick,
        child: FCard(
          title: Row(
            children: [
              Text(stack.name),
              const SizedBox(width: 6),
              FBadge(
                label: Text(stack.status),
                style: stack.status == Strings.closed
                    ? FBadgeStyle.destructive
                    : FBadgeStyle.primary,
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateHelper.convertTimeRangeString(
                  TimeRangeValue.value(
                    startTime: stack.openTime,
                    endTime: stack.closeTime,
                  ),
                ),
              ),
              Text("Current Token - ${stack.currentToken}")
            ],
          ),
          image: RoundedImage(
            image: stack.image,
            width: ScreenSize.getPercentOfWidth(context, 0.9),
            ratio: Style.stackTileImageRatio,
          ),
        ),
      ),
    );
  }
}
