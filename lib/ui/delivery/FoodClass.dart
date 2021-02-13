import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:zomatoui/constants/colors.dart';
import 'package:zomatoui/constants/textstyles.dart';
import 'package:zomatoui/ui/delivery/ItemPopup.dart';

///
import 'package:cached_network_image/cached_network_image.dart';

class FoodClass extends StatefulWidget {
  String FoodSection_ID;

  int amountOfITEMS = 0;

  List<String> itemNames;
  List<String> itemPrices;
  List<String> itemImage;
  List<String> itemDescription;
  FoodClass(
      {this.FoodSection_ID,
      this.amountOfITEMS,
      this.itemImage,
      this.itemPrices,
      this.itemNames,
      this.itemDescription,});
  @override
  _FoodClassState createState() => _FoodClassState();
}

class _FoodClassState extends State<FoodClass> with TickerProviderStateMixin {
  String FoodType;
  double heightItem = 195;
  int amountOfItems = 0;
  int numOfColumns = 2;
  List<String> itemNames;
  List<String> itemPrices;
  List<String> itemImage;
  List<String> itemDescription;
  double heightList = 0;

  AnimationController TabAnimcontroller;
  Animation animationFade;
  @override
  void initState() {
    super.initState();
    print("Starting Class Food");
    FoodType = widget.FoodSection_ID;
    this.amountOfItems = widget.amountOfITEMS;
    this.itemNames = widget.itemNames;
    this.itemPrices = widget.itemPrices;
    this.itemImage = widget.itemImage;
    this.itemDescription = widget.itemDescription;
    ///controlling the fade in effect
    TabAnimcontroller =
        AnimationController( duration: Duration(milliseconds: 400), vsync: this);
    animationFade = Tween(begin: 0.0, end: 1.0).animate(TabAnimcontroller);
  }

//function to load the list of items
  Future<dynamic> LoadItemList() async {


    int listHeight = amountOfItems;
    //check odd number of items on the list
    if (listHeight % 2 == 1) {
      listHeight += 1;
    }

    heightList = (listHeight / numOfColumns) * heightItem * 1.0;

    //catch odd number of items and modify height as per number of items
    return heightList;
  }

  MakeItemList(AsyncSnapshot snapshot) {
    TabAnimcontroller.forward();
    return FadeTransition(opacity:animationFade, child:Container(
      // height should be : amount of dishes/number of columns * item height of 195 * 1.0 double datatype
      height: snapshot.data,
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

                          padding: new EdgeInsets.only(
                              left: 0.0, bottom: 0.0, top: 0.0),
                          decoration: new BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
/*                            image: new DecorationImage(
                              image: new NetworkImage(itemImage[index]),
                              fit: BoxFit.fill,
                            ),*/
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Stack(

                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5),

                                    child:  FadeInImage.assetNetwork(
                                      fit:BoxFit.fill,
                                      placeholder: 'images/ImageIconFood.png',
                                      image: itemImage[index],

                                      height: 173.5,
                                      width: 520,
                                    ),
                                  ),


                                  Row(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 5,
                                            right: 10,
                                            top: 5,
                                            bottom: 5),
                                        decoration: BoxDecoration(
                                            color: Colors.black45,
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        child: new Text(itemNames[index],
                                            style: new TextStyle(
                                                fontSize: 14.0,
                                                color: AppColors.whiteColor)),
                                      ),

                                    ],
                                  ),
                                  //pricing or name////
                                   new Container(
                                      ///this edge inset moves the container to the bottom
                                      padding: EdgeInsets.only(
                                           top: 143, left:3),
                                      child: new Container(
                                        padding: EdgeInsets.only(
                                            left: 5, right: 10, top: 5, bottom: 5),
                                        decoration: BoxDecoration(
                                            color: Colors.blueAccent[200],
                                            borderRadius:
                                            BorderRadius.circular(5.0)),
                                        child: new Text(
                                            itemPrices[index].toString() + " €",
                                            style: new TextStyle(
                                                fontSize: 12.0,
                                                color: AppColors.whiteColor)),
                                      ),
                                    ),


                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              ///this is where the user clicks to check the item details and add to their orders
              onTap: () {
                ItemPopupTab(itemNames[index],itemDescription[index]).PopupItem(context);
              });
        }),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(3), children: <Widget>[
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
    ]);
  }
}
