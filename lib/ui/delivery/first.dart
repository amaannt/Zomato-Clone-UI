import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zomatoui/constants/colors.dart';
import 'package:zomatoui/ui/delivery/food.dart';
import 'package:zomatoui/ui/delivery/FoodTwo.dart';
import 'package:zomatoui/ui/delivery/FoodFour.dart';
import 'package:zomatoui/ui/delivery/FoodThree.dart';
import 'package:zomatoui/ui/delivery/FoodClass.dart';

import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:zomatoui/Utils/StorageUtil.dart';
//encoding the json
import 'dart:convert';

import '../../Utils/StorageUtil.dart';

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
  Future<List<Widget>> myFuture;
  Future<List<Widget>> _FoodClassObjects;

  @override
  void initState() {
    super.initState();
    myFuture = FoodClassObjects();
    appJustOpened = StorageUtil.getBool('RefreshState');
  }

  var Jsonfoodclass;
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
    //save classes json
    Jsonfoodclass = json.encode(foodTypes);
    StorageUtil.putString("FoodClasses", Jsonfoodclass);

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

  //Json Encoders
  var JsonItemName, JsonFoodType, JsonAmount, JsonImage, JsonPrices;

  String userID = "amaan2";
  bool appJustOpened;
  List<Widget> foodContents;

  ///load food pages
  Future<List<Widget>> FoodClassObjects() async {
    print("initializing the page again : " + appJustOpened.toString());
    if (appJustOpened) {
      StorageUtil.putBool("RefreshState", false);
      foodContents = new List(amountOfItems);
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

        ///SAVE TO STORAGE SECTION
        //name save on storage
        JsonItemName = json.encode(itemNames);
        StorageUtil.putString(foodTypes[contentIndex] + "_Name", JsonItemName);
        //price save on storage
        JsonPrices = json.encode(itemPrices);
        StorageUtil.putString(foodTypes[contentIndex] + "_Prices", JsonPrices);
        //image url save on storage
        JsonImage = json.encode(itemImage);
        StorageUtil.putString(foodTypes[contentIndex] + "_IMGURL", JsonImage);
        //amount of items
        StorageUtil.putInt(
            foodTypes[contentIndex] + "_amount", amountOfItemContents);

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
    } else {
      print("The food contents again:");
      foodClassPage = new List(foodTypes.length);

      foodContents = new List(foodTypes.length);
      /*print(foodTypes.length);

      foodTypes = json.decode(StorageUtil.getString('FoodClasses'));
      print(foodTypes.length);*/

      /*  var str = StorageUtil.getString('ItemName');
      var r = json.decode(str);
      print(r);*/

      for (int index = 0; index < foodTypes.length; index++) {
        amountOfItemContents = StorageUtil.getInt(foodTypes[index] + "_amount");
        itemNames = new List(amountOfItemContents);
        itemPrices = new List(amountOfItemContents);
        itemImage = new List(amountOfItemContents);

        itemImage =
            convertToList(foodTypes[index], "_IMGURL", itemImage.length);

        itemNames = convertToList(foodTypes[index], "_Name", itemNames.length);

        itemPrices =
            convertToList(foodTypes[index], "_Prices", itemPrices.length);

        foodClassPage[index] = new FoodClass(
          FoodSection_ID: foodTypes[index],
          amountOfITEMS: amountOfItemContents,
          itemImage: itemImage,
          itemPrices: itemPrices,
          itemNames: itemNames,
        );
      }
      DataQueryBuilder queryBuilderContent2 = DataQueryBuilder()
        ..whereClause = "UserID = '" + userID + "'";
      await Backendless.data
          .of("ChangesCheck")
          .find(queryBuilderContent2)
          .then((changes) {
        print(
            "Changes Available from the server: " + changes[0]["ChangesDone"]);
        StorageUtil.putBool("RefreshState", changes[0]["ChangesDone"]);
      });

      for (int index = 0; index < amountOfItems; index++) {
        foodContents[index] = (foodClassPage[index]);
      }

      return foodContents;
    }
  }

  convertToList(String firstPartOfString, String SecondIdentifier, int len) {
    List<String> second = new List(len);
    var imgs = json
        .decode(StorageUtil.getString(firstPartOfString + SecondIdentifier));
    for (int x = 0; x < len; x++) {
      second[x] = imgs[x].toString();
      print(second[x]);
    }
    return second;
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
                  try {
                    return Expanded(
                      child: TabBarView(
                          controller: tabController,
                          //if you need to add more tabs
                          children: snapshot.data),
                    );
                  } catch (e) {
                    print(e);
                    return Center(child: CircularProgressIndicator());
                  }
                }
              })
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: setItemContentOnline(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          } else {
            return TabMenu();
          }
        });
  }
}
