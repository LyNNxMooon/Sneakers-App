// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sneakers_app/constants/colors.dart';
import 'package:sneakers_app/features/cart/presentation/screens/cart_screen.dart';
import 'package:sneakers_app/features/home_products/presentation/screens/home_screen.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Sneakers App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Urbanist"),
      home: const IndexPage(),
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
    HomeScreen(),
    HomeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 45, vertical: 60),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          color: Color.fromRGBO(139, 137, 137, 0.15),
          boxShadow: [
            BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1)),
          ],
        ),
        child: GNav(
          style: GnavStyle.google,

          rippleColor: const Color.fromARGB(96, 255, 254, 254),
          hoverColor: const Color.fromARGB(255, 80, 78, 78),

          activeColor: kThirdColor,
          iconSize: 24,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          duration: Duration(milliseconds: 400),
          tabBackgroundColor: const Color.fromRGBO(128, 0, 0, 0),
          color: kThirdColor,
          tabs: [
            GButton(icon: LineIcons.home, text: 'Home'),
            GButton(icon: LineIcons.shoppingBag, text: 'Likes'),
            GButton(icon: LineIcons.history, text: 'Search'),
            GButton(icon: LineIcons.user, text: 'Profile'),
          ],
          selectedIndex: _selectedIndex,
          onTabChange: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
