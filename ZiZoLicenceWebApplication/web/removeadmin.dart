import 'loginfunctions.dart';
import 'dart:html';
import 'dart:js';
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
    
  querySelector("#helpButton").onClick.listen(help.showRemoveUsersScreen);
  querySelector("#logoutButton").onClick.listen(log.logout);
  querySelector("#username-output").innerHtml = window.sessionStorage['username'];
  querySelector("#removeUser_button").onClick.listen(removeUser);
    
  ViewablePages.revealOptions();
}

void removeUser(MouseEvent m)
{
  InputElement username = querySelector("#username");
  String userValue;
  
  userValue = username.value;
  
  LicenceServerRequest.removeUser(userValue, window.sessionStorage['username'],window.sessionStorage['password'], "localhost",
      (s) => getResult(popup("#popUpDiv"), s),(s) => getResult(popupFail("#popUpDiv"), s));
  
  username.value = "";
}

void printResponse()
{
  InputElement i = querySelector("#username");
  context.callMethod('alert',["The User "+"'"+i.value+"'"+" Has Been Deleted."]);
}

popup(String popupId)
{
  PopupWindow p = new PopupWindow();
  ButtonElement button = querySelector("#dismissFail");
  button.hidden = true;
  ButtonElement button2 = querySelector("#dismissSuccess");
  button2.hidden = false;
  querySelector("#popupTitle").innerHtml = "Admin Removed";
  OutputElement text = querySelector("#popupText");
  text.value = "The Admin Has Been Successfully Removed: ";
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


