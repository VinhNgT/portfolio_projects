import 'package:e_commerce/features/cart/data/interface/cart_repository.dart';
import 'package:e_commerce/features/cart/domain/cart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cart_providers.g.dart';

@riverpod
Stream<Cart> cart(CartRef ref) {
  return ref.watch(cartRepositoryProvider).watchCart();
}
