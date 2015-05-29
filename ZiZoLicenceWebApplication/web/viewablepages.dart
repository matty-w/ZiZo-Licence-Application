library pages;

import 'dart:html';
import 'licenceserverrequest.dart';

class ViewablePages
{
  static void revealOptions()
  {
    String adminName = window.sessionStorage['username'];
    String adminPassword = window.sessionStorage['password'];
    
    LicenceServerRequest.checkPermissions(adminName,adminPassword,LicenceServerRequest.defaultUri(),enablePermissions);
  }
  
  static void enablePermissions(String response)
  {
    List<String> permissions = response.split(",");
    for (DivElement e in document.getElementsByClassName("actionMenu"))
      if (!permissions.contains(e.attributes['permission']))
        e.innerHtml = "";
    
    DivElement divTable = querySelector("#hidden");
    divTable.style.display = "block";
  }
}