library soap;

import 'dart:html';
import 'dart:async';
import 'dart:js';

bool testing = false;

class SoapRequest
{
  List<Object> arguments = new List();
  String _action;
  String _host;
  StringBuffer buffer = new StringBuffer();
  HttpRequest request;
  
  Stream<ProgressEvent> sendRequest()
  {
    String uriv = uri();
    request = new HttpRequest();
    request.open('POST', uriv);
    request.setRequestHeader('Content-Type', 'text/xml');
    writeRequestHeader();
    writeRequestBody();
    writeRequestTail();
    request.send(buffer.toString());
    return request.onReadyStateChange;
  }

  void getStringResult(Function onReturn)
  {
    if (testing)
    {
      String result = context.callMethod('prompt',[action()+": "+arguments.toString(),""]);
      onReturn(result);
      return;
    }
    sendRequest().listen((ProgressEvent e) 
    {
      if (request.readyState==4)
      {
        if (request.status==200)
          onReturn(xmlResponseText());
      }
    });
  }
  
  String host()
  {
    return _host;
  }
  
  String path()
  {
    return "";
  }
  
  String action()
  {
    return _action;
  }
  
  void writeRequestHeader()
  {
    buffer.writeln("<?xml version='1.0' encoding='UTF-8'?>");
    buffer.writeln(" <S:Envelope xmlns:S='http://schemas.xmlsoap.org/soap/envelope/'>");
    buffer.writeln(" <S:Header/>");
    buffer.writeln(" <S:Body>");
  }
  
  writeRequestTail()
  {
    buffer.writeln(" </S:Body>");
    buffer.writeln("</S:Envelope>");
  }
  
  writeRequestBody()
  {
    buffer.writeln("<ns2:"+action()+" xmlns:ns2='http://"+namespace()+"/'>");
    writeRequestArguments();
    buffer.writeln("</ns2:"+action()+">");
  }
  
  writeRequestArguments()
  {
    for(int i = 0; i < numberOfArguments(); i++)
    {
      writeRequestArgument(i);
    }
  }
  
  writeRequestArgument(int i)
  {
    buffer.writeln("<arg"+i.toString()+">"+getArgument(i)+"</arg"+i.toString()+">");
  }
  
  getArgument(int i)
  {
    return arguments[i];
  }
  
  numberOfArguments()
  {
    return arguments.length;
  }
  
  String namespace()
  {
    return "";
  }
  
  setAction(String a)
  {
    _action = a;
  }
  
  setHost(String h)
  {
    _host = h;
  }
  
  addArgument(String arg)
  {
    arguments.add(arg);
  }
  
  String uri()
  {
    return "http://"+packageName();
  }
  
  String packageName()
  {
    return host()+"/"+path();
  }
  
  String xmlResponseText()
  {
    Node envelope;
    Node body;
    Node response;
    
    envelope = request.responseXml.nodes[0];
    body = envelope.nodes[0];
    response = body.nodes[0];
    return response.text;
  }
}