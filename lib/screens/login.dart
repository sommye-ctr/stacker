import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:forui/forui.dart';
import 'package:stacker/resources/assets.dart';
import 'package:stacker/resources/strings.dart';
import 'package:stacker/resources/style.dart';
import 'package:stacker/screens/home.dart';
import 'package:stacker/utils/screen_size.dart';
import 'package:stacker/widgets/spacing.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  static const String route = "/login";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  BuildContext? buildContext;

  void _proceed() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Style.showLoadingDialog(context: buildContext ?? context);
    try {
      final AuthResponse resp =
          await Supabase.instance.client.auth.signInWithPassword(
        password: _passController.text.trim(),
        email: _emailController.text.trim(),
      );
      Style.dismisLoadingDialog(context: buildContext ?? context);

      if (resp.session != null && resp.user != null) {
        Navigator.pushNamedAndRemoveUntil(
          buildContext ?? context,
          HomeScreen.route,
          (route) => false,
        );
      }
    } on AuthException catch (error) {
      Navigator.pop(buildContext ?? context);
      Style.showToast(context: buildContext ?? context, text: error.message);
    } catch (error) {
      Navigator.pop(buildContext ?? context);
      Style.showToast(
          context: buildContext ?? context, text: Strings.unexpectedError);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  Assets.login,
                  width: double.infinity,
                  height: ScreenSize.getPercentOfHeight(
                    context,
                    0.35,
                  ),
                ),
                Text(
                  Strings.login,
                  style: context.theme.typography.xl4,
                ),
                const Spacing(),
                FTextField.email(
                  enabled: true,
                  hint: Strings.mailHint,
                  controller: _emailController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => EmailValidator.validate(value ?? "")
                      ? null
                      : Strings.emailError,
                ),
                const Spacing(
                  large: true,
                ),
                FTextField.password(
                  enabled: true,
                  hint: Strings.passHint,
                  controller: _passController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                      (value ?? "").length < 8 ? Strings.passError : null,
                ),
                const Spacing(
                  large: true,
                ),
                Hero(
                  tag: Strings.proceed,
                  child: Center(
                    child: FButton(
                      label: const Text(Strings.proceed),
                      onPress: () {
                        _proceed();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
