import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:roamium_app/src/models/user.dart';

part 'exceptions.dart';

abstract class UserRepository {
  /// Logs the user in using the provided [email] and [password].
  Future<User> login(String email, String password);

  /// Registers a new user.
  Future<User> register(
    String email,
    String password, {
    required String firstName,
    required String lastName,
  });

  /// Uses a stored token to login when the app starts.
  Future<User?> loginFromStoredToken();

  /// Logs the user out.
  Future<void> logout();
}

class DioUserRepository implements UserRepository {
  static const accessTokenKey = 'access_token';
  static const refreshTokenKey = 'refresh_token';

  final FlutterSecureStorage storage;
  final Dio client;

  DioUserRepository({required this.client, required this.storage}) {
    client.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          // If the token is expired
          if (error.response?.statusCode == 401 &&
              error.response?.data['code'] == 'token_not_valid') {
            if (error.requestOptions.path == '/token/refresh/') {
              // Logout if it fails to refresh the token
              await logout();
            } else {
              // Grab the stored refresh token and try to refresh it
              String? refreshToken = await storage.read(key: refreshTokenKey);
              if (refreshToken != null) {
                try {
                  await _refreshToken(refreshToken);
                  return handler.resolve(await _retry(error.requestOptions));
                } on DioError catch (e) {
                  return handler.next(e);
                }
              }
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<void> _refreshToken(String refreshToken) async {
    // Refresh the token
    Response response = await client.post(
      '/token/refresh/',
      data: {'refresh': refreshToken},
    );

    String accessToken = response.data['access'];
    await storage.write(key: accessTokenKey, value: accessToken);
    client.options.headers
        .update('Authorization', (value) => 'Bearer $accessToken');
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final Options options = Options(
      method: requestOptions.method,
      headers: client.options.headers,
    );

    return client.request(
      requestOptions.path,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  /// Returns the authenticated user using the provided [accessToken].
  Future<User> _fetchUser(String accessToken) async {
    try {
      int userId = JwtDecoder.decode(accessToken)['user_id'];
      Response response = await client.get('/user/$userId/');

      return User.fromJSON(response.data);
    } on DioError catch (e) {
      if (e.response?.statusCode == 401 &&
          e.response?.data['detail'] == 'token_not_valid') {
        throw AuthenticationException(message: "userNotFound");
      }

      throw AuthenticationException(message: e.message);
    }
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      Response response = await client.post('/token/', data: {
        'email': email,
        'password': password,
      });

      Map<String, dynamic> json = response.data;

      // Grab the tokens
      String accessToken = json["access"];
      String refreshToken = json["refresh"];

      // Store the tokens
      await storage.write(key: accessTokenKey, value: accessToken);
      await storage.write(key: refreshTokenKey, value: refreshToken);

      // Add the access token to the client's headers
      client.options.headers.addAll({'Authorization': 'Bearer $accessToken'});

      return await _fetchUser(accessToken);
    } on DioError catch (e) {
      if (e.response == null || e.response!.statusCode != 401) {
        throw AuthenticationException(message: e.message);
      }

      throw AuthenticationException(message: "noAccountWithGivenCredentials");
    }
  }

  @override
  Future<User> register(
    String email,
    String password, {
    required String firstName,
    required String lastName,
  }) async {
    try {
      Response response = await client.post('/user/', data: {
        'email': email,
        'password': password,
        'first_name': firstName,
        'last_name': lastName,
      });

      return User.fromJSON(response.data);
    } on DioError catch (e) {
      if (e.response != null && e.response!.statusCode == 400) {
        Map<String, dynamic> errorData =
            e.response!.data as Map<String, dynamic>;

        if (errorData.containsKey('email')) {
          throw RegistrationException(message: 'emailAlreadyInUse');
        }
      }

      throw RegistrationException(message: e.message);
    }
  }

  @override
  Future<User?> loginFromStoredToken() async {
    String? accessToken = await storage.read(key: accessTokenKey);

    if (accessToken != null) {
      client.options.headers.addAll({'Authorization': 'Bearer $accessToken'});
      return await _fetchUser(accessToken);
    }

    return null;
  }

  @override
  Future<void> logout() async {
    client.options.headers.remove('Authorization');
    await storage.deleteAll();
  }
}
