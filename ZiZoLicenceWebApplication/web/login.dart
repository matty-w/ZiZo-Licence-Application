import 'loginfunctions.dart';
import 'dart:html';
import 'licenceserverrequest.dart';

void main()
{
  window.onContentLoaded.listen(refresh);
  refresh(null);
}

void refresh(Event e)
{
  LoginAndOut log = new LoginAndOut();      
  querySelector("#resetButton").onClick.listen(resetTextboxes);
  querySelector("#submitButton").onClick.listen(log.login);
}

void resetTextboxes(MouseEvent m)
{
  InputElement username = querySelector("#usernameTextbox");
  InputElement password = querySelector("#passwordTextbox");
  username.value = "";
  password.value = "";
}
