import 'package:flutter/material.dart';
import 'package:trash_uber/models/user.dart';
import 'package:trash_uber/screens/auth/auth.dart';
import 'package:trash_uber/screens/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    print(user);

    if (user == null) {
      return Auth();
    } else {
      return Home();
    }
  }
}
