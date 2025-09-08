import 'package:bloc/bloc.dart';
import 'package:sneakers_app/features/cart/domain/use_cases/add_to_cart.dart';
import 'package:sneakers_app/features/cart/domain/use_cases/load_cart.dart';
import 'package:sneakers_app/features/cart/presentation/BLoC/cart_events.dart';
import 'package:sneakers_app/features/cart/presentation/BLoC/cart_states.dart';

class CartBloc extends Bloc<CartEvents, CartStates> {
  final AddToCart addToCartUseCase;
  final LoadCartUseCase loadCartUseCase;

  CartBloc({required this.addToCartUseCase, required this.loadCartUseCase})
      : super(CartInitial()) {
    on<AddToCartEvent>(_onAddToCart);
    on<LoadCart>(_onLoadCart);
  }

  Future<void> _onAddToCart(
      AddToCartEvent event, Emitter<CartStates> emit) async {
    emit(CartLoading(
        await addToCartUseCase.getCachedSneakersCartWhileLoading(),
        await addToCartUseCase.getCachedPackageCartWhileLoading(),
        await addToCartUseCase.getCachedShippingCartWhileLoading()));

    try {
      final message = await addToCartUseCase(
          event.sneaker, event.qty, event.package, event.shipping,
          packageType: event.packageType, shippingType: event.shippingType);

      emit(AddedToCart(message));
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
      final List loadedCart = await loadCartUseCase(event.cartType);

      emit(CartsLoaded(loadedCart));
    } catch (error) {
      emit(CartError('$error'));
    }
  }
}
