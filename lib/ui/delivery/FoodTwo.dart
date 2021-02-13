import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:zomatoui/constants/colors.dart';
import 'package:zomatoui/constants/textstyles.dart';
import 'package:zomatoui/widgets/rating.dart';

import 'package:zomatoui/ui/delivery/ItemPopup.dart';

class FoodTwoTab extends StatefulWidget {
  @override
  _FoodTwoTabState createState() => _FoodTwoTabState();
}

class _FoodTwoTabState extends State<FoodTwoTab> {
  @override
  double rating = 3.5;
  double heightItem = 195;
  int amountOfItems = 32;
  int numOfColumns = 2;
  Widget build(BuildContext context) {
    print(((amountOfItems / numOfColumns) * heightItem * 1.0));
    return ListView(
      padding: const EdgeInsets.all(3),
      children: <Widget>[
        //filters
        Container(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  Container(
                    child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: AppColors.separatorGrey,
                            ),
                            borderRadius: BorderRadius.circular(5)),
                        color: AppColors.whiteColor,
                        child: Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    FontAwesome.filter,
                                    size: 18,
                                    color: AppColors.primaryTextColorGrey,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Filters',
                                    style: TextStyles.highlighterOne,
                                  )
                                ],
                              ),
                            ],
                          ),
                        )),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: AppColors.separatorGrey,
                            ),
                            borderRadius: BorderRadius.circular(5)),
                        color: AppColors.whiteColor,
                        child: Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Rating:',
                                    style: TextStyles.highlighterOne,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    '4.0+',
                                    style: TextStyles.highlighterOne,
                                  )
                                ],
                              ),
                            ],
                          ),
                        )),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: AppColors.separatorGrey,
                            ),
                            borderRadius: BorderRadius.circular(5)),
                        color: AppColors.whiteColor,
                        child: Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Safe and Hygenic',
                                style: TextStyles.highlighterOne,
                              )
                            ],
                          ),
                        )),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: AppColors.separatorGrey,
                            ),
                            borderRadius: BorderRadius.circular(5)),
                        color: AppColors.whiteColor,
                        child: Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Fastest Delivery',
                                style: TextStyles.highlighterOne,
                              )
                            ],
                          ),
                        )),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: AppColors.separatorGrey,
                            ),
                            borderRadius: BorderRadius.circular(5)),
                        color: AppColors.whiteColor,
                        child: Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Rating',
                                    style: TextStyles.highlighterOne,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    size: 18,
                                    color: AppColors.primaryTextColorGrey,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: AppColors.separatorGrey,
                            ),
                            borderRadius: BorderRadius.circular(5)),
                        color: AppColors.whiteColor,
                        child: Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Cost',
                                    style: TextStyles.highlighterOne,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    size: 18,
                                    color: AppColors.primaryTextColorGrey,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),

        //menu

        Container(
          // height should be : amount of dishes/number of columns * item height of 195 * 1.0 double datatype
          height: ((amountOfItems / numOfColumns) * heightItem * 1.0),
          child: GridView.count(
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: numOfColumns,
            children: List.generate(amountOfItems, (index) {
              return InkWell(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: AppColors.separatorGrey,
                          ),
                          borderRadius: BorderRadius.circular(5)),
                      color: AppColors.whiteColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: Container(
                              constraints: new BoxConstraints.expand(
                                  height: 174.0, width: 520),
                              alignment: Alignment.bottomLeft,
                              padding: new EdgeInsets.only(
                                  left: 16.0, bottom: 8.0, top: 8.0),
                              decoration: new BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: new DecorationImage(
                                  image: new NetworkImage(
                                      'https://www.cultivarguestlodge.com/media/filter/xl/account/55555555-5555-5555-5555-555555555555/img/activity_braai_events_1.jpg'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  /*Row(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 5, right: 10, top: 5, bottom: 5),
                                      decoration: BoxDecoration(
                                          color: AppColors.persianColor,
                                          borderRadius: BorderRadius.circular(5.0)),
                                      child: new Text('Well sanized kitchen',
                                          style: new TextStyle(
                                              fontSize: 12.0,
                                              color: AppColors.whiteColor)),
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),

                                  ],
                                ),*/
                                  //pricing or name////
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 5, right: 10, top: 5, bottom: 5),
                                    decoration: BoxDecoration(
                                        color: AppColors.highlighterBlueDark,
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    child: new Text('Dish Name',
                                        style: new TextStyle(
                                            fontSize: 12.0,
                                            color: AppColors.whiteColor)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                   // ItemPopupTab("itemID2").PopupItem(context);
                  });
            }),
          ),
        ),
      ],
    );
  }
}
