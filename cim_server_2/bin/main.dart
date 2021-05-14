import 'package:cim_server_2/src/app_channel.dart';
import 'package:cim_server_2/src/config/server_configuration.dart';
import 'package:cim_server_2/src/http/server.dart';
import 'package:cim_server_2/src/orm/orm.dart';




void main(List<String> args) async {
  /*var config = ServerConfiguration;
  var server = Server<AppChannel>(config.host, config.port);
  await server.start(timeout: Duration(seconds: 30));*/
  var connection = Connection('45.86.183.142', 5432, 'cim_database', username: 'cimserver', password: 'cimtestserver');
  var query = Query<TestTable>(connection)
    ..where((x) => x.id).equalTo(0);
  var r = await query.select();

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