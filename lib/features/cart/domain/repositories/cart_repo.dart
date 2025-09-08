import 'package:sneakers_app/entities/vos/cart_item_vo.dart';
import 'package:sneakers_app/utils/enums.dart';

abstract class CartRepo {
  Future<void> addToCart(List sneakersCart);

  Future<List> getCart(CartType cartType);

  Future<void> removeCart(List sneakersCart);

  Future<void> updateCart(List sneakersCart);
}
