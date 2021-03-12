import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zomatoui/Model/ListenerModel.dart';
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
  });
}

Future<bool> isFirstTime() async {
  var isFirstTime = StorageUtil.getBool('FirstOpen');

  ///empty cart
  StorageUtil.putString("Cart_ItemName", "");
  StorageUtil.putString("Cart_ItemPrice", "");
  StorageUtil.putString("Cart_ItemID", "");
  StorageUtil.putString("Cart_ItemImage", "");
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
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ChangeNotifierProvider(
        create: (context) => ListenOrderModel(),
        child: HomePage(),
      ),
    );
  }
}
