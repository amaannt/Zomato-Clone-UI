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
  bool isPhoneVerified = false;
  static final User _user = User._internal();
  BackendlessUser bkU = new BackendlessUser();
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

  userRegistration(String regFirstName, String regLastName, String emailId,
      String phoneNo, String pass) async {
    //CHECK IF USER EXISTS

    bkU.email = emailId;
    bkU.password = pass;
    bkU.setProperty("First_Name", regFirstName);
    bkU.setProperty("Last_Name", regLastName);
    bkU.setProperty("phone", phoneNo);
    bkU.setProperty(
        "languageSelected", LanguageInformation().getActiveLanguage());

    var responseMessage;
    try {
      responseMessage = await Backendless.userService.register(bkU);
      print(responseMessage);

      return true;
    } catch (e) {
      print(responseMessage);
    }
  }

  Future<bool> updateKeyProperty(List<String> key, List<String> value) async {
    bool responseMessage = false;

    for (int x = 0; x < key.length; x++) {
      if (key[x] == "email") {
        bkU.email = value[x];
      } else {
        bkU.setProperty("${key[x]}", "${value[x]}");
      }
    }

    ///Updates the changed User Data
    await Backendless.userService.update(bkU).then((user) {
      // user has been updated
      responseMessage = true;
      applyUserDetailLocal(user, false, address);
    });

    ///If successfully updated, change the local variables of the singleton user class
    /*if (responseMessage) {
      for (int x = 0; x < key.length; x++) {
        switch (key[x]) {
          case "phone":
            phone = value[x];
            break;
          case "email":
            email = value[x];
            break;
          case "First_Name":
            fname = value[x];
            break;
          case "Last_Name":
            lastName = value[x];
            break;
          default:
            break;
        }
      }
    }*/
    return responseMessage;
  }

  Future<bool> loginStatus() async {
    bool isValidLog = false;
    await Backendless.userService.isValidLogin().then((response) {
      isValidLog = response;
    });
    return isValidLog;
  }
  Future logoutProcess()async{
    try{
      await Backendless.userService.logout().then((response) {
        // user has been logged out.
        // ListenOrderModel().deleteListener();
        isLoggedIn = false;

      });
    }
    catch(e){
      return false;
    }

    return true;
  }

  ///DONT FORGET TO VALIDATE THIS PHONE NUMBER
  Future<bool> userPhoneConfirmation(String phoneNo) async {
    isPhoneVerified = false;
    //function to confirm verify phone number
    await new Future.delayed(const Duration(seconds: 2, milliseconds: 500), () {
      isPhoneVerified = true;
    });
    return isPhoneVerified;
  }

  applyUserDetailLocal(BackendlessUser thisUser, bool isNewUser, String Address) {
    bkU = thisUser;
    try {
      print("User with email:" +
          thisUser.email +
          " registered with ID:" +
          thisUser.getProperty("objectId"));
    } catch (e) {}
    id = thisUser.getProperty("objectId");
    fname = thisUser.getProperty("First_Name");
    lastName = thisUser.getProperty("Last_Name");
    email = thisUser.email;
    phone = thisUser.getProperty("phone");

    displayName = thisUser.getProperty("First_Name");
    isLoggedIn = true;
    accountType = thisUser.getProperty("socialAccount");
    if (isNewUser) {
      address = "[]";
    } else {
      address = Address;
    }
  }
}
