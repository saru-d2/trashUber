import 'package:flutter/material.dart';
import 'package:trash_uber/screens/services/displayOrders.dart';
import 'package:trash_uber/screens/services/orderForm.dart';
import 'package:trash_uber/screens/services/maps.dart';
import 'package:trash_uber/screens/services/wash.dart';
import 'package:trash_uber/screens/services/profile.dart';
import 'package:trash_uber/screens/settings/settings.dart';
import 'package:trash_uber/screens/services/displayOrdersToDeliver.dart';
import 'package:trash_uber/services/authenticate.dart';

class MainDrawer extends StatelessWidget {
  final Authservice _auth = Authservice();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.pink),
            accountName: Text("User"),
            accountEmail: FutureBuilder<String>(
              future: _auth.getCurrentUserEmail(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data);
                } else {
                  return Text("...");
                }
              },
            ),
            currentAccountPicture: GestureDetector(
              child: CircleAvatar(
                child: Text(
                  "AM",
                  style: TextStyle(
                      color: Colors.pink,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
                backgroundColor: Colors.white,
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: ListTile(
              leading: Icon(
                Icons.my_location,
                color: Colors.black,
              ),
              title: Text("Maps"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MapView()));
              },
            ),
          ),
          InkWell(
            onTap: () {},
            child: ListTile(
              leading: Icon(
                Icons.money,
                color: Colors.black,
              ),
              title: Text("New Order"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return new FormScreen();
                }));
              },
            ),
          ),
          InkWell(
            onTap: () {},
            child: ListTile(
              leading: Icon(
                Icons.person,
                color: Colors.black,
              ),
              title: Text("Profile"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return new Profile();
                }));
              },
            ),
          ),
          InkWell(
            onTap: () {},
            child: ListTile(
              leading: Icon(
                Icons.settings_display,
                color: Colors.black,
              ),
              title: Text("Display Orders"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return new DisplayOrders();
                }));
              },
            ),
          ),
          InkWell(
            onTap: () {},
            child: ListTile(
              leading: Icon(
                Icons.personal_video,
                color: Colors.black,
              ),
              title: Text("Your Delivery"),
              onTap: () async {
                final user = await _auth.getUser();
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return new DisplayAccepted(type: "ordered", uid: user.uid);
                }));
              },
            ),
          ),
          /*
          ListTile(
            
          ListTile(
            contentPadding: EdgeInsets.all(20.0),
            title: Text(
              'Profile',
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return new Profile();
              }));
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.all(0.0),
            title: Text(
              'Display Orders',
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return new DisplayOrders();
              }));
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.all(0.0),
            title: Text(
              'your delivery',
              style: TextStyle(fontSize: 20),
            ),
            onTap: () async {
              final user = await _auth.getUser();
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return new DisplayAccepted(type: "ordered", uid: user.uid);
              }));
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.all(0.0),
            title: Text(
              'you accepted',
              style: TextStyle(fontSize: 20),
            ),
            onTap: () async {
              final user = await _auth.getUser();
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return new DisplayAccepted(type: "accepted", uid: user.uid);
              }));
            },
          ),
          Spacer(),
          ListTile(
            contentPadding: EdgeInsets.all(20.0),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Settings', style: TextStyle(fontSize: 20)),
                Icon(
                  Icons.settings,
                  size: 30,
                ),
              ],
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return new SettingsScreen();
              }));
            },
          ),
          */
        ],
        // ),
      ),
    );
  }
}
