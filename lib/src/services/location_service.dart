import 'package:domain/domain.dart';
import 'package:location/location.dart';

abstract class LocationService {
  Future<Coordinates> get coordinates;
}

class PlatformLocationService implements LocationService {
  final _location = Location();

  @override
  Future<Coordinates> get coordinates async {
    final locationData = await _getLocation();
    return Coordinates(
        longitude: locationData.longitude ?? double.nan,
        latitude: locationData.latitude ?? double.nan);
  }

  Future<LocationData> _getLocation() async {
    bool locationServiceEnabled = await _location.serviceEnabled();
    bool locationPermissionGranted =
        await _location.hasPermission() == PermissionStatus.granted;

    if (locationServiceEnabled && locationPermissionGranted) {
      return await _location.getLocation();
    }

    locationServiceEnabled = await _location.requestService();
    if (!locationServiceEnabled) {
      return LocationData.fromMap({});
    }

    if (locationPermissionGranted) {
      return await _location.getLocation();
    }

    locationPermissionGranted =
        await _location.requestPermission() == PermissionStatus.granted;
    if (locationPermissionGranted) {
      return await _location.getLocation();
    }

    return LocationData.fromMap({});
  }
}
