import 'package:postgres/postgres.dart';

class Connection extends PostgreSQLConnection{
  Connection(String host, int port, String databaseName,
      {String? username, String? password, int timeoutInSeconds = 30,
        int queryTimeoutInSeconds = 30, String timeZone = 'UTC',
        bool useSSL = false, bool isUnixSocket = false}) : super(host, port,
        databaseName, username: username, password: password,
        timeoutInSeconds: timeoutInSeconds,
        queryTimeoutInSeconds: queryTimeoutInSeconds, timeZone: timeZone,
        useSSL: useSSL, isUnixSocket: isUnixSocket);
}