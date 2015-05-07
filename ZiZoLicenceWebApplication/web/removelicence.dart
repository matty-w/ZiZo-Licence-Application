import 'dart:html';
import 'loginfunctions.dart';
import 'helpscreenfunctions.dart';
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
    
  querySelector("#helpButton").onClick.listen(help.showRemoveLicenceScreen);
  querySelector("#logoutButton").onClick.listen(log.logout);
  querySelector("#username-output").innerHtml = window.sessionStorage['username'];
    
  ViewablePages.revealOptions();
}
