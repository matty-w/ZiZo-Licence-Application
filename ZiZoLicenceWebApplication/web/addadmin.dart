import 'loginfunctions.dart';
import 'dart:html';
import 'helpscreenfunctions.dart';
import 'licenceserverrequest.dart';
import 'viewablepages.dart';
import 'popup.dart';

void main()
{
  window.onContentLoaded.listen(refresh);
  refresh(null);
}

void refresh(Event e)
{
  LoginAndOut log = new LoginAndOut();
  HelpScreenFunctions help = new HelpScreenFunctions();
  
  querySelector("#dismissSuccess").onClick.listen(dismissPrompt);
  querySelector("#dismissFail").onClick.listen(dismissPrompt);
  
  querySelector("#logoutButton").onClick.listen(log.logout);
  querySelector("#helpButton").onClick.listen(help.showAddUsersScreen);
  querySelector("#username-output").innerHtml = window.sessionStorage['username'];
  querySelector("#addUser_submitButton").onClick.listen(addAdmin);
  
  ViewablePages.revealOptions();
}

void addAdmin(MouseEvent m)
{
  InputElement password1 = querySelector("#password");
  InputElement password2 = querySelector("#confirmPassword");
  String passwordFirst = password1.value;
  String passwordSecond = password2.value;
  
  InputElement userNameInput = querySelector("#username");
  InputElement passwordInput = querySelector("#password");
  InputElement confirmPassword = querySelector("#confirmPassword");
  
  if(checkPasswordsMatch(passwordFirst, passwordSecond) == true)
  {   
    String user = userNameInput.value;
    String password = passwordInput.value;
     
    LicenceServerRequest.addAdminUser(user, password, window.sessionStorage['username'],window.sessionStorage['password'],
        "localhost", (s) => getResult(popup("#popUpDiv"), s),(s) => getResult(popupFail("#popUpDiv"), s));
    
    userNameInput.value = "";
    passwordInput.value = "";
    confirmPassword.value = "";
    return;
  }  
    
  popupPasswordsDontMatch("#popUpDiv");

}

bool checkPasswordsMatch(String password, String confirmPassword)
{  
  if(confirmPassword != password)
    return false;
  else
    return true;
}

popup(String popupId)
{
  PopupWindow p = new PopupWindow();
  ButtonElement button = querySelector("#dismissFail");
  button.hidden = true;
  ButtonElement button2 = querySelector("#dismissSuccess");
  button2.hidden = false;
  querySelector("#popupTitle").innerHtml = "Admin Created";
  OutputElement text = querySelector("#popupText");
  text.value = "The Admin Account Was Successfully Created: ";
  querySelector("#tick").setAttribute("src", "images/ticksmall.png");
  
  p.blanketSize(popupId);
  p.windowPosition(popupId);
  p.toggle('#blanket');
  p.toggle(popupId);
}

popupFail(String popupId)
{
  PopupWindow p = new PopupWindow();
  ButtonElement button = querySelector("#dismissSuccess");
  button.hidden = true;
  ButtonElement button2 = querySelector("#dismissFail");
  button2.hidden = false;
  
  
  querySelector("#popupTitle").innerHtml = "Error";
  OutputElement text = querySelector("#popupText");
  text.value = "An Error Occurred: ";
  querySelector("#tick").setAttribute("src", "images/dialogWarning2.png");
  p.blanketSize(popupId);
  p.windowPosition(popupId);
  p.toggle('#blanket');
  p.toggle(popupId);
}

popupPasswordsDontMatch(String popupId)
{
  PopupWindow p = new PopupWindow();
  ButtonElement button = querySelector("#dismissSuccess");
  button.hidden = true;
  ButtonElement button2 = querySelector("#dismissFail");
  button2.hidden = false;
    
  querySelector("#popupTitle").innerHtml = "Error";
  OutputElement text = querySelector("#popupText");
  text.value = "The Passwords Do Not Match, Please Try Again";
  querySelector("#tick").setAttribute("src", "images/dialogWarning2.png");
  p.blanketSize(popupId);
  p.windowPosition(popupId);
  p.toggle('#blanket');
  p.toggle(popupId);
}

void getResult(Function popup, String s)
{
  OutputElement admin = querySelector("#serverResponse");
  admin.value = s;
  popup;
}

void dismissPrompt(MouseEvent e)
{
  popup("#popUpDiv");
  main();
}