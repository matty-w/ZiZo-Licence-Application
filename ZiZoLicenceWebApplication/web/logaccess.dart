import 'loginfunctions.dart';
import 'dart:html';

void main()
{
  var log = new LoginAndOut();
  InputElement export = querySelector("#export_button");
  export.disabled == true;
  
  querySelector("#logoutButton").onClick.listen(log.logout);
  querySelector("#username-output").innerHtml = window.sessionStorage['username'];
  
}




