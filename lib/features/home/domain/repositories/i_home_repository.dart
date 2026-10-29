import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/home/domain/entities/home_data_entity.dart';

/// Abstract contract for Home Data operations.
///
/// Follows Dependency Inversion Principle (DIP): High-level Use Cases depend
/// on this abstraction, while Data Layer implements it.
abstract class IHomeRepository {
  /// Fetches aggregated home page data.
  ///
  /// NOTE FOR BACKEND INTEGRATION:
  /// In case the backend splits this data across multiple REST endpoints
  /// (e.g. /hero-slides, /featured, /top-stories, /ambassadors, /regions),
  /// the concrete implementation (HomeRepositoryImpl) will orchestrate them
  /// concurrently using `Future.wait([...])` to maintain 0ms UI delay and
  /// keep the Domain and Presentation layers 100% untouched.
  Future<ApiResult<HomeDataEntity>> getHomeData();
}

