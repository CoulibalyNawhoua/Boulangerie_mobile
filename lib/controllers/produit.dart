import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../constantes/api.dart';
import '../modèles/produit.dart';

class ProductController extends GetxController {
  final isLoading = false.obs;
  final token = GetStorage().read("access_token");
  RxList<Product> products = <Product>[].obs;

  Future<void> fetchProduct() async {
    try {
      isLoading.value = true;
      products.clear();
      var response = await http.get(Uri.parse(Api.product), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        isLoading.value = false;
        var responseBody = jsonDecode(response.body);

        List<dynamic> data = responseBody['data'];
        List<Product> productList =
            data.map((json) => Product.fromJson(json)).toList();
        products.assignAll(productList);

        // for (var item in responseBody["data"]) {
        //   if (item is Map<String, dynamic>) {
        //     listProduct.add(Product.fromJson(item));
        //   } else {
        //     if (kDebugMode) {
        //       print("echec");
        //     }
        //   }
        // }
      } else {
        isLoading.value = false;

        if (kDebugMode) {
          print("Erreur lors de la récupération des produits");
        }

        if (kDebugMode) {
          print(json.decode(response.body));
        }
      }
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      isLoading.value = false;
    }
  }
}
