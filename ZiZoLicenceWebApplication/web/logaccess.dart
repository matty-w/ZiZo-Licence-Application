import 'loginfunctions.dart';
import 'dart:html';
import 'helpscreenfunctions.dart';

void main()
{
  var log = new LoginAndOut();
  var help = new HelpScreenFunctions();
  
  querySelector("#helpButton").onClick.listen(help.showScreen);
  InputElement export = querySelector("#export_button");
  export.disabled == true;
  
  querySelector("#logoutButton").onClick.listen(log.logout);
  querySelector("#username-output").innerHtml = window.sessionStorage['username'];
  
}




