import 'dart:io';

import 'package:map_launcher/map_launcher.dart';
import 'package:map_launcher/src/maps/base_map.dart';
import 'package:map_launcher/src/utils.dart';

// https://developer.apple.com/library/archive/featuredarticles/iPhoneURLScheme_Reference/MapLinks/MapLinks.html
class AppleMaps implements BaseMap {
  const AppleMaps();

  @override
  String getAddressUrl({
    required String address,
    String? title,
    int? zoom,
    Map<String, String?>? extraParams,
  }) {
    return Utils.buildUrl(
      url: _baseUrl,
      queryParams: {
        'address': Uri.encodeQueryComponent(address),
        // serves as the title if address is provided.
        if (title != null) 'q': title,
        if (zoom != null) 'z': '$zoom',
        ...(extraParams ?? {}),
      },
    );
  }

  @override
  String getCoordinatesUrl({
    required Coords coordinates,
    String? title,
    int? zoom,
    Map<String, String?>? extraParams,
  }) {
    return Utils.buildUrl(
      url: _baseUrl,
      queryParams: {
        'll': '${coordinates.latitude},${coordinates.longitude}',
        // serves as the title if ll is provided.
        if (title != null) 'q': title,
        if (zoom != null) 'z': '$zoom',
        ...(extraParams ?? {}),
      },
    );
  }

  @override
  String getDirectionUrl({
    required Coords destination,
    DirectionsMode? directionsMode,
    String? destinationTitle,
    Coords? origin,
    String? originTitle,
    List<Waypoint>? waypoints,
    Map<String, String?>? extraParams,
  }) {
    return Utils.buildUrl(
      url: _baseUrl,
      queryParams: {
        if (origin != null) 'saddr': '${origin.latitude},${origin.longitude}',
        'daddr': '${destination.latitude},${destination.longitude}',
        if (directionsMode != null)
          'dirflg': _getDirectionModeValue(directionsMode),
        ...(extraParams ?? {}),
      },
    );
  }

  String get _baseUrl => Platform.isIOS || Platform.isMacOS
      ? 'maps://'
      : 'http://maps.apple.com/maps';

  /// Returns [DirectionsMode] for [MapType.apple]
  String _getDirectionModeValue(DirectionsMode? directionsMode) {
    switch (directionsMode) {
      case DirectionsMode.driving:
        return 'd';
      case DirectionsMode.transit:
        return 'r';
      case DirectionsMode.walking:
        return 'f';
      default:
        return 'd';
    }
  }
}
