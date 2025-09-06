import 'package:sneakers_app/entities/vos/cart_item_vo.dart';

abstract class CartRepo {
  Future<void> addToCart(List sneakersCart);

  Future<List> getSneakersCart();

  Future<void> removeCart(List sneakersCart);

  Future<void> updateCart(List sneakersCart);
}
