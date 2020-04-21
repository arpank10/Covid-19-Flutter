import 'dart:convert';
import 'dart:io';

import 'package:covid/Helpers/app_exceptions.dart';
import 'package:http/http.dart' as http;

class ApiBaseHelper {

  Future<dynamic> get(String url) async {
    var responseBody;
    try {
      final response = await http.get(url);
      responseBody = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on http.ClientException {
      throw FetchDataException('No Internet connection');
    }
    return responseBody;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseBody = response.body;
        return responseBody;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
          'Error occured while Communication with Server with StatusCode : ${response
            .statusCode}');
    }
  }
}