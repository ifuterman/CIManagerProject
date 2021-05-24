import 'package:yaml/yaml.dart';

import 'configuration.dart';

// ignore: non_constant_identifier_names
final ServerConfiguration = _ServerConfiguration();

class _ServerConfiguration extends Configuration{
  late YamlMap _map;
  _ServerConfiguration() : super('config.yaml'){
    var yamlString = file.readAsStringSync();
    var doc = loadYamlDocument(yamlString);
    _map = doc.contents as YamlMap;
  }

  int get port => _map['server_port'];
  String get host => _map['server_host'];
  String get database_host => _map['database']['host'];
  int get database_port => _map['database']['port'];
  String get database_dbname => _map['database']['database'];
  String get database_username => _map['database']['username'];
  String get database_password => _map['database']['password'];

}