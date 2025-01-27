part of 'cart_bloc.dart';

class CartState extends Equatable {
  final List<CartItem> cartItems;

  const CartState({this.cartItems = const []});

  double get totalPrice {
    return cartItems.fold(
        0, (sum, item) => sum + (item.product.price * item.quantity));
  }

  @override
  List<Object> get props => [cartItems];
}

class CartItem {
  final Product product;
  final int quantity;

  CartItem({required this.product, this.quantity = 1});

  CartItem copyWith({int? quantity}) {
    return CartItem(
      product: product,
      quantity: quantity ?? this.quantity,
    );
  }
}
