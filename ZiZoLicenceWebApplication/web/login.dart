import 'loginfunctions.dart';
import 'dart:html';

void main()
{
  var log = new LoginAndOut();
      
  querySelector("#resetButton").onClick.listen(resetTextboxes);
  querySelector("#submitButton").onClick.listen(log.login);
  
  InputElement username = querySelector("#usernameTextbox");
  InputElement password = querySelector("#passwordTextbox");
  Storage local = window.sessionStorage;
  local['username'] = username.value;
  local['password'] = password.value;
}
  
void resetTextboxes(MouseEvent m)
{
  InputElement username = querySelector("#usernameTextbox");
  InputElement password = querySelector("#passwordTextbox");
  username.value = "";
  password.value = "";
}