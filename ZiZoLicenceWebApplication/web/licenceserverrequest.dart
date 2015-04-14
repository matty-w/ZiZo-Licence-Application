import 'soaprequest.dart';

class LicenceServerRequest extends SoapRequest
{
  static void checkAdminLogin(String name,String password,String host,Function onPass,Function onFail)
  {
    LicenceServerRequest result;
    result = new LicenceServerRequest();
    result.setHost(host);
    result.setAction("checkAdminLogin");
    result.addArgument(name);
    result.addArgument(password);
    result.getStringResult((s) => (s=="true")? onPass() : onFail ());
  }
  
  @override
  namespace()
  {
    return "licence.zizo.decsim.com";
  }
  
  String path()
  {
    return "DataReLicenceServer/LicenceServer";
  }
}