// import 'package:dio/dio.dart';

// class APIRepository {
//   late Dio _client;
//   APIRepository() {
//     _client = Dio()..options.baseUrl = 'https://zara.profcleaning.kz/api';
//   }

//   Future<Response> sendDeviceId(String deviceId) async {
//     Map<String, dynamic> map = {'app_number': deviceId};
//     FormData data = FormData.fromMap(map);
//     return await _client.post('/v1/devices', data: data);
//   }

//   Future<Response> getStatus(String deviceId) async {
//     Map<String, dynamic> map = {'filter[app_number]': deviceId};
//     // FormData data = FormData.fromMap(map);
//     return await _client.get('/v1/user/home', queryParameters: map);
//   }
// }
