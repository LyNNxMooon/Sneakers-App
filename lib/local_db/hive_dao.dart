import 'package:hive_flutter/hive_flutter.dart';
import 'package:sneakers_app/local_db/hive_constants.dart';

import '../features/home_products/data/response/meta_response.dart';
import '../features/home_products/data/response/query_response.dart';
import '../features/home_products/data/response/sneakers_response.dart';
import '../features/home_products/data/vos/sneaker_vo.dart';
import '../utils/log_util.dart';

class LocalDbDAO {
  LocalDbDAO._();

  static final LocalDbDAO _instance = LocalDbDAO._();

  static LocalDbDAO get instance => _instance;

  Future<void> initDB() async {
    try {
      await Hive.initFlutter();

      Hive.registerAdapter(SneakerVOAdapter());
      Hive.registerAdapter(QueryResponseAdapter());
      Hive.registerAdapter(MetaResponseAdapter());
      Hive.registerAdapter(SneakersResponseAdapter());

      await Hive.openBox<SneakersResponse>(kHiveBoxForSneakers);
      await Hive.openBox<DateTime>(kHiveBoxForTimeLastFetch);
      await Hive.openBox<int>(kHiveBoxForSneakerPage);

      logger.d('Successfully initialized local database for sneakers!');
    } catch (error) {
      logger.e('Error initializing for local database: $error');
    }
  }

  //Boxes
  Box<SneakersResponse> _sneakersBox() =>
      Hive.box<SneakersResponse>(kHiveBoxForSneakers);
  Box<DateTime> _timeLastFetchBox() =>
      Hive.box<DateTime>(kHiveBoxForTimeLastFetch);
  Box<int> _sneakerPageBox() => Hive.box<int>(kHiveBoxForSneakerPage);

  //Get Data
  SneakersResponse? getSneakers() {
    try {
      return _sneakersBox().get(kHiveKeyForSneakers);
    } catch (error) {
      logger.e('Error getting sneakers from local db: $error');
      return null;
    }
  }

  DateTime? getLastFetchTime() {
    try {
      return _timeLastFetchBox().get(kHiveKeyForTimeLastFetch);
    } catch (error) {
      logger.e('Error getting last fetch time from local db: $error');
      return null;
    }
  }

  int? getLastLoadedSneakerPage () {
    try {
      return _sneakerPageBox().get(kHiveKeyForSneakerPage);
    } catch (error) {
      logger.e('Error getting last loaded page from local db: $error');
      return null;
    }
  }

  //Insert Data
  void saveSneakers({required SneakersResponse sneakers}) {
    try {
      _sneakersBox().put(kHiveKeyForSneakers, sneakers);
    } catch (error) {
      logger.e('Error saving sneakers to local db: $error');
    }
  }

  void saveLastFetchTime({required DateTime lastFetchTime}) {
    try {
      _timeLastFetchBox().put(kHiveKeyForTimeLastFetch, lastFetchTime);
    } catch (error) {
      logger.e('Error saving last fetch time to local db: $error');
    }
  }

  void saveLastLoadedSneakerPage ({required int page}) {
    try {
      _sneakerPageBox().put(kHiveKeyForSneakerPage, page);
    } catch (error) {
      logger.e('Error saving last loaded page to local db: $error');
    }
  }

  //Check If data is available
  bool isCachedSneakersAvailable() {
    try {
      return _sneakersBox().isEmpty;
    } catch (error) {
      logger
          .e('Error checking if sneakers are available from local db: $error');
      return false;
    }
  }

  bool isCachedLastFetchTimeAvailable() {
    try {
      return _timeLastFetchBox().isEmpty;
    } catch (error) {
      logger.e(
          'Error checking if last fetch time is available from local db: $error');
      return false;
    }
  }

  bool isCachedLastLoadedPageAvailable() {
    try {
      return _sneakerPageBox().isEmpty;
    } catch (error) {
      logger.e(
          'Error checking if last loaded page is available from local db: $error');
      return false;
    }
  }
}
