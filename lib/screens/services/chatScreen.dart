import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trash_uber/services/authenticate.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

class chatScreen extends StatefulWidget {
  chatScreen({Key key, this.chat_id, this.user_id, this.type}) : super(key: key);
  String chat_id;
  String user_id;
  String type;
  // widget.type should give 'accepted' or 'ordered' depending on whether we want chats where the person ordered stuff or accepted orders
  @override
  _chatScreenState createState() => _chatScreenState();
}

class _chatScreenState extends State<chatScreen> {
  String _message = '';
  var listMessage;
  final ScrollController listScrollController = ScrollController();
  final themeColor = Color(0xfff5a623);
  final primaryColor = Color(0xff203152);
  final greyColor = Color(0xffaeaeae);
  final greyColor2 = Color(0xffE8E8E8);
  final TextEditingController textEditingController =
  new TextEditingController();

  final List<String> _dropdownValues = [
    "Cancel Order",
    "Order Has Been Received"
  ];
  final List<String> _dropdownValues2 = [
    "Cancel Order",
  ];//The list of values we want on the dropdown
  String _currentlySelected = ""; //var to hold currently selected value
  //make the drop down its own widget for readability
  Widget dropdownWidget() {
    if(widget.type == "ordered"){
      return DropdownButton(
        hint: Text('Change Order Status'),
        //map each value from the lIst to our dropdownMenuItem widget
        items: _dropdownValues
            .map((value) => DropdownMenuItem(
          child: Text(value),
          value: value,
          onTap: () async {
            Firestore.instance.collection("chats").document(widget.chat_id).collection("messages").getDocuments().then((snapshot) {
              for (DocumentSnapshot ds in snapshot.documents){
                ds.reference.delete();
              };
            });
            Firestore.instance.collection("chats").document(widget.chat_id).delete();
            Firestore.instance.collection("accepted_orders").document(widget.chat_id).delete();
//            if(value == "Cancel Order"){
//              Firestore.instance.collection("orders").document(widget.chat_id).updateData({
//                "accepted" : false,
//              });
//            }
//            else{
              Firestore.instance.collection("orders").document(widget.chat_id).delete();
//            }
          },
        ))
            .toList(),
        onChanged: (String value) {
          //once dropdown changes, update the state of out currentValue
          setState(() {
            _currentlySelected = value;
          });
        },
        //this wont make dropdown expanded and fill the horizontal space
        isExpanded: false,
        //make default value of dropdown the first value of our list
        //value: _dropdownValues.first,
      );
    }
    else{
      return DropdownButton(
        hint: Text('Change Order Status'),
        //map each value from the lIst to our dropdownMenuItem widget
        items: _dropdownValues2
            .map((value) => DropdownMenuItem(
          child: Text(value),
          value: value,
          onTap: () async {

            Firestore.instance.collection("chats").document(widget.chat_id).collection("messages").getDocuments().then((snapshot) {
              for (DocumentSnapshot ds in snapshot.documents){
                ds.reference.delete();
              };
            });
            Firestore.instance.collection("chats").document(widget.chat_id).delete();
            Firestore.instance.collection("accepted_orders").document(widget.chat_id).delete();
            Firestore.instance.collection("orders").document(widget.chat_id).updateData({
              "accepted" : false,
            });

          },
        ))
            .toList(),
        onChanged: (String value) {
          //once dropdown changes, update the state of out currentValue
          setState(() {
            _currentlySelected = value;
          });
        },
        //this wont make dropdown expanded and fill the horizontal space
        isExpanded: false,
        //make default value of dropdown the first value of our list
        //value: _dropdownValues.first,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(title: Text("chat"), actions: <Widget>[
              dropdownWidget(),
            ]), // Custom app bar for chat screen
            body: Stack(children: <Widget>[
              Column(
                children: <Widget>[
                  Flexible(
                      child: StreamBuilder(
                          stream: Firestore.instance
                              .collection("chats")
                              .document(widget.chat_id)
                              .collection("messages")
                              .orderBy('time', descending: true)
                              .snapshots(),
                          builder: (context, snapshots) {
                            if (snapshots.hasData) {
                              return ListView.builder(
                                itemCount:
                                snapshots.data.documents.toList().length,
                                itemBuilder: (context, index) {
                                  List<DocumentSnapshot> orderList =
                                  snapshots.data.documents.toList();
                                  DocumentSnapshot documentSnapshot =
                                  orderList.elementAt(index);
                                  if (widget.user_id ==
                                      documentSnapshot["user"]) {
                                    return Container(
                                      child: Column(children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              child: Text(
                                                documentSnapshot["message"],
                                                style: TextStyle(
                                                    color: themeColor),
                                              ),
                                              padding: EdgeInsets.fromLTRB(
                                                  15.0, 10.0, 15.0, 10.0),
                                              width: 200.0,
                                              decoration: BoxDecoration(
                                                  color: primaryColor,
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      8.0)),
                                              margin:
                                              EdgeInsets.only(right: 10.0),
                                            )
                                          ],
                                          mainAxisAlignment: MainAxisAlignment
                                              .end, // aligns the chatitem to right end
                                        ),
                                      ]),
                                      margin: EdgeInsets.only(bottom: 10.0),
                                    );
                                  } else {
                                    return Container(
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                child: Text(
                                                  documentSnapshot["message"],
                                                  style: TextStyle(
                                                      color: themeColor),
                                                ),
                                                padding: EdgeInsets.fromLTRB(
                                                    15.0, 10.0, 15.0, 10.0),
                                                width: 200.0,
                                                decoration: BoxDecoration(
                                                    color: primaryColor,
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        8.0)),
                                                margin:
                                                EdgeInsets.only(left: 10.0),
                                              )
                                            ],
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                          ),
                                        ],
//                                            crossAxisAlignment: CrossAxisAlignment.start,
                                      ),
                                      margin: EdgeInsets.only(bottom: 10.0),
                                    );
                                  }
                                },
                                reverse: true,
                                controller: listScrollController,
                              );
                            } else {
                              return Align(
                                alignment: FractionalOffset.bottomCenter,
                                child: CircularProgressIndicator(),
                              );
                            }
                          })), //Chat list
                  Container(
                    child: Row(
                      children: <Widget>[
                        Material(
                          child: new Container(
                            margin: new EdgeInsets.symmetric(horizontal: 1.0),
                            child: new IconButton(
                              icon: new Icon(Icons.face),
                              color: primaryColor,
                            ),
                          ),
                          color: Colors.white,
                        ),

                        // Text input
                        Flexible(
                          child: Container(
                            child: TextField(
                              style: TextStyle(
                                  color: Colors.black, fontSize: 15.0),
                              controller: textEditingController,
                              decoration: InputDecoration.collapsed(
                                hintText: 'Type a message',
                                hintStyle: TextStyle(color: greyColor),
                              ),
                            ),
                          ),
                        ),

                        // Send Message Button
                        Material(
                          child: new Container(
                            margin: new EdgeInsets.symmetric(horizontal: 8.0),
                            child: new IconButton(
                              icon: new Icon(Icons.send),
                              onPressed: () async {
                                if (textEditingController.text.length > 0) {
                                  var now = new DateTime.now();
                                  Firestore.instance
                                      .collection("chats")
                                      .document(widget.chat_id)
                                      .collection("messages")
                                      .document()
                                      .setData({
                                    "message": textEditingController.text,
                                    "time": now,
                                    "user": widget.user_id,
                                  });
                                  textEditingController.clear();
                                  print("okay");
                                }
                              },
                              color: primaryColor,
                            ),
                          ),
                          color: Colors.white,
                        ),
                      ],
                    ),
                    width: double.infinity,
                    height: 50.0,
                    decoration: new BoxDecoration(
                        border: new Border(
                            top: new BorderSide(color: greyColor, width: 0.5)),
                        color: Colors.white),
                  ) // The input widget
                ],
              ),
            ])));
  }
}

