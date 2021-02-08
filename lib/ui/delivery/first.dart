import 'package:flutter/material.dart';
import 'package:zomatoui/constants/colors.dart';
import 'package:zomatoui/ui/delivery/food.dart';
import 'package:zomatoui/ui/delivery/FoodTwo.dart';
import 'package:zomatoui/ui/delivery/FoodFour.dart';
import 'package:zomatoui/ui/delivery/FoodThree.dart';
import 'package:zomatoui/ui/delivery/FoodClass.dart';

import 'package:backendless_sdk/backendless_sdk.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> with TickerProviderStateMixin {
  TabController tabController;
  List<String> foodTypes;
  List<FoodClass> foodClassPage;
  int amountOfItems = 0;

  ///the variables for each food class
  List<String> itemNames;
  List<double> itemPrices;
  List<String> itemImage;
  int amountOfItemContents = 0;
  Future<dynamic> _setItemContentOnline;
  Future<List<Widget>> _FoodClassObjects;
  @override
  void initState() {
    super.initState();
    _setItemContentOnline = setItemContentOnline();
    _FoodClassObjects = FoodClassObjects();
  }

  Future<dynamic> setItemContentOnline() async {
    //food classes query
    DataQueryBuilder queryBuilder = DataQueryBuilder()
      ..whereClause = "Section_Active = True";

    print("Starting query ...");

    await Backendless.data
        .of("Food_Item_Classes")
        .find(queryBuilder)
        .then((foodClasses) {
      // every loaded object from the "Contact" table is now an individual Map
      amountOfItems = foodClasses.length;
      foodTypes = new List(amountOfItems);
      foodClassPage = new List(amountOfItems);
      //assigning the values from db
      for (int i = 0; i < foodClasses.length; i++) {
        foodTypes[i] = foodClasses[i]["Item_Name"];
      }

      tabController = new TabController(length: amountOfItems, vsync: this);
    });

    //to add new tab change the length fo the amount of tabs

    return amountOfItems;
  }

  ///return the tabs of the classes
  List<Widget> FoodClasses() {
    List<Tab> tabsFood = new List(amountOfItems);
    for (int index = 0; index < amountOfItems; index++) {
      tabsFood[index] = (new Tab(
          child: Text(
        foodTypes[index],
        style: TextStyle(fontSize: 20, letterSpacing: 2.0),
      )));
    }
    return tabsFood;
  }

  ///load food pages
  Future<List<Widget>> FoodClassObjects() async {
    List<Widget> foodContents = new List(amountOfItems);
    //contents of the page
    for (int contentIndex = 0; contentIndex < amountOfItems; contentIndex++) {
      DataQueryBuilder queryBuilderContent = DataQueryBuilder()
        ..whereClause = "Food_Type = '" + foodTypes[contentIndex] + "'";
      await Backendless.data
          .of("Food_Menu")
          .find(queryBuilderContent)
          .then((foodItems) {
        // every loaded object from the "Contact" table is now an individual Map
        amountOfItemContents = foodItems.length;
        itemNames = new List(amountOfItemContents);
        itemPrices = new List(amountOfItemContents);
        itemImage = new List(amountOfItemContents);
        //assigning the values from db
        for (int i = 0; i < foodItems.length; i++) {
          itemNames[i] = foodItems[i]["Food_Item_Name"];
          itemPrices[i] = foodItems[i]["Food_Price"] * 1.0;
          itemImage[i] = foodItems[i]["Food_Image_URL"];
        }
      });
      foodClassPage[contentIndex] = FoodClass(
        FoodSection_ID: foodTypes[contentIndex],
        amountOfITEMS: amountOfItemContents,
        itemImage: itemImage,
        itemPrices: itemPrices,
        itemNames: itemNames,
      );
    }

    for (int index = 0; index < amountOfItems; index++) {
      foodContents[index] = (foodClassPage[index]);
    }
    return foodContents;
  }

  ///load structure of the tab bar and page
  Widget TabMenu() {
    return Container(
      child: Expanded(
        child: Column(children: <Widget>[
          TabBar(
              controller: tabController,
              indicatorColor: AppColors.whiteColor,
              labelColor: AppColors.errorStateLightRed,
              unselectedLabelColor: Colors.black54,
              isScrollable: true,
              tabs: FoodClasses()),
          FutureBuilder(
              future: FoodClassObjects(),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return Expanded(
                    child: TabBarView(
                        controller: tabController,
                        //if you need to add more tabs
                        children: snapshot.data),
                  );
                }
              })
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _setItemContentOnline,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          } else {
            return TabMenu();
          }
        });
  }
}
