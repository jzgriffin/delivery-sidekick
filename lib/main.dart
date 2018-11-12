import 'package:delivery_sidekick/page/splash_page.dart';
import 'package:flutter/material.dart';

/// Entry point for the application
void main() => runApp(MyApp());

/// Top-level application widget
class MyApp extends StatelessWidget {
  /// Describes the part of the user interface represented by this widget
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Delivery Sidekick',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashPage(),
      );
}
