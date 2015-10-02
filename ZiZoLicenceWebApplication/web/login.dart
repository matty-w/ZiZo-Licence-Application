import 'loginfunctions.dart';
import 'dart:html';
import 'popupconstruct.dart';

void main()
{
  window.onContentLoaded.listen(refresh);
  refresh(null);
}

void refresh(Event e)
{
  LoginAndOut log = new LoginAndOut();    
  PopupWindow p = new PopupWindow();  
  querySelector("#submitButton").onClick.listen(log.login);
  querySelector("#dismissFinal").onClick.listen(p.dismissPrompt);  
}

