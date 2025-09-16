import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:sneakers_app/constants/txt_styles.dart';
import 'package:sneakers_app/features/cart/presentation/BLoC/cart_bloc.dart';
import 'package:sneakers_app/features/cart/presentation/BLoC/cart_states.dart';
import 'package:sneakers_app/features/cart/presentation/widgets/cart_loading_widget.dart';

import '../../../../constants/colors.dart';
import '../../../../utils/enums.dart';
import '../BLoC/cart_events.dart';
import '../widgets/cart_detail_widget.dart';
import '../widgets/cart_list.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartType selectedValue = CartType.cart;

  String getCartTypeLabel(CartType type) {
    switch (type) {
      case CartType.cart:
        return "Cart";
      case CartType.packageCart:
        return "Package Cart";
      case CartType.shippingCart:
        return "Shipping Cart";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        const Gap(30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("C a r t", style: ktitleStyle),
              pageSelectionDropDown(),
            ],
          ),
        ),
        const Gap(25),
        CartDetailWidget(
          grandTotal: 1000,
          totalAmount: 990,
        ),
        const Gap(30),
        selectedValue == CartType.packageCart
            ? packageCartStateWidget()
            : selectedValue == CartType.shippingCart
                ? shippingCartStateWidget()
                : cartStateWidget()
      ],
    );
  }

  Widget cartStateWidget() {
    return BlocBuilder<CartBloc, CartStates>(
      builder: (_, state) {
        //loading
        if (state is CartLoading) {
          return (state.sneakersCart == null)
              ? CartPageLoadingWidget()
              : CartList(
                  cart: state.sneakersCart!,
                );
        }

        //Error
        if (state is CartError) {
          return Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.5 - 200),
            child: Center(
              child: Text(
                state.message,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        //Success
        if (state is CartsLoaded) {
          if (state.cart.isEmpty) {
            return Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.5 - 200),
              child: Center(
                child: Text(
                  "Your Cart is Empty",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return CartList(
            cart: state.cart,
          );
        }

        return CartPageLoadingWidget();
      },
    );
  }

  Widget packageCartStateWidget() {
    return BlocBuilder<CartBloc, CartStates>(
      builder: (_, state) {
        //loading
        if (state is CartLoading) {
          return (state.packageCart == null)
              ? CartPageLoadingWidget()
              : CartList(
                  cart: state.packageCart!,
                );
        }

        //Error
        if (state is CartError) {
          return Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.5 - 200),
            child: Center(
              child: Text(
                state.message,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        //Success
        if (state is CartsLoaded) {
          if (state.cart.isEmpty) {
            return Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.5 - 200),
              child: Center(
                child: Text(
                  "Your Cart is Empty",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return PackageCartList(
            cart: state.cart,
          );
        }

        return CartPageLoadingWidget();
      },
    );
  }

  Widget shippingCartStateWidget() {
    return BlocBuilder<CartBloc, CartStates>(
      builder: (_, state) {
        //loading
        if (state is CartLoading) {
          return (state.shippingCart == null)
              ? CartPageLoadingWidget()
              : CartList(
                  cart: state.shippingCart!,
                );
        }

        //Error
        if (state is CartError) {
          return Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.5 - 200),
            child: Center(
              child: Text(
                state.message,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        //Success
        if (state is CartsLoaded) {
          if (state.cart.isEmpty) {
            return Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.5 - 200),
              child: Center(
                child: Text(
                  "Your Cart is Empty",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ShippingCartList(
            cart: state.cart,
          );
        }

        return CartPageLoadingWidget();
      },
    );
  }

  Widget pageSelectionDropDown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: kThirdColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<CartType>(
          value: selectedValue,
          isDense: true,
          icon: Icon(Icons.arrow_drop_down, color: kThirdColor, size: 18),
          dropdownColor: kPrimaryColor,
          style: TextStyle(fontSize: 14, color: kThirdColor),
          items: CartType.values.map((CartType type) {
            return DropdownMenuItem<CartType>(
              value: type,
              enabled: true,
              child: Center(
                child: Text(
                  getCartTypeLabel(type),
                  style: TextStyle(fontSize: 14, color: kThirdColor),
                ),
              ),
            );
          }).toList(),
          onChanged: (CartType? newValue) {
            setState(() {
              selectedValue = newValue!;
              context.read<CartBloc>().add(LoadCart(cartType: selectedValue, context: context));
            });
          },
        ),
      ),
    );
  }
}
