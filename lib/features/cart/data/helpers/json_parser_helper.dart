import '../models/cart_item_model.dart';

/// Top-level function for parsing cart item list JSON in compute isolate
/// This function must be top-level or static to work with compute()
List<CartItemModel> parseCartItemListJson(List<dynamic> jsonList) {
  return jsonList
      .map((json) => CartItemModel.fromJson(json as Map<String, dynamic>))
      .toList();
}

