import 'package:flutter/material.dart' hide Stack;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:forui/forui.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:stacker/models/stack.dart';
import 'package:stacker/resources/strings.dart';
import 'package:stacker/resources/style.dart';
import 'package:stacker/screens/create_stack.dart';
import 'package:stacker/screens/join_stack.dart';
import 'package:stacker/screens/profile.dart';
import 'package:stacker/screens/stack_details.dart';
import 'package:stacker/store/home/home_store.dart';
import 'package:stacker/widgets/home_stack_tile.dart';
import 'package:stacker/widgets/spacing.dart';

class HomeScreen extends StatefulWidget {
  static const String route = "/home";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeStore homeStore;
  late ReactionDisposer errDisposer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    homeStore = Provider.of<HomeStore>(context);
    homeStore.refresh();
    errDisposer = autorun(
      (_) {
        if (homeStore.error != null) {
          Style.showToast(context: context, text: homeStore.error!);
        }
      },
    );
  }

  @override
  void dispose() {
    errDisposer.reaction.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FScaffold(
        header: FHeader(
          title: Text(
            Strings.appName,
            style: context.theme.typography.xl4
                .copyWith(color: Style.primaryColor),
          ),
          actions: [
            FButton.icon(
              onPress: () => _onPlusClicked(context),
              child: FAssets.icons.plus(),
            ),
            FButton.icon(
              onPress: () => homeStore.refresh(),
              child: FAssets.icons.refreshCcw(),
            ),
            FButton.icon(
              onPress: () => Navigator.pushNamed(context, ProfileScreen.route),
              child: FAssets.icons.userRound(),
            ),
          ],
        ),
        content: SizedBox(
          width: double.infinity,
          child: FTabs(
            tabs: [
              _buildJoinedStacks(),
              _buildCreatedStacks(),
            ],
          ),
        ),
      ),
    );
  }

  FTabEntry _buildJoinedStacks() {
    return FTabEntry(
      content: Flexible(
        child: Observer(builder: (_) {
          return ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: homeStore.joinedStacks.length,
            itemBuilder: (context, index) {
              StackModel s = homeStore.joinedStacks[index];

              return Hero(
                tag: s.id,
                child: HomeStackTile(
                  stack: s,
                  onClick: () => _onStackClicked(s, false, index),
                ),
              );
            },
          );
        }),
      ),
      label: const Text(Strings.joinedStacks),
    );
  }

  FTabEntry _buildCreatedStacks() {
    return FTabEntry(
      content: Flexible(
        child: Observer(builder: (_) {
          return ListView.builder(
            itemBuilder: (context, index) {
              StackModel s = homeStore.createdStacks[index];

              return Hero(
                tag: s.id,
                child: HomeStackTile(
                  stack: s,
                  onClick: () => _onStackClicked(s, true, index),
                ),
              );
            },
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: homeStore.createdStacks.length,
          );
        }),
      ),
      label: const Text(Strings.createdStacks),
    );
  }

  void _onStackClicked(StackModel s, bool created, int index) {
    homeStore.selectedIndex = index;
    Navigator.pushNamed(context, StackDetailsScreen.route, arguments: created);
  }

  void _onPlusClicked(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      shape: RoundedRectangleBorder(
          borderRadius: context.theme.dialogStyle.decoration.borderRadius!),
      builder: (context) {
        return Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Column(
                children: [
                  FButton(
                    onPress: () => _onJoinStackClicked(context),
                    label: const Text(Strings.joinStack),
                  ),
                  const Spacing(),
                  FButton(
                    onPress: () => _onCreateStackClicked(context),
                    label: const Text(Strings.createStack),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _onCreateStackClicked(context) async {
    Navigator.pop(context);
    final result =
        await Navigator.pushNamed<bool>(context, CreateStackScreen.route);

    if (result != null && result) {
      homeStore.refresh();
    }
  }

  void _onJoinStackClicked(context) async {
    Navigator.pop(context);

    var res = await showAdaptiveDialog(
      context: context,
      builder: (context) => const JoinStackDialog(),
    );

    if (res != null && res) {
      homeStore.refresh();
    }
  }
}
