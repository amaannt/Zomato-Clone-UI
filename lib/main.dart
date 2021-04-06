import 'dart:async';

import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zomatoui/Model/ListenerModel.dart';
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

  ///loading sharedprefsaddStringToSF();
  ///loading user information
   // User user = new User();
   // ListenOrderModel ls = new ListenOrderModel();
  //userLoginCheck(user);
  Backendless.setUrl("https://eu-api.backendless.com");

  Backendless.initApp(
      "FD3F0D07-3EE0-28F8-FF83-2B1BF0CCB200",
      "D232A1BF-AD99-4943-A507-209F37031F68",
      "11A5D221-5F27-4926-97F4-5D4EB9B01F33");

  Timer(Duration(seconds: 1), () {
    isFirstTime().then((isFirstTime) {
      StorageUtil.putBool('FirstOpen', isFirstTime);
    });
  });
}

userLoginCheck(User user) async{
  Backendless.userService.getUserToken().then((userToken) {
    if (userToken != null && userToken.isNotEmpty) {
      // user login is available, skip the login activity/login form
      print("user was logged in ");
      user.isLoggedIn = true;
    }else
      {
        user.isLoggedIn = false;
        print("user was not logged in ");
      }
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
          SPLASH_SCREEN: (BuildContext context) =>  SplashScreen(),
          SIGN_IN: (BuildContext context) =>  SignInPage(),
          SIGN_UP: (BuildContext context) =>  SignUpScreen(),
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
