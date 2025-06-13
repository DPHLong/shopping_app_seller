import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  Map<String, dynamic> productData = {
    'productName': '',
    'productPrice': '',
    'productQuantity': '',
    'productDescription': '',
    'productCategory': '',
    'shippingCost': '',
    'isShippingCharged': '',
    'brandName': '',
    'sizeList': [],
    'productImagesUrls': [],
  };

  getFormdata({
    String? productName,
    double? productPrice,
    int? productQuantity,
    String? productDescription,
    String? productCategory,
    bool? isShippingCharged,
    double? shippingCost,
    String? brandName,
    List<String>? sizeList,
    List<String>? productImagesUrls,
  }) {
    if (productName != null) {
      productData['productName'] = productName;
    }
    if (productPrice != null) {
      productData['productPrice'] = productPrice;
    }
    if (productQuantity != null) {
      productData['productQuantity'] = productQuantity;
    }
    if (productDescription != null) {
      productData['productDescription'] = productDescription;
    }
    if (productCategory != null) {
      productData['productCategory'] = productCategory;
    }
    if (isShippingCharged != null) {
      productData['isShippingCharged'] = isShippingCharged;
    }
    if (shippingCost != null) {
      productData['shippingCost'] = shippingCost;
    }
    if (brandName != null) {
      productData['brandName'] = brandName;
    }
    if (sizeList != null) {
      productData['sizeList'] = sizeList;
    }
    if (productImagesUrls != null) {
      productData['productImagesUrls'] = productImagesUrls;
    }
    notifyListeners();
  }

  clearData() {
    productData.clear();
    notifyListeners();
  }
}
