import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:stacker/screens/signup.dart';
import 'package:stacker/screens/view_bookings.dart';
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
          footer: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FButton(
                onPress: () async {
                  await Supabase.instance.client.auth.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    SignupScreen.route,
                    (route) => false,
                  );
                },
                label: const Text("Logout")),
          ),
          header: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                FAvatar(
                  image: const AssetImage(""),
                  fallback: Text(
                    LocalService.getUsername().characters.first.toUpperCase(),
                    style: context.theme.typography.xl5,
                  ),
                  size: 100,
                ),
                const Spacing(),
                Text(
                  LocalService.getUsername(),
                  style: context.theme.typography.xl3,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  LocalService.getUserEmail(),
                  style: context.theme.typography.sm,
                ),
                const Spacing(
                  large: true,
                ),
              ],
            ),
          ),
          content: Column(
            children: [
              FCard(
                child: ListTile(
                  title: const Text("View Bookings"),
                  enabled: true,
                  trailing: FAssets.icons.chevronRight(),
                  leading: FAssets.icons.libraryBig(),
                  onTap: () =>
                      Navigator.pushNamed(context, ViewBookingsScreen.route),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
