import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:stacker/resources/strings.dart';
import 'package:stacker/resources/style.dart';
import 'package:stacker/services/database.dart';
import 'package:stacker/services/local.dart';
import 'package:stacker/widgets/spacing.dart';

class JoinStackDialog extends StatefulWidget {
  const JoinStackDialog({super.key});

  @override
  State<JoinStackDialog> createState() => _JoinStackDialogState();
}

class _JoinStackDialogState extends State<JoinStackDialog> {
  final TextEditingController controller = TextEditingController();

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
            children: [
              Text(
                Strings.joinStack,
                style: context.theme.typography.lg,
              ),
              const Spacing(),
              FTextField(
                label: const Text("Stack ID"),
                hint: "Enter 7 digit Stack ID",
                maxLength: 7,
                controller: controller,
              ),
              const Spacing(large: true),
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
                        if (controller.text.length != 7) {
                          Style.showToast(
                              context: context,
                              text: "Stack ID must be of 7 characters");
                          return;
                        }
                        Style.showLoadingDialog(context: context);
                        var resp = await Database().joinStack(
                            controller.text, LocalService.getUserId());

                        Navigator.pop(context);
                        resp.when(
                          (success) {
                            Navigator.pop(context, true);
                          },
                          (error) =>
                              Style.showToast(context: context, text: error),
                        );
                      },
                      label: const Text("Join"),
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
