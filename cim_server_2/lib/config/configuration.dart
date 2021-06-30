import 'dart:io';

class Configuration{
  late File file;
  Configuration(String yamlFile){
    file = File(yamlFile);
  }
}