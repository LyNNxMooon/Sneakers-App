
import 'package:sneakers_app/features/home_products/data/response/sneakers_response.dart';

import 'package:sneakers_app/features/home_products/domain/repositories/home_products_repo.dart';

import '../../../../local_db/hive_dao.dart';
import '../../../../network/api/api_constants.dart';
import '../../../../utils/internet_connection_utils.dart';
import '../../../../utils/log_util.dart';

class FetchAndDisplaySneakers {
  final HomeProductsRepo repository;

  FetchAndDisplaySneakers(this.repository);

  //Facade Pattern applies here
  Future<SneakersResponse> call(
    int page,
  ) async {
    //(check if it is required to call api or just load from local db) attempt to load from db if possible
    if (isRequiredToCallApi(page)) {
      //check if internet is connected
      if (await InternetConnectionUtils.instance.checkInternetConnection()) {
        try {
          logger.d('Loading data from API');

          int callingPage = pageAvailable() == null
              ? page
              : page > num.parse(pageAvailable().toString())
                  ? 1
                  : page;

          final sneakersResponse = await repository.fetchSneakers(
              kAuthToken, "sneakers", "Nike", callingPage, 20);

          //checks if sneaker list is empty
          if (sneakersResponse.data.isNotEmpty) {
            //store in local db and return that cached data
            LocalDbDAO.instance
                .saveLastFetchTime(lastFetchTime: DateTime.now());
            LocalDbDAO.instance.saveSneakers(sneakers: sneakersResponse);
            LocalDbDAO.instance.saveLastLoadedSneakerPage(page: callingPage);

            return LocalDbDAO.instance.getSneakers()!;
          }
          //attempt to load from local db is sneaker list is empty
          else {
            if (LocalDbDAO.instance.isCachedSneakersAvailable()) {
              logger.d('Loading data from local db');

              try {
                logger.d('Cached data Loaded!');
                return LocalDbDAO.instance.getSneakers()!;
              } catch (error) {
                return Future.error(error);
              }
            } //finally display error if local db is unavailable
            else {
              logger.e('No data in local db! Sneaker list is empty!');
              return Future.error("No sneaker is available for now:(");
            }
          }
        } catch (error) {
          //attempt to load from local db if api calling is failed
          if (LocalDbDAO.instance.isCachedSneakersAvailable()) {
            logger.d('Loading data from local db');

            try {
              logger.d('Cached data Loaded!');
              return LocalDbDAO.instance.getSneakers()!;
            } catch (error) {
              return Future.error(error);
            }
          } //finally display error if local db is unavailable
          else {
            logger.e('No data in local db! Fix your api calling!');
            return Future.error("Error calling api to fetch sneakers: $error");
          }
        }
      } //attempt to load from local db if no internet
      else {
        if (LocalDbDAO.instance.isCachedSneakersAvailable()) {
          logger.d('Loading data from local db');

          try {
            logger.d('Cached data Loaded!');
            return LocalDbDAO.instance.getSneakers()!;
          } catch (error) {
            return Future.error(error);
          }
        } //finally display error if local db is unavailable
        else {
          logger.e('No data in local db. Check the network and try again!');
          return Future.error("Check your internet connection and try again!");
        }
      }
    } //if not required to call api, load from local db
    else {
      logger.d('Loading data from local db');

      try {
        logger.d(
            'Not required to call api since last time loaded is within 5 hours! Cached data Loaded!');
        return LocalDbDAO.instance.getSneakers()!;
      } catch (error) {
        logger.e('No data in local db! Sneaker list is empty!');
        return Future.error(error);
      }
    }
  }

  //Providing cached data to display while loading
  Future<SneakersResponse?> getCachedSneakersWhileLoading() async {
    try {
      return LocalDbDAO.instance.getSneakers();
    } catch (error) {
      return null;
    }
  }

  //set up to check last fetch time from local db to see if it's needed to call API
  bool isRequiredToCallApi(int page) {
    bool checkIfNeedsToLoadDataFromNetwork = true;

    DateTime? lastFetchTime = LocalDbDAO.instance.getLastFetchTime();

    if (LocalDbDAO.instance.isCachedLastFetchTimeAvailable() &&
        LocalDbDAO.instance.isCachedSneakersAvailable() &&
        page == LocalDbDAO.instance.getSneakers()?.meta.currentPage) {
      final Duration timeSinceLastFetch =
          DateTime.now().difference(lastFetchTime!);
      if (timeSinceLastFetch.inHours > 5) {
        checkIfNeedsToLoadDataFromNetwork = true;
      } else {
        checkIfNeedsToLoadDataFromNetwork = false;
      }
    } else {
      checkIfNeedsToLoadDataFromNetwork = true;
    }

    return checkIfNeedsToLoadDataFromNetwork;
  }

  //Available page calculation
  int? pageAvailable() {
    if (LocalDbDAO.instance.isCachedSneakersAvailable()) {
      return LocalDbDAO.instance.getSneakers()!.meta.total ~/
          LocalDbDAO.instance.getSneakers()!.meta.perPage;
    } else {
      return null;
    }
  }
}

