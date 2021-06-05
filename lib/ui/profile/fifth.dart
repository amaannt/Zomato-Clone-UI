import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:zomatoui/Model/ListenerModel.dart';
import 'package:zomatoui/Model/User.dart';
import 'package:zomatoui/Utils/StorageUtil.dart';
import 'package:zomatoui/constants/colors.dart';
import 'package:zomatoui/constants/constants.dart';
import 'package:zomatoui/constants/textstyles.dart';
import 'package:zomatoui/ui/profile/EditAccountDetailsPage.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoggingOut = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    /*if (!User().isLoggedIn) {
      Navigator.of(context).pushNamed(SIGN_IN);
    }
*/
  }

  @override
  Widget build(BuildContext context) {
    if (!User().isLoggedIn) {
      return Container(
          child: Column(
        children: <Widget>[
          Divider(),
          Text("Please Login/Register to continue"),
          Divider(),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(SIGN_IN);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                color: Colors.lightGreen,
                child: Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
              )),
          Divider(),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(SIGN_UP);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                color: Colors.lightBlue,
                child: Text(
                  "Register",
                  style: TextStyle(color: Colors.white),
                ),
              )),
        ],
      ));
    } else {
      var radiusOfButtons = BorderRadius.circular(30.0);
      double elevationOfButtons = 2;
      var colorsOfButtons  =Color.fromRGBO(125, 0, 0, 1);
      return Scaffold(
          backgroundColor: Colors.red[900],
          body: isLoggingOut == true
              ? Container(
                  constraints: BoxConstraints.expand(),
                  child: Center(
                    child: Column(children: <Widget>[
                      SizedBox(
                        height: 200,
                      ),
                      Text("Logging Out"),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          width: 90,
                          child: LinearProgressIndicator(
                            backgroundColor: Colors.red,
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                Colors.red[800]),
                          ))
                    ]),
                  ))
              : SingleChildScrollView(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: AbsorbPointer(
                        absorbing: isLoggingOut,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                User().displayName == null
                                    ? "errorName"
                                    : User().displayName +
                                        " " +
                                        User().lastName,
                                style: TextStyle(
                                    fontSize: 28, color: Colors.white),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    User().email == null
                                        ? "errorEmail"
                                        : "  " + User().email,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'Lato',
                                      fontFamilyFallback: <String>[
                                        'Noto Sans CJK SC',
                                        'Noto Color Emoji',
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              isThreeLine: true,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Divider(),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                                height: 550,
                                padding: EdgeInsets.symmetric(horizontal: 0,vertical:10 ),
                                child: GridView.count(
                                  // Create a grid with 2 columns. If you change the scrollDirection to
                                  // horizontal, this produces 2 rows.
                                  physics: NeverScrollableScrollPhysics(),

                                  crossAxisCount: 3,
                                  // Generate 100 widgets that display their index in the List.
                                  children: <Widget>[
                                    ///EDIT ACCOUNT, ORDERS, PAYMENTS
                                    Card(

                                        shape: RoundedRectangleBorder(
                                          borderRadius: radiusOfButtons,
                                        ),
                                        elevation: elevationOfButtons,
                                        color: colorsOfButtons,
                                        child: TextButton(
                                            onPressed: () async {
                                              ///profile details page
                                              var result = await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          EditAccountDetailsPage()));
                                              if (result == true) {
                                                setState(() {});
                                              }
                                            },
                                            child: Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    5, 24, 0, 6),
                                                child: Column(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.account_box,
                                                      color:
                                                          AppColors.whiteColor,
                                                      size: 40,
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Text(
                                                      'Edit Account',
                                                      style: TextStyle(
                                                        color: AppColors
                                                            .whiteColor,
                                                      ),
                                                    ),
                                                  ],
                                                )))),
                                    ///Your Orders Button
                                    Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: radiusOfButtons,
                                        ),
                                        elevation: elevationOfButtons,
                                        color: colorsOfButtons,
                                        child: Container(
                                            padding: EdgeInsets.fromLTRB(
                                                5, 30, 5, 10),
                                            child: Column(
                                              children: <Widget>[
                                                Icon(
                                                  Feather.shopping_bag,
                                                  color: AppColors.whiteColor,
                                                  size: 40,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  'Your Orders',
                                                  style: TextStyle(
                                                    color: AppColors.whiteColor,
                                                  ),
                                                )
                                              ],
                                            ))),
                                    ///Payments Button
                                    Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: radiusOfButtons,
                                        ),
                                        elevation: elevationOfButtons,
                                        color: colorsOfButtons,
                                        child: Container(
                                            padding: EdgeInsets.fromLTRB(
                                                5, 30, 5, 10),
                                            child: Column(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.payment,
                                                  color: AppColors.whiteColor,
                                                  size: 40,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  'Payments',
                                                  style: TextStyle(
                                                    color: AppColors.whiteColor,
                                                  ),
                                                )
                                              ],
                                            ))),


                                    ///REPORT SAFETY, SEND FEEDBACK, ABOUT
                                    Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: radiusOfButtons,
                                        ),
                                        elevation: elevationOfButtons,
                                        color: colorsOfButtons,
                                        child: Container(
                                            padding: EdgeInsets.fromLTRB(
                                                5, 30, 5, 10),
                                            child: Column(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.report_problem_outlined,
                                                  color: AppColors.whiteColor,
                                                  size: 40,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  'Report Issue',
                                                  style: TextStyle(
                                                    color: AppColors.whiteColor,
                                                  ),
                                                )
                                              ],
                                            ))),
                                    ///Feedback Button
                                    Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: radiusOfButtons,
                                        ),
                                        elevation: elevationOfButtons,
                                        color: colorsOfButtons,
                                        child: Container(
                                            padding: EdgeInsets.fromLTRB(
                                                5, 30, 5, 10),
                                            child: Column(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.message,
                                                  color: AppColors.whiteColor,
                                                  size: 40,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  'Feedback',
                                                  style: TextStyle(
                                                    color: AppColors.whiteColor,
                                                  ),
                                                )
                                              ],
                                            ))),
                                    ///About Button
                                    Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: radiusOfButtons,
                                        ),
                                        elevation: elevationOfButtons,
                                        color: colorsOfButtons,
                                        child: Container(
                                            padding: EdgeInsets.fromLTRB(
                                                5, 30, 5, 10),
                                            child: Column(
                                              children: <Widget>[
                                                Icon(Feather.info,
                                                    color:
                                                        AppColors.whiteColor,
                                                  size: 40,),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  'About Us',
                                                  style: TextStyle(
                                                    color: AppColors.whiteColor,
                                                  ),
                                                )
                                              ],
                                            ))),

                                    ///Rate us, Logout, Settings
                                    Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: radiusOfButtons,
                                        ),
                                        elevation: elevationOfButtons,
                                        color: colorsOfButtons,
                                        child: Container(
                                            padding: EdgeInsets.fromLTRB(
                                                5, 30, 5, 10),
                                            child: Column(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.rate_review_rounded,
                                                  color: AppColors.whiteColor,
                                                  size: 40,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  'Rate Us',
                                                  style: TextStyle(
                                                    color: AppColors.whiteColor,
                                                  ),
                                                )
                                              ],
                                            ))),
                                    ///Logout Button
                                    Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: radiusOfButtons,

                                        ),
                                        elevation: elevationOfButtons,
                                        color: colorsOfButtons,
                                        child: TextButton(
                                            onPressed: () async {
                                              StorageUtil.putBool(
                                                  'isLoggedIn', false);
                                              setState(() {
                                                isLoggingOut = true;
                                              });
                                              await User().logoutProcess();
                                              setState(() {
                                                isLoggingOut = false;
                                              });
                                              //log out procedure
                                            },
                                            child: Container(
                                            padding: EdgeInsets.fromLTRB(
                                                5, 30, 5, 10),
                                            child: Column(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.logout,
                                                    color: AppColors.whiteColor,
                                                    size: 40,
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    'Log Out',
                                                    style: TextStyle(
                                                      color:
                                                          AppColors.whiteColor,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ))),
                                    ///Settings Button
                                    Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: radiusOfButtons,
                                        ),
                                        elevation: elevationOfButtons,
                                        color: colorsOfButtons,
                                        child: Container(
                                            padding: EdgeInsets.fromLTRB(
                                                5, 30, 5, 10),
                                            child: Column(
                                              children: <Widget>[
                                                Icon(Feather.settings,
                                                    color:
                                                        AppColors.whiteColor,
                                                  size: 40,),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  'Settings',
                                                  style: TextStyle(
                                                    color: AppColors.whiteColor,
                                                  ),
                                                )
                                              ],
                                            ))),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ));
    }
  }
}
