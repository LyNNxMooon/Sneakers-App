import 'package:alert_info/alert_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:sneakers_app/features/cart/domain/repositories/cart_repo.dart';
import 'package:sneakers_app/utils/enums.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

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

class LoadCartCountUseCase {
  Future<int> call(BuildContext context) async {
    try {
      final notifier = CountNotifier();

      final countObserver = CountChannel();
      final snackBarAlertObserver = SnackBarAlertChannel(context: context);

      notifier.subscribe(countObserver);
      notifier.subscribe(snackBarAlertObserver);

      return notifier.notifyCount();
    } catch (error) {
      logger.e("Error showing cart count! Error: $error");
      return Future.error("Error showing cart count! Error: $error");
    }
  }
}

//Observer Interface
abstract class ICountChannel {
  int update();
}

//Subject (Observable)
class CountNotifier {
  final List<ICountChannel> _channels = [];

  void subscribe(ICountChannel channel) {
    _channels.add(channel);
  }

  void unsubscribe(ICountChannel channel) {
    _channels.remove(channel);
  }

  int _notifyChannels() {
    int count = 0;
    for (final channel in _channels) {
      count = channel.update();
    }

    return count;
  }

  int notifyCount() {
    return _notifyChannels();
  }
}

//Concrete class: provide count
class CountChannel implements ICountChannel {
  @override
  int update() {
    List cart = LocalDbDAO.instance.getSneakersCart() ?? [];

    return cart.length;
  }
}

//Concrete class : Snack bar count alert
class SnackBarAlertChannel implements ICountChannel {
  final BuildContext context;

  SnackBarAlertChannel({required this.context});
  @override
  int update() {
    List cart = LocalDbDAO.instance.getSneakersCart() ?? [];

    AlertInfo.show(
        context: context,
        text: 'You now have ${cart.length} items in cart!',
        position: MessagePosition.bottom,
        typeInfo: TypeInfo.success);

    return cart.length;
  }
}
