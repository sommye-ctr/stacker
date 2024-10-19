import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:provider/provider.dart';
import 'package:stacker/models/booking.dart';
import 'package:stacker/resources/style.dart';
import 'package:stacker/store/home/home_store.dart';
import 'package:stacker/utils/date_helper.dart';
import 'package:stacker/utils/screen_size.dart';
import 'package:stacker/widgets/rounded_image.dart';
import 'package:stacker/widgets/spacing.dart';

class ViewBookingsScreen extends StatefulWidget {
  static const String route = "/view-bookings";
  const ViewBookingsScreen({super.key});

  @override
  State<ViewBookingsScreen> createState() => _ViewBookingsScreenState();
}

class _ViewBookingsScreenState extends State<ViewBookingsScreen> {
  late HomeStore homeStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    homeStore = Provider.of<HomeStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: FScaffold(
          header: Text(
            "Your Bookings",
            style: context.theme.typography.xl3,
          ),
          content: ListView.builder(
            itemCount: homeStore.bookings.length,
            itemBuilder: (context, index) {
              Booking booking = homeStore.bookings[index];
              return FCard(
                image: RoundedImage(
                  image: booking.stacks.image,
                  width: ScreenSize.getPercentOfWidth(context, 0.9),
                  ratio: Style.stackTileImageRatio,
                ),
                title: Row(
                  children: [
                    Text(
                      booking.stacks.name,
                      style: context.theme.typography.lg
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    const Spacing(),
                    _buildBadge(booking),
                  ],
                ),
                subtitle: Column(
                  children: [
                    const Spacing(),
                    Text(
                      "Token - #${booking.token}",
                    ),
                    const Spacing(),
                    Text(
                        "At ${DateHelper.formatTimeOfDay(booking.timeArrival)}"),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(Booking booking) {
    if (booking.status == "Active") {
      return FBadge(label: Text(booking.status));
    }
    return FBadge(
      label: Text(booking.status),
      style: FBadgeStyle.secondary,
    );
  }
}
