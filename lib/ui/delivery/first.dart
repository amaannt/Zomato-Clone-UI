import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zomatoui/constants/colors.dart';
import 'package:zomatoui/ui/UIElements.dart';
import 'package:zomatoui/ui/delivery/food.dart';
import 'package:zomatoui/ui/delivery/FoodTwo.dart';
import 'package:zomatoui/ui/delivery/FoodFour.dart';
import 'package:zomatoui/ui/delivery/FoodThree.dart';
import 'package:zomatoui/ui/delivery/FoodClass.dart';

///Backendless database backend
import 'package:backendless_sdk/backendless_sdk.dart';
//encoding the json
import 'dart:convert';

///storage class to cache items
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
  List<String> itemID;
  List<String> itemPrices;
  List<String> itemImage;
  List<String> itemDescription;
  int amountOfItemContents = 0;
  Future<List<Widget>> myFuture;

  //Json Encoders
  var JsonItemName, JsonFoodType, JsonAmount, JsonImage, JsonPrices, JsonDesc, JsonID;

  //remove id from here
  String userID = "amaan2";

  ///App refresh state and food contents to load
  bool appJustOpened;
  List<Widget> foodContents;

  ///Access UI elements from UI ELEMENTS class
  UIElements _topBar;

  ///fade effects controller
  AnimationController TabAnimcontroller;
  Animation animationFade;
  @override
  void initState() {
    super.initState();

    ///This is the UIElements Class widget area
    _topBar = new UIElements();

    ///animation tab fade controller
    TabAnimcontroller = AnimationController(
        duration: Duration(seconds: 1, milliseconds: 200), vsync: this);
    animationFade = Tween(begin: 0.0, end: 1.2).animate(TabAnimcontroller);

    ///check if app has been opened for the first time
    StorageUtil.getBool('FirstOpen')
        ? appJustOpened = true
        : appJustOpened = false;
    print("App opened for the first time: " + appJustOpened.toString());

    ///the use of first time opened comes to an end here for now
    StorageUtil.putBool("FirstOpen", false);

    ///if app has already passed the first time opened ,
    ///it doesn't need to re evaluate and change the value of 'appJustOpened' to negative
    if (!appJustOpened) {
      //check for any refresh needed
      CheckServerChanges();
    }
    print("Server says that this is : " + appJustOpened.toString());
  }

  Future<bool> CheckServerChanges() async {
    ///build a query to find any changes in server data so user doesn't take too long to load the menu
    DataQueryBuilder queryBuilderContent2 = DataQueryBuilder()
      ..whereClause = "UserID = '" + userID + "'";
    await Backendless.data
        .of("ChangesCheck")
        .find(queryBuilderContent2)
        .then((changes) {
      ///change this variable to the bool value online to perform necessary refreshes and changes from server
      appJustOpened = changes[0]["ChangesDone"];
      if (appJustOpened) {
        // update a property in the object
        Map sendConfirm = changes[0];
        sendConfirm['ChangesDone'] = false;

// now save the updated object
        Backendless.data
            .of("ChangesCheck")
            .save(sendConfirm)
            .then((updatedOrder) {
          print(
              "Order Object has been updated in the database - ${updatedOrder['objectId']}");
        });
        setState(() {});
      }
    });
  }

  var Jsonfoodclass;
  Future<dynamic> setItemContentOnline() async {
    ///Query food classes
    DataQueryBuilder queryBuilder = DataQueryBuilder()
      ..whereClause = "Section_Active = True";

    print("Sending query ...");

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

  int setItemContentCache() {
    var type = json.decode(StorageUtil.getString('FoodClasses'));
    foodTypes = new List(type.length);
    amountOfItems = type.length;
    for (int indexType = 0; indexType < type.length; indexType++) {
      foodTypes[indexType] = type[indexType].toString();
    }
    //initialize with length again
    tabController = new TabController(length: amountOfItems, vsync: this);
    return amountOfItems;
  }

  ///return the tabs of the classes
  List<Widget> FoodClasses() {
    List<Tab> tabsFood = new List(amountOfItems);
    for (int index = 0; index < amountOfItems; index++) {
      TabAnimcontroller.forward();
      tabsFood[index] = (new Tab(
          child: FadeTransition(
        opacity: animationFade,
        child: Text(
          foodTypes[index],
          style: TextStyle(fontSize: 20, letterSpacing: 2.0),
        ),
      )));
    }
    return tabsFood;
  }

  ///load food pages
  Future<List<Widget>> FoodClassObjectsFromServer() async {
    print("initializing the page again : " + appJustOpened.toString());

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
        itemID = new List(amountOfItemContents);
        itemPrices = new List(amountOfItemContents);
        itemImage = new List(amountOfItemContents);
        itemDescription = new List(amountOfItemContents);
        //assigning the values from db
        for (int i = 0; i < foodItems.length; i++) {
          itemNames[i] = foodItems[i]["Food_Item_Name"];
          itemID[i] = foodItems[i]["objectId"];
          itemPrices[i] = foodItems[i]["Food_Price"].toString();
          itemImage[i] = foodItems[i]["Food_Image_URL"];
          itemDescription[i] = foodItems[i]["Food_Description"];
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
      //save Description on storage
      JsonDesc = json.encode(itemDescription);
      StorageUtil.putString(foodTypes[contentIndex] + "_Description", JsonDesc);
      //save ID on storage
      JsonID = json.encode(itemID);
      StorageUtil.putString(foodTypes[contentIndex] + "_ID", JsonID);
      //amount of items
      StorageUtil.putInt(
          foodTypes[contentIndex] + "_amount", amountOfItemContents);

      foodClassPage[contentIndex] = FoodClass(
        foodSectionName: foodTypes[contentIndex],
        amountOfITEMS: amountOfItemContents,
        itemImage: itemImage,
        itemPrices: itemPrices,
        itemNames: itemNames,
        itemID: itemID,
        itemDescription: itemDescription,
      );
    }

    for (int index = 0; index < amountOfItems; index++) {
      foodContents[index] = (foodClassPage[index]);
    }

    return foodContents;
  }

  FoodClassObjectsFromStorage() {
    //re initialize
    foodClassPage = new List(foodTypes.length);

    foodContents = new List(foodTypes.length);

    for (int index = 0; index < foodTypes.length; index++) {
      amountOfItemContents = StorageUtil.getInt(foodTypes[index] + "_amount");
      itemNames = new List(amountOfItemContents);
      itemID = new List(amountOfItemContents);
      itemPrices = new List(amountOfItemContents);
      itemImage = new List(amountOfItemContents);
      itemDescription = new List(amountOfItemContents);
      itemImage = convertToList(foodTypes[index], "_IMGURL", itemImage.length);

      itemNames = convertToList(foodTypes[index], "_Name", itemNames.length);

      itemID = convertToList(foodTypes[index], "_ID", itemID.length);

      itemPrices =
          convertToList(foodTypes[index], "_Prices", itemPrices.length);

      itemDescription = convertToList(
          foodTypes[index], "_Description", itemDescription.length);

      foodClassPage[index] = new FoodClass(
        foodSectionName: foodTypes[index],
        amountOfITEMS: amountOfItemContents,
        itemImage: itemImage,
        itemPrices: itemPrices,
        itemID: itemID,
        itemNames: itemNames,
        itemDescription: itemDescription,
      );
    }

    for (int index = 0; index < amountOfItems; index++) {
      foodContents[index] = (foodClassPage[index]);
    }

    return foodContents;
  }

  ///convert string from the storage to list
  ///this is working
  convertToList(String firstPartOfString, String SecondIdentifier, int len) {
    List<String> second = new List(len);
    var imgs = json
        .decode(StorageUtil.getString(firstPartOfString + SecondIdentifier));
    for (int x = 0; x < len; x++) {
      second[x] = imgs[x].toString();
    }
    return second;
  }

  ///load structure of the tab bar and page
  Widget TabMenu() {
    return Container(
      //add an expanded widget if there is any issues
      child: Column(children: <Widget>[
        TabBar(
            controller: tabController,
            indicatorColor: AppColors.whiteColor,
            labelColor: AppColors.errorStateLightRed,
            unselectedLabelColor: Colors.black54,
            isScrollable: true,
            tabs: FoodClasses()),
        appJustOpened
            ? FutureBuilder(
                future: FoodClassObjectsFromServer(),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    try {
                      return Expanded(
                        child: TabBarView(
                            physics: NeverScrollableScrollPhysics(),
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
            : Container(
                child: Expanded(
                child: TabBarView(
                    controller: tabController,
                    //if you need to add more tabs
                    children: FoodClassObjectsFromStorage()),
              ))
      ]),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    TabAnimcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    try {
      if (appJustOpened) {
        //remove scaffolding if any future issues
        return Scaffold(
          ///APP BAR SUBJECT TO CHANGE
          /*appBar: PreferredSize(
              preferredSize: Size.fromHeight(78.0),
              child: AppBar(
                automaticallyImplyLeading: false, // hides leading widget
                flexibleSpace: new UIElements(),
              )),*/
          body: FutureBuilder(
              future: setItemContentOnline(),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return TabMenu();
                }
              }),
        );
      } else {
        setItemContentCache();
        return Scaffold(

            ///APPBAR SUBJECT TO CHANGE
            /* appBar: PreferredSize(
                preferredSize: Size.fromHeight(72.0),
                child: AppBar(
                  backgroundColor: Colors.white,
                  automaticallyImplyLeading: false, // hides leading widget
                  flexibleSpace: new UIElements(),
                )),*/
            body: TabMenu());
      }
    } catch (e) {
      Timer(Duration(seconds: 3), () {
        setState(() {
          appJustOpened = true;
        });
      });
      return Text("Loading Menu...");
    }
  }
}
