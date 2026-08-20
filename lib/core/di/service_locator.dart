import 'package:get_it/get_it.dart';
import '../../features/home/data/datasources/home_mock_data_source.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/i_home_repository.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/main_layout/cubit/navigation_cubit.dart';

final getIt = GetIt.instance;

/// Bağımlılık Enjeksiyonu (Dependency Injection) Kurulumu
Future<void> setupServiceLocator() async {
  // 1. Data Sources
  getIt.registerLazySingleton<HomeMockDataSource>(() => HomeMockDataSource());

  // 2. Repositories
  getIt.registerLazySingleton<IHomeRepository>(
    () => HomeRepositoryImpl(dataSource: getIt<HomeMockDataSource>()),
  );

  // 3. Cubits / ViewModels
  getIt.registerFactory<NavigationCubit>(() => NavigationCubit());
  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(repository: getIt<IHomeRepository>()),
  );
}
