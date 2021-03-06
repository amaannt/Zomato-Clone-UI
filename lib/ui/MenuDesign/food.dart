/*import 'dart:html';*/
/*
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:zomatoui/constants/colors.dart';
import 'package:zomatoui/constants/textstyles.dart';
import 'package:zomatoui/ui/delivery/ItemPopup.dart';
import 'package:backendless_sdk/backendless_sdk.dart';

import 'package:flutter_beautiful_popup/main.dart';

class FoodTabIndian extends StatefulWidget {
  @override
  _FoodTabIndianState createState() => _FoodTabIndianState();
}

class _FoodTabIndianState extends State<FoodTabIndian> {
  double rating = 3.5;
  double heightItem = 195;
  int amountOfItems = 0;
  int numOfColumns = 2;
  List<String> itemNames;
  List<double> itemPrices;
  List<String> itemImage;
  @override
  void initState() {
    super.initState();



  }

  double heightList = 0;
  EventHandler<Map> rtEventHandler = Backendless.data.of("Food_Menu").rt();


  //this function gets the food item data for the "Indian tab"
  Future<dynamic> LoadItemList() async {

    DataQueryBuilder queryBuilder = DataQueryBuilder()
      ..whereClause = "Food_Type = 'Indian'";
    await Backendless.data.of("Food_Menu").find(queryBuilder).then((foodItems) {
      // every loaded object from the "Contact" table is now an individual Map
      amountOfItems = foodItems.length;
      itemNames = new List(amountOfItems);
      itemPrices = new List(amountOfItems);
      itemImage = new List(amountOfItems);
      //assigning the values from db
      for (int i = 0; i < foodItems.length; i++) {
        itemNames[i] = foodItems[i]["Food_Item_Name"];
        itemPrices[i] = foodItems[i]["Food_Price"] * 1.0;
        itemImage[i] = foodItems[i]["Food_Image_URL"];
      }
      int listHeight = foodItems.length;
      if (listHeight % 2 == 1) {
        listHeight += 1;
      }

      heightList = (listHeight / numOfColumns) * heightItem * 1.0;
    });
    //catch odd number of items and modify height as per number of items
    return heightList;
  }

//this is each food item Container, can be edited for visual
  MakeItemList(AsyncSnapshot snapshot) {
    return Container(
      // height should be : amount of dishes/number of columns * item height of 195 * 1.0 double datatype
      height: snapshot.data,
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: numOfColumns,
        children: List.generate(amountOfItems, (index) {
          *//*  if (posts == null) {
                            return circularProgress();
                          }*//*
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
                              image: new NetworkImage(itemImage[index]),
                              fit: BoxFit.fill,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 5, right: 10, top: 5, bottom: 5),
                                    decoration: BoxDecoration(
                                        color: AppColors.persianColor,
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    child: new Text(itemNames[index],
                                        style: new TextStyle(
                                            fontSize: 12.0,
                                            color: AppColors.whiteColor)),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                ],
                              ),
                              //pricing or name////
                              Container(
                                padding: EdgeInsets.only(
                                    left: 5, right: 10, top: 5, bottom: 5),
                                decoration: BoxDecoration(
                                    color: AppColors.highlighterBlueDark,
                                    borderRadius: BorderRadius.circular(5.0)),
                                child: new Text(
                                    itemPrices[index].toString() + " €",
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
                ItemPopupTab(itemNames[index],itemDescription[index]).PopupItem(context);
              });
        }),
      ),
    );
  }*/
/*

  List<Map> foodItems;
  @override
  Widget build(BuildContext context) {
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

        //grid menu which will be made
        FutureBuilder(
            future: LoadItemList(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Center(child: CircularProgressIndicator());
              } else {
                try {
                  return MakeItemList(snapshot);
                } catch (e) {
                  return CircularProgressIndicator();
                }
              }
            }),
      ],
    );
  }
}
*/
