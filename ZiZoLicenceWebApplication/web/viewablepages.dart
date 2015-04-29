library pages;

import 'dart:html';


class ViewablePages
{
  showOptions(bool test)
  {
    
    
    DivElement div1,div2,div3,div4,div5,div6,div7,div8,divTable;
    
    div1 = querySelector("#showCreateLicence");
    div2 = querySelector("#showAddAdmin");
    div3 = querySelector("#showAddPermissions");
    div4 = querySelector("#showRegenerateLicence");
    div5 = querySelector("#showRemoveLicence");
    div6 = querySelector("#showRemoveAdmin");
    div7 = querySelector("#showLogAccess");
    div8 = querySelector("#showViewLicences");
    divTable = querySelector("#hidden");
    
    
    
    if(test)
      div1.innerHtml = "";
    if(!test)
      div2.innerHtml = "";
    if(test)
      div3.innerHtml = "";
    if(test)
      div4.innerHtml = "";
    if(!test)
      div5.innerHtml = "";
    if(test)
      div6.innerHtml = "";
    if(test)
      div7.innerHtml = "";
    if(test)
      div8.innerHtml = "";
    
    divTable.style.display = "block";
    
  }
}