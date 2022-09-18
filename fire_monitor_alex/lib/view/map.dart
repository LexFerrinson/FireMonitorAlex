import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:fire_monitor_alex/viewmodel/main_view_model.dart';

class MapView extends StatefulWidget {
  MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final int ICON_SIZE = 150;
  GoogleMapController? mapController; //contrller for Google map
  Set<Marker> markers = Set(); //markers for google map
  LatLng showLocation = const LatLng(41.3874, 2.1686);
  LatLng auxLocation = const LatLng(41, 1.8);
  //location to show in map
  late BitmapDescriptor greenBitmap;
  late BitmapDescriptor warningBitmap;
  late BitmapDescriptor fireBitmap;

  @override
  void initState() {
    loadMarkers();
    addMarkers(); //gets and adds the markers from the cloud
    super.initState();
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

    if (greenIcon != null) {
      greenBitmap = BitmapDescriptor.fromBytes(greenIcon);
    }

    if (warningIcon != null) {
      warningBitmap = BitmapDescriptor.fromBytes(warningIcon);
    }

    if (fireIcon != null) {
      fireBitmap = BitmapDescriptor.fromBytes(fireIcon);
    }

    var result = await readNetwork();
    print(result.runtimeType);

    setState(() {});

    /*if (greenIcon != null) {
      markers.add(Marker(
          //add marker on google map
          markerId: MarkerId(showLocation.toString()),
          position: showLocation, //position of marker
          infoWindow: const InfoWindow(
            //popup info
            title: 'Custom marker alex ',
            snippet: 'My Custom Subtitle',
          ),
          icon: BitmapDescriptor.fromBytes(greenIcon), //Icon for Marker
          onTap: () {
            print('Marker clickeeed fire');
          }));
    }

    if (warningIcon != null) {
      markers.add(Marker(
          //add marker on google map
          markerId: MarkerId(showLocation.toString()),
          position: showLocation, //position of marker
          infoWindow: const InfoWindow(
            //popup info
            title: 'Custom marker alex ',
            snippet: 'My Custom Subtitle',
          ),
          icon: BitmapDescriptor.fromBytes(warningIcon), //Icon for Marker
          onTap: () {
            print('Marker clickeeed fire');
          }));
    }

    if (fireIcon != null) {
      markers.add(Marker(
          //add marker on google map
          markerId: MarkerId(showLocation.toString()),
          position: showLocation, //position of marker
          infoWindow: const InfoWindow(
            //popup info
            title: 'Custom marker alex ',
            snippet: 'My Custom Subtitle',
          ),
          icon: BitmapDescriptor.fromBytes(fireIcon), //Icon for Marker
          onTap: () {
            print('Marker clickeeed fire');
          }));
    }*/

    //setState(() {});
  }

  void addMarkers() async {}

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
