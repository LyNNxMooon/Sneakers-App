import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/images.dart';
import '../../../../entities/vos/sneaker_vo.dart';

class SearchSneakersList extends StatelessWidget {
  const SearchSneakersList({super.key, required this.sneakersList});

  final List<SneakerVO> sneakersList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: AnimationLimiter(
        child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) =>
                itemCard(sneakersList[index], index, context),
            separatorBuilder: (context, index) => const Gap(25),
            itemCount: sneakersList.length),
      ),
    );
  }

  Widget itemCard(SneakerVO sneaker, int index, BuildContext context) {
    return AnimationConfiguration.staggeredList(
        duration: const Duration(milliseconds: 1000),
        position: index,
        child: ScaleAnimation(
          child: FadeInAnimation(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 90,
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius:
                    BorderRadius.circular(12), // Slightly rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15), // Soft shadow
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 5), // Shadow position
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: CachedNetworkImage(
                            imageUrl: sneaker.image,
                            placeholder: (_, url) => CupertinoActivityIndicator(
                              radius: 13,
                            ),
                            errorWidget: (_, url, error) => Image.asset(
                              placeholderSampleSneaker,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const Gap(20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: Text(
                              sneaker.title.length > 22
                                  ? "${sneaker.title.substring(0, 22)} ..."
                                  : sneaker.title,
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          const Gap(8),
                          Row(
                            children: [
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
                              ),
                              const Gap(15),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 3),

                                child: Text(
                                  sneaker.secondaryCategory!.length > 15
                                      ? "${sneaker.secondaryCategory!.substring(0, 15)} ..."
                                      : sneaker.secondaryCategory!,
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),


                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                  Icon(
                    Icons.add_shopping_cart,
                    size: 20,
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
