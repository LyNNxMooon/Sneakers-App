import 'package:collection/algorithms.dart';
import 'package:sneakers_app/features/home_products/data/response/sneakers_response.dart';

import '../../../../local_db/hive_dao.dart';
import '../../../../utils/log_util.dart';
import '../../data/vos/sneaker_vo.dart';

class SearchHomePageSneakers {
  //Pre-sorted lists for each query
  List<SneakerVO> _sneakersByTitle = [];
  List<SneakerVO> _sneakersByModel = [];
  List<SneakerVO> _sneakersBySku = [];

  //Normalize to lower-case
  static String _norm(String s) => s.toLowerCase().trim();

  //Applying Search Method
  Future<SneakersResponse> call(String title, String model, String sku) async {
    try {
      final SneakersResponse allSneakers = LocalDbDAO.instance.getSneakers()!;

      _sneakersByTitle = List.of(allSneakers.data)
        ..sort((a, b) => _norm(a.title).compareTo(_norm(b.title)));

      _sneakersByModel = List.of(allSneakers.data)
        ..sort((a, b) => _norm(a.model).compareTo(_norm(b.model)));

      _sneakersBySku = List.of(allSneakers.data)
        ..sort((a, b) => _norm(a.sku).compareTo(_norm(b.sku)));

      final normalizedTitle = _norm(title);
      final normalizedModel = _norm(model);
      final normalizedSku = _norm(sku);

      if (normalizedTitle.isEmpty &&
          normalizedModel.isEmpty &&
          normalizedSku.isEmpty) {
        // Return all sneakers if search is empty
        logger.d("search query is empty, returning all sneakers!");
        return allSneakers;
      }

      Set<SneakerVO> results = {};
      bool isFirstFilter = true;

      if (normalizedTitle.isNotEmpty) {
        final titleSearchResults = _performPrefixSearch(
            _sneakersByTitle, (s) => s.title, normalizedTitle);
        results.addAll(titleSearchResults);
        isFirstFilter = false;
      }

      if (normalizedModel.isNotEmpty) {
        final modelSearchResults = _performPrefixSearch(
            _sneakersByModel, (s) => s.model, normalizedModel);
        if (isFirstFilter) {
          results.addAll(modelSearchResults);
          isFirstFilter = false;
        } else {
          // Keep only the items that are in previous results and this result.
          results = results.intersection(modelSearchResults.toSet());
        }
      }

      if (normalizedSku.isNotEmpty) {
        final skuSearchResults =
            _performPrefixSearch(_sneakersBySku, (s) => s.sku, normalizedSku);
        if (isFirstFilter) {
          results.addAll(skuSearchResults);
          isFirstFilter = false;
        } else {
          // Keep only the items that are in previous results and this result.
          results = results.intersection(skuSearchResults.toSet());
        }
      }

      return SneakersResponse(
          data: results.toList(),
          status: allSneakers.status,
          query: allSneakers.query,
          meta: allSneakers.meta);
    } catch (error) {
      logger.e(
          "Error occurred on searching home page sneakers! Read message on screen");
      return Future.error(
          "Error occurred while searching home page sneakers! Please wipe out the Text field filter and try again! Error sms: $error");
    }
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
