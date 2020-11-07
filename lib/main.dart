import 'package:flutter/material.dart';
import 'package:trash_uber/models/user.dart';
import 'package:trash_uber/screens/wrapper.dart';
import 'package:trash_uber/services/authenticate.dart';
import 'package:provider/provider.dart';

void main() => runApp(Myapp());

class Myapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: Authservice().user,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
