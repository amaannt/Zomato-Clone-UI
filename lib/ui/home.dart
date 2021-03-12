import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zomatoui/Model/ListenerModel.dart';
import 'package:zomatoui/Utils/StorageUtil.dart';
import 'package:zomatoui/constants/colors.dart';
import 'package:zomatoui/constants/textstyles.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:zomatoui/ui/OrderFoodCart/OrderPage.dart';
import 'package:zomatoui/ui/UIElements.dart';
import 'package:zomatoui/ui/profile/fifth.dart';
import 'package:zomatoui/ui/MenuDesign/first.dart';
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
    OrderPageTab(),
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
        "FD3F0D07-3EE0-28F8-FF83-2B1BF0CCB200",
        "D232A1BF-AD99-4943-A507-209F37031F68",
        "11A5D221-5F27-4926-97F4-5D4EB9B01F33");

    ///Start the listening service for orders
    ListenOrderModel().createListen("User123");
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
          icon: Image.asset("assets/icons/Offers.png",width: 60,),
          activeIcon: Image.asset("assets/icons/OffersActive - Copy.png", width: 62), title: Container(),
        ),
        BottomNavigationBarItem(
          icon: Image.asset("assets/icons/Menu.png",width: 50,),
          activeIcon: Image.asset("assets/icons/MenuActive - Copy.png", width: 45), title: Container(),
        ),
        BottomNavigationBarItem(
          icon: Image.asset("assets/icons/Orders.png",width: 50,),
          activeIcon: Image.asset("assets/icons/OrdersActive - Copy.png", width: 55), title: Container(),

        ),
     /*   BottomNavigationBarItem(
          icon: Icon(SimpleLineIcons.exclamation, color: Colors.pink,),
          title: Text(
            'DELETE \n    Tab',
            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.red),
          ),
        ),*/
        BottomNavigationBarItem(
          icon: Image.asset("assets/icons/Profile.png",width: 50,),
          activeIcon: Image.asset("assets/icons/ProfileActive - Copy.png", width: 45,color: Colors.deepOrange[500]), title: Container(),
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