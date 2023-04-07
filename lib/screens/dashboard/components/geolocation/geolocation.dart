import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher_string.dart';

// ignore: camel_case_types
class geolocationpage extends StatefulWidget {
  const geolocationpage({super.key});

  @override
  State<geolocationpage> createState() => _geolocationpageState();
}

// ignore: camel_case_types
class _geolocationpageState extends State<geolocationpage> {
  String locationMessage = 'current location of the pharmacist';
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
          title: const Text('flutter pharmacist location'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(locationMessage, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _getCurrentLocation().then((value) {
                    lat = '${value.latitude}';
                    long = '${value.longitude}';
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
