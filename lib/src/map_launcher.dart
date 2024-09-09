import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:map_launcher/src/address_url.dart';
import 'package:map_launcher/src/directions_url.dart';
import 'package:map_launcher/src/marker_url.dart';
import 'package:map_launcher/src/models.dart';
import 'package:map_launcher/src/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class MapLauncher {
  static const MethodChannel _channel = MethodChannel('map_launcher');

  /// Returns list of installed map apps on the device.
  static Future<List<AvailableMap>> get installedMaps async {
    final maps = await _channel.invokeMethod('getInstalledMaps');
    return List<AvailableMap>.from(
      maps.map((map) => AvailableMap.fromJson(map)),
    );
  }

  @Deprecated(
    'Use showCoordinates instead. '
    'This feature was deprecated after v4.0.0',
  )
  static Future<dynamic> showMarker({
    required MapType mapType,
    required Coords coords,
    String? title,
    String? description,
    int? zoom,
    Map<String, String>? extraParams,
  }) =>
      showCoordinates(
        mapType: mapType,
        coords: coords,
        title: title,
        description: description,
        zoom: zoom,
        extraParams: extraParams,
      );

  /// Opens map app specified in [mapType] and shows marker at its [coords].
  static Future<dynamic> showCoordinates({
    required MapType mapType,
    required Coords coords,
    String? title,
    String? description,
    int? zoom,
    Map<String, String>? extraParams,
  }) async {
    final String url = getMapMarkerUrl(
      mapType: mapType,
      coords: coords,
      title: title,
      description: description,
      zoom: zoom,
      extraParams: extraParams,
    );

    await launchUrl(Uri.parse(url));
  }

  static Future<dynamic> showAddress({
    required MapType mapType,
    required String address,
    String? title,
    int? zoom,
    Map<String, String>? extraParams,
  }) async {
    final String url = getMapAddressUrl(
      mapType: mapType,
      address: address,
      title: title,
      zoom: zoom,
      extraParams: extraParams,
    );

    await _launchMap(url);
  }

  /// Opens map app specified in [mapType]
  /// and shows directions to [destination]
  static Future<dynamic> showDirections({
    required MapType mapType,
    required Coords destination,
    String? destinationTitle,
    Coords? origin,
    String? originTitle,
    List<Waypoint>? waypoints,
    DirectionsMode? directionsMode = DirectionsMode.driving,
    Map<String, String>? extraParams,
  }) async {
    if (Platform.isIOS && waypoints != null && waypoints.length > 1) {
      final Map<String, dynamic> args = {
        'destinationTitle': destinationTitle,
        'destinationLatitude': destination.latitude.toString(),
        'destinationLongitude': destination.longitude.toString(),
        'originLatitude': origin?.latitude.toString(),
        'originLongitude': origin?.longitude.toString(),
        'originTitle': originTitle,
        'directionsMode': Utils.enumToString(directionsMode),
        'waypoints': waypoints
            .map((waypoint) => {
                  'latitude': waypoint.latitude.toString(),
                  'longitude': waypoint.longitude.toString(),
                  'title': waypoint.title,
                })
            .toList(),
      };

      return _channel.invokeMethod('showDirections', args);
    } else {
      final String url = getMapDirectionsUrl(
        mapType: mapType,
        destination: destination,
        destinationTitle: destinationTitle,
        origin: origin,
        originTitle: originTitle,
        waypoints: waypoints,
        directionsMode: directionsMode,
        extraParams: extraParams,
      );

      return _launchMap(url);
    }
  }

  /// Returns boolean indicating if map app is installed
  static Future<bool?> isMapAvailable(MapType mapType) async {
    return _channel.invokeMethod(
      'isMapAvailable',
      {'mapType': Utils.enumToString(mapType)},
    );
  }

  static Future<dynamic> _launchMap(String url) async {
    await launchUrl(Uri.parse(url));
  }
}
