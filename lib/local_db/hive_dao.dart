import 'package:hive_flutter/hive_flutter.dart';
import 'package:sneakers_app/local_db/hive_constants.dart';

import '../entities/response/meta_response.dart';
import '../entities/response/sneakers_response.dart';
import '../entities/vos/sneaker_vo.dart';
import '../utils/log_util.dart';

class LocalDbDAO {
  LocalDbDAO._();

  static final LocalDbDAO _instance = LocalDbDAO._();

  static LocalDbDAO get instance => _instance;

  Future<void> initDB() async {
    try {
      await Hive.initFlutter();

      Hive.registerAdapter(SneakerVOAdapter());
      Hive.registerAdapter(MetaResponseAdapter());
      Hive.registerAdapter(SneakersResponseAdapter());

      await Hive.openBox<SneakersResponse>(kHiveBoxForSneakers);
      await Hive.openBox<DateTime>(kHiveBoxForTimeLastFetch);
      await Hive.openBox<int>(kHiveBoxForSneakerPage);

      await Hive.openBox<SneakersResponse>(kHiveBoxForSearchSneakers);
      await Hive.openBox<DateTime>(kHiveBoxForTimeLastSearch);
      await Hive.openBox<int>(kHiveBoxForSearchedSneakersPage);

      logger.d('Successfully initialized local database for sneakers!');
    } catch (error) {
      logger.e('Error initializing for local database: $error');
    }
  }

  //Boxes
  //--Home Page
  Box<SneakersResponse> _sneakersBox() =>
      Hive.box<SneakersResponse>(kHiveBoxForSneakers);
  Box<DateTime> _timeLastFetchBox() =>
      Hive.box<DateTime>(kHiveBoxForTimeLastFetch);
  Box<int> _sneakerPageBox() => Hive.box<int>(kHiveBoxForSneakerPage);

  //--Search Page
  Box<SneakersResponse> _searchedSneakersBox() =>
      Hive.box<SneakersResponse>(kHiveBoxForSearchSneakers);
  Box<DateTime> _timeLastSearchBox() =>
      Hive.box<DateTime>(kHiveBoxForTimeLastSearch);
  Box<int> _searchedSneakerPageBox() =>
      Hive.box<int>(kHiveBoxForSearchedSneakersPage);

  //Get Data
//--HomePage
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

  int? getLastLoadedSneakerPage() {
    try {
      return _sneakerPageBox().get(kHiveKeyForSneakerPage);
    } catch (error) {
      logger.e('Error getting last loaded page from local db: $error');
      return null;
    }
  }

  //--Search page
  SneakersResponse? getSearchedSneakers() {
    try {
      return _searchedSneakersBox().get(kHiveKeyForSearchSneakers);
    } catch (error) {
      logger.e('Error getting searched sneakers from local db: $error');
      return null;
    }
  }

  DateTime? getLastSearchTime() {
    try {
      return _timeLastSearchBox().get(kHiveKeyForTimeLastSearch);
    } catch (error) {
      logger.e('Error getting last search time from local db: $error');
      return null;
    }
  }

  int? getLastSearchedSneakerPage() {
    try {
      return _searchedSneakerPageBox().get(kHiveKeyForSearchedSneakersPage);
    } catch (error) {
      logger.e('Error getting last searched page from local db: $error');
      return null;
    }
  }

  //Insert Data
  //--home Page
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

  void saveLastLoadedSneakerPage({required int page}) {
    try {
      _sneakerPageBox().put(kHiveKeyForSneakerPage, page);
    } catch (error) {
      logger.e('Error saving last loaded page to local db: $error');
    }
  }

  //--Search page
  void saveSearchedSneakers({required SneakersResponse sneakers}) {
    try {
      _searchedSneakersBox().put(kHiveKeyForSearchSneakers, sneakers);
    } catch (error) {
      logger.e('Error saving searched sneakers to local db: $error');
    }
  }

  void saveLastSearchTime({required DateTime lastSearchTime}) {
    try {
      _timeLastSearchBox().put(kHiveKeyForTimeLastSearch, lastSearchTime);
    } catch (error) {
      logger.e('Error saving last search time to local db: $error');
    }
  }

  void saveLastSearchedSneakerPage({required int page}) {
    try {
      _searchedSneakerPageBox().put(kHiveKeyForSearchedSneakersPage, page);
    } catch (error) {
      logger.e('Error saving last searched page to local db: $error');
    }
  }

  //Check If data is available
  //--Home page
  bool isCachedSneakersAvailable() {
    try {
      return _sneakersBox().isNotEmpty;
    } catch (error) {
      logger
          .e('Error checking if sneakers are available from local db: $error');
      return false;
    }
  }

  bool isCachedLastFetchTimeAvailable() {
    try {
      return _timeLastFetchBox().isNotEmpty;
    } catch (error) {
      logger.e(
          'Error checking if last fetch time is available from local db: $error');
      return false;
    }
  }

  bool isCachedLastLoadedPageAvailable() {
    try {
      return _sneakerPageBox().isNotEmpty;
    } catch (error) {
      logger.e(
          'Error checking if last loaded page is available from local db: $error');
      return false;
    }
  }

  //--Search Page
  bool isCachedSearchedSneakersAvailable() {
    try {
      return _searchedSneakersBox().isNotEmpty;
    } catch (error) {
      logger
          .e('Error checking if searched sneakers are available from local db: $error');
      return false;
    }
  }

  bool isCachedLastSearchTimeAvailable() {
    try {
      return _timeLastSearchBox().isNotEmpty;
    } catch (error) {
      logger.e(
          'Error checking if last search time is available from local db: $error');
      return false;
    }
  }

  bool isCachedLastSearchedPageAvailable() {
    try {
      return _searchedSneakerPageBox().isNotEmpty;
    } catch (error) {
      logger.e(
          'Error checking if last searched page is available from local db: $error');
      return false;
    }
  }
}
