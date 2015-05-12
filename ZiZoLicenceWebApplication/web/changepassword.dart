import 'dart:html';

void main()
{
  window.onContentLoaded.listen(refresh);
  refresh(null); 
}

void refresh(Event e)
{
  querySelector("#username-output").innerHtml = window.sessionStorage['username'];
  InputElement username = querySelector("#username");
  username.value = window.sessionStorage['username'];
  username.disabled = true; 
}