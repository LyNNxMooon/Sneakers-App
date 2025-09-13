import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class CartPageLoadingWidget extends StatelessWidget {
  const CartPageLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: AnimationLimiter(
        child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) =>
                AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(microseconds: 1000),
                  child: ScaleAnimation(
                    child: FadeInAnimation(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        width: MediaQuery.of(context).size.width * 1 - 40,
                        height: 85,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(5)),
                      ),
                    ),
                  ),
                ),
            separatorBuilder: (context, index) => const Gap(15),
            itemCount: 20),
      ),
    );
  }
}
