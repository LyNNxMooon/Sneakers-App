import 'package:sneakers_app/entities/vos/sneaker_vo.dart';
import 'package:sneakers_app/features/cart/domain/repositories/cart_repo.dart';

import '../../../../entities/vos/cart_item_vo.dart';
import '../../../../entities/vos/package_item_vo.dart';
import '../../../../entities/vos/shipping_item_vo.dart';
import '../../../../local_db/hive_dao.dart';
import '../../../../utils/log_util.dart';

class AddToCart {
  final CartRepo repository;

  AddToCart(this.repository);

  Future<String> call(SneakerVO sneaker, int qty, bool package, bool shipping,
      {String packageType = "", String shippingType = ""}) async {
    try {
      AddCartItem addingCartFunction = AddNormalCartItem();

      if (shipping && package) {
        addingCartFunction =
            AddCartItemWithPackageDecorator(addingCartFunction, packageType);
        addingCartFunction = AddCartItemWithShippingDecorator(
            addingCartFunction, shippingType, packageType);

        return addingCartFunction.addToCart(
            sneaker, qty, package, shipping, repository);
      }

      if (package) {
        addingCartFunction =
            AddCartItemWithPackageDecorator(addingCartFunction, packageType);

        return addingCartFunction.addToCart(
            sneaker, qty, package, shipping, repository);
      }

      return addingCartFunction.addToCart(
          sneaker, qty, package, shipping, repository);
    } catch (error) {
      logger.e("Error occurred when adding cart! Read Error sms on screen!");
      return Future.error(
          "Error occurred when adding to cart! Please try again with correct parameters. Error sms: $error");
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

//Decorator Pattern
//Common interface
abstract class AddCartItem {
  Future<String> addToCart(SneakerVO sneaker, int qty, bool package,
      bool shipping, CartRepo repository);
}

//Concrete component (Base Object)
class AddNormalCartItem implements AddCartItem {
  @override
  Future<String> addToCart(SneakerVO sneaker, int qty, bool package,
      bool shipping, CartRepo repository) async {
    try {
      List sneakersCart = LocalDbDAO.instance.getSneakersCart() ?? [];

      CartItemVO newItem = CartItemVO(
          id: sneaker.id,
          title: sneaker.title,
          brand: sneaker.brand,
          model: sneaker.model,
          gender: sneaker.gender,
          image: sneaker.image,
          sku: sneaker.sku,
          secondaryCategory: sneaker.secondaryCategory,
          qty: qty,
          package: package,
          shipping: shipping);

      sneakersCart.add(newItem);

      repository.addToCart(sneakersCart);

      return "Successfully added to cart!";
    } catch (error) {
      logger.e("Error occurred when adding to cart!");
      return Future.error("Error adding to cart: $error");
    }
  }
}

//Decorator Class
class AddCartItemDecorator implements AddCartItem {
  final AddCartItem _wrapperAddCartItem;

  AddCartItemDecorator(this._wrapperAddCartItem);

  @override
  Future<String> addToCart(SneakerVO sneaker, int qty, bool package,
      bool shipping, CartRepo repository) async {
    return _wrapperAddCartItem.addToCart(
        sneaker, qty, package, shipping, repository);
  }
}

//Concrete Decorators with new functionality
class AddCartItemWithPackageDecorator extends AddCartItemDecorator {
  final String packageType;
  AddCartItemWithPackageDecorator(super.wrapperAddCartItem, this.packageType);

  @override
  Future<String> addToCart(SneakerVO sneaker, int qty, bool package,
      bool shipping, CartRepo repository) async {
    try {
      String returnMessage =
          await super.addToCart(sneaker, qty, package, shipping, repository);
      List packageCart = LocalDbDAO.instance.getPackageCart() ?? [];

      PackageItemVO newPackageItem = PackageItemVO(
          id: sneaker.id,
          title: sneaker.title,
          model: sneaker.model,
          image: sneaker.image,
          sku: sneaker.sku,
          qty: qty,
          packageType: packageType);

      packageCart.add(newPackageItem);

      LocalDbDAO.instance.savePackageCart(cart: packageCart);

      returnMessage += "\n Item is wrapped with $packageType";

      return returnMessage;
    } catch (error) {
      logger.e("Error occurred when adding to cart with package!");
      return Future.error("Error adding to cart with package: $error");
    }
  }
}

class AddCartItemWithShippingDecorator extends AddCartItemDecorator {
  final String packageType;
  final String shippingType;
  AddCartItemWithShippingDecorator(
      super.wrapperAddCartItem, this.shippingType, this.packageType);

  @override
  Future<String> addToCart(SneakerVO sneaker, int qty, bool package,
      bool shipping, CartRepo repository) async {
    try {
      String returnMessage =
          await super.addToCart(sneaker, qty, package, shipping, repository);
      List shippingCart = LocalDbDAO.instance.getShippingCart() ?? [];

      ShippingItemVO newShippingItem = ShippingItemVO(
          id: sneaker.id,
          title: sneaker.title,
          model: sneaker.model,
          image: sneaker.image,
          sku: sneaker.sku,
          qty: qty,
          packageType: packageType,
          shippingType: shippingType);

      shippingCart.add(newShippingItem);

      LocalDbDAO.instance.saveShippingCart(cart: shippingCart);

      logger.d("Item added to cart with shipping: $shippingType!");
      returnMessage += "\n Item is Shipped with $shippingType";

      return returnMessage;
    } catch (error) {
      logger.e("Error occurred when adding to cart with shipping!");
      return Future.error("Error adding to cart with shipping: $error");
    }
  }
}
