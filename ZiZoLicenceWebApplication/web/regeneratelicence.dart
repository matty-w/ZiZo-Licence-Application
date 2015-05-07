import 'dart:html';
import 'loginfunctions.dart';
import 'helpscreenfunctions.dart';
import 'licenceserverrequest.dart';
import 'viewablepages.dart';

void main()
{
  window.onContentLoaded.listen(refresh);
  refresh(null); 
}

void refresh(Event e)
{
  LoginAndOut log = new LoginAndOut();
  HelpScreenFunctions help = new HelpScreenFunctions();
    
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
  
  userValue = usernameInput.value;
    if (url.value.length>0)
      userValue = userValue+"("+url.value+")";
    
  LicenceServerRequest.regenerateLicence(userValue, window.sessionStorage['username'],window.sessionStorage['password'], 
      "localhost", (s) => window.alert(s),(s) => window.alert("fail: "+s));  
}

setDefaultIpAddress()
{
  InputElement ipAddress = querySelector("#url");
  ipAddress.value = window.location.host;
}

