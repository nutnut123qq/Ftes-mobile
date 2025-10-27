import 'package:flutter/foundation.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/cart_item_model.dart';
import '../models/cart_summary_model.dart';
import '../models/add_to_cart_request_model.dart';
import '../helpers/json_parser_helper.dart';
import '../../domain/constants/cart_constants.dart';
import 'cart_remote_datasource.dart';

/// Remote data source implementation for Cart feature
class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final ApiClient _apiClient;

  CartRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<bool> addToCart(String courseId) async {
    try {
      print('🛒 Adding course to cart: $courseId');
      
      final request = AddToCartRequestModel(courseId: courseId);
      
      final response = await _apiClient.post(
        '${AppConstants.cartEndpoint}',
        data: request.toJson(),
      );
      
      print('📥 Add to cart response status: ${response.statusCode}');
      print('📥 Add to cart response data: ${response.data}');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['success'] == true) {
          final messageCode = data['messageDTO']?['code'];
          if (messageCode == 'M001' || messageCode == 'M004') {
            return true; // Success or already in cart
          }
        }
        throw ServerException('Failed to add to cart');
      } else {
        throw ServerException(response.data?['messageDTO']?['message'] ?? 'Failed to add to cart');
      }
    } catch (e) {
      print('❌ Add to cart error: $e');
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('Failed to add to cart: ${e.toString()}');
    }
  }

  @override
  Future<CartSummaryModel> getCartItems({
    int pageNumber = 1,
    int pageSize = 10,
    String? sortField,
    String sortOrder = 'ASC',
  }) async {
    try {
      print('🛒 Getting cart items: page=$pageNumber, size=$pageSize');
      
      final queryParams = <String, dynamic>{
        'pageNumber': pageNumber.toString(),
        'pageSize': pageSize.toString(),
        'sortOrder': sortOrder,
      };
      
      if (sortField != null && sortField.isNotEmpty) {
        queryParams['sortField'] = sortField;
      }
      
      final response = await _apiClient.get(
        '${AppConstants.cartEndpoint}',
        queryParameters: queryParams,
      );
      
      print('📥 Get cart items response status: ${response.statusCode}');
      print('📥 Get cart items response data: ${response.data}');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['success'] == true) {
          final result = data['result'];
          if (result != null) {
            // Extract items list from 'data' field
            List<dynamic> itemsList;
            if (result['data'] is List) {
              itemsList = result['data'] as List;
            } else {
              itemsList = [];
            }
            
            // Extract pagination info
            final paging = result['paging'] as Map<String, dynamic>?;
            final currentPage = paging?['currentPage'] ?? result['currentPage'] ?? 1;
            final totalPages = result['totalPages'] ?? 1;
            final totalElements = result['totalElements'] ?? itemsList.length;
            
            // Use compute() isolate for parsing if list is large
            if (itemsList.length > CartConstants.computeIsolateThreshold) {
              print('🔄 Using compute() isolate for parsing ${itemsList.length} cart items');
              final items = await compute(parseCartItemListJson, itemsList);
              
              // Return CartSummaryModel with parsed items
              return CartSummaryModel.fromItems(
                items: items,
                currentPage: currentPage,
                totalPages: totalPages,
                totalElements: totalElements,
              );
            } else {
              // For smaller lists, parse directly on main isolate
              final items = parseCartItemListJson(itemsList);
              
              return CartSummaryModel.fromItems(
                items: items,
                currentPage: currentPage,
                totalPages: totalPages,
                totalElements: totalElements,
              );
            }
          }
        }
        throw ServerException('Invalid response format - missing result');
      } else {
        throw ServerException(response.data?['messageDTO']?['message'] ?? 'Failed to get cart items');
      }
    } catch (e) {
      print('❌ Get cart items error: $e');
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('Failed to get cart items: ${e.toString()}');
    }
  }

  @override
  Future<int> getCartCount() async {
    try {
      print('🛒 Getting cart count');
      
      final response = await _apiClient.get(
        '${AppConstants.cartCountEndpoint}',
      );
      
      print('📥 Get cart count response status: ${response.statusCode}');
      print('📥 Get cart count response data: ${response.data}');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['success'] == true) {
          final result = data['result'];
          if (result != null) {
            return result is int ? result : int.tryParse(result.toString()) ?? 0;
          }
        }
        throw ServerException('Invalid response format - missing result');
      } else {
        throw ServerException(response.data?['messageDTO']?['message'] ?? 'Failed to get cart count');
      }
    } catch (e) {
      print('❌ Get cart count error: $e');
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('Failed to get cart count: ${e.toString()}');
    }
  }

  @override
  Future<bool> removeFromCart(String cartItemId) async {
    try {
      print('🛒 Removing cart item: $cartItemId');
      
      final response = await _apiClient.delete(
        '${AppConstants.cartEndpoint}/$cartItemId',
      );
      
      print('📥 Remove from cart response status: ${response.statusCode}');
      print('📥 Remove from cart response data: ${response.data}');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['success'] == true) {
          return true;
        }
        throw ServerException('Failed to remove from cart');
      } else {
        throw ServerException(response.data?['messageDTO']?['message'] ?? 'Failed to remove from cart');
      }
    } catch (e) {
      print('❌ Remove from cart error: $e');
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('Failed to remove from cart: ${e.toString()}');
    }
  }
}
