import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../constantes/api.dart';
import '../modèles/historique.dart';

class LivraisonController extends GetxController {
  final isLoading = false.obs;
  final token = GetStorage().read("access_token");
  RxList<HistorieProduct> livraisonProducts = <HistorieProduct>[].obs;
  RxList<HistorieProduct> filteredLivraisonProducts = <HistorieProduct>[].obs; // Liste filtrée
  var searchQuery = ''.obs; // Variable pour le terme de recherche

  @override
  void onInit() {
    super.onInit();
    fetchLivraison();  // Charger les livraisons lors de l'initialisation
  }


  Future<void> fetchLivraison() async {
    try {
      isLoading.value = true;
      livraisonProducts.clear();
      var response = await http.get(Uri.parse(Api.deliveries), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        isLoading.value = false;
        var responseBody = jsonDecode(response.body);

        List<dynamic> data = responseBody['data'];
        List<HistorieProduct> productList = data.map((json) => HistorieProduct.fromJson(json)).toList();
        livraisonProducts.assignAll(productList);
        filteredLivraisonProducts.assignAll(productList);  // Initialiser la liste filtrée avec toutes les livraisons
        
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
  
  void filterLivraisonProducts(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredLivraisonProducts.assignAll(livraisonProducts);  // Réinitialiser la liste filtrée
    } else {
      filteredLivraisonProducts.assignAll(
        livraisonProducts.where((product) => product.name.toLowerCase().contains(query.toLowerCase())).toList(),
      );
    }
  }
   
}
