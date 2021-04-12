import 'dart:async';

import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zomatoui/Model/ListenerModel.dart';
import 'package:zomatoui/Utils/BackendlessUtil.dart';
import 'package:zomatoui/ui/home.dart';
import 'package:zomatoui/ui/profile/fifth.dart';
import 'package:zomatoui/ui/signin.dart';
import 'package:zomatoui/ui/signup.dart';
import 'package:zomatoui/ui/splashscreen.dart';

//saving first open
import 'package:zomatoui/Utils/StorageUtil.dart';

import 'Model/User.dart';
import 'constants/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageUtil.getInstance();
  runApp(MyApp());

  //backendless initialization
  await BackendlessUtil().initializeBackend();

  ///Check user logged in status and apply storage data
  if (StorageUtil.getBool('isLoggedIn')) User().getUserDataLocal();

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
    return ChangeNotifierProvider(
      create: (context) => ListenOrderModel(),
      child: MaterialApp(
        title: 'PaliBaba',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: <String, WidgetBuilder>{
          SPLASH_SCREEN: (BuildContext context) => SplashScreen(),
          SIGN_IN: (BuildContext context) => SignInPage(),
          SIGN_UP: (BuildContext context) => SignUpScreen(),
          HOME: (BuildContext context) => HomePage(),
          PROFILE: (BuildContext context) => ProfilePage(),
        },
        initialRoute: HOME,
        /*
        home: ChangeNotifierProvider(
          create: (context) => ListenOrderModel(),
          child: HomePage(),
        ),*/
      ),
    );
  }
}
