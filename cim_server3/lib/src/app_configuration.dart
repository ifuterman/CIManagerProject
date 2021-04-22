import 'package:liquidart/liquidart.dart';
import 'dart:io';

class AppConfiguration extends Configuration{
  AppConfiguration.fromFile(File file) :super.fromFile(file);
  DatabaseConfiguration database = DatabaseConfiguration();
  late String server_host;
  late int server_port;
  late bool console_logging;
/*  String host;
  String port;
  String databaseName;*/
}