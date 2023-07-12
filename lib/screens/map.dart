import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MainMapScreen extends StatefulWidget {
  const MainMapScreen({super.key});

  @override
  State<MainMapScreen> createState() => _MainMapScreenState();
}

class _MainMapScreenState extends State<MainMapScreen> {
  // late GoogleMapController mapController;

  // final LatLng _center = const LatLng(1.2971365,103.7775268);

  // void _onMapCreated(GoogleMapController controller) {
  //   mapController = controller;
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     theme: ThemeData(
  //       useMaterial3: true,
  //       colorSchemeSeed: Colors.green[700],
  //     ),
  //     home: Scaffold(
  //       body: GoogleMap(
  //         onMapCreated: _onMapCreated,
  //         initialCameraPosition: CameraPosition(
  //           target: _center,
  //           zoom: 16.0,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  final Completer<GoogleMapController> _controller = Completer();
  // on below line we have specified camera position
  static const CameraPosition _kGoogle = CameraPosition(
    target: LatLng(1.2971365, 103.7775268),
    zoom: 7,
  );

  // on below line we have created the list of markers
  final List<Marker> _markers = <Marker>[
    const Marker(
        markerId: MarkerId('1'),
        position: LatLng(1.2971365, 103.7775268),
        infoWindow: InfoWindow(
          title: 'My Position',
        )),
  ];

  @override
  void initState() {
    super.initState();
    requestLocation();
  }

  requestLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      debugPrint("ERROR${error.toString()}");
    });
  }

  // created method for getting user current location
  Future<Position> getUserCurrentLocation() async {
    requestLocation();
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          // on below line creating google maps
          child: GoogleMap(
            // on below line setting camera position
            initialCameraPosition: _kGoogle,
            // on below line we are setting markers on the map
            markers: Set<Marker>.of(_markers),
            // on below line specifying map type.
            mapType: MapType.normal,
            // on below line setting user location enabled.
            myLocationEnabled: true,
            // on below line setting compass enabled.
            compassEnabled: true,
            // on below line specifying controller on map complete.
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            minMaxZoomPreference: MinMaxZoomPreference(14, 20),
            cameraTargetBounds: CameraTargetBounds(
              LatLngBounds(
                northeast: LatLng(1.30908237, 103.7894576),
                southwest: LatLng(1.2897933, 103.7687561),
              ),
            ),
          ),
        ),
      ),
      // on pressing floating action button the camera will take to user current location
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          getUserCurrentLocation().then((value) async {
            debugPrint(
                "${value.latitude.toString()} ${value.longitude.toString()}");

            // marker added for current users location
            _markers.add(Marker(
              markerId: const MarkerId("2"),
              position: LatLng(value.latitude, value.longitude),
              infoWindow: const InfoWindow(
                title: 'My Current Location',
              ),
            ));

            // specified current users location
            CameraPosition cameraPosition = CameraPosition(
              target: LatLng(value.latitude, value.longitude),
              zoom: 16,
            );

            final GoogleMapController controller = await _controller.future;
            controller
                .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
            setState(() {});
          });
        },
        child: const Icon(Icons.local_activity),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
