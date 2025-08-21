import 'package:collection/collection.dart';

import '../../../../entities/response/sneakers_response.dart';
import '../../../../entities/vos/sneaker_vo.dart';
import '../../../../local_db/hive_dao.dart';
import '../../../../utils/log_util.dart';

class SearchSneakers {
  //Strategy + Composite design patterns
  Future<SneakersResponse> call(
      String title, String model, String sku, String secCategory) async {
    try {
      final SneakersResponse sneakerObjFromLocalDb =
          LocalDbDAO.instance.getSearchedSneakers()!;

      List<SneakerVO> currentSearchedList = sneakerObjFromLocalDb.data;

      List<ISearchSneakersStrategy> activeStrategies = [];
      if (title.isNotEmpty) {
        activeStrategies.add(TitleSearch(searchTerm: title));
      }
      if (model.isNotEmpty) {
        activeStrategies.add(ModelSearch(searchTerm: model));
      }
      if (sku.isNotEmpty) {
        activeStrategies.add(SkuSearch(searchTerm: sku));
      }
      if (secCategory.isNotEmpty) {
        activeStrategies.add(SecCategorySearch(searchTerm: secCategory));
      } //Continue adding more search criteria here.....

      for (ISearchSneakersStrategy strategy in activeStrategies) {
        currentSearchedList =
            await strategy.searchSneakers(currentSearchedList);
      }

      return SneakersResponse(
          data: currentSearchedList,
          status: sneakerObjFromLocalDb.status,
          query: sneakerObjFromLocalDb.query,
          meta: sneakerObjFromLocalDb.meta);
    } catch (error) {
      logger.e("Error occurred on searching sneakers! Read message on screen");
      return Future.error(
          "Error occurred while searching sneakers! Please wipe out the Text field filter and try again! Error sms: $error");
    }
  }
}

//Strategy Pattern interface
abstract class ISearchSneakersStrategy {
  Future<List<SneakerVO>> searchSneakers(List<SneakerVO> allSneakers);
}

//Concrete Class: titleSearch
class TitleSearch implements ISearchSneakersStrategy {
  final String searchTerm;

  TitleSearch({required this.searchTerm});

  @override
  Future<List<SneakerVO>> searchSneakers(List<SneakerVO> allSneakers) async {
    try {
      List<SneakerVO> sneakersByTitle = List.of(allSneakers)
        ..sort((a, b) => _norm(a.title).compareTo(_norm(b.title)));

      if (searchTerm.isEmpty) return allSneakers;

      return _performPrefixSearch(
          sneakersByTitle, (s) => s.title, _norm(searchTerm));
    } catch (error) {
      logger.e(
          "Error occurred on searching sneakers by TITLE! Read message on screen");
      return Future.error(
          "Error occurred while searching sneakers by TITLE! Please wipe out the Text field filter and try again! Error sms: $error");
    }
  }
}

//Concrete Class: modelSearch
class ModelSearch implements ISearchSneakersStrategy {
  final String searchTerm;

  ModelSearch({required this.searchTerm});

  @override
  Future<List<SneakerVO>> searchSneakers(List<SneakerVO> allSneakers) async {
    try {
      List<SneakerVO> sneakersByModel = List.of(allSneakers)
        ..sort((a, b) => _norm(a.model).compareTo(_norm(b.model)));

      if (searchTerm.isEmpty) return allSneakers;

      return _performPrefixSearch(
          sneakersByModel, (s) => s.model, _norm(searchTerm));
    } catch (error) {
      logger.e(
          "Error occurred on searching sneakers by MODEL! Read message on screen");
      return Future.error(
          "Error occurred while searching sneakers by MODEL! Please wipe out the Text field filter and try again! Error sms: $error");
    }
  }
}

//Concrete Class: skuSearch
class SkuSearch implements ISearchSneakersStrategy {
  final String searchTerm;

  SkuSearch({required this.searchTerm});

  @override
  Future<List<SneakerVO>> searchSneakers(List<SneakerVO> allSneakers) async {
    try {
      List<SneakerVO> sneakersBySku = List.of(allSneakers)
        ..sort((a, b) => _norm(a.sku).compareTo(_norm(b.sku)));

      if (searchTerm.isEmpty) return allSneakers;

      return _performPrefixSearch(
          sneakersBySku, (s) => s.sku, _norm(searchTerm));
    } catch (error) {
      logger.e(
          "Error occurred on searching sneakers by SKU! Read message on screen");
      return Future.error(
          "Error occurred while searching sneakers by SKU! Please wipe out the Text field filter and try again! Error sms: $error");
    }
  }
}

//Concrete Class: 2nd Category Search
class SecCategorySearch implements ISearchSneakersStrategy {
  final String searchTerm;

  SecCategorySearch({required this.searchTerm});

  @override
  Future<List<SneakerVO>> searchSneakers(List<SneakerVO> allSneakers) async {
    try {
      List<SneakerVO> sneakersBySecCategory = List.of(allSneakers)
        ..sort((a, b) =>
            _norm(a.secondaryCategory).compareTo(_norm(b.secondaryCategory)));

      if (searchTerm.isEmpty) return allSneakers;

      return _performPrefixSearch(
          sneakersBySecCategory, (s) => s.secondaryCategory, _norm(searchTerm));
    } catch (error) {
      logger.e(
          "Error occurred on searching sneakers by 2nd Category! Read message on screen");
      return Future.error(
          "Error occurred while searching sneakers by 2nd Category! Please wipe out the Text field filter and try again! Error sms: $error");
    }
  }
} //Continue adding more search algorithms here...

//Normalize to lower-case
String _norm(String s) => s.toLowerCase().trim();

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
      secondaryCategory: q,
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
      secondaryCategory: qMax,
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
