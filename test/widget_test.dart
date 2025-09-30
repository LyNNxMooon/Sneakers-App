// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/cupertino.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sneakers_app/app.dart';
import 'package:sneakers_app/entities/response/meta_response.dart';
import 'package:sneakers_app/entities/response/sneakers_response.dart';
import 'package:sneakers_app/entities/vos/sneaker_vo.dart';
import 'package:sneakers_app/features/cart/presentation/BLoC/cart_bloc.dart';
import 'package:sneakers_app/features/cart/presentation/BLoC/cart_states.dart';
import 'package:sneakers_app/features/cart/presentation/screens/cart_screen.dart';
import 'package:sneakers_app/features/home_products/presentation/BLoC/home_sneakers_bloc.dart';
import 'package:sneakers_app/features/home_products/presentation/BLoC/home_sneakers_event.dart';
import 'package:sneakers_app/features/home_products/presentation/BLoC/home_sneakers_state.dart';
import 'package:sneakers_app/features/home_products/presentation/screens/home_screen.dart';
import 'package:sneakers_app/features/home_products/presentation/widgets/home_sneakers_list.dart';
import 'package:sneakers_app/features/search/presentation/BLoC/search_sneakers_bloc.dart';
import 'package:sneakers_app/features/search/presentation/BLoC/search_sneakers_event.dart';
import 'package:sneakers_app/features/search/presentation/BLoC/search_sneakers_state.dart';
import 'package:sneakers_app/features/search/presentation/screens/search_screen.dart';
import 'package:sneakers_app/features/search/presentation/widgets/search_sneakers_list.dart';

class MockHomeSneakersBloc extends Mock implements HomeSneakersBloc {}

class FakeHomeSneakersEvent extends Fake implements HomeSneakersEvent {}

class FakeSearchSneakersEvent extends Fake implements SearchSneakersEvent {}

class MockCartBloc extends Mock implements CartBloc {}

class MockSearchSneakersBloc extends Mock implements SearchSneakersBloc {}

final fakeSneakersResponse = SneakersResponse(
  data: [
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
      title: 'Yeezy Boost 350',
      brand: 'Adidas',
      model: 'YB350',
      gender: 'Unisex',
      description: 'Adidas Yeezy Boost 350, comfortable and stylish.',
      image: 'https://example.com/yeezy350.jpg',
      sku: 'YB350-002',
      category: 'Streetwear',
      secondaryCategory: 'Running',
      productType: 'Shoes',
    ),
    SneakerVO(
      id: '3',
      title: 'Air Jordan 1',
      brand: 'Converse',
      model: 'CTAS',
      gender: 'Unisex',
      description: 'Timeless Converse Chuck Taylor high tops.',
      image: 'https://example.com/ctas.jpg',
      sku: 'CTAS-003',
      category: 'Casual',
      secondaryCategory: 'Lifestyle',
      productType: 'Shoes',
    ),
  ],
  meta: MetaResponse(
    currentPage: 1,
    total: 3,
    perPage: 1,
  ),
);

final fakeSneakersResponsePage2 = SneakersResponse(
  data: [
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
  ],
  meta: MetaResponse(
    currentPage: 2,
    total: 3,
    perPage: 1,
  ),
);

void main() {
  late MockHomeSneakersBloc mockHomeSneakersBloc;
  late MockCartBloc mockCartBloc;
  late MockSearchSneakersBloc mockSearchSneakersBloc;

  setUpAll(() {
    registerFallbackValue(FakeHomeSneakersEvent());
    registerFallbackValue(FakeSearchSneakersEvent());
  });

  setUp(() {
    mockHomeSneakersBloc = MockHomeSneakersBloc();
    mockCartBloc = MockCartBloc();
    mockSearchSneakersBloc = MockSearchSneakersBloc();

    when(() => mockCartBloc.stream)
        .thenAnswer((_) => const Stream<CartStates>.empty());
    when(() => mockCartBloc.state).thenReturn(CartInitial());

    when(() => mockHomeSneakersBloc.stream)
        .thenAnswer((_) => const Stream<HomeSneakersState>.empty());
    when(() => mockHomeSneakersBloc.state).thenReturn(HomeSneakersInitial());

    when(() => mockSearchSneakersBloc.stream)
        .thenAnswer((_) => const Stream<SearchSneakersState>.empty());
    when(() => mockSearchSneakersBloc.state)
        .thenReturn(SearchSneakersInitial());
  });

  //Home Screen Widgets Tests

  testWidgets('typing in search field updates value', (tester) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<CartBloc>.value(value: mockCartBloc),
          BlocProvider<HomeSneakersBloc>.value(value: mockHomeSneakersBloc),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: HomeScreen(),
          ),
        ),
      ),
    );

    final searchFields = find.byType(TextFormField);

    expect(searchFields, findsNWidgets(3));

    await tester.enterText(searchFields.at(0), 'Air Max');
    await tester.pump();

    expect(find.text('Air Max'), findsOneWidget);
  });

  testWidgets('tapping search icon ', (tester) async {
    when(() => mockHomeSneakersBloc.state)
        .thenReturn(HomeSneakersLoaded(fakeSneakersResponse));

    await tester.pumpWidget(MultiBlocProvider(
      providers: [
        BlocProvider<CartBloc>.value(
          value: mockCartBloc,
        ),
        BlocProvider<HomeSneakersBloc>.value(
          value: mockHomeSneakersBloc,
        ),
      ],
      child: const MaterialApp(
        home: Scaffold(
          body: HomeScreen(),
        ),
      ),
    ));

    final searchFields = find.byType(TextFormField);

    await tester.enterText(searchFields.at(0), 'Air Max');
    await tester.pump();

    final searchIconButton = find.byIcon(Icons.search);
    await tester.tap(searchIconButton);
    await tester.pump();

    verify(() => mockHomeSneakersBloc.add(
          any(
            that: isA<SearchHomeSneakers>()
                .having((e) => e.title, 'title', 'Air Max')
                .having((e) => e.model, 'model', '')
                .having((e) => e.sku, 'sku', ''),
          ),
        )).called(1);
  });

  testWidgets('pagination arrow fetches next page and updates UI',
      (tester) async {
    whenListen(
      mockHomeSneakersBloc,
      Stream.fromIterable([
        HomeSneakersLoaded(fakeSneakersResponse),
        HomeSneakersLoaded(fakeSneakersResponsePage2),
      ]),
      initialState: HomeSneakersLoaded(fakeSneakersResponse),
    );

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<CartBloc>.value(value: mockCartBloc),
          BlocProvider<HomeSneakersBloc>.value(value: mockHomeSneakersBloc),
        ],
        child: const MaterialApp(
          home: Scaffold(body: HomeScreen()),
        ),
      ),
    );

    expect(find.text('Air Max 90'), findsOneWidget);
    expect(find.text('Air Jordan 1'), findsOneWidget);

    final nextArrow = find.byIcon(CupertinoIcons.chevron_up);
    await tester.tap(nextArrow);
    await tester.pump();

    expect(find.text('Chuck Taylor All Star'), findsOneWidget);

    expect(find.text('Air Max 90'), findsNothing);

    verify(() => mockHomeSneakersBloc.add(
          any(that: isA<FetchHomeSneakers>().having((e) => e.page, 'page', 2)),
        )).called(1);
  });

  testWidgets('Item Card List Renders Correctly', (tester) async {
    when(() => mockHomeSneakersBloc.state)
        .thenReturn(HomeSneakersLoaded(fakeSneakersResponse));

    await tester.pumpWidget(MaterialApp(
      home: HomeSneakersList(
        sneakersList: fakeSneakersResponse.data,
      ),
    ));

    expect(find.text('Air Max 90'), findsOneWidget);
    expect(find.byIcon(Icons.add_shopping_cart), findsNWidgets(3));
  });

  testWidgets('Bottom navigation bar buttons navigate correctly',
      (tester) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<HomeSneakersBloc>.value(value: mockHomeSneakersBloc),
          BlocProvider<CartBloc>.value(value: mockCartBloc),
          BlocProvider<SearchSneakersBloc>.value(value: mockSearchSneakersBloc),
        ],
        child: const MaterialApp(home: IndexPage()),
      ),
    );

    expect(find.byType(HomeScreen), findsOneWidget);

    final cartTab = find.widgetWithText(GButton, 'Cart');

    expect(cartTab, findsOneWidget);
    await tester.tap(cartTab);
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(CartScreen), findsOneWidget);

    final searchTab = find.widgetWithText(GButton, 'Search');
    expect(searchTab, findsOneWidget);
    await tester.tap(searchTab);
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(SearchScreen), findsOneWidget);
  });

  //Search Screen Widgets Tests

  testWidgets('typing in search fields of Search page updates value',
      (tester) async {
    await tester.pumpWidget(MultiBlocProvider(
      providers: [
        BlocProvider<SearchSneakersBloc>.value(
          value: mockSearchSneakersBloc,
        )
      ],
      child: const MaterialApp(
        home: Scaffold(
          body: SearchScreen(),
        ),
      ),
    ));

    final searchFields = find.byType(TextFormField);

    expect(searchFields, findsNWidgets(5));
    await tester.enterText(searchFields.at(1), 'Air Max');

    await tester.pump();

    expect(find.text('Air Max'), findsOneWidget);
  });

  testWidgets('tapping search icon on Search Page', (tester) async {
    when(() => mockSearchSneakersBloc.state)
        .thenReturn(SearchSneakersLoaded(fakeSneakersResponse));

    await tester.pumpWidget(MultiBlocProvider(
      providers: [
        BlocProvider<SearchSneakersBloc>.value(
          value: mockSearchSneakersBloc,
        )
      ],
      child: const MaterialApp(
        home: Scaffold(
          body: SearchScreen(),
        ),
      ),
    ));

    final searchFields = find.byType(TextFormField);

    await tester.enterText(searchFields.at(1), 'Air Max');
    await tester.pump();

    final searchIconButton = find.byIcon(Icons.search);
    await tester.tap(searchIconButton);
    await tester.pump();

    verify(() => mockSearchSneakersBloc.add(any(
        that: isA<SearchEvent>()
            .having((e) => e.title, 'title', 'Air Max')
            .having((e) => e.model, 'model', '')
            .having((e) => e.sku, 'sku', '')
            .having((e) => e.secCategory, 'secCategory', '')))).called(1);
  });

  testWidgets(
      'entering page number dispatch fetching sneakers and updates UI with new sneakers',
      (tester) async {
    whenListen(
        mockSearchSneakersBloc,
        Stream.fromIterable([
          SearchSneakersLoaded(fakeSneakersResponse),
          SearchSneakersLoaded(fakeSneakersResponsePage2)
        ]),
        initialState: SearchSneakersLoaded(fakeSneakersResponse));

    await tester.pumpWidget(MultiBlocProvider(
      providers: [
        BlocProvider<SearchSneakersBloc>.value(
          value: mockSearchSneakersBloc,
        )
      ],
      child: const MaterialApp(
        home: Scaffold(
          body: SearchScreen(),
        ),
      ),
    ));

    expect(find.text('Air Max 90'), findsOneWidget);

    final pageField = find.widgetWithText(TextFormField, 'Page..');
    await tester.enterText(pageField, '2');
    await tester.pump();

    await tester.pump(const Duration(milliseconds: 500));

    await tester.pump();
    //expect(find.text('Chuck Taylor All Star'), findsOneWidget);

    verify(() => mockSearchSneakersBloc.add(
          any(
            that: isA<FetchSneakersEvent>().having((e) => e.page, 'page', 2),
          ),
        )).called(1);

    expect(find.text('Air Max 90'), findsNothing);
    //await tester.pump(const Duration(seconds: 1));
    expect(find.text('Chuck Taylor All Sta ...'), findsOneWidget);
  });

  testWidgets('List item card on Search Page renders correctly',
      (tester) async {
    when(() => mockSearchSneakersBloc.state)
        .thenReturn(SearchSneakersLoaded(fakeSneakersResponse));

    await tester.pumpWidget(MaterialApp(
      home: SearchSneakersList(
        sneakersList: fakeSneakersResponse.data,
      ),
    ));

    expect(find.text('Air Max 90'), findsOneWidget);
    expect(find.byIcon(Icons.add_shopping_cart), findsNWidgets(3));
  });
}
