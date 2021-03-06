
import 'controller.dart';
import 'request.dart';
import 'response.dart';
import 'body.dart';

typedef controllerGetter = Controller Function();

class Linkable{
  List<controllerGetter> links = List.empty(growable: true);
  Linkable link(controllerGetter getter){
    links.add(getter);
    return this;
  }
  Future<Response> handle(Request request) async{
    for(var i = 0; i < links.length; i++){
      var getter = links[i];
      var controller = getter();
      var result = await controller.handle(request);
      if(result is Response){
        return result;
      }
    }
    return Response.internalServerError();
  }
}

class Router{
  Map<Uri, Linkable> linksMap = {};
  Linkable route(String path){
    if(!path.startsWith('/')){
      path = '/' + path;
    }
    var uri = Uri(path: path);
    var link = Linkable();
    linksMap[uri] = link;
    return link;
  }
  Future<Response> processRequest(Request request) async{
    var link = linksMap[request.uri];
    if(link == null){
      return Response.notFound();
    }
    try{
      return await link.handle(request);
    }catch(e){
      return Response.internalServerError(body: Body.fromMap({'Endpoint exception' : e.toString()}));
    }

  }
}