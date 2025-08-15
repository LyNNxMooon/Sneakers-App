import 'package:collection/algorithms.dart';
import 'package:sneakers_app/features/home_products/data/response/sneakers_response.dart';
import 'package:sneakers_app/features/home_products/data/vos/sneaker_vo.dart';
import 'package:sneakers_app/features/home_products/domain/repositories/home_products_repo.dart';

import '../../../../local_db/hive_dao.dart';
import '../../../../network/api/api_constants.dart';
import '../../../../utils/dependency_injection_utils.dart';
import '../../../../utils/internet_connection_utils.dart';
import '../../../../utils/log_util.dart';

class FetchAndDisplaySneakers {
  final HomeProductsRepo repository;

  FetchAndDisplaySneakers(this.repository);

  //Facade Pattern applies here
  Future<SneakersResponse> call(int page,
      {bool isSearching = false,
      String title = "",
      String model = "",
      String sku = ""}) async {
    if (!isSearching) {
      return fetchAndLoadSneakers(page);
    } else {
      return sl<HomeSneakerSearchService>().search(title, model, sku);
    }
  }

  //Fetching and Displaying sneakers as normal
  Future<SneakersResponse> fetchAndLoadSneakers(int page) async {
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

//Searching home sneakers

class HomeSneakerSearchService {
  final SneakersResponse _allSneakers;

  //Pre-sorted lists for each query
  late final List<SneakerVO> _sneakersByTitle;
  late final List<SneakerVO> _sneakersByModel;
  late final List<SneakerVO> _sneakersBySku;

  //Normalize to lower-case
  static String _norm(String s) => s.toLowerCase().trim();

  HomeSneakerSearchService(SneakersResponse sneakersResponse)
      : _allSneakers = sneakersResponse {
    _sneakersByTitle = List.of(_allSneakers.data)
      ..sort((a, b) => _norm(a.title).compareTo(_norm(b.title)));

    _sneakersByModel = List.of(_allSneakers.data)
      ..sort((a, b) => _norm(a.model).compareTo(_norm(b.model)));

    _sneakersBySku = List.of(_allSneakers.data)
      ..sort((a, b) => _norm(a.sku).compareTo(_norm(b.sku)));
  }

  //Applying Search Method
  SneakersResponse search(String title, String model, String sku) {
    final normalizedTitle = _norm(title);
    final normalizedModel = _norm(model);
    final normalizedSku = _norm(sku);

    if (normalizedTitle.isEmpty &&
        normalizedModel.isEmpty &&
        normalizedSku.isEmpty) {
      // Return all sneakers if search is empty
      return _allSneakers;
    }

    Set<SneakerVO> results = {};
    bool isFirstFilter = true;

    if (normalizedTitle.isNotEmpty) {
      final titleResults = _performPrefixSearch(
          _sneakersByTitle, (s) => s.title, normalizedTitle);
      results.addAll(titleResults);
      isFirstFilter = false;
    }

    if (normalizedModel.isNotEmpty) {
      final modelResults = _performPrefixSearch(
          _sneakersByModel, (s) => s.model, normalizedModel);
      if (isFirstFilter) {
        results.addAll(modelResults);
        isFirstFilter = false;
      } else {
        // Keep only the items that are in BOTH previous results and this result.
        results = results.intersection(modelResults.toSet());
      }
    }

    if (normalizedSku.isNotEmpty) {
      final skuResults =
          _performPrefixSearch(_sneakersBySku, (s) => s.sku, normalizedSku);
      if (isFirstFilter) {
        results.addAll(skuResults);
        isFirstFilter = false;
      } else {
        results = results.intersection(skuResults.toSet());
      }
    }

    return SneakersResponse(
        data: results.toList(),
        status: _allSneakers.status,
        query: _allSneakers.query,
        meta: _allSneakers.meta);
  }

  //Helper to perform binary search
  List<SneakerVO> _performPrefixSearch(
    List<SneakerVO> sortedList,
    String Function(SneakerVO) fieldGetter,
    String query,
  ) {
    final q = _norm(query);
    final qMax = '$q\u{FFFF}';

    final dummyStart = SneakerVO(
        id: '',
        title: q,
        model: q,
        sku: q,
        brand: '',
        gender: '',
        description: '',
        image: '',
        category: '',
        productType: '');
    final dummyEnd = SneakerVO(
        id: '',
        title: qMax,
        model: qMax,
        sku: qMax,
        brand: '',
        gender: '',
        description: '',
        image: '',
        category: '',
        productType: '');

    final start = lowerBound<SneakerVO>(
      sortedList,
      dummyStart,
      compare: (a, b) => _norm(fieldGetter(a)).compareTo(_norm(fieldGetter(b))),
    );

    final end = lowerBound<SneakerVO>(
      sortedList,
      dummyEnd,
      compare: (a, b) => _norm(fieldGetter(a)).compareTo(_norm(fieldGetter(b))),
    );

    if (start >= end) {
      return []; // No results found
    }

    return sortedList.sublist(start, end);
  }
}
