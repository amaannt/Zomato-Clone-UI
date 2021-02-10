import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zomatoui/ui/home.dart';

//saving first open
import 'package:zomatoui/Utils/StorageUtil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageUtil.getInstance();
  runApp(MyApp());

  ///loading sharedprefsaddStringToSF();

  Timer(Duration(seconds: 1), () {
    isFirstTime().then((isFirstTime) {
      StorageUtil.putBool('FirstOpen', isFirstTime);

    });
  }
  );

}

Future<bool> isFirstTime() async {
  var isFirstTime = StorageUtil.getBool('FirstOpen');
  print("Opened for the first time : " + isFirstTime.toString());
  if (isFirstTime != null && !isFirstTime) {
    StorageUtil.putBool('FirstOpen', false);
    return false;
  } else {
    return true;
  }
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PaliBaba',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}
