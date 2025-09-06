abstract class CartStates {}

class CartInitial extends CartStates {}

class CartLoading extends CartStates {
  final List? sneakersCart;
  final List? packageCart;
  final List? shippingCart;

  CartLoading(this.sneakersCart, this.packageCart, this.shippingCart);
}

class AddedToCart extends CartStates {
  final String message;

  AddedToCart(this.message);
}

class CartsLoaded extends CartStates {
  final List sneakersCart;

  CartsLoaded(this.sneakersCart);
}

class CartError extends CartStates {
  final String message;

  CartError(this.message);
}
