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

}