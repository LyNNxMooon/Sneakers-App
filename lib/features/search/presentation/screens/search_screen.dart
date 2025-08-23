import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:sneakers_app/features/search/presentation/BLoC/search_sneakers_bloc.dart';

import '../../../../constants/txt_styles.dart';
import '../BLoC/search_sneakers_event.dart';
import '../BLoC/search_sneakers_state.dart';
import '../widgets/search_box_widget.dart';

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
        const Gap(20),
        searchFieldWidgetsRow(),
      ],
    );
  }

  Widget searchFieldWidgetsRow() {
    return Padding(
      padding: EdgeInsets.only(left: 12, right: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: 45,
            width: (MediaQuery.of(context).size.width - 30) * 0.4,
            child: SearchBoxWidget(
              controller: _sneakerTitleController,
              hintText: "Search by title..",
              label: "Title",
            ),
          ),
          SizedBox(
            height: 45,
            width: (MediaQuery.of(context).size.width - 30) * 0.2,
            child: SearchBoxWidget(
              controller: _sneakerModelController,
              hintText: "Model..",
              label: "Model",
            ),
          ),
          SizedBox(
            height: 45,
            width: (MediaQuery.of(context).size.width - 30) * 0.25,
            child: SearchBoxWidget(
              controller: _sneakerSkuController,
              hintText: "Sku..",
              label: "Sku",
            ),
          ),
          BlocBuilder<SearchSneakersBloc, SearchSneakersState>(
            builder: (_, state) {
              if (state is SearchSneakersLoaded) {
                return IconButton(
                  onPressed: () {
                    context.read<SearchSneakersBloc>().add(SearchEvent(
                        title: _sneakerTitleController.text,
                        model: _sneakerModelController.text,
                        sku: _sneakerSkuController.text,
                        secCategory: _sneakerCategoryController.text));
                  },
                  icon: Icon(Icons.search),
                );
              }

              return IconButton(
                onPressed: () {},
                icon: Icon(Icons.search),
              );
            },
          )
        ],
      ),
    );
  }
}
