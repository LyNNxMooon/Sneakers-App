import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:sneakers_app/constants/colors.dart';
import 'package:sneakers_app/constants/images.dart';
import 'package:sneakers_app/constants/txt_styles.dart';
import 'package:sneakers_app/features/cart/presentation/BLoC/cart_bloc.dart';
import 'package:sneakers_app/features/cart/presentation/BLoC/cart_states.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 1 - 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: kSecondaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    child: CachedNetworkImage(
                      imageUrl: profilePlaceHoler,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error_outline),
                      placeholder: (context, url) =>
                          const CupertinoActivityIndicator(),
                    ),
                  ),
                ),
                const Gap(15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("J u s t  D o  I t !", style: ksubTitleStyle),
                    const Gap(5),
                    Text("Kyaw Lin Thant", style: ktitleStyle),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.notifications_active_outlined),
                  onPressed: () {},
                ),
                const Gap(5),
                SizedBox(
                  width: 40,
                  height: 45,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: IconButton(
                          icon: Icon(Icons.shopping_cart_outlined),
                          onPressed: () {},
                        ),
                      ),
                      BlocBuilder<CartBloc, CartStates>(
                        builder: (_, state) {
                          if (state is CartsLoaded && state.count != 0) {
                            return Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                    color: kCartCountColor,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  child: Center(
                                    child: Text(
                                      state.count.toString(),
                                      style: TextStyle(
                                          color: kPrimaryColor,
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }

                          return const SizedBox();
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
