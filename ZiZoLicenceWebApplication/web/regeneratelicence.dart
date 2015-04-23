import 'dart:html';
import 'loginfunctions.dart';
import 'helpscreenfunctions.dart';

void main()
{
  var log = new LoginAndOut();
  var help = new HelpScreenFunctions();
  
  setDefaultIpAddress();
  
  querySelector("#helpButton").onClick.listen(help.showRegenerateLicenceScreen);
  querySelector("#logoutButton").onClick.listen(log.logout);
  querySelector("#username-output").innerHtml = window.sessionStorage['username'];
}

setDefaultIpAddress()
{
  InputElement ipAddress = querySelector("#url");
  ipAddress.value = window.location.host;
}
