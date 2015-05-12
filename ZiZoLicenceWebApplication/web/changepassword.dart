import 'dart:html';
import 'loginfunctions.dart';

void main()
{
  window.onContentLoaded.listen(refresh);
  refresh(null); 
}

void refresh(Event e)
{
  setlogOut();
  querySelector("#username-output").innerHtml = window.sessionStorage['username'];
  InputElement username = querySelector("#username");
  username.innerHtml = window.sessionStorage['username'];
  username.disabled; 
}

void setlogOut()
{
  LoginAndOut log = new LoginAndOut();
  querySelector("#logoutButton").onClick.listen(log.logout);
}