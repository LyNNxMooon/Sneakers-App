import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shimmer/shimmer.dart';

class SneakersLoadingWidget extends StatelessWidget {
  const SneakersLoadingWidget({super.key});

  final int columnCount = 2;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        period: const Duration(milliseconds: 1500),
        child: AnimationLimiter(
          child: GridView.count(
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: columnCount,
            childAspectRatio: 0.7,
            children: List.generate(
              12,
              (int index) {
                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  duration: const Duration(milliseconds: 1000),
                  columnCount: columnCount,
                  child: ScaleAnimation(
                    child: FadeInAnimation(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class TitleAndPageSettingLoadingWidget extends StatelessWidget {
  const TitleAndPageSettingLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 15, left: 17, bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 10,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      border: Border.all(width: 1.5),
                      borderRadius: BorderRadius.circular(3)),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  width: 130,
                  height: 10,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      border: Border.all(width: 1.5),
                      borderRadius: BorderRadius.circular(3)),
                ),
              ],
            ),
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
                  onPressed: () {},
                  icon: Icon(
                    CupertinoIcons.chevron_down,
                    size: 16,
                  ),
                ),
                CupertinoActivityIndicator(radius: 8,),
                IconButton(
                  onPressed: () {},
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
