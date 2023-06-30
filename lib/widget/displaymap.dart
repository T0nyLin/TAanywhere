import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:ta_anywhere/components/place.dart';

class DisplayMap extends StatefulWidget {
  const DisplayMap({
    super.key,
    this.location = const PlaceLocation(
      //wont need "required" if picking the location for the first time
      latitude: 1.2971365,
      longitude: 103.7775268,
      address: '',
    ),
    this.isSelecting = true,
  });

  final PlaceLocation location;
  final bool isSelecting;

  @override
  State<DisplayMap> createState() => _DisplayMapState();
}

class _DisplayMapState extends State<DisplayMap> {
  LatLng? _pickedLocation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isSelecting ? 'Pick your Location' : 'Your Location'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              onPressed: () {
                Navigator.of(context).pop(_pickedLocation);
              },
              icon: const Icon(Icons.save),
            ),
        ],
      ),
      body: GoogleMap(
        onTap: !widget.isSelecting
            ? null
            : (position) {
                setState(() {
                  _pickedLocation = position;
                });
              },
        myLocationEnabled: true,
        compassEnabled: true,
        initialCameraPosition: CameraPosition(
            target: LatLng(
              widget.location.latitude,
              widget.location.longitude,
            ),
            zoom: 16),
        markers: (_pickedLocation == null && widget.isSelecting)
            ? {}
            : {
                //create a set of markers
                Marker(
                  markerId: const MarkerId('m1'),
                  position: _pickedLocation ??
                      LatLng(
                        widget.location.latitude,
                        widget.location.longitude,
                      ),
                ),
              },
        minMaxZoomPreference: MinMaxZoomPreference(14, 20),
        cameraTargetBounds: CameraTargetBounds(
          LatLngBounds(
          northeast: LatLng(1.29208237, 103.7844576),
          southwest: LatLng(1.2917933,103.7787561),
          ),
        ),
      ),
    );
  }
}
