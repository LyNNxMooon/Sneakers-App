import 'package:sneakers_app/features/cart/domain/repositories/cart_repo.dart';
import 'package:sneakers_app/utils/enums.dart';

import '../../../../local_db/hive_dao.dart';
import '../../../../utils/log_util.dart';

class LoadCartUseCase {
  final CartRepo repository;

  LoadCartUseCase(this.repository);

  Future<List> call(CartType cartType) async {
    try {
      logger.d("Loading Carts...");
      return repository.getCart(cartType);
    } catch (error) {
      logger
          .e("Error occurred when loading cart! Read the error sms on screen!");

      return Future.error(
          "Error occurred when loading cart from db. Try again! Error: $error");
    }
  }

  //Providing cached data to display while loading
  Future<List?> getCachedSneakersCartWhileLoading() async {
    try {
      return LocalDbDAO.instance.getSneakersCart();
    } catch (error) {
      return null;
    }
  }

  Future<List?> getCachedPackageCartWhileLoading() async {
    try {
      return LocalDbDAO.instance.getPackageCart();
    } catch (error) {
      return null;
    }
  }

  Future<List?> getCachedShippingCartWhileLoading() async {
    try {
      return LocalDbDAO.instance.getShippingCart();
    } catch (error) {
      return null;
    }
  }
}
