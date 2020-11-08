// import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:collection';
import 'dart:async';
import 'package:geolocator/geolocator.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// class Maps extends StatefulWidget {
//   Maps({Key key}) : super(key: key);

//   @override
//   _MapsState createState() => _MapsState();
// }

// class _MapsState extends State<MapView> {
//   @override
//   Widget build(BuildContext context) {
//     CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
//     GoogleMapController mapController;

//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//     return Container(
//       height: height,
//       width: width,
//       child: Scaffold(
//         body: Stack(
//           children: <Widget>[
//             GoogleMap(
//               initialCameraPosition: _initialLocation,
//               myLocationEnabled: true,
//               myLocationButtonEnabled: false,
//               mapType: MapType.normal,
//               zoomGesturesEnabled: true,
//               zoomControlsEnabled: false,
//               onMapCreated: (GoogleMapController controller) {
//                 mapController = controller;
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  GoogleMapController mapController;
  final Geolocator _geolocator = Geolocator();
  Position _currentPosition;

  _getCurrentLocation() async {
    print("ATTEMPTING TO ACCESS LOC");
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
        print('CURRENT POS: $_currentPosition');
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18.0,
            ),
          ),
        );
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    // Determining the screen width & height
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      height: height,
      width: width,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            GoogleMap(
              initialCameraPosition: _initialLocation,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
            ),
            ClipOval(
              child: Material(
                color: Colors.orange[100],
                child: InkWell(
                  splashColor: Colors.orange,
                  child: SizedBox(
                    width: 56,
                    height: 56,
                    child: Icon(Icons.add),
                  ),
                  onTap: () {
                    mapController.animateCamera(
                      CameraUpdate.zoomIn(),
                    );
                  },
                ),
              ),
            ),
            ClipOval(
              child: Material(
                color: Colors.orange[100], // button color
                child: InkWell(
                  splashColor: Colors.orange, // inkwell color
                  child: SizedBox(
                    width: 56,
                    height: 56,
                    child: Icon(Icons.zoom_out_map),
                  ),
                  onTap: () {
                    mapController.animateCamera(
                      CameraUpdate.zoomOut(),
                    );
                  },
                ),
              ),
            ),
            ClipOval(
              child: Material(
                color: Colors.orange[100], // button color
                child: InkWell(
                  splashColor: Colors.orange, // inkwell color
                  child: SizedBox(
                    width: 56,
                    height: 56,
                    child: Icon(Icons.my_location),
                  ),
                  onTap: () {
                    mapController.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: LatLng(100.0, -100.0
                              // _currentPosition.latitude,
                              // _currentPosition.longitude,
                              ),
                          zoom: 18.0,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
