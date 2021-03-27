import 'package:backendless_sdk/backendless_sdk.dart';

class BackendlessUtil {
  static final BackendlessUtil beUtil = BackendlessUtil._internal();

  factory BackendlessUtil() {
    return beUtil;
  }

  BackendlessUtil._internal();

  var updatesColumn = "", updatesRecord = "";
  createListenerColumn(String tableName, String column) {
    EventHandler<Map> orderEventHandler = Backendless.data.of(tableName).rt();

//have to insert socket.io for this listener
    orderEventHandler.addUpdateListener((updatedOrder) {
      //print("An Order object has been updated. Object ID - ${updatedOrder}");
      updatesColumn = updatedOrder[column].toString();
    });
  }

  createListenerRecord(String tableName) {
    EventHandler<Map> orderEventHandler = Backendless.data.of(tableName).rt();

//have to insert socket.io for this listener
    orderEventHandler.addUpdateListener((updatedOrder) {
      //print("An Order object has been updated. Object ID - ${updatedOrder}");
      updatesRecord = updatedOrder.toString();
    });
  }
}
