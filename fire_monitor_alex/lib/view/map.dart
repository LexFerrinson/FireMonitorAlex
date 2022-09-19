import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:fire_monitor_alex/model/remote_node.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:fire_monitor_alex/viewmodel/main_view_model.dart';
import 'dart:developer';

class MapView extends StatefulWidget {
  MapView({Key? key}) : super(key: key);

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

  @override
  void initState() {
    loadMarkers();
    super.initState();
  }

  BitmapDescriptor getCorrectMarker(RemoteNode rn) {
    if (rn.humidity == 'No data' || rn.temperature == 'No data') {
      return questionBitmap;
    } else {
      try {
        double h = double.parse(rn.humidity);
        double t = double.parse(rn.temperature);

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

  void showMarker(RemoteNode rn) {
    LatLng nodeLocation =
        LatLng(double.parse(rn.latitude), double.parse(rn.longitude));
    String name = rn.name;
    markers.add(Marker(
        //add marker on google map
        markerId: MarkerId(name),
        position: nodeLocation, //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: name,
          snippet: name,
        ),
        icon: getCorrectMarker(rn), //Icon for Marker
        onTap: () {
          print('Marker clickeeed fire');
        }));
  }

  Future<Uint8List?> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        ?.buffer
        .asUint8List();
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

    var usernet = await readNetwork();
    if (usernet != null &&
        greenIcon != null &&
        warningIcon != null &&
        fireIcon != null) {
      //Go through all the nodes list of the user
      for (RemoteNode rn in usernet.nodes) {
        //Show the initial markers in the map
        showMarker(rn);
      }
    } else {
      debugPrint('Error retrieving the user net from cloud or loading icons');
    }

    setState(() {});
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
      ),
    );
  }
}
