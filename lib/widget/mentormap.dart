import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ta_anywhere/models/constants.dart';

class MentorMapScreen extends StatefulWidget {
  const MentorMapScreen({super.key, required this.username, required this.x_coordinate, required this.y_coordinate});

  final String username;
  final double x_coordinate;
  final double y_coordinate;

  @override
  State<MentorMapScreen> createState() => _MentorMapScreenState();
}

class _MentorMapScreenState extends State<MentorMapScreen> {

  final Completer<GoogleMapController> _controller = Completer();
  // on below line we have specified camera position
  static const CameraPosition _kGoogle = CameraPosition(
    target: LatLng(1.2971365,103.7775268),
    zoom: 20,
  );
 
  // on below line we have created the list of markers
  final Set<Marker> _markers = {};
 
  // created method for getting user current location
  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value){
    }).onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      debugPrint("ERROR${error.toString()}");
    });
    return await Geolocator.getCurrentPosition();
  }

  List<LatLng> polylineCoordinates = [];

  void getPolyPoints(double srclat, double srclng, double dstlat, double dstlng) async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyC7EFshsiUoJdt-lItecOX5Wpm4mGo2dCo', 
      PointLatLng(srclat, srclng),
      // PointLatLng(1.2971365,103.7775268), 
      PointLatLng(dstlat, dstlng), 
    );

    if(result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) => 
          polylineCoordinates.add(LatLng(point.latitude, point.longitude))
      );
      setState(() {
        
      });
    }
  }

  @override
  void initState() {
    super.initState();

    final menteeMarker = Marker(
      markerId: MarkerId('1'),
      position: LatLng(widget.y_coordinate, widget.x_coordinate),
      infoWindow: InfoWindow(
        title: "Mentee",
      ),
    );
    _markers.add(menteeMarker);

    getUserCurrentLocation().then((userLocation) {
      final mentorMarker = Marker(
        markerId: MarkerId('2'),
        position: LatLng(userLocation.latitude, userLocation.longitude),
        // position: LatLng(1.2971365,103.7775268),
        infoWindow: InfoWindow(
          title: "Me",
        ),
      );

      setState(() {
        _markers.add(mentorMarker);
      });

      getPolyPoints(userLocation.latitude, userLocation.longitude, widget.y_coordinate, widget.x_coordinate);
    });
  }
 
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Route to ${widget.username}"),
      ),
       body: Container(
        child: SafeArea(
          // on below line creating google maps
          child: GoogleMap(
            // on below line setting camera position
            initialCameraPosition: _kGoogle,
            // on below line we are setting markers on the map
            markers: _markers,
            polylines: {
              Polyline(
                polylineId: PolylineId("route"),
                points: polylineCoordinates,
                color: primaryColor,
                width: 6,
              )
            },
            // on below line specifying map type.
            mapType: MapType.normal,
            // on below line setting user location enabled.
            myLocationEnabled: true,
            // on below line setting compass enabled.
            compassEnabled: true,
            // on below line specifying controller on map complete.
            onMapCreated: (GoogleMapController controller){
                  _controller.complete(controller);
              },
            minMaxZoomPreference: MinMaxZoomPreference(14, 20),
            cameraTargetBounds: CameraTargetBounds(
              LatLngBounds(
                northeast: LatLng(1.30908237, 103.7894576),
                southwest: LatLng(1.2897933,103.7687561),
              ),
            ),
          ),
        ),
      ),
      // on pressing floating action button the camera will take to user current location
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          getUserCurrentLocation().then((value) async {
            debugPrint("${value.latitude.toString()} ${value.longitude.toString()}");
 
            // marker added for current users location
            _markers.add(
                Marker(
                  markerId: const MarkerId("2"),
                  position: LatLng(value.latitude, value.longitude),
                  infoWindow: const InfoWindow(
                    title: 'My Current Location',
                  ),
                )
            );
 
            // specified current users location
            CameraPosition cameraPosition = CameraPosition(
              target: LatLng(value.latitude, value.longitude),
              zoom: 16,
            );
 
            final GoogleMapController controller = await _controller.future;
            controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
            setState(() {
            });
          });
        },
        child: const Icon(Icons.local_activity),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}