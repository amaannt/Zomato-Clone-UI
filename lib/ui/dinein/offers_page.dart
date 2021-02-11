import 'package:flutter/material.dart';
import 'package:zomatoui/constants/colors.dart';
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
  @override
  void initState() {
    super.initState();
    //tabController = new TabController(length: 2, vsync: this);
    ///controlling the fade in effect
    TabAnimcontroller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    animationFade = Tween(begin: 0.2, end: 1.0).animate(TabAnimcontroller);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TabAnimcontroller.forward();
   return Expanded(
          child:   FadeTransition(
     opacity: animationFade,
     child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Lockdown Specials',
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            ClipRRect(
                                borderRadius: BorderRadius.circular(4.0),
                                child: Image.network(
                                  'https://cdn.pixabay.com/photo/2015/12/08/00/26/food-1081707__480.jpg',
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                )),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text('Burger')
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            ClipRRect(
                                borderRadius: BorderRadius.circular(4.0),
                                child: Image.network(
                                  'https://cdn.pixabay.com/photo/2017/12/09/08/18/pizza-3007395__480.jpg',
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                )),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text('Pizza')
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            ClipRRect(
                                borderRadius: BorderRadius.circular(4.0),
                                child: Image.network(
                                  'https://cdn.pixabay.com/photo/2018/08/16/23/06/ice-3611722_1280.jpg',
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                )),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text('Sundae')
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            ClipRRect(
                                borderRadius: BorderRadius.circular(4.0),
                                child: Image.network(
                                  'https://www.eastcoastdaily.in/wp-content/uploads/2018/05/veg-paratha-1.png',
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                )),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text('Paratha')
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ])),
        );
  }
}
