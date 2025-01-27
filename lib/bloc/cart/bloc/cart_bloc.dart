import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mini_ecom_app/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateQuantity>(_onUpdateQuantity);
    _loadCart(); // Load cart data when the bloc is initialized
  }

  void _onAddToCart(AddToCart event, Emitter<CartState> emit) {
    final updatedCart = List<CartItem>.from(state.cartItems);
    final index =
        updatedCart.indexWhere((item) => item.product.id == event.product.id);

    if (index != -1) {
      // If the product is already in the cart, increase its quantity
      updatedCart[index] = updatedCart[index]
          .copyWith(quantity: updatedCart[index].quantity + 1);
    } else {
      // If the product is not in the cart, add it with a quantity of 1
      updatedCart.add(CartItem(product: event.product));
    }

    emit(CartState(cartItems: updatedCart));
    _saveCart(updatedCart); // Save the updated cart to SharedPreferences
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) {
    final updatedCart = List<CartItem>.from(state.cartItems)
      ..removeWhere((item) => item.product.id == event.product.id);
    emit(CartState(cartItems: updatedCart));
    _saveCart(updatedCart); // Save the updated cart to SharedPreferences
  }

  void _onUpdateQuantity(UpdateQuantity event, Emitter<CartState> emit) {
    final updatedCart = List<CartItem>.from(state.cartItems);
    final index =
        updatedCart.indexWhere((item) => item.product.id == event.product.id);

    if (index != -1) {
      updatedCart[index] =
          updatedCart[index].copyWith(quantity: event.quantity);
      emit(CartState(cartItems: updatedCart));
      _saveCart(updatedCart); // Save the updated cart to SharedPreferences
    }
  }

  // Helper method to load cart data from SharedPreferences
  Future<void> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = prefs.getStringList('cart');

    if (cartJson != null) {
      try {
        final cartItems = cartJson.map((json) {
          final data = jsonDecode(json);
          if (data == null ||
              data['product'] == null ||
              data['quantity'] == null) {
            throw FormatException('Invalid cart item data');
          }
          return CartItem(
            product: Product.fromJson(data['product']),
            quantity: data['quantity'],
          );
        }).toList();
        emit(CartState(cartItems: cartItems));
      } catch (e) {
        // If there's an error, clear the cart and log the error
        print('Error loading cart: $e');
        emit(const CartState(cartItems: []));
        await prefs.remove('cart'); // Clear corrupted data
      }
    }
  }

  // Helper method to save cart data to SharedPreferences
  Future<void> _saveCart(List<CartItem> cartItems) async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = cartItems.map((item) {
      return jsonEncode({
        'product': item.product.toJson(),
        'quantity': item.quantity,
      });
    }).toList();
    await prefs.setStringList('cart', cartJson);
  }
}
