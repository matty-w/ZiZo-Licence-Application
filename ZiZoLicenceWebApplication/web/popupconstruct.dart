library popup;

import 'dart:html';

String licenceName;

class PopupWindow
{
  void hide(div_id)
  {
    DivElement el = querySelector(div_id);  
    el.style.display = "none";   
  }
  
  void show(div_id)
  {
    DivElement el = querySelector(div_id);  
    el.style.display = "block";  
  }


  Rectangle blanketSize(String popupId)
  {
    int viewportHeight, blanketHeight, popupHeight;
    HtmlHtmlElement frame = document.body.parentNode;
    viewportHeight = window.innerHeight;
    
    if ((viewportHeight > frame.scrollHeight) && (viewportHeight > frame.clientHeight))
      blanketHeight = viewportHeight;
    else if(frame.clientHeight > frame.scrollHeight)
      blanketHeight = frame.clientHeight;
    else
      blanketHeight = frame.scrollHeight;
    
    DivElement blanket = querySelector('#blanket');
    blanket.style.height = blanketHeight.toString() + 'px';
    DivElement popUpDiv = querySelector(popupId);
    popupHeight = (blanketHeight/2-200).floor();
    popUpDiv.style.top = popupHeight.toString() + 'px';
   
    return new Rectangle(0, 0, 0, viewportHeight);
  }
 
  Point windowPosition(String popupId)
  {
    int windowWidth;
    int viewportWidth = window.innerHeight;
    HtmlHtmlElement frame = document.body.parentNode;
    
    if ((viewportWidth > frame.scrollWidth) && (viewportWidth > frame.clientWidth))
      windowWidth = viewportWidth;
    else if(frame.clientWidth > frame.scrollWidth)
      windowWidth = frame.clientWidth;
    else
      windowWidth = frame.scrollWidth;
       
    DivElement popUpDiv = querySelector(popupId);
    windowWidth = (windowWidth/2-200).floor();
    popUpDiv.style.left = windowWidth.toString() + 'px';
    
    return new Point(windowWidth, 0);
  }
  
  void dismiss(String popupId)
  {
    hide("#blanket");
    hide(popupId);
  }
  
  void popup(String popupId)
  {
    print("popup"+popupId);
    blanketSize(popupId);
    windowPosition(popupId);
    show('#blanket');
    show(popupId); 
  }
  
  void buttons(bool dismissFail, bool dismissSuccess, bool dismissFinal, bool clipboard)
  {
    ButtonElement button1 = querySelector("#dismissFail");
    ButtonElement button2 = querySelector("#dismissSuccess");
    ButtonElement button3 = querySelector("#dismissFinal");
    ButtonElement button4 = querySelector("#clipboard");
    
    button1.hidden = dismissFail;
    button2.hidden = dismissSuccess;
    button3.hidden = dismissFinal;
    button4.hidden = clipboard; 
  }
  
  void setFailText(String title, String description)
  {
    querySelector("#popupTitle").innerHtml = title;
    OutputElement text = querySelector("#popupText");
    text.innerHtml = description;
  }
  
  void setText(String option)
  {
    String title;
    String description;
    
    if(option == "add-licence")
    {
      title = "Licence Created";
      description = "The Licence Is: ";
      querySelector("#popupTitle").innerHtml = title;
      OutputElement text = querySelector("#popupText");
      text.innerHtml = description;
    }
    if(option == "add-admin")
    {
      title = "Admin Created";
      description = "The Admin Account Was Successfully Created: ";
      querySelector("#popupTitle").innerHtml = title;
      OutputElement text = querySelector("#popupText");
      text.innerHtml = description;
    }
    if(option == "add-permissions")
    {
      title = "Permission Added";
      description = "The Permission Was Successfully Added: ";
      querySelector("#popupTitle").innerHtml = title;
      OutputElement text = querySelector("#popupText");
      text.innerHtml = description;
    }
    if(option == "change-password")
    {
      title = "Password Changed";
      description = "Your Password Was Successfully Changed: ";
      querySelector("#popupTitle").innerHtml = title;
      OutputElement text = querySelector("#popupText");
      text.innerHtml = description;
    }
    if(option == "regenerate-licence")
    {
      title = "Licence Regenerated";
      description = "The Licence Has Been Successfully Regenerated: ";
      querySelector("#popupTitle").innerHtml = title;
      OutputElement text = querySelector("#popupText");
      text.innerHtml = description;
    }
    if(option == "remove-admin")
    {
      title = "Admin Removed";
      description = "The Admin Has Been Successfully Removed: ";
      querySelector("#popupTitle").innerHtml = title;
      OutputElement text = querySelector("#popupText");
      text.innerHtml = description;
    }
    if(option == "remove-licence")
    {
      title = "Licence Removed";
      description = "The Licence Has Been Successfully Removed: ";
      querySelector("#popupTitle").innerHtml = title;
      OutputElement text = querySelector("#popupText");
      text.innerHtml = description;
    } 
    if(option == "no-username")
    {
      title = "Error";
      description = "No Username Entered, Please Enter A Username.";
      querySelector("#popupTitle").innerHtml = title;
      OutputElement server = querySelector("#serverResponse");
      server.innerHtml = "";
      OutputElement text = querySelector("#popupText");
      text.innerHtml = description;
    }
    if(option == "passwords-dont-match")
    {
      title = "Error";
      description = "The Passwords Do Not Match, Please Try Again.";
      querySelector("#popupTitle").innerHtml = title;
      OutputElement server = querySelector("#serverResponse");
      server.innerHtml = "";
      OutputElement text = querySelector("#popupText");
      text.innerHtml = description;
    }
    if(option == "no-password")
    {
      title = "Error";
      description = "Password Not Entered, Please Enter A Password.";
      querySelector("#popupTitle").innerHtml = title;
      OutputElement server = querySelector("#serverResponse");
      server.innerHtml = "";
      OutputElement text = querySelector("#popupText");
      text.innerHtml = description;
    }
    if(option == "no-licence-name")
    {
      title = "Error";
      description = "Please Enter A Licence Name To Continue.";
      querySelector("#popupTitle").innerHtml = title;
      OutputElement server = querySelector("#serverResponse");
      server.innerHtml = "";
      OutputElement text = querySelector("#popupText");
      text.innerHtml = description;
    }
    if(option == "no-option-selected")
    {
      title = "Error";
      description = "No Licence Length Option Selected, Please Pick An Option.";
      querySelector("#popupTitle").innerHtml = title;
      OutputElement text = querySelector("#popupText");
      text.innerHtml = description;
      OutputElement server = querySelector("#serverResponse");
      server.innerHtml = "";
    }
  }
  
  void setErrorPicture(bool a)
  {
    if(a == true)
      querySelector("#tick").setAttribute("src", "images/dialogWarning2.png");
    else
      querySelector("#tick").setAttribute("src", "images/ticksmall.png");
  }
  
  void getResult(Function popup, String response)
  {
    OutputElement output = querySelector("#serverResponse");
    output.innerHtml = response;
    licenceName = response;
    popup; 
  }
  
  String getLicenceName()
  {
    return licenceName;
  }
  
  void dismissPrompt(MouseEvent e)
  {
    dismiss("#popUpDiv");
  }
}