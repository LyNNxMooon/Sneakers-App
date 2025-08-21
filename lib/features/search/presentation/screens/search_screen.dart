import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../constants/txt_styles.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  final _sneakerTitleController = TextEditingController();
  final _sneakerModelController = TextEditingController();
  final _sneakerSkuController = TextEditingController();
  final _sneakerCategoryController = TextEditingController();
  final _pageController = TextEditingController();

  @override
  void dispose() {
    _sneakerTitleController.dispose();
    _sneakerModelController.dispose();
    _sneakerSkuController.dispose();
    _sneakerCategoryController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      children: [
        const Gap(30),
        Center(child: Text("S e a r c h", style: ktitleStyle)),

      ],
    );
  }
}
