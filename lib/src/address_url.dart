import 'package:map_launcher/src/maps/apple_maps.dart';
import 'package:map_launcher/src/maps/base_map.dart';
import 'package:map_launcher/src/maps/google_maps.dart';
import 'package:map_launcher/src/models.dart';

/// Returns a url that is used by [showAddress]
String getMapAddressUrl({
  required MapType mapType,
  required String address,
  String? title,
  int? zoom,
  Map<String, String>? extraParams,
}) {
  final BaseMap map;

  switch (mapType) {
    case MapType.googleGo:
    case MapType.google:
      map = GoogleMaps(go: mapType == MapType.googleGo);
      break;

    case MapType.apple:
      map = const AppleMaps();
      break;

    default:
      throw UnimplementedError(
        'Opening address for $mapType is not yet supported!',
      );
  }

  return map.getAddressUrl(
    address: address,
    title: title,
    zoom: zoom,
    extraParams: extraParams,
  );
}
