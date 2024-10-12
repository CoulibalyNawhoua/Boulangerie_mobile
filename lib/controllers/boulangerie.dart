import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../constantes/api.dart';
import '../modèles/boulangerie.dart';


class BoulangerieController extends GetxController {
  final token = GetStorage().read("access_token");
  final isLoading = false.obs;

  RxList<Boulangerie> boulangeries = <Boulangerie>[].obs;
  RxList<Boulangerie> filteredBoulangeries = <Boulangerie>[].obs;  // Liste filtrée

  @override
  void onInit() {
    super.onInit();
    fetchBoulangerie();  // Charger les boulangeries lors de l'initialisation
  }


  
  Future<void> fetchBoulangerie() async {
    try {
      isLoading.value = true;
      boulangeries.clear();
      var response = await http.get(Uri.parse(Api.listBoulangerie), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        isLoading.value = false;
        var responseBody = jsonDecode(response.body);
        List<dynamic> data = responseBody['data'];
        List<Boulangerie> boulangerieList = data.map((json) => Boulangerie.fromJson(json)).toList();
        boulangeries.assignAll(boulangerieList);
        filteredBoulangeries.assignAll(boulangerieList);  // Initialiser la liste filtrée avec toutes les boulangeries
      } else {
        isLoading.value = false;

        if (kDebugMode) {
          print("Erreur lors de la récupération des boulangeries");
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

  void filterBoulangeries(String query) {
    if (query.isEmpty) {
      filteredBoulangeries.assignAll(boulangeries);  // Réinitialiser la liste filtrée
    } else {
      filteredBoulangeries.assignAll(
        boulangeries.where((boulangerie) => boulangerie.name.toLowerCase().contains(query.toLowerCase())).toList(),
      );
    }
  }
}