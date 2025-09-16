import 'package:sneakers_app/entities/vos/cart_item_vo.dart';
import 'package:sneakers_app/entities/vos/package_item_vo.dart';
import 'package:sneakers_app/entities/vos/shipping_item_vo.dart';
import 'package:sneakers_app/features/cart/domain/repositories/cart_repo.dart';

import '../../../../local_db/hive_dao.dart';
import '../../../../utils/log_util.dart';

class RemoveCart {
  final CartRepo repository;

  RemoveCart(this.repository);

  Future<String> call(CartItemVO? cartItem, PackageItemVO? packageItem,
      ShippingItemVO? shippingItem) async {
    try {
      IRemoveCartStrategy strategy;

      if (cartItem != null) {
        strategy = RemoveCartItem(cartItem: cartItem, repository: repository);

        return strategy.removeCart();
      } else if (packageItem != null) {
        strategy =
            RemovePackageItem(packageItem: packageItem, repository: repository);

        return strategy.removeCart();
      } else {
        strategy = RemoveShippingItem(
            shippingItem: shippingItem!, repository: repository);

        return strategy.removeCart();
      }
    } catch (error) {
      logger.e("Error occurred when removing cart! Error: $error");
      return Future.error(
          "Error occurred when removing to cart! Please try again with correct parameters. Error sms: $error");
    }
  }
}

//Strategy Pattern Interface
abstract class IRemoveCartStrategy {
  Future<String> removeCart();
}

//Concrete Class: Remove CartItem
class RemoveCartItem implements IRemoveCartStrategy {
  final CartItemVO cartItem;
  final CartRepo repository;

  RemoveCartItem({required this.cartItem, required this.repository});

  @override
  Future<String> removeCart() async {
    try {
      List cart = LocalDbDAO.instance.getSneakersCart() ?? [];
      List packageCart = LocalDbDAO.instance.getPackageCart() ?? [];
      List shippingCart = LocalDbDAO.instance.getShippingCart() ?? [];

      cart.remove(cartItem);

      for (PackageItemVO packageItem in List.from(packageCart)) {
        if (packageItem.id == cartItem.id) {
          packageCart.remove(packageItem);
        }
      }

      for (ShippingItemVO shippingItem in List.from(shippingCart)) {
        if (shippingItem.id == cartItem.id) {
          shippingCart.remove(shippingItem);
        }
      }

      repository.removeCart(cart);
      LocalDbDAO.instance.savePackageCart(cart: packageCart);
      LocalDbDAO.instance.saveShippingCart(cart: shippingCart);

      return "Successfully removed from cart!";
    } catch (error) {
      logger.e("Error occurred on removing the cart item! Error: $error");
      return Future.error(
          "Error occurred while removing the cart item! Please try again! Error sms: $error");
    }
  }
}

//Concrete Class: Remove PackageItem
class RemovePackageItem implements IRemoveCartStrategy {
  final PackageItemVO packageItem;
  final CartRepo repository;

  RemovePackageItem({required this.packageItem, required this.repository});

  @override
  Future<String> removeCart() async {
    try {
      List cart = LocalDbDAO.instance.getSneakersCart() ?? [];
      List packageCart = LocalDbDAO.instance.getPackageCart() ?? [];

      packageCart.remove(packageItem);

      for (CartItemVO cartItem in List.from(cart)) {
        if (cartItem.id == packageItem.id) {
          cart.remove(cartItem);
        }
      }

      repository.removeCart(cart);
      LocalDbDAO.instance.savePackageCart(cart: packageCart);

      return "Successfully removed from cart!";
    } catch (error) {
      logger.e(
          "Error occurred on removing the cart item! Read message on screen");
      return Future.error(
          "Error occurred while removing the cart item! Please try again! Error sms: $error");
    }
  }
}

//Concrete Class: Remove Shipping Item
class RemoveShippingItem implements IRemoveCartStrategy {
  final ShippingItemVO shippingItem;
  final CartRepo repository;

  RemoveShippingItem({required this.shippingItem, required this.repository});

  @override
  Future<String> removeCart() async {
    try {
      List cart = LocalDbDAO.instance.getSneakersCart() ?? [];
      List packageCart = LocalDbDAO.instance.getPackageCart() ?? [];
      List shippingCart = LocalDbDAO.instance.getShippingCart() ?? [];

      shippingCart.remove(shippingItem);

      for (PackageItemVO packageItem in List.from(packageCart)) {
        if (packageItem.id == shippingItem.id) {
          packageCart.remove(packageItem);
        }
      }

      for (CartItemVO cartItem in List.from(cart)) {
        if (cartItem.id == shippingItem.id) {
          cart.remove(cartItem);
        }
      }

      repository.removeCart(cart);
      LocalDbDAO.instance.savePackageCart(cart: packageCart);
      LocalDbDAO.instance.saveShippingCart(cart: shippingCart);

      return "Successfully removed from cart!";
    } catch (error) {
      logger.e(
          "Error occurred on removing the cart item! Read message on screen");
      return Future.error(
          "Error occurred while removing the cart item! Please try again! Error sms: $error");
    }
  }
}
