import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:forui/forui.dart';
import 'package:stacker/resources/assets.dart';
import 'package:stacker/resources/strings.dart';
import 'package:stacker/resources/style.dart';
import 'package:stacker/screens/home.dart';
import 'package:stacker/screens/login.dart';
import 'package:stacker/utils/screen_size.dart';
import 'package:stacker/widgets/spacing.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupScreen extends StatefulWidget {
  static const String route = "/signup";
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  BuildContext? buildContext;

  static bool _validateEmail(String email) {
    return EmailValidator.validate(email, true);
  }

  void _proceed() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    Style.showLoadingDialog(context: buildContext!);

    try {
      AuthResponse authResponse = await Supabase.instance.client.auth.signUp(
          password: _passController.text.trim(),
          email: _emailController.text.trim(),
          data: {
            "name": _nameController.text.trim(),
          });
      Style.dismisLoadingDialog(context: buildContext!);

      if (authResponse.user != null &&
          authResponse.user!.identities != null &&
          authResponse.user!.identities!.isEmpty) {
        Style.showToast(
          context: buildContext!,
          text: Strings.emailAlrInUse,
        );
        return;
      }
      Navigator.pushNamedAndRemoveUntil(
        buildContext!,
        HomeScreen.route,
        (route) => false,
      );
    } on AuthException catch (error) {
      Style.dismisLoadingDialog(context: buildContext!);
      Style.showToast(context: buildContext!, text: error.message);
    } catch (error) {
      Style.dismisLoadingDialog(context: buildContext!);
      Style.showToast(context: buildContext!, text: Strings.unexpectedError);
    }
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;
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
                  Assets.welcome,
                  width: double.infinity,
                  height: ScreenSize.getPercentOfHeight(
                    context,
                    0.35,
                  ),
                ),
                Text(
                  Strings.getStarted,
                  style: context.theme.typography.xl4,
                ),
                const Spacing(),
                FTextField(
                  enabled: true,
                  hint: Strings.nameHint,
                  controller: _nameController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  label: const Text(Strings.name),
                  validator: (value) =>
                      (value ?? "").length < 5 ? Strings.nameError : null,
                ),
                const Spacing(
                  large: true,
                ),
                FTextField.email(
                  enabled: true,
                  hint: Strings.mailHint,
                  controller: _emailController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                      _validateEmail(value ?? "") ? null : Strings.emailError,
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
                const Spacing(),
                FButton(
                  style: FButtonStyle.outline,
                  onPress: () {
                    Navigator.pushNamed(context, LoginScreen.route);
                  },
                  label: const Text(Strings.alrHaveAcc),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
