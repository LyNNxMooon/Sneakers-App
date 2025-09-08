import 'package:sneakers_app/features/cart/domain/repositories/cart_repo.dart';
import 'package:sneakers_app/utils/enums.dart';

import '../../../local_db/hive_dao.dart';

class CartModel implements CartRepo {
  @override
  Future<void> addToCart(List sneakersCart) async {
    try {
      LocalDbDAO.instance.saveSneakersCart(cart: sneakersCart);
    } on Exception catch (error) {
      return Future.error(error);
    }
  }

  @override
  Future<List> getCart(CartType cartType) async {
    try {
      if (cartType == CartType.packageCart) {
        return LocalDbDAO.instance.getPackageCart() ?? [];
      }

      if (cartType == CartType.shippingCart) {
        return LocalDbDAO.instance.getShippingCart() ?? [];
      }

      return LocalDbDAO.instance.getSneakersCart() ?? [];
    } on Exception catch (error) {
      return Future.error(error);
    }
  }

  @override
  Future<void> removeCart(List sneakersCart) async {
    try {
      LocalDbDAO.instance.saveSneakersCart(cart: sneakersCart);
    } on Exception catch (error) {
      return Future.error(error);
    }
  }

  @override
  Future<void> updateCart(List sneakersCart) async {
    try {
      LocalDbDAO.instance.saveSneakersCart(cart: sneakersCart);
    } on Exception catch (error) {
      return Future.error(error);
    }
  }
}
