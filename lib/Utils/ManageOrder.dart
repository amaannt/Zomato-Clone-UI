import 'dart:convert';

class ManagePayAndOrder{
  ///User Information
  String userID;
  String userAddress;
  String userPhone_Number;
  bool isPaymentDone;
  String paymentType;
  String PaymentID = "";
  ///Item Information
  List<String> itemName;
  List<String> itemPrice;
  List<String> itemID;
  List<String> itemImage;
  List<int> quantityItem;
  int orderAmount;
  bool isCartEmpty;
  double serviceCharge = 0.0;
  double totalCost = 0.0;

  Future<void> _sendOrder() async {
    var jsonID = json.encode(itemID);
    var jsonName = json.encode(itemName);
    var jsonPrice = json.encode(itemPrice);
    var jsonQuantity = json.encode(quantityItem);
    print(jsonName);
    //**************************************test data

    userAddress = "Test Address 1";
    paymentType = "Visa/Mastercard";

    //*********************** end of test data
    userID = User().id;
    userPhone_Number = User().phone;
    Map orderData = {
      "Address": "$userAddress",
      "ItemID_List": jsonID,
      "Order_List": jsonName,
      "Pay_Type": paymentType,
      "Price_List": jsonPrice,
      "Total_Price": totalCost,
      "User_ID": userID,
      "UserPhone_Number": userPhone_Number,
      "Items_Quantity": jsonQuantity,
    };
    await Backendless.data
        .of("Live_Orders")
        .save(orderData)
        .then((updatedOrder) {
      print(
          "Order Object has been updated in the database - ${updatedOrder['objectId']}");
      ///Get the order ID first
      StorageUtil.putString("TempOrderID", updatedOrder["objectId"]);
    });

    ///save order to local storage
    int orderIndexInStorage = 0;
    bool ActiveOrderSaved = false;
    while (!ActiveOrderSaved) {
      if (StorageUtil.getString(
          "ActiveOrder_" + orderIndexInStorage.toString()) ==
          null ||
          StorageUtil.getString(
              "ActiveOrder_" + orderIndexInStorage.toString()) ==
              "") {
        try {
          ///Add the Order ID into the active order storage
          StorageUtil.putString(
              "ActiveOrderID_" + orderIndexInStorage.toString(),
              StorageUtil.getString("TempOrderID"));
          print("The order ID that is saved " +
              StorageUtil.getString(
                  "ActiveOrderID_" + orderIndexInStorage.toString()));
          ///Delete the order key that was saved previously
          StorageUtil.deleteKey("TempOrderID");
          StorageUtil.putString(
              "ActiveOrderStatus_" + orderIndexInStorage.toString(),
              "Confirmation Pending");
          //need this to check the if condition we are running of this scope (if this is null only then we can save this as an active order in this index *we need this*)
          StorageUtil.putString(
              "ActiveOrder_" + orderIndexInStorage.toString(), "Order Active");
          StorageUtil.putString(
              "ActiveOrderAddress_" + orderIndexInStorage.toString(),
              userAddress);

          ///Save order date into he active order
          var now = new DateTime.now();
          var formatter = new DateFormat('yyyy-MM-dd');
          String formattedDate = formatter.format(now);
          print(formattedDate); // 2016-01-25

          StorageUtil.putString(
              "ActiveOrderDate_" + orderIndexInStorage.toString(),
              formattedDate.toString());
          StorageUtil.putInt(
              "ActiveOrderIndex_" + orderIndexInStorage.toString(),
              orderIndexInStorage);
          StorageUtil.putString(
              "ActiveOrderItemIDList_" + orderIndexInStorage.toString(),
              jsonID);
          StorageUtil.putString(
              "ActiveOrderItemNameList_" + orderIndexInStorage.toString(),
              jsonName);
          StorageUtil.putString(
              "ActiveOrderPayMode_" + orderIndexInStorage.toString(),
              paymentType);
          StorageUtil.putString(
              "ActiveOrderPriceList_" + orderIndexInStorage.toString(),
              jsonPrice);
          StorageUtil.putString(
              "ActiveOrderTotalPrice_" + orderIndexInStorage.toString(),
              totalCost.toString());
          StorageUtil.putString(
              "ActiveOrderQuantityList_" + orderIndexInStorage.toString(),
              jsonQuantity);
          ActiveOrderSaved = true;
        } catch (e) {
          ActiveOrderSaved = false;
          orderIndexInStorage++;
        }
      } else {
        orderIndexInStorage++;
      }
    }

    setState(() {
      _resetOrder();
    });
    print('Sent Order');
    /*
    ADMIN CODE
    DataQueryBuilder queryBuilderContent2 = DataQueryBuilder();
    new Future.delayed(const Duration(seconds: 5), () {
       Backendless.data
          .of("Live_Orders")
          .find(queryBuilderContent2)
          .then((changes) {
            for(int x = 0; x<changes.length;x++){
              Map itemJSON = changes[x]["ItemID_List"];
              print("Order: ${changes[x]["objectId"]}");
            }
      });

    });*/
  }
}