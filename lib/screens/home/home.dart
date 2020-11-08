import 'package:flutter/material.dart';
import 'package:trash_uber/screens/services/sport.dart';
// import 'package:trash_uber/screens/services/washingMachine.dart';
import 'package:trash_uber/services/authenticate.dart';
import 'package:trash_uber/shared/dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trash_uber/shared/loading.dart';
import 'package:trash_uber/models/option.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Firestore _db = Firestore.instance;
  final Authservice _auth = Authservice();
  final Geolocator _geolocator = Geolocator();
  var user;
  Position _currentPosition;

  _getCurrentLocation() async {
    print("ATTEMPTING TO ACCESS LOC");
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
        print('CURRENT POS: $_currentPosition');
        _db.collection('users').document(user.uid).setData({
          'location':
              GeoPoint(_currentPosition.latitude, _currentPosition.longitude),
        }, merge: true);
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void initState() {
    super.initState();
    print("inside initstate");
    getuid();
    _getCurrentLocation();
  }

  void getuid() async {
    var temp = await _auth.getUser();
    setState(() {
      user = temp;
    });
    print("user");
  }

  bool loading = true;
  List<String> favs = [];

  Widget favCard(text) {
    return Card(
      margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
      color: Colors.deepPurple[50],
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            text,
            style: TextStyle(fontSize: 28),
            textAlign: TextAlign.center,
          ),
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return identifier[text];
          }));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _getFavsList();
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
                title: Text("Home"),
                backgroundColor: Colors.red,
                elevation: 0.2,
                actions: <Widget>[
                  FlatButton.icon(
                      icon: Icon(Icons.person),
                      onPressed: () async {
                        await _auth.signout();
                      },
                      label: Text('logout'))
                ]),
            drawer: MainDrawer(),
            body: Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: favs.map((text) => favCard(text)).toList())),
          );
  }

  Future _getFavsList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('favlist') == false) {
      favs = [];
    } else {
      favs = prefs.getStringList('favlist');
    }
    setState(() {
      loading = false;
    });
  }
}
