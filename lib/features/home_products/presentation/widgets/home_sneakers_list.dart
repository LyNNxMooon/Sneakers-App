import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sneakers_app/features/home_products/data/vos/sneaker_vo.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/images.dart';

class HomeSneakersList extends StatelessWidget {
  const HomeSneakersList({super.key, required this.sneakersList});

  final List<SneakerVO> sneakersList;
  final int columnCount = 2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: AnimationLimiter(
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columnCount,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: 0.7),
          itemBuilder: (context, index) => itemCard(sneakersList[index], index),
          itemCount: sneakersList.length,
        ),
      ),
    );
  }

  Widget itemCard(SneakerVO sneaker, int index) {
    return AnimationConfiguration.staggeredGrid(
      position: index,
      duration: const Duration(milliseconds: 1000),
      columnCount: columnCount,
      child: ScaleAnimation(
          child: FadeInAnimation(
        child: Container(
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(12), // Slightly rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15), // Soft shadow
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 5), // Shadow position
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(15),
              Center(
                child: SizedBox(
                  height: 100,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: sneaker.image,
                      placeholder: (_, url) => CupertinoActivityIndicator(
                        radius: 15,
                      ),
                      errorWidget: (_, url, error) => Image.asset(
                        placeholderSampleSneaker,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              const Gap(15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  sneaker.title.length > 30
                      ? "${sneaker.title.substring(0, 30)} ..."
                      : sneaker.title,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const Gap(10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.star_rate_rounded,
                          color: Colors.yellow,
                          size: 20,
                        ),
                        const Gap(5),
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Text(
                            "4.5",
                            style: TextStyle(fontSize: 12),
                          ),
                        )
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      height: 18,
                      decoration: BoxDecoration(
                          color: kFifthColor,
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        children: [
                          Icon(
                            Icons.person_2_outlined,
                            size: 15,
                          ),
                          const Gap(5),
                          Text(
                            sneaker.gender,
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const Gap(20),
              Padding(
                padding: EdgeInsets.only(left: 22, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$120.89",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Icon(Icons.add_shopping_cart, size: 20,)
                  ],
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
