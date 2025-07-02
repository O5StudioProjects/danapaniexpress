import 'package:danapaniexpress/core/common_imports.dart';


double calculateTotalAmount({required double productPrice, required int quantity}){
  return productPrice * quantity.toDouble();
}