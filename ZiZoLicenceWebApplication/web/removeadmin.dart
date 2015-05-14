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
    
  querySelector("#helpButton").onClick.listen(help.showRemoveUsersScreen);
  querySelector("#logoutButton").onClick.listen(log.logout);
  querySelector("#username-output").innerHtml = window.sessionStorage['username'];
  querySelector("#removeUser_button").onClick.listen(removeUser);
    
  ViewablePages.revealOptions();
}

void removeUser(MouseEvent m)
{
  SelectPopup sp = new SelectPopup();
  PopupWindow p = new PopupWindow();
  InputElement username = querySelector("#username");
  String userValue;
  
  userValue = username.value;
  
  if(userValue == null || userValue.trim() == "")
  {
    sp.popupOther("no-username", "#popUpDiv");
    return;
  }
  
  LicenceServerRequest.removeUser(userValue, window.sessionStorage['username'],window.sessionStorage['password'], "localhost",
      (s) => p.getResult(sp.popup("remove-admin","#popUpDiv"), s),(s) => p.getResult(sp.popupFail("#popUpDiv"), s));
  
  username.value = "";
}
