import 'loginfunctions.dart';
import 'dart:html';
import 'helpscreenfunctions.dart';
import 'licenceserverrequest.dart';
import 'viewablepages.dart';
import 'popupconstruct.dart';
import 'popup.dart';


void main()
{
  window.onContentLoaded.listen(refresh);
  refresh(null);
}

void refresh(Event e)
{
  LoginAndOut log = new LoginAndOut();
  PopupWindow p = new PopupWindow();
  HelpScreenFunctions help = new HelpScreenFunctions();
  
  querySelector("#dismissSuccess").onClick.listen(p.dismissPrompt);
  querySelector("#dismissFinal").onClick.listen(p.dismissPrompt);
  
  querySelector("#logoutButton").onClick.listen(log.logout);
  querySelector("#helpButton").onClick.listen(help.showAddUsersScreen);
  querySelector("#username-output").innerHtml = window.sessionStorage['username'];
  querySelector("#addUser_submitButton").onClick.listen(addAdmin);
  
  ViewablePages.revealOptions();
}

void addAdmin(MouseEvent m)
{
  SelectPopup sp = new SelectPopup();
  InputElement userNameInput = querySelector("#username");
  InputElement passwordInput = querySelector("#password");
  InputElement confirmPassword = querySelector("#confirmPassword");
  String passwordFirst = passwordInput.value;
  String passwordSecond = confirmPassword.value;
  
  if(userNameInput.value == null || userNameInput.value.trim() == "")
  {
    sp.popupOther("no-username","#popUpDiv");
    return;
  }
  
  if(passwordFirst == null || passwordFirst.trim() == "" || passwordSecond == null || passwordSecond.trim() == "")
  {  
    sp.popupOther("no-password","#popUpDiv");
    return;
  }  
  
  if(checkPasswordsMatch(passwordFirst, passwordSecond) == true)
  { 
    PopupWindow p = new PopupWindow();
    String user = userNameInput.value;
    String password = passwordInput.value;
     
    LicenceServerRequest.addAdminUser(user, password, window.sessionStorage['username'],window.sessionStorage['password'],
        "localhost", (s) => p.getResult(sp.popup("add-admin","#popUpDiv"), s),(s) => p.getResult(sp.popupFail("#popUpDiv"), s));
    
    userNameInput.value = "";
    passwordInput.value = "";
    confirmPassword.value = "";
    return;
  }  
    
  sp.popupOther("passwords-dont-match","#popUpDiv");

}

bool checkPasswordsMatch(String password, String confirmPassword)
{  
  if(confirmPassword != password)
    return false;
  else
    return true;
}