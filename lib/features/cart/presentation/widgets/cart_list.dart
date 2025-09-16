import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart'
    show CupertinoActivityIndicator, CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:sneakers_app/entities/vos/cart_item_vo.dart';
import 'package:sneakers_app/entities/vos/package_item_vo.dart';
import 'package:sneakers_app/entities/vos/shipping_item_vo.dart';
import 'package:sneakers_app/features/cart/presentation/BLoC/cart_states.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/images.dart';
import '../../../../utils/enums.dart';
import '../BLoC/cart_bloc.dart';
import '../BLoC/cart_events.dart';

class CartList extends StatelessWidget {
  const CartList({super.key, required this.cart});

  final List cart;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AnimationLimiter(
        child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) =>
                cartItem(cart[index], context, index),
            separatorBuilder: (context, index) => const Gap(15),
            itemCount: cart.length),
      ),
    );
  }

  Widget cartItem(CartItemVO cartItem, BuildContext context, int index) {
    return AnimationConfiguration.staggeredList(
        duration: const Duration(milliseconds: 1000),
        position: index,
        child: ScaleAnimation(
          child: FadeInAnimation(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              width: double.infinity,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BlocConsumer<CartBloc, CartStates>(
                    builder: (context, state) {
                      if (state is CartLoading) {
                        return GestureDetector(
                          onTap: () {},
                          child: Center(
                            child: Icon(
                              Icons.delete,
                              size: 18,
                              color: kThirdColor,
                            ),
                          ),
                        );
                      }

                      return GestureDetector(
                        onTap: () {
                          context
                              .read<CartBloc>()
                              .add(RemoveCartEvent(cartItem, null, null));

                          context.read<CartBloc>().add(LoadCart(
                              cartType: CartType.cart, context: context));
                        },
                        child: Center(
                          child: Icon(
                            Icons.delete,
                            size: 18,
                            color: kThirdColor,
                          ),
                        ),
                      );
                    },
                    listener: (context, state) {
                      if (state is CartError) {
                        showTopSnackBar(
                          Overlay.of(context),
                          CustomSnackBar.error(
                            message: state.message,
                          ),
                        );
                      }

                      if (state is RemovedFromCart) {
                        showTopSnackBar(
                          Overlay.of(context),
                          CustomSnackBar.success(
                            maxLines: 5,
                            message: state.message,
                          ),
                        );
                      }
                    },
                  ),
                  Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(5)),
                    width: 55,
                    height: 75,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CachedNetworkImage(
                        imageUrl: cartItem.image,
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.42,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cartItem.title.length > 20
                              ? "${cartItem.title.substring(0, 20)} ..."
                              : cartItem.title,
                          style: TextStyle(fontSize: 13),
                        ),
                        const Gap(5),
                        Row(
                          children: [
                            Text(
                              "${cartItem.qty * 120.89} Ks",
                              style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                  color: kThirdColor),
                            ),
                            const Gap(10),
                            cartItem.package
                                ? Icon(
                                    CupertinoIcons.cube_box_fill,
                                    size: 18,
                                    color: kFourthColor,
                                  )
                                : const SizedBox(),
                            const Gap(10),
                            cartItem.shipping
                                ? Icon(
                                    Icons.local_shipping,
                                    size: 18,
                                    color: kFourthColor,
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                              color: kThirdColor,
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Icon(
                              Icons.add,
                              size: 14,
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          cartItem.qty.toString(),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                              color: kThirdColor,
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Icon(
                              Icons.remove,
                              size: 14,
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class PackageCartList extends StatelessWidget {
  const PackageCartList({super.key, required this.cart});

  final List cart;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AnimationLimiter(
        child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) =>
                cartItem(cart[index], context, index),
            separatorBuilder: (context, index) => const Gap(15),
            itemCount: cart.length),
      ),
    );
  }

  Widget cartItem(PackageItemVO cartItem, BuildContext context, int index) {
    return AnimationConfiguration.staggeredList(
        duration: const Duration(milliseconds: 1000),
        position: index,
        child: ScaleAnimation(
          child: FadeInAnimation(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              width: double.infinity,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BlocConsumer<CartBloc, CartStates>(
                    builder: (context, state) {
                      if (state is CartLoading) {
                        return GestureDetector(
                          onTap: () {},
                          child: Center(
                            child: Icon(
                              Icons.delete,
                              size: 18,
                              color: kThirdColor,
                            ),
                          ),
                        );
                      }

                      return GestureDetector(
                        onTap: () {
                          context
                              .read<CartBloc>()
                              .add(RemoveCartEvent(null, cartItem, null));

                          context.read<CartBloc>().add(LoadCart(
                              cartType: CartType.packageCart,
                              context: context));
                        },
                        child: Center(
                          child: Icon(
                            Icons.delete,
                            size: 18,
                            color: kThirdColor,
                          ),
                        ),
                      );
                    },
                    listener: (context, state) {
                      if (state is CartError) {
                        showTopSnackBar(
                          Overlay.of(context),
                          CustomSnackBar.error(
                            message: state.message,
                          ),
                        );
                      }

                      if (state is RemovedFromCart) {
                        showTopSnackBar(
                          Overlay.of(context),
                          CustomSnackBar.success(
                            maxLines: 5,
                            message: state.message,
                          ),
                        );
                      }
                    },
                  ),
                  Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(5)),
                    width: 55,
                    height: 75,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CachedNetworkImage(
                        imageUrl: cartItem.image,
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.42,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cartItem.title.length > 20
                              ? "${cartItem.title.substring(0, 20)} ..."
                              : cartItem.title,
                          style: TextStyle(fontSize: 13),
                        ),
                        const Gap(5),
                        Text(
                          "${cartItem.qty * 120.89} Ks",
                          style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: kThirdColor),
                        ),
                        const Gap(5),
                        Text(
                          cartItem.packageType,
                          style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: kThirdColor),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                              color: kThirdColor,
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Icon(
                              Icons.add,
                              size: 14,
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          cartItem.qty.toString(),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                              color: kThirdColor,
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Icon(
                              Icons.remove,
                              size: 14,
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class ShippingCartList extends StatelessWidget {
  const ShippingCartList({super.key, required this.cart});

  final List cart;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AnimationLimiter(
        child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) =>
                cartItem(cart[index], context, index),
            separatorBuilder: (context, index) => const Gap(15),
            itemCount: cart.length),
      ),
    );
  }

  Widget cartItem(ShippingItemVO cartItem, BuildContext context, int index) {
    return AnimationConfiguration.staggeredList(
        duration: const Duration(milliseconds: 1000),
        position: index,
        child: ScaleAnimation(
          child: FadeInAnimation(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              width: double.infinity,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BlocConsumer<CartBloc, CartStates>(
                    builder: (context, state) {
                      if (state is CartLoading) {
                        return GestureDetector(
                          onTap: () {},
                          child: Center(
                            child: Icon(
                              Icons.delete,
                              size: 18,
                              color: kThirdColor,
                            ),
                          ),
                        );
                      }

                      return GestureDetector(
                        onTap: () {
                          context
                              .read<CartBloc>()
                              .add(RemoveCartEvent(null, null, cartItem));

                          context.read<CartBloc>().add(LoadCart(
                              cartType: CartType.shippingCart,
                              context: context));
                        },
                        child: Center(
                          child: Icon(
                            Icons.delete,
                            size: 18,
                            color: kThirdColor,
                          ),
                        ),
                      );
                    },
                    listener: (context, state) {
                      if (state is CartError) {
                        showTopSnackBar(
                          Overlay.of(context),
                          CustomSnackBar.error(
                            message: state.message,
                          ),
                        );
                      }

                      if (state is RemovedFromCart) {
                        showTopSnackBar(
                          Overlay.of(context),
                          CustomSnackBar.success(
                            maxLines: 5,
                            message: state.message,
                          ),
                        );
                      }
                    },
                  ),
                  Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(5)),
                    width: 55,
                    height: 75,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CachedNetworkImage(
                        imageUrl: cartItem.image,
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.42,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cartItem.title.length > 20
                              ? "${cartItem.title.substring(0, 20)} ..."
                              : cartItem.title,
                          style: TextStyle(fontSize: 13),
                        ),
                        const Gap(5),
                        Text(
                          "${cartItem.qty * 120.89} Ks",
                          style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: kThirdColor),
                        ),
                        const Gap(5),
                        Text(
                          "${cartItem.packageType} | ${cartItem.shippingType}",
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: kThirdColor),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                              color: kThirdColor,
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Icon(
                              Icons.add,
                              size: 14,
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          cartItem.qty.toString(),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                              color: kThirdColor,
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Icon(
                              Icons.remove,
                              size: 14,
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
