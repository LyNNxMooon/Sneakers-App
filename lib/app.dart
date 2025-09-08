// ignore_for_file: prefer_final_fields

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sneakers_app/constants/colors.dart';
import 'package:sneakers_app/features/cart/presentation/BLoC/cart_bloc.dart';
import 'package:sneakers_app/features/cart/presentation/BLoC/cart_events.dart';
import 'package:sneakers_app/features/cart/presentation/screens/cart_screen.dart';
import 'package:sneakers_app/features/home_products/presentation/BLoC/home_sneakers_bloc.dart';
import 'package:sneakers_app/features/home_products/presentation/screens/home_screen.dart';
import 'package:sneakers_app/features/search/presentation/BLoC/search_sneakers_bloc.dart';
import 'package:sneakers_app/utils/dependency_injection_utils.dart';
import 'package:sneakers_app/utils/log_util.dart';
import 'package:sneakers_app/utils/enums.dart';
import 'features/home_products/presentation/BLoC/home_sneakers_event.dart';
import 'features/search/presentation/BLoC/search_sneakers_event.dart';
import 'features/search/presentation/screens/search_screen.dart';
import 'local_db/hive_dao.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeSneakersBloc>(
          create: (_) => sl<HomeSneakersBloc>()
            ..add(FetchHomeSneakers(
                page: LocalDbDAO.instance.getLastLoadedSneakerPage() == null
                    ? 1
                    : LocalDbDAO.instance.getLastLoadedSneakerPage()!)),
        ),
        BlocProvider<SearchSneakersBloc>(
          create: (_) => sl<SearchSneakersBloc>()
            ..add(FetchSneakersEvent(
                page: LocalDbDAO.instance.getLastSearchedSneakerPage() == null
                    ? 1
                    : LocalDbDAO.instance.getLastSearchedSneakerPage()!)),
        ),
        BlocProvider<CartBloc>(
            create: (_) =>
                sl<CartBloc>()..add(LoadCart(cartType: CartType.cart)))
      ],
      child: MaterialApp(
        title: "Sneakers App",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: "Urbanist"),
        home: const IndexPage(),
      ),
    );
  }
}

//bottom nav navigator
class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int _selectedIndex = 0;
  List<Widget> _screens = <Widget>[
    HomeScreen(),
    CartScreen(),
    SearchScreen(),
    HomeScreen(),
  ];

  List<ILoadDataStrategy> _loadingDataStrategies = <ILoadDataStrategy>[
    LoadDataOnHomePage(),
    LoadDataOnCartPage(),
    LoadDataOnSearchPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Stack(
        children: [
          _screens[_selectedIndex],

          // Floating Glass Nav Bar
          Positioned(
            left: 45,
            right: 45,
            bottom: 60,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1), // Slight opacity
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2), // Subtle border
                    ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 20,
                        color: Colors.black.withOpacity(.1),
                      ),
                    ],
                  ),
                  child: GNav(
                    backgroundColor: Colors.transparent,
                    style: GnavStyle.google,
                    rippleColor: Colors.white.withOpacity(0.1),
                    hoverColor: Colors.white.withOpacity(0.05),
                    activeColor: kThirdColor,
                    iconSize: 24,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    duration: const Duration(milliseconds: 400),
                    tabBackgroundColor: Colors.white.withOpacity(0.25),
                    color: kThirdColor,
                    tabs: const [
                      GButton(icon: LineIcons.home, text: 'Home'),
                      GButton(icon: LineIcons.shoppingBag, text: 'Cart'),
                      GButton(icon: LineIcons.search, text: 'Search'),
                      GButton(icon: LineIcons.user, text: 'Profile'),
                    ],
                    selectedIndex: _selectedIndex,
                    onTabChange: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });

                      _loadingDataStrategies[index].loadData(context);
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//Strategy Pattern Interface
abstract class ILoadDataStrategy {
  Future<void> loadData(BuildContext context);
}

//Concrete Class: Load data for home page
class LoadDataOnHomePage implements ILoadDataStrategy {
  @override
  Future<void> loadData(BuildContext context) async {
    context.read<HomeSneakersBloc>().add(FetchHomeSneakers(
        page: LocalDbDAO.instance.getLastLoadedSneakerPage() == null
            ? 1
            : LocalDbDAO.instance.getLastLoadedSneakerPage()!));
  }
}

//Concrete Class: Load data for cart page
class LoadDataOnCartPage implements ILoadDataStrategy {
  @override
  Future<void> loadData(BuildContext context) async {
    logger.d("Loading data for cart page...");
  }
}

//Concrete Class: Load data for search page
class LoadDataOnSearchPage implements ILoadDataStrategy {
  @override
  Future<void> loadData(BuildContext context) async {
    context.read<SearchSneakersBloc>().add(FetchSneakersEvent(
        page: LocalDbDAO.instance.getLastLoadedSneakerPage() == null
            ? 1
            : LocalDbDAO.instance.getLastLoadedSneakerPage()!));
  }
}
