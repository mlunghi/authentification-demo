import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'login_page.dart';

void main() {
  runApp(new MyApp()); //entry point of our application
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(

      title: 'Login Demo',
      theme: new ThemeData (primarySwatch: Colors.green,), home: new LoginPage());

  }

}
