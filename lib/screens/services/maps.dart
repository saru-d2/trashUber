// import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:collection';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trash_uber/services/authenticate.dart';
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
  final Authservice _auth = Authservice();
  final Firestore _db = Firestore.instance;

  final Geolocator _geolocator = Geolocator();
  Set<Marker> markers = {};

  GeoPoint _currentPosition;

  _getDocs() async {
    print("inside");
    QuerySnapshot querySnapshot =
        await Firestore.instance.collection("orders").getDocuments();
    print("after");
    var list = querySnapshot.documents;
    print("${list.length} list length");
    // for (int i = 0; i < querySnapshot.documents.length; i++) {
    //   print("$i");
    //   var l = querySnapshot.documents[i].data["geolocation"];
    //   print("$i");
    //   print(
    //       "$i ${querySnapshot.documents[i].documentID} ${l.latitude} ${l.longitude}");
    //   // Start Location Marker
    //   Marker m = Marker(
    //     markerId: MarkerId('$i'),
    //     position: LatLng(
    //       l.latitude,
    //       l.longitude,
    //     ),
    //     infoWindow: InfoWindow(
    //       title: 'Start',
    //       snippet: "$i",
    //     ),
    //     icon: BitmapDescriptor.defaultMarker,
    //   );
    //   markers.add(m);
    // }
  }

  _setCurrentLocation() async {
    print("ATTEMPTING TO SET LOC");
    var user = await _auth.getUser();
    var res = await _db.collection('users').document(user.uid).get();
    _currentPosition = res.data['location'];
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            res.data['location'].latitude,
            res.data['location'].longitude,
          ),
          zoom: 18.0,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _setCurrentLocation();
    _getDocs();
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
              markers: markers != null ? Set<Marker>.from(markers) : null,
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
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipOval(
                      child: Material(
                        color: Colors.blue[100], // button color
                        child: InkWell(
                          splashColor: Colors.blue, // inkwell color
                          child: SizedBox(
                            width: 50,
                            height: 50,
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
                    SizedBox(height: 20),
                    ClipOval(
                      child: Material(
                        color: Colors.blue[100], // button color
                        child: InkWell(
                          splashColor: Colors.blue, // inkwell color
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(Icons.remove),
                          ),
                          onTap: () {
                            mapController.animateCamera(
                              CameraUpdate.zoomOut(),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
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
                                    target: LatLng(
                                      _currentPosition.latitude,
                                      _currentPosition.longitude,
                                    ),
                                    zoom: 18.0,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
