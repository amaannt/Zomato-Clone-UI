import 'package:flutter/material.dart';
import 'package:zomatoui/Utils/StorageUtil.dart';
import 'package:zomatoui/constants/colors.dart';
import 'package:zomatoui/constants/textstyles.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:zomatoui/ui/UIElements.dart';
import 'package:zomatoui/ui/profile/fifth.dart';
import 'package:zomatoui/ui/delivery/first.dart';
import 'package:zomatoui/ui/explore/fourth.dart';
import 'package:zomatoui/ui/dinein/offers_page.dart';
import 'package:zomatoui/ui/OrderFoodCart/CartPayPage.dart';
import 'package:zomatoui/widgets/widgets.dart';

///the table database
import 'package:backendless_sdk/backendless_sdk.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  PageController _pageController;
  UIElements _topBar;
  static List<Widget> _widgetOptions = <Widget>[

    OfferPage(),
    MenuPage(),
    FoodCart(),
    FourthPage(),
    FifthPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      //EVERY TIME USER TAPS THE NAVIGATION BAR, IT CHANGES INDEX AND CHANGED PAGE
      _selectedIndex = index;
      _pageController.jumpToPage(_selectedIndex);
    });
  }


  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    ///loading backendless API
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
    _pageController.dispose();

  }

  _getBottomBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      items: <BottomNavigationBarItem>[

        BottomNavigationBarItem(
          icon: Icon(
            Icons.stars_rounded, color: Colors.redAccent[700], size: 40,),
          title: Text('Offers'),
        ),
        BottomNavigationBarItem(
          icon: Icon(MaterialCommunityIcons.food_fork_drink,
              color: Colors.yellowAccent[700]),

          title: Text('Menu'),
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesome.shopping_bag, color: Colors.blueGrey),
          title: Text('Orders'),
        ),
        BottomNavigationBarItem(
          icon: Icon(SimpleLineIcons.exclamation, color: Colors.pink,),
          title: Text(
            'DELETE \n    Tab',
            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.red),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, color: Colors.lightGreen),
          title: Text('Profile'),
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: AppColors.gold,
      unselectedItemColor: AppColors.primaryTextColorGrey,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      onTap: _onItemTapped,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: _getBottomBar(),
        body: _bodyDesign(),

    );
  }

  _bodyDesign() {
    return    SafeArea(
        child: PageView(
          physics:new NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _selectedIndex = index);
          },

          children:
            _widgetOptions,

        ),
      );

  }
}