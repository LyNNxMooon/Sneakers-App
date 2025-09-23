import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sneakers_app/entities/response/meta_response.dart';
import 'package:sneakers_app/entities/response/sneakers_response.dart';
import 'package:sneakers_app/entities/vos/sneaker_vo.dart';
import 'package:sneakers_app/features/home_products/domain/repositories/home_products_repo.dart';
import 'package:sneakers_app/features/home_products/domain/use_cases/fetch_and_display_sneakers.dart';
import 'package:sneakers_app/local_db/hive_dao.dart';
import 'package:sneakers_app/utils/internet_connection_utils.dart';

// Mock Home Repo
class MockHomeProductsRepo extends Mock implements HomeProductsRepo {}

// Mock Local DB DAO
class MockLocalDbDAO extends Mock implements LocalDbDAO {}

//Mock internet connection util
class MockInternetUtil extends Mock implements InternetConnectionUtils {}

void main() {
  late MockHomeProductsRepo mockRepo;
  late MockLocalDbDAO mockDb;
  late MockInternetUtil mockInternet;
  late FetchAndDisplaySneakers facade;

  setUp(() {
    mockRepo = MockHomeProductsRepo();
    mockDb = MockLocalDbDAO();
    mockInternet = MockInternetUtil();
    facade = FetchAndDisplaySneakers(mockRepo);

    LocalDbDAO.testInstance = mockDb;
    InternetConnectionUtils.testInstance = mockInternet;
  });

  List<SneakerVO> testSneakers = <SneakerVO>[
    SneakerVO(
      id: '1',
      title: 'Air Max 90',
      brand: 'Nike',
      model: 'AM90',
      gender: 'Men',
      description: 'Classic Nike Air Max 90 sneakers.',
      image: 'https://example.com/am90.jpg',
      sku: 'AM90-001',
      category: 'Running',
      secondaryCategory: 'Lifestyle',
      productType: 'Shoes',
    ),
    SneakerVO(
      id: '2',
      title: 'Air Jordan 1',
      brand: 'Nike',
      model: 'AJ1',
      gender: 'Men',
      description: 'Iconic Air Jordan 1 Retro.',
      image: 'https://example.com/aj1.jpg',
      sku: 'AJ1-002',
      category: 'Basketball',
      secondaryCategory: 'Lifestyle',
      productType: 'Shoes',
    ),
    SneakerVO(
      id: '3',
      title: 'Yeezy Boost 350',
      brand: 'Adidas',
      model: 'YB350',
      gender: 'Unisex',
      description: 'Adidas Yeezy Boost 350 comfortable and stylish.',
      image: 'https://example.com/yeezy350.jpg',
      sku: 'YB350-003',
      category: 'Running',
      secondaryCategory: 'Streetwear',
      productType: 'Shoes',
    ),
    SneakerVO(
      id: '4',
      title: 'Chuck Taylor All Star',
      brand: 'Converse',
      model: 'CTAS',
      gender: 'Unisex',
      description: 'Classic Converse Chuck Taylor high tops.',
      image: 'https://example.com/chucktaylor.jpg',
      sku: 'CTAS-004',
      category: 'Casual',
      secondaryCategory: 'Lifestyle',
      productType: 'Shoes',
    ),
    SneakerVO(
      id: '5',
      title: 'Ultraboost 21',
      brand: 'Adidas',
      model: 'UB21',
      gender: 'Women',
      description: 'High-performance Adidas Ultraboost running shoes.',
      image: 'https://example.com/ultraboost21.jpg',
      sku: 'UB21-005',
      category: 'Running',
      secondaryCategory: 'Training',
      productType: 'Shoes',
    ),
    SneakerVO(
      id: '6',
      title: 'Puma Suede Classic',
      brand: 'Puma',
      model: 'PSC',
      gender: 'Unisex',
      description: 'Puma Suede Classic retro sneakers.',
      image: 'https://example.com/pumasuede.jpg',
      sku: 'PSC-006',
      category: 'Casual',
      secondaryCategory: 'Streetwear',
      productType: 'Shoes',
    ),
    SneakerVO(
      id: '7',
      title: 'New Balance 574',
      brand: 'New Balance',
      model: 'NB574',
      gender: 'Men',
      description: 'Classic New Balance 574 lifestyle sneakers.',
      image: 'https://example.com/nb574.jpg',
      sku: 'NB574-007',
      category: 'Casual',
      secondaryCategory: 'Lifestyle',
      productType: 'Shoes',
    ),
    SneakerVO(
      id: '8',
      title: 'Gel-Lyte III',
      brand: 'ASICS',
      model: 'GL3',
      gender: 'Women',
      description: 'ASICS Gel-Lyte III with split tongue design.',
      image: 'https://example.com/gellyte3.jpg',
      sku: 'GL3-008',
      category: 'Running',
      secondaryCategory: 'Casual',
      productType: 'Shoes',
    ),
    SneakerVO(
      id: '9',
      title: 'ZoomX Vaporfly',
      brand: 'Nike',
      model: 'ZVF',
      gender: 'Unisex',
      description: 'Nike ZoomX Vaporfly performance marathon shoes.',
      image: 'https://example.com/vaporfly.jpg',
      sku: 'ZVF-009',
      category: 'Running',
      secondaryCategory: 'Performance',
      productType: 'Shoes',
    ),
    SneakerVO(
      id: '10',
      title: 'Stan Smith',
      brand: 'Adidas',
      model: 'SS',
      gender: 'Unisex',
      description: 'Timeless Adidas Stan Smith tennis shoes.',
      image: 'https://example.com/stansmith.jpg',
      sku: 'SS-010',
      category: 'Casual',
      secondaryCategory: 'Lifestyle',
      productType: 'Shoes',
    ),
  ];

  //Case 1: API is required to call and succeeds
  test('fetched from API when required and internet available', () async {
    final fakeResponse = SneakersResponse(
        data: testSneakers,
        meta: MetaResponse(currentPage: 1, total: 10, perPage: 20));

    when(() => mockInternet.checkInternetConnection())
        .thenAnswer((_) async => true);
    when(() => facade.isRequiredToCallApi(1)).thenAnswer((_) => true);
    when(() => mockRepo.fetchSneakers(any(), any(), any(), any(), any()))
        .thenAnswer((_) async => fakeResponse);
    when(() => mockDb.getSneakers()).thenReturn(fakeResponse);
    when(() => mockDb.isCachedSneakersAvailable()).thenReturn(false);
    when(() => mockDb.isCachedLastFetchTimeAvailable()).thenReturn(false);

    final result = await facade.call(1);

    expect(result, fakeResponse);

    verify(() => mockRepo.fetchSneakers(any(), any(), any(), any(), any()))
        .called(1);
    verify(() => mockDb.saveSneakers(sneakers: fakeResponse)).called(1);
  });

  //Case 2: API is required but no internet - fallback to cache
  test('loads from cache when no internet', () async {
    final cachedResponse = SneakersResponse(
        data: testSneakers,
        meta: MetaResponse(currentPage: 1, total: 10, perPage: 20));

    when(() => mockInternet.checkInternetConnection())
        .thenAnswer((_) async => false);
    when(() => mockDb.isCachedSneakersAvailable()).thenReturn(true);
    when(() => mockDb.isCachedLastFetchTimeAvailable()).thenReturn(true);
    when(() => mockDb.getLastFetchTime()).thenReturn(DateTime.now());

    when(() => mockDb.getSneakers()).thenReturn(cachedResponse);

    final result = await facade.call(1);

    expect(result, cachedResponse);

    verifyNever(
        () => mockRepo.fetchSneakers(any(), any(), any(), any(), any()));
  });

  //Case 3: API fails with error - fallback to cache

  test('loads from cache when API fails', () async {
    final cachedResponse = SneakersResponse(
        data: testSneakers,
        meta: MetaResponse(currentPage: 1, total: 10, perPage: 20));

    when(() => mockInternet.checkInternetConnection())
        .thenAnswer((_) async => true);
    when(() => mockRepo.fetchSneakers(any(), any(), any(), any(), any()))
        .thenThrow(Exception('API error'));
    when(() => mockDb.isCachedSneakersAvailable()).thenReturn(true);
    when(() => mockDb.isCachedLastFetchTimeAvailable()).thenReturn(true);
    when(() => mockDb.getLastFetchTime()).thenReturn(DateTime.now());

    when(() => mockDb.getSneakers()).thenReturn(cachedResponse);

    final result = await facade.call(1);

    expect(result, cachedResponse);
  });
}
