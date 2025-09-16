import 'package:flutter/cupertino.dart';
import 'package:sneakers_app/entities/vos/cart_item_vo.dart';
import 'package:sneakers_app/entities/vos/package_item_vo.dart';
import 'package:sneakers_app/entities/vos/shipping_item_vo.dart';
import 'package:sneakers_app/entities/vos/sneaker_vo.dart';
import 'package:sneakers_app/utils/enums.dart';

abstract class CartEvents {}

class AddToCartEvent extends CartEvents {
  final SneakerVO sneaker;
  final int qty;
  final bool package;
  final bool shipping;
  final String packageType;
  final String shippingType;

  AddToCartEvent(
      {required this.sneaker,
      required this.qty,
      required this.package,
      required this.shipping,
      this.packageType = "",
      this.shippingType = ""});
}

class RemoveCartEvent extends CartEvents {
  final CartItemVO? cartItem;
  final PackageItemVO? packageItem;
  final ShippingItemVO? shippingItem;

  RemoveCartEvent(this.cartItem, this.packageItem, this.shippingItem);
}

class UpdateCart extends CartEvents {}

class LoadCart extends CartEvents {
  final CartType cartType;
  final BuildContext context;

  LoadCart({required this.cartType, required this.context});
}
