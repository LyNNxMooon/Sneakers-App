import 'package:flutter/material.dart';

import 'package:sneakers_app/features/home_products/presentation/widgets/app_bar_session.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
       
             CustomAppBar()
        
      ],
    );
  }
}
