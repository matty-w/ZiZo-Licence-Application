library login;

import 'dart:html';
import 'licenceserverrequest.dart';

bool testing = false;

class LoginAndOut
{
  void login(MouseEvent m)
  {
    InputElement username = querySelector("#usernameTextbox");
    InputElement password = querySelector("#passwordTextbox");
    checkDetails(username.value, password.value);
  }
  
  void logout(MouseEvent m)
  {
    Storage local = window.sessionStorage;
    local['username'] = "";
    local['password'] = "";
    window.location.href = "login.html";
  }
  
  void goToPage(String page)
  {
    InputElement username = querySelector("#usernameTextbox");
    InputElement password = querySelector("#passwordTextbox");
    Storage local = window.sessionStorage;
    local['username'] = username.value;
    local['password'] = password.value;
    window.location.href = page;
  }
  
  void checkDetails(String userName, String password)
  {  
    LicenceServerRequest.checkAdminLogin(userName, password, "localhost",
        () => goToPage("createLicence.html"),
        () => window.alert("The Login Details Are Incorrect, Please Try Again."));
  }
}