import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:m9/core/data/network/api_path.dart';
import 'package:m9/core/data/response/api_exception.dart';
import 'package:m9/core/data/response/api_response.dart';



class NetworkCall {
  final Logger log = Logger();
  Future<ApiResponse> request({
    required String paths,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    required method,
   
  }) async {
    dynamic requestBody;
    final url = Uri.parse(paths);
    if (body != null) {
      requestBody = jsonEncode(body);
    }
   // log.d('Request: $method => $url, headers = $headers, body = $requestBody');

    try {
      dynamic response;
      switch (method) {
        case ApiPaths.getRequest:
          response = await http.get(url, headers: headers);
          break;
        case ApiPaths.postRequest:
          response = await http.post(url, headers: headers, body: requestBody);
          break;
        case ApiPaths.putRequest:
          response = await http.put(url, headers: headers, body: requestBody);
          break;
        case ApiPaths.patchRequest:
          response = await http.patch(url, headers: headers, body: requestBody);
          break;
        case ApiPaths.deleteRequest:
          response =
              await http.delete(url, headers: headers, body: requestBody);
          break;
        default:
          response = await http.get(url, headers: headers);
      }
      return _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on FormatException {
      throw FetchDataException('Error while parsing response');
    }
  }

  dynamic _returnResponse(http.Response response) {
    //log.d('Response: ${response.statusCode} => ${response.body}');
    switch (response.statusCode) {
      case HttpStatus.ok:
        return ApiResponse.fromJson(json.decode(response.body));
      case HttpStatus.badRequest:
        throw BadRequestException('Your request is invalid');
      case HttpStatus.unauthorized:
        throw UnauthorisedException('Invalid Unauthorized');
      case HttpStatus.forbidden:
        throw ForbiddenException(
            'Access to the resources on the server is denied!');
      case HttpStatus.notFound:
        throw NotFoundException('Not found response');
      case HttpStatus.internalServerError:
        throw ServerException('Something went wrong on server side');
      default:
        throw FetchDataException(
            'Error occured while communication with server');
    }
  }
}