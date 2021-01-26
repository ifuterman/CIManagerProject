enum CIMErrors{
  ok,
  connection_error_server_not_found,
  connection_error_server_db_fault,
  unexpected_server_response,
  wrong_user_credentials
}

const Map<CIMErrors, String> mapError = {
  CIMErrors.connection_error_server_not_found: "connection_error_server_not_found",
  CIMErrors.connection_error_server_db_fault: "connection_error_server_db_fault",
  CIMErrors.unexpected_server_response: "unexpected_server_response",
  CIMErrors.wrong_user_credentials: "wrong_user_credentials"
};