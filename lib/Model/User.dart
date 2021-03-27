import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:zomatoui/Utils/LanguageController.dart';
class User {
  String id;
  String email;
  String fname;
  String lastName;
  String displayName;
  String phone;
  String address;
  String languageSelection;
  String wordPass;
  String accountType;
  bool isLoggedIn = false;

  static final User _user = User._internal();

  factory User() {
    return _user;
  }
  User._internal();

  Map toMap(User user) {
    var data = Map<String, dynamic>();
    data['ownerId'] = user.id;
    data['email'] = user.email;
    data['First_Name'] = user.displayName;
    data['AddressList'] = user.address;
    data['phone'] = user.phone;
    data['languageSelected'] = user.languageSelection;
    return data;
  }

  User.fromMap(Map<String, dynamic> mapData) {
    this.id = mapData['ownerId'];
    this.email = mapData['email'];
    this.fname = mapData['First_Name'];
    this.lastName = mapData['Last_Name'];
    this.displayName = mapData['First_Name'];
    this.address = mapData['AddressList'];
    this.phone = mapData['phone'];
  }

  userRegistration(String regFirstName, String regLastName, String emailId, String phoneNo,
      String pass) async {
    BackendlessUser bkU = new BackendlessUser();
    bkU.email = emailId;
    bkU.password = pass;
    bkU.setProperty("First_Name", regFirstName);
    bkU.setProperty("Last_Name", regLastName);
    bkU.setProperty("phone", phoneNo);
    bkU.setProperty("languageSelected", LanguageInformation().getActiveLanguage());

    var responseMessage;
    try {
      responseMessage = await Backendless.userService.register(bkU);
      print(responseMessage);
      return true;
    } catch (e) {
      print(responseMessage);
    }
  }
}
