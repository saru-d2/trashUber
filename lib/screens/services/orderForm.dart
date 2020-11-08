import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trash_uber/services/authenticate.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

class FormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final Authservice _auth = Authservice();

  String _items;
  String _address;
  String _payment;
  String _place = '';
  String _weight = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildItems() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Waste type"),
      validator: (val) => val.isEmpty ? 'enter Items' : null,
      onSaved: (String value) {
        _items = value;
      },
    );
  }
  Widget _buildWeight() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Waste weight"),
      validator: (val) => val.isEmpty ? 'enter Weight' : null,
      onSaved: (String value) {
        _weight = value;
      },
    );
  }


  Widget _buildAddress() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Address"),
      validator: (val) => val.isEmpty ? 'enter Address' : null,
      onSaved: (String value) {
        _address = value;
      },
    );
  }

  Widget _buildPayment() {
    return DropDownFormField(
      titleText : "Type of Payment",
      hintText : "Type of Payment",
      value : _payment,
      onSaved: (value) {
        setState(() {
          _payment = value;
        });
      },
      onChanged: (value) {
        setState(() {
          _payment = value;
        });
      },
      dataSource: [
        {
          'display' : "Free",
          'value' : "Free"
        },
        {
          'display' : "Paid",
          'value' : "Paid"
        }
      ],
      textField: 'display',
      valueField: 'value',

    );
  }
  Widget _buildplace(){
    return DropDownFormField(
      titleText : "Type of waste",
      hintText : "Type of waste",
      value : _place,
      onSaved: (value) {
        setState(() {
          _place = value;
        });
      },
      onChanged: (value) {
        setState(() {
          _place = value;
        });
      },
      dataSource: [
        {
          'display' : "Wet waste",
          'value' : "Wet waste"
        },
        {
          'display' : "Recyclable Waste",
          'value' : "Recyclable Waste"
        }
      ],
      textField: 'display',
      valueField: 'value',

    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.deepOrange[100],
        appBar: AppBar(
          title: Text("Form"),
          backgroundColor: Colors.deepOrange[400],
        ),
        body: Container(
          margin: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildItems(),
                _buildWeight(),
                _buildAddress(),
                _buildPayment(),
                SizedBox(height:20),
                _buildplace(),
                SizedBox(height: 120),
                RaisedButton(
                    color: Colors.deepOrange[400],
                    child: Text('Sell!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        )),
                    onPressed: () async {
                      print("hey!");
                      if (!_formKey.currentState.validate()) {
                        return;
                      }
                      _formKey.currentState.save();
                      final user = await _auth.getUser();
//                      var user = await _auth.getUser();
                      var res = await Firestore.instance.collection('users').document(user.uid).get();
                      var currentPosition = res.data['location'];
                      Firestore.instance
                          .collection('orders')
                          .document()
                          .setData({
                        'items': _items,
                        'address': _address,
                        'mode_of_payment': _payment,
                        'User_id': user.uid,
                        'place' : _place,
                        'accepted' : false,
                        'geolocation' : currentPosition,
                        'weight' : _weight,
                      });
                      _formKey.currentState.reset();   //to reset the form after each submission
                    //   alert to tell the user the order has been placed
                    showDialog(
                        context: context,
                        builder: (BuildContext context){
                            return AlertDialog(
                              content: Text("We have made buyers of waste aware of your waste."),
                            );
                        }
                      );
                    })
              ],
            ),
          ),
        ));
  }
}
