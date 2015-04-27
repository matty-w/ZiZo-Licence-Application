import 'loginfunctions.dart';
import 'dart:html';
import 'helpscreenfunctions.dart';
import 'licenceserverrequest.dart';

bool confirmWidnow = window.confirm("The Username You Have Created Is Not In An Email Format (Test@Account.co.uk) Which Is Recommended, Are You Sure You Wish To Use"+ 
        " This Username?");

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
}

void addAdmin(MouseEvent m)
{
  InputElement userNameInput = querySelector("#username");
  InputElement passwordInput = querySelector("#password");
  
  String user = userNameInput.value;
  String password = passwordInput.value;
  
  
  Event e;
  checkUsername(e);
  
  LicenceServerRequest.addAdminUser("add-user", user, password, window.sessionStorage['username'],window.sessionStorage['password'],
      "localhost", (s) => window.alert(s),(s) => window.alert("fail: "+s));
}

checkUsername(Event e)
{
  InputElement input = querySelector("#username");
  String username = input.value;
  
  RegExp exp = new RegExp("[a-zA-Z0-9][a-zA-Z0-9-_\s]+@[a-zA-Z0-9-\s].+\.[a-zA-Z]{2,5}");
  
   
  if(!(exp.hasMatch(username)))
  {  
    confirmWidnow;
      if(confirmWidnow == true)
        return;
      else
      {
        e.preventDefault();
        window.location.reload();
      }  
  }
  else
    return;
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
