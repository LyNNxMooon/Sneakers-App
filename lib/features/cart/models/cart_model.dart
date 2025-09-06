import 'package:sneakers_app/features/cart/domain/repositories/cart_repo.dart';

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
  Future<List> getSneakersCart() async {
    try {
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
