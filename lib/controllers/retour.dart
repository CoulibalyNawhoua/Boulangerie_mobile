import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../constantes/api.dart';
import '../modèles/historique.dart';

class RetourController extends GetxController {
  final isLoading = false.obs;
  final token = GetStorage().read("access_token");
  RxList<HistorieProduct> retourProducts = <HistorieProduct>[].obs;
  var searchQuery = ''.obs; // Variable pour le terme de recherche

  
    Future<void> fetchRetour() async {
    try {
      isLoading.value = true;
      retourProducts.clear();
      var response = await http.get(Uri.parse(Api.orderReturn), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        isLoading.value = false;
        var responseBody = jsonDecode(response.body);

        List<dynamic> data = responseBody['data'];
        List<HistorieProduct> productList = data.map((json) => HistorieProduct.fromJson(json)).toList();

        if (searchQuery.value.isNotEmpty) {
          productList = productList.where((product) => product.name.toLowerCase().contains(searchQuery.value.toLowerCase())).toList();
        }

        retourProducts.assignAll(productList);
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
    }finally{
      isLoading.value = false;
    }
  }

   
}