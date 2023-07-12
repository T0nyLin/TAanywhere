import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:ta_anywhere/components/place.dart';
import 'package:ta_anywhere/widget/displaymap.dart';

class PickLocation extends StatefulWidget {
  const PickLocation({
    super.key,
    required this.onSelectLocation,
  });

  final void Function(PlaceLocation location) onSelectLocation;

  @override
  State<PickLocation> createState() => _PickLocationState();
}

class _PickLocationState extends State<PickLocation> {
  PlaceLocation? _pickedLocation;
  var _isGettingLocation = false;
  Location location = Location();

  String get locationImage {
    if (_pickedLocation == null) {
      return '';
    }
    final lat = _pickedLocation!.latitude;
    final lng = _pickedLocation!.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=AIzaSyC7EFshsiUoJdt-lItecOX5Wpm4mGo2dCo';
  }

  Future<void> _savePlace(double latitude, double longitude) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=AIzaSyC7EFshsiUoJdt-lItecOX5Wpm4mGo2dCo');
    final response = await http.get(url);
    final resData = json.decode(response.body);
    final address = resData['results'][0]['formatted_address'];

    setState(() {
      _pickedLocation = PlaceLocation(
        latitude: latitude,
        longitude: longitude,
        address: address,
      );
      _isGettingLocation = false;
    });

    widget.onSelectLocation(_pickedLocation!);
  }

  @override
  void initState() {
    super.initState();
    requestLocation();
  }

  void requestLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  void _getCurrentLocation() async {
    LocationData locationData;

    setState(() {
      _isGettingLocation = true;
    });

    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lng = locationData.longitude;

    if (lat == null || lng == null) {
      return;
    }

    if (LatLngBounds(
      northeast: LatLng(1.30908237, 103.7894576),
      southwest: LatLng(1.2897933, 103.7687561),
    ).contains(LatLng(lat, lng))) {
      _savePlace(lat, lng);
    } else {
      setState(() {
        previewContent = Text(
          'Error: You are out of range.\nPlease meet within NUS campus.',
          style: TextStyle(fontSize: 13, color: Colors.black),
        );
        _isGettingLocation = false;
      });
    }
  }

  void _selectOnMap() async {
    final pickedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (ctx) => const DisplayMap(),
      ),
    );

    if (pickedLocation == null) {
      return;
    }

    _savePlace(pickedLocation.latitude, pickedLocation.longitude);
  }

  Widget previewContent = Text(
    'No Location chosen',
    textAlign: TextAlign.center,
    style: TextStyle(fontSize: 13, color: Colors.black),
  );
  @override
  Widget build(BuildContext context) {
    if (_pickedLocation != null) {
      previewContent = Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator(
        color: Color.fromARGB(255, 48, 97, 104),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Location'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Colors.black,
                ),
              ),
              child: previewContent,
            ),
            if (_pickedLocation != null) Text(_pickedLocation!.address),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.location_on),
                  label: const Text('Get Current Location'),
                  onPressed: _getCurrentLocation,
                ),
                TextButton.icon(
                  icon: const Icon(Icons.map),
                  label: const Text('Select on Map'),
                  onPressed: _selectOnMap,
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.save_rounded),
              label: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
