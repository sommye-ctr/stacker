import 'package:geolocator/geolocator.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:multiple_result/multiple_result.dart';

class LocationHelper {
  static Future<Result<Position, String>> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return const Error(
          'Location services are disabled. Kindly enable location services.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error(
            'Denied location permissions. Location permission is required to continue.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied. Kindly enable them by going in app settings.');
    }

    try {
      var res = await Geolocator.getCurrentPosition();
      return Success(res);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static void openMaps({String? query, double? lat, double? long}) {
    if (query != null) {
      MapsLauncher.launchQuery(query);
    } else {
      MapsLauncher.launchCoordinates(lat!, long!);
    }
  }
}
