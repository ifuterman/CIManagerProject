import 'package:cim_server_2/src/app_channel.dart';
import 'package:cim_server_2/src/config/server_configuration.dart';
import 'package:cim_server_2/src/http/http.dart';
import 'package:cim_server_2/src/orm/orm.dart';




void main(List<String> args) async {
  var config = ServerConfiguration;
  var server = Server<AppChannel>(config.host, config.port);
  await server.start(timeout: Duration(seconds: 30));
  /*var query = Query<TestTable>(connection)
    ..where((x) => x.id).equalTo(159);
  var r = await query.select();*/

}

class TestTable extends ManagedObject<_TestTable> implements _TestTable{

}
@Table('users')
class _TestTable{
  @Column()
  int? id;
  @Column()
  String? username;
  @Column()
  String? pwrd;
  @Column()
  String? role;
}