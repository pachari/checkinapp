// ignore_for_file: avoid_print

import 'package:checkinapp/utility/app_controller.dart';
import 'package:checkinapp/utility/app_service.dart';
import 'package:checkinapp/widgets/widget_map.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CheckInMap extends StatefulWidget {
  const CheckInMap({super.key});

  @override
  State<CheckInMap> createState() => _CheckInMapState();
}

class _CheckInMapState extends State<CheckInMap> {
  Map<MarkerId, Marker> mapMarkers = {};
  AppController controller = Get.put(AppController());

  @override
  void initState() {
    super.initState();
    aboutPositionAndMarker();
    addMarkerFactory();
  }

  void addMarkerFactory() {
    for (var i = 0; i < controller.factoryModels.length; i++) {
      MarkerId markerId = MarkerId('Factory $i');
      Marker marker = AppService().createMarker(
        latLng: LatLng(
            controller.factoryModels[i].position.latitude,controller.factoryModels[i].position.longitude), //controller.factoryModels[i].lat, controller.factoryModels[i].lng
        markerId: markerId,
        title: controller.factoryModels[i].title,
        subtitle: controller.factoryModels[i].subtitle,
      );
      mapMarkers[markerId] = marker;
    }
  }

  void aboutPositionAndMarker() {
    AppService().processFindPosition(context: context).then((value) {
      MarkerId markerId = const MarkerId('idUser');
      Marker marker = AppService().createMarker(
          latLng: LatLng(controller.position.last.latitude,
              controller.position.last.longitude),
          markerId: markerId,
          title: 'คุณอยู่ที่นี่',
          subtitle: 'You Here',
          hue: 240);

      mapMarkers[markerId] = marker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX(
          init: AppController(),
          builder: (AppController appController) {
            print('## fac lat --> ${appController.factoryModels.length}');
            return appController.position.isEmpty
                ? const SizedBox()
                : WidgetMap(
                    latLng: LatLng(appController.position.last.latitude,
                        appController.position.last.longitude),
                    mapMarkers: mapMarkers,
                  );
          }),
    );
  }
}
