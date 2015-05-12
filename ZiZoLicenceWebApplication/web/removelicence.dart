import 'dart:html';
import 'loginfunctions.dart';
import 'helpscreenfunctions.dart';
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
    
  querySelector("#helpButton").onClick.listen(help.showRemoveLicenceScreen);
  querySelector("#logoutButton").onClick.listen(log.logout);
  querySelector("#username-output").innerHtml = window.sessionStorage['username'];
    
  ViewablePages.revealOptions();
}

popup(String popupId)
{
  PopupWindow p = new PopupWindow();
  ButtonElement button = querySelector("#dismissFail");
  button.hidden = true;
  ButtonElement button2 = querySelector("#dismissSuccess");
  button2.hidden = false;
  querySelector("#popupTitle").innerHtml = "Licence Removed";
  OutputElement text = querySelector("#popupText");
  text.value = "The Licence Has Been Successfully Removed: ";
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