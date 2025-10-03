import 'package:sneakers_app/entities/vos/cart_item_vo.dart';
import 'package:sneakers_app/entities/vos/package_item_vo.dart';
import 'package:sneakers_app/entities/vos/shipping_item_vo.dart';

abstract class CartStates {}

class CartInitial extends CartStates {}

class CartLoading extends CartStates {
  final List? sneakersCart;
  final List? packageCart;
  final List? shippingCart;

  CartLoading(this.sneakersCart, this.packageCart, this.shippingCart);
}

class AddedToCart extends CartStates {
  final String message;

  AddedToCart(this.message);
}

class CartsLoaded extends CartStates {
  final List<CartItemVO> cart;
  final List<PackageItemVO> packageCart;
  final List<ShippingItemVO> shippingCart;
  final int count;

  CartsLoaded(this.cart, this.packageCart, this.shippingCart, this.count);
}

class RemovedFromCart extends CartStates {
  final String message;

  RemovedFromCart(this.message);
}

class CartError extends CartStates {
  final String message;

  CartError(this.message);
}
