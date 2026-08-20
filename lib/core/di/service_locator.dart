import 'package:get_it/get_it.dart';
import 'package:sanayi_mobil_app/features/garage/data/datasources/garage_mock_data_source.dart';
import 'package:sanayi_mobil_app/features/garage/data/repositories/garage_repository_impl.dart';
import 'package:sanayi_mobil_app/features/garage/domain/repositories/i_garage_repository.dart';
import 'package:sanayi_mobil_app/features/garage/presentation/cubit/garage_cubit.dart';
import 'package:sanayi_mobil_app/features/home/data/datasources/home_mock_data_source.dart';
import 'package:sanayi_mobil_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:sanayi_mobil_app/features/home/domain/repositories/i_home_repository.dart';
import 'package:sanayi_mobil_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:sanayi_mobil_app/features/main_layout/cubit/navigation_cubit.dart';
import 'package:sanayi_mobil_app/features/notifications/data/datasources/notification_mock_data_source.dart';
import 'package:sanayi_mobil_app/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:sanayi_mobil_app/features/notifications/domain/repositories/i_notification_repository.dart';
import 'package:sanayi_mobil_app/features/notifications/presentation/cubit/notification_cubit.dart';
import 'package:sanayi_mobil_app/features/profile/data/datasources/profile_mock_data_source.dart';
import 'package:sanayi_mobil_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:sanayi_mobil_app/features/profile/domain/repositories/i_profile_repository.dart';
import 'package:sanayi_mobil_app/features/profile/presentation/cubit/profile_cubit.dart';

final getIt = GetIt.instance;

/// Bağımlılık Enjeksiyonu (Dependency Injection) Kurulumu
Future<void> setupServiceLocator() async {
  // 1. Data Sources
  if (!getIt.isRegistered<HomeMockDataSource>()) {
    getIt.registerLazySingleton<HomeMockDataSource>(() => HomeMockDataSource());
  }
  if (!getIt.isRegistered<ProfileMockDataSource>()) {
    getIt.registerLazySingleton<ProfileMockDataSource>(() => ProfileMockDataSource());
  }
  if (!getIt.isRegistered<NotificationMockDataSource>()) {
    getIt.registerLazySingleton<NotificationMockDataSource>(() => NotificationMockDataSource());
  }
  if (!getIt.isRegistered<GarageMockDataSource>()) {
    getIt.registerLazySingleton<GarageMockDataSource>(() => GarageMockDataSource());
  }

  // 2. Repositories
  if (!getIt.isRegistered<IHomeRepository>()) {
    getIt.registerLazySingleton<IHomeRepository>(
      () => HomeRepositoryImpl(dataSource: getIt<HomeMockDataSource>()),
    );
  }
  if (!getIt.isRegistered<IProfileRepository>()) {
    getIt.registerLazySingleton<IProfileRepository>(
      () => ProfileRepositoryImpl(dataSource: getIt<ProfileMockDataSource>()),
    );
  }
  if (!getIt.isRegistered<INotificationRepository>()) {
    getIt.registerLazySingleton<INotificationRepository>(
      () => NotificationRepositoryImpl(dataSource: getIt<NotificationMockDataSource>()),
    );
  }
  if (!getIt.isRegistered<IGarageRepository>()) {
    getIt.registerLazySingleton<IGarageRepository>(
      () => GarageRepositoryImpl(dataSource: getIt<GarageMockDataSource>()),
    );
  }

  // 3. Cubits / ViewModels
  if (!getIt.isRegistered<NavigationCubit>()) {
    getIt.registerFactory<NavigationCubit>(() => NavigationCubit());
  }
  if (!getIt.isRegistered<HomeCubit>()) {
    getIt.registerFactory<HomeCubit>(
      () => HomeCubit(repository: getIt<IHomeRepository>()),
    );
  }
  if (!getIt.isRegistered<ProfileCubit>()) {
    getIt.registerFactory<ProfileCubit>(
      () => ProfileCubit(repository: getIt<IProfileRepository>()),
    );
  }
  if (!getIt.isRegistered<NotificationCubit>()) {
    getIt.registerFactory<NotificationCubit>(
      () => NotificationCubit(repository: getIt<INotificationRepository>()),
    );
  }
  if (!getIt.isRegistered<GarageCubit>()) {
    getIt.registerLazySingleton<GarageCubit>(
      () => GarageCubit(repository: getIt<IGarageRepository>()),
    );
  }
}
