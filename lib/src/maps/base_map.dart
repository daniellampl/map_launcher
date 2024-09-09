import 'package:map_launcher/map_launcher.dart';

abstract class BaseMap {
  const BaseMap();

  String getCoordinatesUrl({
    required Coords coordinates,
    String? title,
    int? zoom,
    Map<String, String?>? extraParams,
  });

  String getAddressUrl({
    required String address,
    String? title,
    int? zoom,
    Map<String, String?>? extraParams,
  });

  String getDirectionUrl({
    required Coords destination,
    DirectionsMode? directionsMode,
    String? destinationTitle,
    Coords? origin,
    String? originTitle,
    List<Waypoint>? waypoints,
    Map<String, String?>? extraParams,
  });
}
