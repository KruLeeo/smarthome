// init_dependencies.dart
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:testik2/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:testik2/features/auth/data/repositories/auth_repositoriy_impl.dart';
import 'package:testik2/features/auth/domain/repository/auth_repository.dart';
import 'package:testik2/features/auth/domain/usecases/user_sign_up.dart';
import 'package:testik2/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:testik2/features/device/bloc/devices_bloc.dart';
import 'package:testik2/features/scenes/bloc/scenes_bloc.dart';
import 'package:testik2/screens/home_controll_bloc.dart';

import 'core/secrets/app_secrets.dart';
import 'features/auth/domain/usecases/user_login.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initDevice();
  _initScenes();

  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnnonKey,
  );

  serviceLocator.registerLazySingleton(() => supabase.client);
}

void _initAuth() {
  serviceLocator.registerFactory<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(serviceLocator()));
  serviceLocator.registerFactory<AuthRepository>(() => AuthRepositoryImpl(serviceLocator()));
  serviceLocator.registerFactory(() => UserSignUp(serviceLocator()));
  serviceLocator.registerFactory(() => UserLogin(serviceLocator()));
  serviceLocator.registerFactory<HomeControlBloc>(() => HomeControlBloc());
  serviceLocator.registerFactory(() => AuthBloc(
    userSignUp: serviceLocator(),
    userLogin: serviceLocator(),
  ));
}

void _initDevice() {
  serviceLocator.registerFactory<DevicesBloc>(() => DevicesBloc());
}

void _initScenes() {
  serviceLocator.registerFactory<ScenesBloc>(() => ScenesBloc());
}