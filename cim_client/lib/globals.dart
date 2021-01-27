enum CIMErrors {
  ok,
  connectionErrorServerNotFound,
  connectionErrorServerDbFault,
  unexpectedServerResponse,
  wrongUserCredentials
}

const Map<CIMErrors, String> mapError = {
  CIMErrors.connectionErrorServerNotFound: "connection_error_server_not_found",
  CIMErrors.connectionErrorServerDbFault: "connection_error_server_db_fault",
  CIMErrors.unexpectedServerResponse: "unexpected_server_response",
  CIMErrors.wrongUserCredentials: "wrong_user_credentials"
};
