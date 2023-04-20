import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

// ignore: camel_case_types
class geolocationpage extends StatefulWidget {
  final Map<String, dynamic> data;
  const geolocationpage({super.key, required this.data});

  @override
  State<geolocationpage> createState() => _geolocationpageState();
}

// ignore: camel_case_types
class _geolocationpageState extends State<geolocationpage> {
  String locationMessage = 'current location';
  late String lat;
  late String long;

  //Getting current location
  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('location services are disabled');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'location permission are permanently denied, we cannot request permission to access the location');
    }
    return await Geolocator.getCurrentPosition();
  }

  //listen to location updates
  void _liveLocation() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      lat = position.latitude.toString();
      long = position.longitude.toString();

      setState(() {
        locationMessage = 'latitude: $lat , longitude: $long';
      });
    });
  }

  // //open the current location in the GoogleMap
  // Future<void> _openMap(String lat, String long) async {
  //   String googleURL =
  //       'https://www.google.com/maps/search/?api=1@query=$lat,$long';
  //   await canLaunchUrlString(googleURL)
  //       ? await launchUrlString(googleURL)
  //       : throw 'could not  launch $googleURL';
  // }
  

//open the current location and destination location in the GoogleMap with a route
  Future<void> _openMap(String lat, String long) async {
    Position currentPosition = await _getCurrentLocation();
    String sourceLat = currentPosition.latitude.toString();
    String sourceLong = currentPosition.longitude.toString();

    LatLng sourceLatLng =
        LatLng(currentPosition.latitude, currentPosition.longitude);
    LatLng destinationLatLng = LatLng(double.parse(lat), double.parse(long));

    String googleURL =
        'https://www.google.com/maps/dir/?api=1&origin=$sourceLat,$sourceLong&destination=$lat,$long';
    await canLaunchUrlString(googleURL)
        ? await launchUrlString(googleURL)
        : throw 'could not  launch $googleURL';

    setState(() {
      _markers.clear();
      _markers.add(Marker(
        markerId: const MarkerId('source'),
        position: sourceLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: const InfoWindow(title: 'Your Location'),
      ));
      _markers.add(Marker(
        markerId: const MarkerId('destination'),
        position: destinationLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(title: widget.data['name']),
      ));
      _polylines.clear();
      _addPolyline(sourceLatLng, destinationLatLng);
    });
  }

  GoogleMapController? _controller;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  void _addPolyline(LatLng source, LatLng destination) {
    _polylines.add(Polyline(
      polylineId: const PolylineId('route'),
      visible: true,
      points: [source, destination],
      width: 4,
      color: Colors.blue,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
    ));
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        GoogleMap(
          onMapCreated: _onMapCreated,
          markers: _markers,
          polylines: _polylines,
          initialCameraPosition: const CameraPosition(
            target: LatLng(0, 0),
            zoom: 14.4746,
          ),
          myLocationEnabled: true,
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _getCurrentLocation().then((value) {
            lat = widget.data['location'].first;
            long = widget.data['location'].last;
            setState(() {
              locationMessage = 'Latitude: $lat, Longitude: $long';
            });
            _liveLocation();
            _openMap(lat, long);
          });
        },
        child: const Icon(Icons.map),
      ),
    );
  }
}
