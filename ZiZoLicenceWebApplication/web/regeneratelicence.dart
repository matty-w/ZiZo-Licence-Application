import 'dart:html';
import 'loginfunctions.dart';
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
  querySelector("#regenerateLicence_button").onClick.listen(regenerateLicence);
    
  setDefaultIpAddress();
    
  querySelector("#helpButton").onClick.listen(help.showRegenerateLicenceScreen);
  querySelector("#logoutButton").onClick.listen(log.logout);
  querySelector("#username-output").innerHtml = window.sessionStorage['username'];
  querySelector("#regenerateLicence_button").onClick.listen(regenerateLicence);
    
  ViewablePages.revealOptions();
}

void regenerateLicence(MouseEvent m)
{
  SelectPopup sp = new SelectPopup();
  PopupWindow p = new PopupWindow();
  InputElement usernameInput = querySelector("#username");
  InputElement url = querySelector("#url");
  
  String userValue;
  
  if(usernameInput.value == null || usernameInput.value.trim() == "")
  {
    sp.popupOther("no-username","#popUpDiv");
    return;
  }  
  
  userValue = usernameInput.value;
    if (url.value.length>0)
      userValue = userValue+"("+url.value+")";
    
  LicenceServerRequest.regenerateLicence(userValue, window.sessionStorage['username'],window.sessionStorage['password'], 
      "localhost", (s) => p.getResult(sp.popup("regenerate-licence","#popUpDiv"), s),(s) => p.getResult(sp.popupFail("#popUpDiv"), s));  
}

void setDefaultIpAddress()
{
  InputElement ipAddress = querySelector("#url");
  ipAddress.value = window.location.host;
}
