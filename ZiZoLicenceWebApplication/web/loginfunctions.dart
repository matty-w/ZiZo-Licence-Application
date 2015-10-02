library login;

import 'dart:html';
import 'licenceserverrequest.dart';
import 'popup.dart';

bool testing = false;

class LoginAndOut
{
  void login(MouseEvent m)
  {
    SelectPopup sp = new SelectPopup();
    InputElement username = querySelector("#usernameTextbox");
    InputElement password = querySelector("#passwordTextbox");
    
    if(username.value.trim() == "" || username.value == null)
    {
      sp.popupOther("no-username", "#popUpDiv");
      return;
    }
    if(password.value.trim() == "" || password.value == null)
    {
      sp.popupOther("no-password", "#popUpDiv");
      return;
    }
    
    LicenceServerRequest.checkPermissions(username.value,password.value,LicenceServerRequest.defaultUri(),storePermissions);
    checkDetails(username.value, password.value);
  }
  
  void logout(MouseEvent m)
  {
    Storage local = window.sessionStorage;
    local['username'] = "";
    local['password'] = "";
    local['permissions'] = "";
    window.location.href = "login.html";
  }
  
  void goToPage()
  {
    InputElement username = querySelector("#usernameTextbox");
    InputElement password = querySelector("#passwordTextbox");
    Storage local = window.sessionStorage;
    String page = "";
    List<String> permissions = new List<String>();
    String response = local['permissions'];
    if(response != null || response.trim() != "")
    {
      permissions = response.split(",");
    }  
    if(permissions.contains("add-licence"))
    {  
      page = "createLicence.html";
    }    
    if ((permissions!=null)&&(!permissions.contains('add-licence')))
    { 
      page = "changePassword.html";
    }    
    local['username'] = username.value;
    local['password'] = password.value;
    window.location.href = page;
  }
  
  void checkDetails(String userName, String password)
  {  
    SelectPopup sp = new SelectPopup();
    LicenceServerRequest.checkAdminLogin(userName, password, LicenceServerRequest.defaultUri(),
        () => goToPage(),
        () => sp.popupOther("incorrect-details", "#popUpDiv"));
  }

  void storePermissions(String response)
  {
    Storage local = window.sessionStorage;
    local['permissions'] = response;
  }
}