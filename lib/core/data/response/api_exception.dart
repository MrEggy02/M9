// ignore_for_file: prefer_typing_uninitialized_variables, unused_field

class AppException implements Exception {
  final _message;
  final _prefix;

  AppException(this._message, this._prefix);

  @override
  String toString() {
    return '${_message ?? ''}';
  }
}

class FetchDataException extends AppException {
  FetchDataException(message) : super(message, "");
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message, "");
}

class ForbiddenException extends AppException {
  ForbiddenException([message]) : super(message, "");
}

class InvalidInputException extends AppException {
  InvalidInputException([message]) : super(message, "");
}

class ServerException extends AppException {
  ServerException([message]) : super(message, "");
}

class NotFoundException extends AppException {
  NotFoundException([message]) : super(message, "");
}

/// [LLMISUIException] can be able to show the error message to user
class LLMISUIException extends AppException {
  LLMISUIException({required String message, String? prefix})
      : super(message, prefix);
}