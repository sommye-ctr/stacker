import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:stacker/screens/signup.dart';
import 'package:stacker/services/local.dart';
import 'package:stacker/widgets/spacing.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatelessWidget {
  static const String route = "/profile";
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: FScaffold(
          content: Container(),
          footer: FButton(
              onPress: () async {
                await Supabase.instance.client.auth.signOut();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  SignupScreen.route,
                  (route) => false,
                );
              },
              label: const Text("Logout")),
          header: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                FAvatar(
                  image: const AssetImage(""),
                  fallback: Text(
                    "",
                    style: context.theme.typography.xl5,
                  ),
                  size: 100,
                ),
                const Spacing(),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        LocalService.getUsername(),
                        style: context.theme.typography.xl3,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(LocalService.getUserEmail()),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
