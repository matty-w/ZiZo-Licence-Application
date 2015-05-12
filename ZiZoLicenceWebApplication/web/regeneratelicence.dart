import 'dart:html';
import 'loginfunctions.dart';
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
  InputElement usernameInput = querySelector("#username");
  InputElement url = querySelector("#url");
  
  String userValue;
  
  if(usernameInput.value == null || usernameInput.value.trim() == "")
  {
    popupNoUserName("#popUpDiv");
    return;
  }  
  
  userValue = usernameInput.value;
    if (url.value.length>0)
      userValue = userValue+"("+url.value+")";
    
  LicenceServerRequest.regenerateLicence(userValue, window.sessionStorage['username'],window.sessionStorage['password'], 
      "localhost", (s) => getResult(popup("#popUpDiv"), s),(s) => getResult(popupFail("#popUpDiv"), s));  
}

void setDefaultIpAddress()
{
  InputElement ipAddress = querySelector("#url");
  ipAddress.value = window.location.host;
}

popup(String popupId)
{
  PopupWindow p = new PopupWindow();
  ButtonElement button = querySelector("#dismissFail");
  button.hidden = true;
  ButtonElement button2 = querySelector("#dismissSuccess");
  button2.hidden = false;
  querySelector("#popupTitle").innerHtml = "Licence Regenerated";
  OutputElement text = querySelector("#popupText");
  text.value = "The Licence For The User Is: ";
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

popupNoUserName(String popupId)
{
  PopupWindow p = new PopupWindow();
  querySelector("#tick").setAttribute("src", "images/dialogWarning2.png");
  querySelector("#popupTitle").innerHtml = "Error";
  OutputElement text = querySelector("#popupText");
  text.value = "No Username Entered, Please Enter A Username.";
  OutputElement licenceText = querySelector("#licence");
  licenceText.value = "";
  ButtonElement button = querySelector("#dismissSuccess");
  button.hidden = true;
  ButtonElement button2 = querySelector("#dismissFail");
  button2.hidden = false;
 
  p.blanketSize(popupId);
  p.windowPosition(popupId);
  p.toggle('#blanket');
  p.toggle(popupId);  
}

