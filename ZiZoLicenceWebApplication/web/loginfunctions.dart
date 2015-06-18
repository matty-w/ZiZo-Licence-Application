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
    LicenceServerRequest.checkPermissions(username.value,password.value,LicenceServerRequest.defaultUri(),storePermissions);
    checkDetails(username.value, password.value);
  }
  
  void logout(MouseEvent m)
  {
    Storage local = window.sessionStorage;
    local['username'] = "";
    local['password'] = "";
    window.location.href = "login.html";
  }
  
  void goToPage()
  {
    InputElement username = querySelector("#usernameTextbox");
    InputElement password = querySelector("#passwordTextbox");
    Storage local = window.sessionStorage;
    String page = "createLicence.html";
    List<String> permissions = null;
    String response = local['permissions'];
    
    if(response != null)
      permissions = response.split(",");
    if ((permissions!=null)&&(!permissions.contains('add-licence')))
        page = "changePassword.html";
    print("5");
    local['username'] = username.value;
    local['password'] = password.value;
    window.location.href = page;
  }
  
  void checkDetails(String userName, String password)
  {  
    LicenceServerRequest.checkAdminLogin(userName, password, LicenceServerRequest.defaultUri(),
        () => goToPage(),
        () => window.alert("The Login Details Are Incorrect, Please Try Again."));
  }

  void storePermissions(String response)
  {
    Storage local = window.sessionStorage;
    local['permissions'] = response;
  }
}