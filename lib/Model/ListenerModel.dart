import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/cupertino.dart';

class ListenOrderModel extends ChangeNotifier{

  ///Singleton Instance creator
  static final ListenOrderModel _singleton = ListenOrderModel._internal();

  factory ListenOrderModel() {
    return _singleton;
  }

  ListenOrderModel._internal();
  ///initialize update variables
  String updateStatus="";
  String updateOrderID="";
  //ListenOrderModel({this.userID});
  ///Listen to Active order changes Specific to user account ID
 void createListen(String userID) {
    bool isChanged = false;
    EventHandler<Map> orderEventHandler =
    Backendless.data.of("Live_Orders").rt();

//have to insert socket.io for this listener
    orderEventHandler.addUpdateListener((updatedOrder) {
      print("An Order object has been updated. Object ID - ${updatedOrder}");
      this.updateStatus = updatedOrder["Order_Status"].toString();
      this.updateOrderID = updatedOrder["objectId"];
       notifyChanges();


    }, whereClause: "User_ID =" + userID.toString());
  }
  
  Future <void> notifyChanges() async => Future.delayed(const Duration(seconds: 3), () {
      notifyListeners();
    });
}