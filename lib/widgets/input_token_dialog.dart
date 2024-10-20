import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:stacker/resources/style.dart';
import 'package:stacker/services/database.dart';
import 'package:stacker/widgets/spacing.dart';

class InputTokenDialog extends StatefulWidget {
  final String stackId;
  const InputTokenDialog({super.key, required this.stackId});

  @override
  State<InputTokenDialog> createState() => _InputTokenDialogState();
}

class _InputTokenDialogState extends State<InputTokenDialog> {
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
                "Input Token",
                style: context.theme.typography.lg,
              ),
              const Spacing(),
              FTextField(
                label: const Text("Token Number"),
                hint: "Enter token number (given by customer)",
                keyboardType: TextInputType.number,
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
                        int token = int.parse(controller.text);
                        Style.showLoadingDialog(context: context);
                        var res = await Database()
                            .setCurrentToken(widget.stackId, token);

                        Navigator.pop(context);
                        res.when(
                          (success) {
                            Navigator.pop(context, token);
                          },
                          (error) =>
                              Style.showToast(context: context, text: error),
                        );
                      },
                      label: const Text("Enter"),
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
