import 'package:bloc/bloc.dart';
import 'package:sneakers_app/entities/vos/cart_item_vo.dart';
import 'package:sneakers_app/entities/vos/package_item_vo.dart';
import 'package:sneakers_app/entities/vos/shipping_item_vo.dart';
import 'package:sneakers_app/features/cart/domain/use_cases/add_to_cart.dart';
import 'package:sneakers_app/features/cart/domain/use_cases/load_cart.dart';
import 'package:sneakers_app/features/cart/domain/use_cases/remove_cart.dart';
import 'package:sneakers_app/features/cart/presentation/BLoC/cart_events.dart';
import 'package:sneakers_app/features/cart/presentation/BLoC/cart_states.dart';

import '../../../../utils/enums.dart';

class CartBloc extends Bloc<CartEvents, CartStates> {
  final AddToCart addToCartUseCase;
  final LoadCartUseCase loadCartUseCase;
  final RemoveCart removeCartUseCase;
  final LoadCartCountUseCase loadCartCountUseCase;

  CartBloc(
      {required this.addToCartUseCase,
      required this.loadCartUseCase,
      required this.removeCartUseCase,
      required this.loadCartCountUseCase})
      : super(CartInitial()) {
    on<AddToCartEvent>(_onAddToCart);
    on<LoadCart>(_onLoadCart);
    on<RemoveCartEvent>(_onRemoveCart);
  }

  Future<void> _onAddToCart(
      AddToCartEvent event, Emitter<CartStates> emit) async {
    emit(CartLoading(
        await loadCartUseCase.getCachedSneakersCartWhileLoading(),
        await loadCartUseCase.getCachedPackageCartWhileLoading(),
        await loadCartUseCase.getCachedShippingCartWhileLoading()));

    try {
      final message = await addToCartUseCase(
          event.sneaker, event.qty, event.package, event.shipping,
          packageType: event.packageType, shippingType: event.shippingType);

      emit(AddedToCart(message));
    } catch (error) {
      emit(CartError('$error'));
    }
  }

  Future<void> _onRemoveCart(
      RemoveCartEvent event, Emitter<CartStates> emit) async {
    emit(CartLoading(
        await loadCartUseCase.getCachedSneakersCartWhileLoading(),
        await loadCartUseCase.getCachedPackageCartWhileLoading(),
        await loadCartUseCase.getCachedShippingCartWhileLoading()));

    try {
      final message = await removeCartUseCase(
          event.cartItem, event.packageItem, event.shippingItem);

      emit(RemovedFromCart(message));
    } catch (error) {
      emit(CartError('$error'));
    }
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartStates> emit) async {
    emit(CartLoading(
        await loadCartUseCase.getCachedSneakersCartWhileLoading(),
        await loadCartUseCase.getCachedPackageCartWhileLoading(),
        await loadCartUseCase.getCachedShippingCartWhileLoading()));

    try {
      List<CartItemVO> cart = [];
      List<PackageItemVO> packageCart = [];
      List<ShippingItemVO> shippingCart = [];

      if (event.cartType == CartType.cart) {
        cart =
            cart = (await loadCartUseCase(event.cartType)).cast<CartItemVO>();
      } else if (event.cartType == CartType.packageCart) {
        packageCart =
            (await loadCartUseCase(event.cartType)).cast<PackageItemVO>();
      } else {
        shippingCart =
            (await loadCartUseCase(event.cartType)).cast<ShippingItemVO>();
      }

      emit(CartsLoaded(
          cart,
          packageCart,
          shippingCart,
          event.context.mounted
              ? await loadCartCountUseCase(event.context)
              : 0));
    } catch (error) {
      emit(CartError('$error'));
    }
  }
}
