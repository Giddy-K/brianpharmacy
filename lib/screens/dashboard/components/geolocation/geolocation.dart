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

  //open the current location in the GoogleMap
  Future<void> _openMap(String lat, String long) async {
    String googleURL =
        'https://www.google.com/maps/search/?api=1@query=$lat,$long';
    await canLaunchUrlString(googleURL)
        ? await launchUrlString(googleURL)
        : throw 'could not  launch $googleURL';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Location'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                isThreeLine: true,
                leading: Text(widget.data['profession']),
                title: Text(widget.data['name']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Longitude ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: widget.data['location'].first),
                          const TextSpan(
                            text: 'Latitude ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: widget.data['location'].last),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Text(locationMessage, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _getCurrentLocation().then((value) {
                    // lat = '${value.latitude}';
                    // long = '${value.longitude}';
                    lat = widget.data['location'].last;
                    long = widget.data['location'].first;
                    setState(() {
                      locationMessage = 'Latitude: $lat, Longitude: $long';
                    });
                    _liveLocation();
                  });
                },
                child: const Text('Get current location'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _openMap(lat, long);
                },
                child: const Text('View location'),
              ),
            ],
          ),
        ));
  }
}
