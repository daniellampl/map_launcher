import 'dart:io';

import 'package:map_launcher/map_launcher.dart';
import 'package:map_launcher/src/maps/base_map.dart';
import 'package:map_launcher/src/utils.dart';

/// for Android: https://developers.google.com/maps/documentation/urls/android-intents
/// for iOS: https://developers.google.com/maps/documentation/urls/ios-urlscheme
class GoogleMaps implements BaseMap {
  const GoogleMaps({this.go = false});

  final bool go;

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
        'api': '1',
        'q': Uri.encodeQueryComponent(address),
        if (zoom != null) 'zoom': '$zoom',
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
        'q':
            '${coordinates.latitude},${coordinates.longitude}${title != null && title.isNotEmpty ? '($title)' : ''}',
        if (zoom != null) 'zoom': '$zoom',
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
      url: 'https://www.google.com/maps/dir/',
      queryParams: {
        'api': '1',
        'destination': '${destination.latitude},${destination.longitude}',
        'origin': Utils.nullOrValue(
          origin,
          '${origin?.latitude},${origin?.longitude}',
        ),
        'waypoints': waypoints
            ?.map((waypoint) => '${waypoint.latitude},${waypoint.longitude}')
            .join('|'),
        if (directionsMode != null)
          'travelmode': _getTravelMode(directionsMode),
        ...(extraParams ?? {}),
      },
    );
  }

  String get _baseUrl => go
      ? 'http://maps.google.com/maps'
      : Platform.isIOS
          ? 'comgooglemaps://'
          : 'geo:0,0';

  String _getTravelMode(DirectionsMode directionsMode) {
    switch (directionsMode) {
      case DirectionsMode.driving:
        return 'driving';
      case DirectionsMode.walking:
        return 'walking';
      case DirectionsMode.bicycling:
        return 'bicycling';
      case DirectionsMode.transit:
        return 'transit';
    }
  }
}
