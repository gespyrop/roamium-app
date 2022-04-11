import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:roamium_app/config.dart';
import 'package:roamium_app/src/app.dart';
import 'package:roamium_app/src/blocs/auth/auth_bloc.dart';
import 'package:roamium_app/src/repositories/place/place_repository.dart';
import 'package:roamium_app/src/repositories/user/user_repository.dart';

void main() => runApp(MultiRepositoryProvider(
      providers: [
        RepositoryProvider<Dio>(
          create: (context) => Dio(BaseOptions(baseUrl: Config.apiAddress)),
        ),
        RepositoryProvider<UserRepository>(
          create: (context) => DioUserRepository(
            client: context.read<Dio>(),
            storage: const FlutterSecureStorage(),
          ),
        ),
        RepositoryProvider<PlaceRepository>(
          create: (context) => DioPlaceRepository(context.read<Dio>()),
        )
      ],
      child: BlocProvider<AuthBloc>(
        create: (context) =>
            AuthBloc(context.read<UserRepository>())..add(CheckToken()),
        child: const Roamium(),
      ),
    ));
