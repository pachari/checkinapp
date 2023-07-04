// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class WidgetMap extends StatelessWidget {
  const WidgetMap({
    Key? key,
    required this.latLng,
    required this.mapMarkers,
  }) : super(key: key);

  final LatLng latLng;
  final Map<MarkerId, Marker> mapMarkers;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(target: latLng, zoom: 19),
      onMapCreated: (controller) {},
      markers: Set<Marker>.of(mapMarkers.values),
      circles: {
        Circle(
          circleId: const CircleId('cirid'),
          center: latLng,
          radius: 30,
          strokeWidth: 1,
          fillColor: Colors.red.withOpacity(0.3),

        )
      },
    );
  }
}
