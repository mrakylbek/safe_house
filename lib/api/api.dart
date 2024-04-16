import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class APIRepository {
  late Dio _client;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  APIRepository() {
    _client = Dio()
      ..options.baseUrl = 'https://test.profcleaning.kz/api'
      ..interceptors.add(
        InterceptorsWrapper(onRequest: (RequestOptions option,
            RequestInterceptorHandler interceptorHandler) async {
          // _storage.deleteAll();
          String? token = await _storage.read(key: "accessToken");
          option.headers.addAll({
            "Authorization": "Bearer $token",
            // "Accept": "application/json",
          });

          return interceptorHandler.next(option);
        }, onError: (DioError error, ErrorInterceptorHandler handler) {
          print(error);
        }),
      );
  }
  Future<Response> logIn(
      {String? username, String? password, required String deviceId}) async {
    print(deviceId);
    return await Dio().post(
      'https://test.profcleaning.kz/api/v1/login',
      data: {
        "username": username,
        "password": password,
        'app_id': deviceId,
      },
    );
  }

  Future<Response> signUp({
    String? email,
    String? password,
    String? name,
    String? surname,
    String? username,
  }) async {
    return await Dio()
        .post('https://test.profcleaning.kz/api/v1/registration', data: {
      "email": email,
      "password": password,
      "username": username,
      'surname': surname,
      'name': name,
    });
  }

  Future<Response> fetchProfile() async {
    return await _client.get('/v1/user');
  }

  Future<Response> addHouse(
      {required String lat,
      required String let,
      required String address}) async {
    return await _client.post('/v1/houses', data: {
      "lat": lat,
      "let": let,
      "address": address,
    });
  }

  Future<Response> deleteHouse({required int houseId}) async {
    return await _client
        .post('/v1/houses/$houseId', data: {'_method': 'delete'});
  }

  Future<Response> fetchNotifications() async {
    return await _client.get('/v1/user/notifications');
  }

  Future<Response> updateUser(
      {required int userId, required int status}) async {
    return await _client.post(
      '/v1/users/$userId',
      data: {
        // '_method': 'put',
        'notification': '$status',
      },
    );
  }

  Future<Response> sendDeviceId(String deviceId) async {
    Map<String, dynamic> map = {'app_number': deviceId};
    FormData data = FormData.fromMap(map);
    return await _client.post('/v1/devices', data: data);
  }

  Future<Response> getStatus(String deviceId) async {
    Map<String, dynamic> map = {'filter[app_number]': deviceId};
    // FormData data = FormData.fromMap(map);
    return await _client.get('/v1/user/home', queryParameters: map);
  }

  Future<Response> sendStatus(int notificationId) async {
    Map<String, dynamic> map = {'_method': 'put', 'state': 'normal'};
    FormData data = FormData.fromMap(map);
    return await _client.post('/v1/notifications/$notificationId', data: data);
  }
}
