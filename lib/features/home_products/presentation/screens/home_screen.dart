import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:sneakers_app/features/home_products/presentation/BLoC/home_sneakers_bloc.dart';
import 'package:sneakers_app/features/home_products/presentation/BLoC/home_sneakers_state.dart';

import 'package:sneakers_app/features/home_products/presentation/widgets/app_bar_session.dart';

import '../../../../local_db/hive_dao.dart';
import '../BLoC/home_sneakers_event.dart';
import '../widgets/home_sneakers_list.dart';
import '../widgets/sneaker_search_box.dart';
import '../widgets/sneakers_loading_widget.dart';
import '../widgets/title_and_page_setting.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _sneakerTitleController = TextEditingController();
  final _sneakerModelController = TextEditingController();
  final _sneakerSkuController = TextEditingController();

  @override
  void dispose() {
    _sneakerTitleController.dispose();
    _sneakerModelController.dispose();
    _sneakerSkuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        CustomAppBar(),
        const Gap(20),
        searchFieldWidgetsRow(),
        const Gap(40),
        titleAndPageSettingWidget(),
        sneakersListWidget()
      ],
    );
  }

  Widget titleAndPageSettingWidget() {
    return BlocBuilder<HomeSneakersBloc, HomeSneakersState>(
      builder: (_, state) {
        //loading
        if (state is HomeSneakersLoading) {
          return (state.sneakers == null)
              ? TitleAndPageSettingLoadingWidget()
              : TitleAndPageSetting(
                  sneakerResponse: state.sneakers!,
                );
        }

        //Success

        if (state is HomeSneakersLoaded) {
          return TitleAndPageSetting(
            sneakerResponse: state.sneakers,
          );
        }

        return SizedBox();
      },
    );
  }

  Widget sneakersListWidget() {
    return BlocBuilder<HomeSneakersBloc, HomeSneakersState>(
      builder: (_, state) {
        //loading
        if (state is HomeSneakersLoading) {
          return (state.sneakers == null)
              ? SneakersLoadingWidget()
              : HomeSneakersList(
                  sneakersList: state.sneakers!.data,
                );
        }

        //Error
        if (state is HomeSneakersError) {
          return Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.5 - 220),
            child: Center(
              child: Text(state.errorMessage),
            ),
          );
        }

        //Success
        if (state is HomeSneakersLoaded) {
          return HomeSneakersList(
            sneakersList: state.sneakers.data,
          );
        }

        return SizedBox();
      },
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
            child: SneakerSearchBox(
              controller: _sneakerTitleController,
              hintText: "Search by title..",
              label: "Title",
            ),
          ),
          SizedBox(
            height: 45,
            width: (MediaQuery.of(context).size.width - 30) * 0.2,
            child: SneakerSearchBox(
              controller: _sneakerModelController,
              hintText: "Model..",
              label: "Model",
            ),
          ),
          SizedBox(
            height: 45,
            width: (MediaQuery.of(context).size.width - 30) * 0.25,
            child: SneakerSearchBox(
              controller: _sneakerSkuController,
              hintText: "Sku..",
              label: "Sku",
            ),
          ),
          BlocBuilder<HomeSneakersBloc, HomeSneakersState>(
            builder: (_, state) {
              if (state is HomeSneakersLoaded) {
                return IconButton(
                  onPressed: () {
                    context.read<HomeSneakersBloc>().add(SearchHomeSneakers(
                        title: _sneakerTitleController.text,
                        model: _sneakerModelController.text,
                        sku: _sneakerSkuController.text));
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
