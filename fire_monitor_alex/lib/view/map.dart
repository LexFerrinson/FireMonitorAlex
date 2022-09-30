import 'dart:typed_data';
import 'package:fire_monitor_alex/model/env_data.dart';
import 'package:fire_monitor_alex/model/user_net.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:fire_monitor_alex/viewmodel/main_view_model.dart';
import '../viewmodel/tools.dart';

import '../model/sensor.dart';

typedef FloatingInfoCallback = void Function(String, String, Color);
typedef HideFloatingCallback = void Function();

class MapView extends StatefulWidget {
  const MapView(
      {Key? key, required this.floatingInfo, required this.hideFloatingInfo})
      : super(key: key);

  final FloatingInfoCallback floatingInfo;
  final HideFloatingCallback hideFloatingInfo;
  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final int ICON_SIZE = 150;
  GoogleMapController? mapController; //contrller for Google map
  Set<Marker> markers = {}; //markers for google map
  LatLng showLocation = const LatLng(41.3874, 2.1686);
  LatLng auxLocation = const LatLng(41, 1.8);
  //location to show in map
  late BitmapDescriptor greenBitmap;
  late BitmapDescriptor warningBitmap;
  late BitmapDescriptor fireBitmap;
  late BitmapDescriptor questionBitmap;
  String selId = "";

  void createShit(FloatingInfoCallback onSuccess) {}

  void myCustomListener(UserNet net) {
    print('My listener says: $net');
    markers = {};
    String? h;
    String? t;
    Color? c;
    List envValues = readNetworkAndShowMarkers(net, false);
    h = envValues[0];
    t = envValues[1];
    c = envValues[2];

    if (h != null && t != null && c != null) {
      widget.floatingInfo(h, t, c);
      //The floating information is shown in the father class with a callback
    } else {
      widget.hideFloatingInfo();
    }
    setState(() {});
  }

  @override
  void initState() {
    loadMarkers();
    subscribeToBBDDchange(myCustomListener);
    super.initState();
  }

  List readNetworkAndShowMarkers(UserNet net, bool showMarkersFlag) {
    String? h;
    String? t;
    Color? c;
    bool found = false;
    net.nodes.forEach(
      (key, value) {
        //showMarker(value); here should be shown an icon to indicate a rn in a certain location
        if (value.sensors != null) {
          value.sensors!.forEach(
            (key, value) {
              if (value.dataRecord != null && value.dataRecord!.isNotEmpty) {
                showMarker(value, value.dataRecord!.last);
                if (value.name == selId) {
                  //We must show floating information only of the selected marker
                  h = value.dataRecord!.last.humidity;
                  t = value.dataRecord!.last.temperature;
                  c = getCorrectColor(value.dataRecord!.last);
                  found = true;
                }
              } else {
                EnvData emptyData = EnvData('No data', 'No data', '00:00');
                showMarker(value, emptyData);
                if (value.name == selId) {
                  h = 'No data';
                  t = 'No data';
                  c = getCorrectColor(emptyData);
                  found = true;
                }
              }
            },
          );
        }
      },
    );

    return found ? [h, t, c] : [null, null, null];
  }

  //This function gets the correct icon for the marker
  BitmapDescriptor getCorrectMarker(EnvData d) {
    if (d.humidity == 'No data' || d.temperature == 'No data') {
      return questionBitmap;
    } else {
      try {
        double h = double.parse(d.humidity);
        double t = double.parse(d.temperature);

        if (t < 50) {
          return greenBitmap;
        } else if (t >= 50 && h >= 50) {
          return warningBitmap;
        } else if (t >= 50 && h < 50) {
          return fireBitmap;
        }
      } on Exception catch (_) {
        return questionBitmap;
      }
    }
    return questionBitmap;
  }

  //This function gets the correct color for the floating information
  Color getCorrectColor(EnvData d) {
    if (d.humidity == 'No data' || d.temperature == 'No data') {
      return const Color.fromARGB(251, 37, 37, 37);
    } else {
      try {
        double h = double.parse(d.humidity);
        double t = double.parse(d.temperature);

        if (t < 50) {
          return const Color.fromARGB(250, 51, 145, 8);
        } else if (t >= 50 && h >= 50) {
          return const Color.fromARGB(249, 165, 138, 15);
        } else if (t >= 50 && h < 50) {
          return const Color.fromARGB(250, 139, 12, 12);
        }
      } on Exception catch (_) {
        return const Color.fromARGB(251, 37, 37, 37);
      }
    }
    return const Color.fromARGB(251, 37, 37, 37);
  }

  void showMarker(Sensor s, EnvData d) {
    LatLng nodeLocation =
        LatLng(double.parse(s.latitude), double.parse(s.longitude));
    String name = s.name;
    String h = d.humidity;
    String t = d.temperature;
    markers.add(Marker(
        //add marker on google map
        markerId: MarkerId(name),
        position: nodeLocation, //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: name,
          snippet: ' ',
        ),
        icon: getCorrectMarker(d), //Icon for Marker
        onTap: () {
          selId = name;
          Color c = getCorrectColor(d);
          widget.floatingInfo(h, t, c);
        }));
  }

  void loadMarkers() async {
    final Uint8List? greenIcon =
        await getBytesFromAsset('assets/images/green.png', ICON_SIZE);

    final Uint8List? fireIcon =
        await getBytesFromAsset('assets/images/fire.png', ICON_SIZE);

    final Uint8List? warningIcon =
        await getBytesFromAsset('assets/images/warning.png', ICON_SIZE);

    final Uint8List? questionIcon =
        await getBytesFromAsset('assets/images/question.png', ICON_SIZE);

    if (greenIcon != null) {
      greenBitmap = BitmapDescriptor.fromBytes(greenIcon);
    }

    if (warningIcon != null) {
      warningBitmap = BitmapDescriptor.fromBytes(warningIcon);
    }

    if (fireIcon != null) {
      fireBitmap = BitmapDescriptor.fromBytes(fireIcon);
    }

    if (questionIcon != null) {
      questionBitmap = BitmapDescriptor.fromBytes(questionIcon);
    }

    UserNet? usernet = await readNetwork();
    if (usernet != null &&
        greenIcon != null &&
        warningIcon != null &&
        fireIcon != null) {
      //Go through all the nodes list of the user
      readNetworkAndShowMarkers(usernet, true);
    } else {
      debugPrint('Error retrieving the user net from cloud or loading icons');
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemStatusBarContrastEnforced: false,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ));

    //Setting SystmeUIMode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
        overlays: [SystemUiOverlay.top]);

    return Scaffold(
      body: GoogleMap(
        //Map widget from google_maps_flutter package
        mapToolbarEnabled: false,
        zoomControlsEnabled: false,
        zoomGesturesEnabled: true, //enable Zoom in, out on map
        initialCameraPosition: CameraPosition(
          //innital position in map
          target: showLocation, //initial position
          zoom: 10.0, //initial zoom level
        ),
        markers: markers, //markers to show on map
        mapType: MapType.hybrid, //map type
        onMapCreated: (controller) {
          //method called when map is created
          setState(() {
            mapController = controller;
          });
        },
        onTap: (coord) {
          widget.hideFloatingInfo();
        },
      ),
    );
  }
}
