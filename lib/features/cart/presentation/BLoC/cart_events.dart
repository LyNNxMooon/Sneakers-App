import 'package:sneakers_app/entities/vos/sneaker_vo.dart';

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

class RemoveCart extends CartEvents {}

class UpdateCart extends CartEvents {}

class LoadCart extends CartEvents {}
