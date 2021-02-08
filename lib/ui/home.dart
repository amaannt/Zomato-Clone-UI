import 'package:flutter/material.dart';
import 'package:zomatoui/constants/colors.dart';
import 'package:zomatoui/constants/textstyles.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:zomatoui/ui/profile/fifth.dart';
import 'package:zomatoui/ui/delivery/first.dart';
import 'package:zomatoui/ui/explore/fourth.dart';
import 'package:zomatoui/ui/dinein/second.dart';
import 'package:zomatoui/ui/gold/third.dart';
import 'package:zomatoui/widgets/widgets.dart';

import 'package:backendless_sdk/backendless_sdk.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    OfferPage(),
    MenuPage(),
    ThirdPage(),
    FourthPage(),
    FifthPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  void initState() {
    super.initState();

    // uncomment the line below if your application is hosted in the European hosting zone of Backendless:
    Backendless.setUrl("https://eu-api.backendless.com");

    Backendless.initApp(
        "4CCACF64-55A7-6B67-FFC3-44558A179500",
        "BB87A32F-17D7-4C50-A9E8-4D5AFA66D881",
        "154EC8F4-6B07-43BD-BE2A-9E0C59DEDB18");

  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.whiteColor,
        items:  <BottomNavigationBarItem>[

          BottomNavigationBarItem(
            icon: Icon(Icons.stars_rounded),
            title: Text('Offers'),
          ),
          BottomNavigationBarItem(
            icon: Icon(MaterialCommunityIcons.food_fork_drink),
            title: Text('Menu'),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesome.shopping_bag),
            title: Text('Orders'),
          ),
          BottomNavigationBarItem(
            icon: Icon(SimpleLineIcons.exclamation,color: Colors.pink,),
            title: Text(
                'DELETE \n    Tab',
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.red),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.blackColor,
        unselectedItemColor: AppColors.primaryTextColorGrey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
      body: SafeArea(
        child: _selectedIndex!=1?Container(child:_widgetOptions.elementAt(_selectedIndex),) :Container(
          color: AppColors.whiteColor,
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15.0, right: 10),
                      child: Icon(
                        SimpleLineIcons.location_pin,
                        size: 35,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Home',
                            textAlign: TextAlign.left,
                            style: TextStyles.actionTitle,
                          ),
                          Text(
                            'MG Road Bangalore',
                            textAlign: TextAlign.left,
                            style: TextStyles.subText,
                          ),
                          Divider(
                            color: AppColors.blackColor,
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(),
                  ),
                  Expanded(
                    flex: 1,
                    child: Icon(
                      Icons.payment,
                      color: AppColors.blackColor,
                      size: 25,
                    ),
                  ),
                ],
              ),
              SearchBar('Search for Item'),
              _widgetOptions.elementAt(_selectedIndex),

            ],
          ),
        ),
      ),
    );
  }
}
