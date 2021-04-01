import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:zomatoui/Model/ListenerModel.dart';
import 'package:zomatoui/Model/User.dart';
import 'package:zomatoui/constants/colors.dart';
import 'package:zomatoui/constants/constants.dart';
import 'package:zomatoui/constants/textstyles.dart';
import 'package:zomatoui/ui/profile/EditAccountDetailsPage.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
                padding: EdgeInsets.symmetric(vertical:4, horizontal: 10),
                color: Colors.lightGreen,

                child: Text("Login", style: TextStyle(color: Colors.white),),
              )),
          Divider(),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(SIGN_UP);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical:4, horizontal: 10),
                color: Colors.lightBlue,

                child: Text("Register", style: TextStyle(color: Colors.white),),
              )),
        ],
      ));
    } else {
      return SingleChildScrollView(
        child: Container(
          color: AppColors.whiteColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  title: Text(
                    User().displayName==null?"errorName":User().displayName,
                    style: TextStyles.pageHeading,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(User().email==null?"errorEmail":User().email),
                      Row(
                        children: <Widget>[
                          TextButton(
                            onPressed: () {
                              ///profile details page
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>EditAccountDetailsPage()));
                            },
                            child: Text(
                              'Edit Account Details',
                              style: TextStyle(
                                color: AppColors.highlighterPink,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_right,
                            color: AppColors.highlighterPink,
                          )
                        ],
                      ),
                    ],
                  ),
                  isThreeLine: true,
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Icon(
                          Feather.shopping_bag,
                          color: AppColors.blackColor,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text('Your Orders')
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Icon(Icons.payment),
                        SizedBox(
                          height: 5,
                        ),
                        Text('Payments')
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Icon(Feather.settings),
                        SizedBox(
                          height: 5,
                        ),
                        Text('Settings')
                      ],
                    ),
                  ],
                ),
                Divider(),
                Text(
                  'Food Orders',
                  style: TextStyles.actionTitleBlack,
                ),
                ListTile(
                  leading: Icon(
                    Feather.shopping_bag,
                    color: AppColors.blackColor,
                  ),
                  title: Text(
                    'Your Orders',
                    style: TextStyles.highlighterTwo,
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
                Divider(),
                ListTile(
                  title: Text(
                    'Send Feedback',
                    style: TextStyles.highlighterTwo,
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
                ListTile(
                  title: Text(
                    'Report a Safety Emergency',
                    style: TextStyles.highlighterTwo,
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
                ListTile(
                  title: Text(
                    'Rate us on the Play Store',
                    style: TextStyles.highlighterTwo,
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
                ListTile(
                  title: Text(
                    'About',
                    style: TextStyles.highlighterTwo,
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
                TextButton(onPressed: () async {

                  await Backendless.userService.logout().then((response) {
                    // user has been logged out.
                   // ListenOrderModel().deleteListener();
                    User().isLoggedIn = false;
                    setState(() {

                    });
                  });

                  //log out procedures

                }, child:  ListTile(
                  title: Text(
                    'Log Out',
                    style: TextStyles.highlighterTwo,
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),)

              ],
            ),
          ),
        ),
      );
    }
  }
}
