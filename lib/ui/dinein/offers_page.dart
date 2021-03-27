import 'dart:convert';

import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:web_socket_channel/io.dart';
import 'package:zomatoui/Utils/StorageUtil.dart';
import 'package:zomatoui/constants/colors.dart';
import 'package:zomatoui/ui/OrderFoodCart/CartPayPage.dart';
import 'package:zomatoui/ui/dinein/dining.dart';
import 'package:zomatoui/ui/dinein/nightlife.dart';
import 'package:zomatoui/constants/textstyles.dart';


class OfferPage extends StatefulWidget {
  @override
  _OfferPageState createState() => _OfferPageState();
}

class _OfferPageState extends State<OfferPage> with TickerProviderStateMixin {
  TabController tabController;
  //animation fade in controller
  AnimationController TabAnimcontroller;
  Animation animationFade;
  Widget _appBarBuilder;

  connectionAchieve()async{


  }
  _getUserApi()  {

  }
  @override
  void initState() {
    super.initState();
    //tabController = new TabController(length: 2, vsync: this);
    ///controlling the fade in effect
    TabAnimcontroller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    animationFade = Tween(begin: 0.2, end: 1.0).animate(TabAnimcontroller);
    _appBarBuilder = appBarBuilder();
  }

  @override
  void dispose() {
    super.dispose();
    //TabAnimcontroller.dispose();
  }

  appBarBuilder() {
    return PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false, // hides leading widget
          title: Row(
            children: [
              Text(
                "Pali Baba",
                style: TextStyle(color: Colors.black),
              ),
              Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FoodCart()),
                  );
                },
                child: Icon(
                  FontAwesome.shopping_basket,
                  size: 25,
                  color: AppColors.primaryTextColorGrey,
                ),
              )
            ],
          ),
        ));
  }

   test() {
    int x= 0;
    /*while(StorageUtil.getString("ActiveOrder_" + x.toString()) != null &&StorageUtil.getString("ActiveOrder_" + x.toString()) != ""){

        print(StorageUtil.getString("ActiveOrderStatus_3"));
        x++;
      }*/
     print(StorageUtil.getKeyPrefs());
    }


  @override
  Widget build(BuildContext context) {
    TabAnimcontroller.forward();
    return Scaffold(
      appBar: _appBarBuilder,
      body: FadeTransition(
          opacity: animationFade,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    //test();
                  },
                  child: Container(child: Text("Save API MONEEEYYYSSSSS")),
                ),
                Container(
                    child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Special Offers',
                        style: TextStyles.h1Heading,
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        'Most Ordered Dishes',
                        style: TextStyles.subText,
                      ),
                    ],
                  ),
                )),
                // most ordered area food items
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            ClipRRect(
                                borderRadius: BorderRadius.circular(4.0),
                                child: Image.network(
                                  'https://cdn.pixabay.com/photo/2015/12/08/00/59/ice-cream-1082237_1280.jpg',
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                )),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text('Ice Cream')
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            ClipRRect(
                                borderRadius: BorderRadius.circular(4.0),
                                child: Image.network(
                                  'https://cdn.pixabay.com/photo/2015/08/11/10/34/camel-meat-883772_1280.jpg',
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                )),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text('Biryani')
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            ClipRRect(
                                borderRadius: BorderRadius.circular(4.0),
                                child: Image.network(
                                  'https://cdn.pixabay.com/photo/2016/08/30/18/45/grilled-1631727_1280.jpg',
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                )),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text('Chicken')
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            ClipRRect(
                                borderRadius: BorderRadius.circular(4.0),
                                child: Image.network(
                                  'https://cdn.pixabay.com/photo/2015/11/23/11/54/chocolate-smoothie-1058191_1280.jpg',
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                )),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text('Shake')
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                    child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("Promotional Offers",style: TextStyles.actionTitleBlack,),
                )),
                Container(
                  height: 150.0,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            ClipRRect(
                                borderRadius: BorderRadius.circular(4.0),
                                child: Image.network(
                                  'https://cdn.pixabay.com/photo/2015/12/08/00/26/food-1081707__480.jpg',
                                  height: 100,
                                  width: 140,
                                  fit: BoxFit.cover,
                                )),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text('Burger')
                          ],
                        ),
                        Container(
                          width: 10,
                        ),
                        Column(
                          children: <Widget>[
                            ClipRRect(
                                borderRadius: BorderRadius.circular(4.0),
                                child: Image.network(
                                  'https://cdn.pixabay.com/photo/2017/12/09/08/18/pizza-3007395__480.jpg',
                                  height: 100,
                                  width: 140,
                                  fit: BoxFit.cover,
                                )),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text('Pizza')
                          ],
                        ),
                        Container(
                          width: 10,
                        ),
                        Column(
                          children: <Widget>[
                            ClipRRect(
                                borderRadius: BorderRadius.circular(4.0),
                                child: Image.network(
                                  'https://cdn.pixabay.com/photo/2018/08/16/23/06/ice-3611722_1280.jpg',
                                  height: 100,
                                  width: 140,
                                  fit: BoxFit.cover,
                                )),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text('Sundae')
                          ],
                        ),
                        Container(
                          width: 10,
                        ),
                        Column(
                          children: <Widget>[
                            ClipRRect(
                                borderRadius: BorderRadius.circular(4.0),
                                child: Image.network(
                                  'https://www.eastcoastdaily.in/wp-content/uploads/2018/05/veg-paratha-1.png',
                                  height: 100,
                                  width: 140,
                                  fit: BoxFit.cover,
                                )),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text('Paratha')
                          ],
                        ),
                        Container(
                          width: 10,
                        ),
                        Column(
                          children: <Widget>[
                            ClipRRect(
                                borderRadius: BorderRadius.circular(4.0),
                                child: Image.network(
                                  'https://www.eastcoastdaily.in/wp-content/uploads/2018/05/veg-paratha-1.png',
                                  height: 100,
                                  width: 140,
                                  fit: BoxFit.cover,
                                )),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text('Paratha')
                          ],
                        ),
                        Container(
                          width: 10,
                        ),
                        Column(
                          children: <Widget>[
                            ClipRRect(
                                borderRadius: BorderRadius.circular(4.0),
                                child: Image.network(
                                  'https://www.eastcoastdaily.in/wp-content/uploads/2018/05/veg-paratha-1.png',
                                  height: 100,
                                  width: 140,
                                  fit: BoxFit.cover,
                                )),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text('Paratha')
                          ],
                        ),
                        Container(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ),
            Container(child:  _getUserApi(),),
              ])),
    );
  }
}
