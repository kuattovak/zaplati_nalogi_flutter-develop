import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qpay/screens/LoginScreen.dart';
import 'package:qpay/screens/RegisterScreen.dart';
import 'package:qpay/screens/WelcomePageScreen.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(
   MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Q-Pay',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:WelcomePageScreen(),
    );
  }
}

