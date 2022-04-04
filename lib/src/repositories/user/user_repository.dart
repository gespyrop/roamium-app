import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:roamium_app/src/models/user.dart';

part 'exceptions.dart';

abstract class UserRepository {
  /// Logs the user in using the provided [email] and [password].
  Future<User> login(String email, String password);

  /// Registers a new user
  Future<User> register(
    String email,
    String password, {
    required String firstName,
    required String lastName,
  });
}

class DioUserRepository implements UserRepository {
  static const accessTokenKey = 'access_token';
  static const refreshTokenKey = 'refresh_token';

  final FlutterSecureStorage storage;
  Dio client;

  DioUserRepository({required this.client, required this.storage});

  /// Returns the authenticated user using the provided [accessToken].
  Future<User> _fetchUser(String accessToken) async {
    try {
      int userId = JwtDecoder.decode(accessToken)['user_id'];
      Response response = await client.get('/user/$userId/');

      return User.fromJSON(response.data);
    } on DioError catch (e) {
      if (e.response == null || e.response!.statusCode != 401) {
        throw AuthenticationException();
      }

      throw AuthenticationException(message: "userNotFound");
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
        throw AuthenticationException();
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

      throw RegistrationException();
    }
  }
}
