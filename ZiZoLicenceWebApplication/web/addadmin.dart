import 'loginfunctions.dart';
import 'dart:html';
import 'helpscreenfunctions.dart';
import 'licenceserverrequest.dart';
import 'viewablepages.dart';

void main()
{
  var log = new LoginAndOut();
  var help = new HelpScreenFunctions();
  
  querySelector("#logoutButton").onClick.listen(log.logout);
  querySelector("#helpButton").onClick.listen(help.showAddUsersScreen);
  querySelector("#username-output").innerHtml = window.sessionStorage['username'];
  querySelector("#password").onChange.listen(checkPasswords);
  querySelector("#confirmPassword").onChange.listen(checkPasswords);
  querySelector("#addUser_submitButton").onClick.listen(addAdmin);

  ViewablePages.revealOptions();
}

void addAdmin(MouseEvent m)
{
  InputElement userNameInput = querySelector("#username");
  InputElement passwordInput = querySelector("#password");
  InputElement confirmPassword = querySelector("#confirmPassword");
  
  String user = userNameInput.value;
  String password = passwordInput.value;
  
  
  LicenceServerRequest.addAdminUser(user, password, window.sessionStorage['username'],window.sessionStorage['password'],
      "localhost", (s) => window.alert(s),(s) => window.alert("fail: "+s));
  
  userNameInput.value = "";
  passwordInput.value = "";
  confirmPassword.value = "";
  
}

checkPasswords(Event e)
{
  InputElement password1 = querySelector("#password");
  InputElement password2 = querySelector("#confirmPassword");
  String passwordFirst = password1.value;
  String passwordSecond = password2.value;
  
  checkPasswordLength(passwordFirst.length);
  checkPasswordsMatch(passwordFirst, passwordSecond);
}

checkPasswordLength(int length)
{
    InputElement password1 = querySelector("#password");

    if(length <= 5)
    {  
      password1.setCustomValidity("The Password Must Be At Least 6 Characters Long");
      return;
    }  
    else
    {  
      password1.setCustomValidity("");
      return;
    }
}

checkPasswordsMatch(String password, String confirmPassword)
{
  InputElement password2 = querySelector("#confirmPassword");
  
  if(confirmPassword != password)
  {  
    password2.setCustomValidity("Passwords Must Be Matching.");
    return;
  }
  else
  {  
    password2.setCustomValidity("");
    return;
  }  
}
