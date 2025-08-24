import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sneakers_app/features/home_products/presentation/BLoC/home_sneakers_bloc.dart';

import '../../../../constants/txt_styles.dart';
import '../../../../entities/response/sneakers_response.dart';
import '../../../../local_db/hive_dao.dart';
import '../BLoC/home_sneakers_event.dart';

class TitleAndPageSetting extends StatefulWidget {
  const TitleAndPageSetting({super.key, required this.sneakerResponse});

  final SneakersResponse sneakerResponse;

  @override
  State<TitleAndPageSetting> createState() => _TitleAndPageSettingState();
}

class _TitleAndPageSettingState extends State<TitleAndPageSetting> {
  int page = 1;

  @override
  void initState() {
    if (LocalDbDAO.instance.isCachedLastLoadedPageAvailable()) {
      page = LocalDbDAO.instance.getLastLoadedSneakerPage()!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 15, left: 20, bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${widget.sneakerResponse.data[0].category} Sneakers",
            style: ktitleStyle,
          ),
          Container(
            //padding: EdgeInsets.symmetric(horizontal: 10),
            width: 135,
            height: 35,
            decoration: BoxDecoration(
                border: Border.all(width: 0.8),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    if (page > 1) {
                      setState(() {
                        page--;
                      });
                      context.read<HomeSneakersBloc>().add(FetchHomeSneakers(page: page));
                    }
                  },
                  icon: Icon(
                    CupertinoIcons.chevron_down,
                    size: 16,
                  ),
                ),
                Text(
                  "$page / ${widget.sneakerResponse.meta.total ~/ widget.sneakerResponse.meta.perPage}",
                  style: TextStyle(fontSize: 12),
                ),
                IconButton(
                  onPressed: () {
                    if (page <
                        (widget.sneakerResponse.meta.total ~/
                            widget.sneakerResponse.meta.perPage)) {
                      setState(() {
                        page++;
                      });
                      context.read<HomeSneakersBloc>().add(FetchHomeSneakers(page: page));
                    }
                  },
                  icon: Icon(
                    CupertinoIcons.chevron_up,
                    size: 16,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
