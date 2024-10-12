import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../constantes/api.dart';
import '../modèles/boulangerie.dart';
import '../modèles/transaction.dart';
import '../pages/versement/guichet.dart';

class TransactionController extends GetxController {
  final isLoading = false.obs;
  final token = GetStorage().read("access_token");
  RxList<Transaction> transactions = <Transaction>[].obs;
  RxList<Transaction> transactionsRecents = <Transaction>[].obs;
  RxList<Transaction> filteredTransactions = <Transaction>[].obs; // Liste filtrée
  final reliquat = 0.obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchTransaction();  // Charger les transactions lors de l'initialisation
  }
  

  Future<void> fetchTransaction() async {
    try {
      isLoading.value = true;
      transactions.clear();
      var response = await http.get(Uri.parse(Api.transactions), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {

        isLoading.value = false;
        var responseBody = jsonDecode(response.body);

        List<dynamic> data = responseBody['data'];
        List<Transaction> transactionList = data.map((json) => Transaction.fromJson(json)).toList();
        transactions.assignAll(transactionList);
        filteredTransactions.assignAll(transactionList);  // Initialiser la liste filtrée avec toutes les transactions

      } else {
        isLoading.value = false;

        if (kDebugMode) {
          print("Erreur lors de la récupération des transactions");
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

  void filterTransactions(String query) {
    if (query.isEmpty) {
      filteredTransactions.assignAll(transactions);  // Réinitialiser la liste filtrée
    } else {
      filteredTransactions.assignAll(
        transactions.where((transaction) => transaction.name.toLowerCase().contains(query.toLowerCase())).toList(),
      );
    }
  }

  Future<void> fetchTransactionRecent() async {
    try {
      isLoading.value = true;
      transactionsRecents.clear();
      var response =
          await http.get(Uri.parse(Api.transactionsRecents), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        isLoading.value = false;
        var responseBody = jsonDecode(response.body);

        List<dynamic> data = responseBody['data'];
        List<Transaction> recentTransactionList = data.map((json) => Transaction.fromJson(json)).toList();
        transactionsRecents.assignAll(recentTransactionList);
        inspect(recentTransactionList);
      } else {
        isLoading.value = false;

        if (kDebugMode) {
          print("Erreur lors de la récupération des transactions");
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

  Future<void> fetchReliquat(int id ) async {
    try {
      var response = await http.get(Uri.parse(Api.reliquats(id)), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        int reliquatValue = responseBody['data'];
        reliquat.value = reliquatValue;
      } else {
        if (kDebugMode) {
          print("Erreur lors de la récupération du reliquat");
        }
        if (kDebugMode) {
          print(json.decode(response.body));
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> payment(reliquat,id) async {
    try {
      isLoading.value = true;
      var data = {
        "total_amount": reliquat.toString(),
        "bakehouse_id": id.toString(),
      };
      var response = await http.post(Uri.parse(Api.paiement), 
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: data,
      );
      
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body)['data'];
       
        if (responseBody["code"] == 400) {
          isLoading.value = false;
          Get.snackbar(
            "Echec",
            responseBody["msg"],
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }else{
          Get.to(Guichet(
            url: responseBody["payment_url"],
            transactionId: responseBody["transaction_id"],
          ));
        }
       
      } else {
        isLoading.value = false;
        Get.snackbar(
          'Echec : ',
          "echec du paiement",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );

      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> checkPayment(String transactionId) async {
    Timer timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
    var data = {
      "transaction_id": transactionId,
    };
      isLoading.value = true;
      var response = await http.post(
        Uri.parse(Api.updateStatusTransaction),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: data,
      );

      // inspect(response);
      if (response.statusCode == 200) {
        if (json.decode(response.body)['data'] == "OK") {
          //Faire update du status de paiement
          Get.snackbar(
            'Succes : ',
            "Paiement mis à jour avec succès",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          // Get.back();
          timer.cancel();
        } else if(json.decode(response.body)['data'] == "ECHEC") {
          Get.snackbar(
            'Desolé : ',
            "Le paiement à echoué!",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          // Get.back();
          timer.cancel();
        }else{
          print('continuer les verifications');
        }
      } else {
        timer.cancel();
      }
    });

    Future.delayed(const Duration(seconds: 300), () {
      timer.cancel();
    });
  }

  Future<void> updateStatusPayment(String transactionId) async {
    try {
      var data = {
        "transaction_id": transactionId,
      };
      isLoading.value = true;
      var response = await http.post(
        Uri.parse(Api.updateStatusTransaction),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: data,
      );
      if (response.statusCode == 200) {
        isLoading.value = false;
        var responseBody = json.decode(response.body)['data'];
       
       if (responseBody == true) {
        if (kDebugMode) {
          print('Statut de paiement mis à jour avec succès');
        }
      } else {
        if (kDebugMode) {
          print('Erreur lors de la mise à jour du statut de paiement');
        }
      }
      } else {
        isLoading.value = false;
        if (kDebugMode) {
          print("Erreur lors de la récupération du statut du paiement");
        }
      }
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        print(e);
      }
    }
  }
}

