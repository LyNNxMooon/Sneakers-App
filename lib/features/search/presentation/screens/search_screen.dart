import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:gap/gap.dart';
import 'package:sneakers_app/features/search/presentation/BLoC/search_sneakers_bloc.dart';

import '../../../../constants/txt_styles.dart';
import '../BLoC/search_sneakers_event.dart';
import '../BLoC/search_sneakers_state.dart';
import '../widgets/search_box_widget.dart';
import '../widgets/search_page_loading_widget.dart';
import '../widgets/search_sneakers_list.dart';

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
      physics: const BouncingScrollPhysics(),
      children: [
        const Gap(30),
        Center(child: Text("S e a r c h  S n e a k e r s", style: ktitleStyle)),
        const Gap(20),
        searchFieldWidgetsRow(),
        const Gap(35),
        sneakersListWidget()
      ],
    );
  }

  Widget sneakersListWidget() {
    return BlocBuilder<SearchSneakersBloc, SearchSneakersState>(
      builder: (_, state) {
        //loading
        if (state is SearchSneakersLoading) {
          return (state.sneakers == null)
              ? SearchPageLoadingWidget()
              : SearchSneakersList(
                  sneakersList: state.sneakers!.data,
                );
        }

        //Error
        if (state is SearchSneakersError) {
          return Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.5 - 220),
            child: Center(
              child: Text(
                state.errorMessage,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        //Success
        if (state is SearchSneakersLoaded) {
          return SearchSneakersList(
            sneakersList: state.sneakers.data,
          );
        }

        return SizedBox();
      },
    );
  }

  final Debouncer debouncer = Debouncer();
  static const duration = Duration(milliseconds: 250);

  Widget searchFieldWidgetsRow() {
    return Padding(
      padding: EdgeInsets.only(left: 12, right: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BlocBuilder<SearchSneakersBloc, SearchSneakersState>(
                    builder: (_, state) {
                  if (state is SearchSneakersLoaded) {
                    return SizedBox(
                      height: 45,
                      width: (MediaQuery.of(context).size.width - 30) * 0.3,
                      child: SearchBoxWidget(
                        keyboardType: TextInputType.number,
                        function: (value) {
                          debouncer.debounce(
                              duration: duration,
                              onDebounce: () {
                                context.read<SearchSneakersBloc>().add(
                                    FetchSneakersEvent(
                                        page: int.parse(_pageController.text)));
                              });
                        },
                        controller: _pageController,
                        hintText: "Page..",
                        label:
                            "Total Page: ${state.sneakers.meta.total ~/ state.sneakers.meta.perPage}",
                      ),
                    );
                  }
                  return SizedBox(
                    height: 45,
                    width: (MediaQuery.of(context).size.width - 30) * 0.3,
                    child: SearchBoxWidget(

                      controller: _pageController,
                      hintText: "Page..",
                      label: "Page",
                    ),
                  );
                }),
                SizedBox(
                  height: 45,
                  width: (MediaQuery.of(context).size.width - 30) * 0.7,
                  child: SearchBoxWidget(
                    controller: _sneakerTitleController,
                    hintText: "Search by title..",
                    label: "Title",
                  ),
                ),
              ],
            ),
          ),
          const Gap(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 45,
                width: (MediaQuery.of(context).size.width - 30) * 0.4,
                child: SearchBoxWidget(
                  controller: _sneakerCategoryController,
                  hintText: "2nd Category..",
                  label: "2nd Category",
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
        ],
      ),
    );
  }
}
