import 'dart:convert';
import 'dart:developer';

import 'package:boulangerie_mobile/pages/auth/login.dart';
import 'package:boulangerie_mobile/widgets/root.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import '../constantes/api.dart';
import '../modèles/user.dart';

class AuthenticateController extends GetxController {
  final isLoading = false.obs;
  final token = "".obs;

  Future<void> checkAccessToken() async {
    var token = await GetStorage().read("access_token");
    if (token != null) {
      bool isExpired = JwtDecoder.isExpired(token);
      if (isExpired) {
        GetStorage().remove("access_token");
        GetStorage().remove("user");
        Get.offAll(const LoginPage());
      } else {}
    } else {
      Get.offAll(() => const LoginPage());
    }
  }

  Future<void> login({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      var data = {
        'phone': phoneNumber,
        'password': password,
      };

      var response = await http.post(
        Uri.parse(Api.login),
        headers: {
          'Accept': 'application/json',
        },
        body: data,
      );
      if (response.statusCode == 200) {
        isLoading.value = false;
        var responseBody = json.decode(response.body);
        token.value = responseBody["access_token"];
        var userResponse = UserResponse.fromJson(responseBody);

        Get.snackbar(
          'Succès',
          'Connexion réussie',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAll(() => const Root());
        // Stocker les données de l'utilisateur en session
        GetStorage().write('access_token', userResponse.accessToken);
        GetStorage().write('user', userResponse.user.toJson());
        // GetStorage().write('backhouse', userResponse.backhouse.toJson());
        // inspect(userResponse.backhouse);
      } else {
        isLoading.value = false;
        Get.snackbar(
          'Erreur',
          'Les informations d\'identification fournies sont incorrectes',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        if (kDebugMode) {
          print("Échec de la connexion");
        }
      }
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        print("Error: $e");
      }
    }
  }

  Future<void> logout() async {
    GetStorage().remove("access_token");
    GetStorage().remove("user");
    GetStorage().remove("backhouse");
  }

  void deconnectUser() {
    Get.defaultDialog(
      title: "Déconnexion",
      middleText: "Voulez-vous vraiment vous déconnecter ?",
      backgroundColor: Colors.white,
      radius: 0,
      confirm: TextButton(
        onPressed: () {
          GetStorage().remove("access_token");
          Get.offAll(() => const LoginPage());
        },
        child: const Text(
          "Déconnexion",
          style: TextStyle(color: Colors.red),
        ),
      ),
      cancel: TextButton(
        onPressed: () {
          Get.back();
        },
        child: const Text(
          "Annuler",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

}
