import 'dart:html';
import 'loginfunctions.dart';
import 'helpscreenfunctions.dart';
import 'viewablepages.dart';

void main()
{
  var log = new LoginAndOut();
  var help = new HelpScreenFunctions();
  
  querySelector("#helpButton").onClick.listen(help.showRemoveLicenceScreen);
  querySelector("#logoutButton").onClick.listen(log.logout);
  querySelector("#username-output").innerHtml = window.sessionStorage['username'];
  
  ViewablePages.revealOptions();
}
